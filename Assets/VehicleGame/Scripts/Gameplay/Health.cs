using System;
using NaughtyAttributes;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay
{
	public class Health : MonoBehaviour
	{
		[field: SerializeField] public float MaxHealth { get; private set; } = 100f;

		public float CurrentHealth { get; private set; }

		public event Action Inited;
		public event Action Damaged;
		public event Action Died;

		[Button]
		private void TestDamage()
		{
			TakeDamage(10);
		}

		public void Release()
		{
			CurrentHealth = MaxHealth;
		}
		
		public void Init(float health)
		{
			MaxHealth = CurrentHealth = health;
			Inited?.Invoke();
		}

		public void TakeDamage(float damage)
		{
			damage = Mathf.Clamp(damage, 0, float.MaxValue);
			
			CurrentHealth -= damage;

			if (CurrentHealth <= 0)
			{
				Died?.Invoke();
				return;
			}
			
			Damaged?.Invoke();
		}
	}
}
