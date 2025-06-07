using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car
{
	[RequireComponent(typeof(Collider))]
	public class BehindZombieDestroyer : MonoBehaviour
	{
		private void OnTriggerEnter(Collider other)
		{
			if (other.TryGetComponent(out ZombieCollisionEventInvoker zombieCollisionEventInvoker))
			{
				zombieCollisionEventInvoker.GetComponentInParent<ZombieFacade>().ZombieDestroyer.ReturnToPool();
			}
		}
	}
}
