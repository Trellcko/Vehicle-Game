using System;
using Trell.VehicleGame.GamePlay.Car;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	[RequireComponent(typeof(Collider))]
	public class ZombieCollisionEventInvoker : MonoBehaviour
	{
		public event Action CarCollided;
		
		private void OnTriggerEnter(Collider other)
		{
			if (other.TryGetComponent(out CarFacade carFacade))
			{
				CarCollided?.Invoke();
			}
		}

		private void OnTriggerStay(Collider other)
		{			
			if (other.TryGetComponent(out CarFacade carFacade))
			{
				Debug.Log("Lox");
			}
		}
	}
}
