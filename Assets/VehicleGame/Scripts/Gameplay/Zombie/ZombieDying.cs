using System;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	public class ZombieDying : MonoBehaviour
	{
		[SerializeField] private ZombieFacade _zombie;
		
		private void OnEnable()
		{
			_zombie.ZombieHealth.Died += Die;
			_zombie.ZombieAttacking.AttackCompleted += Die;
		}

		private void OnDisable()
		{
			_zombie.ZombieHealth.Died -= Die;
			_zombie.ZombieAttacking.AttackCompleted -= Die;
		}

		private void Die()
		{
			_zombie.ZombieDestroyer.ReturnToPool();
		}

	}
}