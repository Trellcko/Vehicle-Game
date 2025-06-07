using System;
using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
	[RequireComponent(typeof(Collider))]
	public class ProjectileCollisionEventInvoker : MonoBehaviour
	{
		public event Action<ZombieFacade> ZombieCollided;
		
		private void OnTriggerEnter(Collider other)
		{
			if (other.TryGetComponent(out ZombieCollisionEventInvoker zombie))
			{
				ZombieCollided?.Invoke(zombie.GetComponentInParent<ZombieFacade>());
			}
		}
	}
}
