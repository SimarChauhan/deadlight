#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEAM_NAME="GroupName"
WINDOWS_BUILD_DIR="$ROOT_DIR/Builds/Windows"
OUTPUT_DIR="$ROOT_DIR/output/submissions"
VALIDATE_ONLY=0

print_usage() {
  cat <<USAGE
Usage: $(basename "$0") [options]

Create a clean Deliverable 2 submission zip with only required Unity folders,
a Windows build, and the report PDF.

Options:
  --team <name>            Team or group name for output zip naming.
  --windows-build <path>   Path to Windows build folder containing .exe and *_Data.
  --report <path>          Path to written report PDF.
  --output <path>          Output directory for staged folder and zip.
  --validate-only          Validate inputs only; do not copy or zip.
  -h, --help               Show this help text.

Example:
  scripts/prepare_deliverable2.sh \\
    --team Group16 \\
    --windows-build Builds/Windows \\
    --report "Deliverable 2 (1).pdf"
USAGE
}

first_matching_report() {
  local candidate
  for candidate in "$ROOT_DIR"/Deliverable\ 2*.pdf "$ROOT_DIR"/deliverable\ 2*.pdf; do
    if [[ -f "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

REPORT_PDF="$(first_matching_report || true)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --team)
      TEAM_NAME="${2:-}"
      shift 2
      ;;
    --windows-build)
      WINDOWS_BUILD_DIR="${2:-}"
      shift 2
      ;;
    --report)
      REPORT_PDF="${2:-}"
      shift 2
      ;;
    --output)
      OUTPUT_DIR="${2:-}"
      shift 2
      ;;
    --validate-only)
      VALIDATE_ONLY=1
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      print_usage
      exit 1
      ;;
  esac
done

# Normalize relative paths to repo root.
if [[ "$WINDOWS_BUILD_DIR" != /* ]]; then
  WINDOWS_BUILD_DIR="$ROOT_DIR/$WINDOWS_BUILD_DIR"
fi
if [[ -n "$REPORT_PDF" && "$REPORT_PDF" != /* ]]; then
  REPORT_PDF="$ROOT_DIR/$REPORT_PDF"
fi
if [[ "$OUTPUT_DIR" != /* ]]; then
  OUTPUT_DIR="$ROOT_DIR/$OUTPUT_DIR"
fi

if [[ -z "$TEAM_NAME" ]]; then
  echo "Error: --team cannot be empty." >&2
  exit 1
fi

required_dirs=(Assets Packages ProjectSettings)
for dir_name in "${required_dirs[@]}"; do
  if [[ ! -d "$ROOT_DIR/$dir_name" ]]; then
    echo "Error: required directory missing: $ROOT_DIR/$dir_name" >&2
    exit 1
  fi
done

if [[ ! -d "$WINDOWS_BUILD_DIR" ]]; then
  echo "Error: Windows build directory not found: $WINDOWS_BUILD_DIR" >&2
  exit 1
fi

exe_files=()
while IFS= read -r exe_path; do
  exe_files+=("$exe_path")
done < <(find "$WINDOWS_BUILD_DIR" -maxdepth 1 -type f -name '*.exe' | sort)
if [[ "${#exe_files[@]}" -eq 0 ]]; then
  echo "Error: no .exe found in Windows build directory: $WINDOWS_BUILD_DIR" >&2
  exit 1
fi

exe_name="$(basename "${exe_files[0]}")"
exe_base="${exe_name%.exe}"
data_dir="$WINDOWS_BUILD_DIR/${exe_base}_Data"
if [[ ! -d "$data_dir" ]]; then
  echo "Error: missing data folder for $exe_name: $data_dir" >&2
  exit 1
fi

if [[ -z "${REPORT_PDF:-}" || ! -f "$REPORT_PDF" ]]; then
  echo "Error: report PDF not found. Pass --report <path>." >&2
  exit 1
fi

submission_name="${TEAM_NAME}_Deliverable2"
stage_dir="$OUTPUT_DIR/$submission_name"
zip_path="$OUTPUT_DIR/$submission_name.zip"

if [[ "$VALIDATE_ONLY" -eq 1 ]]; then
  cat <<VALID
Validation passed.
- Unity folders: Assets, Packages, ProjectSettings
- Windows build: $exe_name + ${exe_base}_Data
- Report PDF: $REPORT_PDF
VALID
  exit 0
fi

mkdir -p "$OUTPUT_DIR"
rm -rf "$stage_dir" "$zip_path"
mkdir -p "$stage_dir"

for dir_name in "${required_dirs[@]}"; do
  rsync -a "$ROOT_DIR/$dir_name/" "$stage_dir/$dir_name/"
done

rsync -a "$WINDOWS_BUILD_DIR/" "$stage_dir/WindowsBuild/"
cp "$REPORT_PDF" "$stage_dir/$(basename "$REPORT_PDF")"

if command -v ditto >/dev/null 2>&1; then
  (
    cd "$OUTPUT_DIR"
    ditto -c -k --sequesterRsrc --keepParent "$submission_name" "$submission_name.zip"
  )
else
  (
    cd "$OUTPUT_DIR"
    zip -r -q "$submission_name.zip" "$submission_name"
  )
fi

cat <<DONE
Created deliverable package:
- Staging folder: $stage_dir
- Zip file: $zip_path

Contents include:
- Assets/
- Packages/
- ProjectSettings/
- WindowsBuild/ ($exe_name + ${exe_base}_Data)
- $(basename "$REPORT_PDF")
DONE
