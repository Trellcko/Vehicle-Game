using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure
{
    public class StaticDataService : MonoBehaviour, IStaticDataService
    {
        [SerializeField] private CarData _carData;
        [SerializeField] private ZombieData _zombieData;
        
        public CarData GetCarData() =>
            _carData;

        public ZombieData GetZombieData() => 
            _zombieData;
    }
}