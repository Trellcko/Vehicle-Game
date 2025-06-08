using System;
using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
	[RequireComponent(typeof(Collider))]
	public class ProjectileCollisionEventInvoker : MonoBehaviour
	{
		[SerializeField] private ProjectileMovement _movement;
		public event Action<ZombieFacade> ZombieCollided;

		private void OnEnable()
		{
			_movement.WentThroughSomething += OnWentThroughSomething;
		}

		private void OnDisable()
		{
			_movement.WentThroughSomething += OnWentThroughSomething;
		}

		private void OnWentThroughSomething(GameObject obj)
		{			
			if (obj.TryGetComponent(out ZombieCollisionEventInvoker zombie))
			{
				ZombieCollided?.Invoke(zombie.GetComponentInParent<ZombieFacade>());
			}
		}
	}
}
