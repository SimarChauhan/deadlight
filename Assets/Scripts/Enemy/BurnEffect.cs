using UnityEngine;
using System.Collections;

namespace Deadlight.Enemy
{
    public class BurnEffect : MonoBehaviour
    {
        private float damagePerSecond = 3f;
        private float duration = 3f;
        private float elapsed;
        private SpriteRenderer spriteRenderer;
        private Color originalColor;
        private EnemyHealth enemyHealth;
        private Deadlight.Player.PlayerHealth playerHealth;
        
        public void Initialize(float dps, float dur)
        {
            damagePerSecond = dps;
            duration = dur;
        }
        
        void Start()
        {
            enemyHealth = GetComponent<EnemyHealth>();
            playerHealth = GetComponent<Deadlight.Player.PlayerHealth>();
            spriteRenderer = GetComponent<SpriteRenderer>();
            if (spriteRenderer != null)
                originalColor = spriteRenderer.color;
            StartCoroutine(BurnRoutine());
        }
        
        IEnumerator BurnRoutine()
        {
            while (elapsed < duration)
            {
                if (enemyHealth != null)
                {
                    if (!enemyHealth.IsAlive) break;
                    enemyHealth.TakeDamage(damagePerSecond * Time.deltaTime);
                }
                else if (playerHealth != null)
                {
                    if (!playerHealth.IsAlive) break;
                    playerHealth.TakeDamage(damagePerSecond * Time.deltaTime);
                }
                else
                {
                    break;
                }
                
                if (spriteRenderer != null)
                {
                    float t = Mathf.PingPong(Time.time * 6f, 1f);
                    spriteRenderer.color = Color.Lerp(originalColor, new Color(1f, 0.5f, 0.1f), t * 0.7f);
                }
                
                elapsed += Time.deltaTime;
                yield return null;
            }
            
            if (spriteRenderer != null)
                spriteRenderer.color = originalColor;
            Destroy(this);
        }
    }
}
