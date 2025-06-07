using System;
using Trell.VehicleGame.GamePlay.Car;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	public class ZombieAttacking : MonoBehaviour
	{
		private const float OffsetFromCenter = 2;
		[SerializeField] private ZombieFacade zombie;

		private float _damage;
		private CarFacade _carFacade;
		
		public event Action AttackCompleted;

		private void OnEnable()
		{
			zombie.ZombieCollisionEventInvoker.CarCollided += Attack;
			zombie.ZombieAnimator.Attacked += OnAttacked;
		}

		private void OnDisable()
		{
			zombie.ZombieCollisionEventInvoker.CarCollided -= Attack;
			zombie.ZombieAnimator.Attacked -= OnAttacked;
		}

		public void Init(float damage, CarFacade carFacade)
		{
			_carFacade = carFacade;
			_damage = damage;
		}

		private void Attack()
		{
			if (transform.position.z > (_carFacade.transform.position.z + OffsetFromCenter))
			{
				OnAttacked();
				return;
			}
			
			zombie.ZombieAnimator.SetAttackTrigger();
			zombie.ZombieMovement.StopMovement();
		}

		private void OnAttacked()
		{
			_carFacade.CarHealth.TakeDamage(_damage);
			AttackCompleted?.Invoke();
		}
	}
}
