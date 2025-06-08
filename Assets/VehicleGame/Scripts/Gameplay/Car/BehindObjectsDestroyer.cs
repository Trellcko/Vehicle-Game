using Trell.VehicleGame.GamePlay.Car.Projectile;
using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car
{
	[RequireComponent(typeof(Collider))]
	public class BehindObjectsDestroyer : MonoBehaviour
	{
		private void OnTriggerEnter(Collider other)
		{
			if (other.TryGetComponent(out ZombieCollisionEventInvoker zombieCollisionEventInvoker))
			{
				zombieCollisionEventInvoker.GetComponentInParent<ZombieFacade>().ZombieDestroyer.ReturnToPool();
			}

			else if (other.TryGetComponent(out ProjectileCollisionEventInvoker projectileCollisionEventInvoker))
			{
				projectileCollisionEventInvoker.GetComponentInParent<ProjectileFacade>().ProjectileDestroyer.ReturnToPool();
			}
		}
	}
}
