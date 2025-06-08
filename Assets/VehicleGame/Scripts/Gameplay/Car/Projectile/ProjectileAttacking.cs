using System;
using Trell.VehicleGame.GamePlay.Car.Projectile;
using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame
{
	public class ProjectileAttacking : MonoBehaviour
	{
		[SerializeField] private ProjectileFacade _facade;

		private float _damage;
		public event Action AttackCompleted;

		private void OnEnable()
		{
			_facade.ProjectileCollisionEventInvoker.ZombieCollided += OnZombieCollided;
		}

		private void OnDisable()
		{
			_facade.ProjectileCollisionEventInvoker.ZombieCollided -= OnZombieCollided;
		}

		public void Init(float damage)
		{
			_damage = damage;
		}

		private void OnZombieCollided(ZombieFacade obj)
		{
			obj.ZombieHealth.TakeDamage(_damage);
			AttackCompleted?.Invoke();
		}
	}
}
