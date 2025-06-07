using Trell.VehicleGame.GamePlay.Car;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	[RequireComponent(typeof(Collider))]
	public class ZombieChaseTrigger : MonoBehaviour
	{
		[SerializeField] private ZombieMovement _zombieMovement;
		
		private CarFacade _carFacade;

		public void Init(CarFacade carFacade)
		{
			_carFacade = carFacade;
		}

		public void Release()
		{
			_carFacade = null;
		}
		
		private void OnTriggerEnter(Collider other)
		{
			if(_zombieMovement.HasTarget)
				return;
			_zombieMovement.SetTarget(_carFacade.transform);
		}
	}
}
