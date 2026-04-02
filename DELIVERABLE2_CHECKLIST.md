# Deliverable 2 Submission Checklist

Use this before exporting your final zip for Brightspace.

## 1) Required Submission Contents

- [ ] Zip file name follows the format `GroupName_Deliverable2.zip`
- [ ] Zip contains only required Unity project folders:
  - [ ] `Assets/`
  - [ ] `Packages/`
  - [ ] `ProjectSettings/`
- [ ] Zip includes a functional Windows build:
  - [ ] `YourGame.exe`
  - [ ] `YourGame_Data/`
- [ ] Zip includes the written report PDF
- [ ] Zip excludes auto-generated folders (`Library`, `Logs`, `Temp`, `UserSettings`, cache folders)

## 2) Rubric Coverage: Level Design & Player Guidance

- [ ] Report explains map layout and player flow
- [ ] Report explains player guidance methods (visual cues, pacing, landmarks)
- [ ] Report explains challenge vs. exploration balance
- [ ] Build demonstrates navigable, readable level flow

## 3) Rubric Coverage: Narrative Design & World-Building

- [ ] Report explains story premise and progression across gameplay
- [ ] Report covers dialogue/radio/lore systems and immersion goals
- [ ] Report explains how narrative and gameplay systems connect
- [ ] Build includes narrative content players can discover in play

## 4) Rubric Coverage: Systems Design & Game Balance

- [ ] Report explains resource systems (health, ammo, currency)
- [ ] Report explains risk/reward decisions and difficulty pacing
- [ ] Report describes balancing updates made from playtesting
- [ ] Build demonstrates stable core systems during play

## 5) Rubric Coverage: Progression Systems & Rewards

- [ ] Report explains progression loops (unlocks, upgrades, milestones)
- [ ] Report explains intrinsic and extrinsic rewards
- [ ] Report shows how progression supports long-term engagement
- [ ] Build exposes progression features in normal gameplay

## 6) Rubric Coverage: Unity Implementation & Documentation

- [ ] Unity project opens with no compile errors
- [ ] Scenes and prefabs are organized and coherent
- [ ] Report describes iteration process and feedback-driven changes
- [ ] Report includes relevant technical notes (scripts/tools/components)
- [ ] Build launches on Windows and reaches playable state

## 7) Final Verification Steps

- [ ] Run a final playtest using the Windows build (not only in Editor)
- [ ] Confirm no blocking runtime errors during key gameplay loop
- [ ] Open the final zip and verify required folders/files are present
- [ ] Upload the verified zip to Brightspace

## Optional Helper Script

You can validate and package quickly with:

```bash
scripts/prepare_deliverable2.sh --team Group16 --windows-build Builds/Windows --report "Deliverable 2 (1).pdf"
```

Validation-only mode:

```bash
scripts/prepare_deliverable2.sh --team Group16 --windows-build Builds/Windows --report "Deliverable 2 (1).pdf" --validate-only
```
