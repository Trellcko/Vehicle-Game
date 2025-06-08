using Trell.VehicleGame.GamePlay;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Car.Projectile;
using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure
{
    public class StaticDataService : MonoBehaviour, IStaticDataService
    {
        [SerializeField] private CarData _carData;
        [SerializeField] private ZombieData _zombieData;
        [SerializeField] private ProjectileData _projectileData;
        [SerializeField] private LevelWinData _getLevelWinData;
        
        
        public LevelWinData GetLevelWinData() => 
            _getLevelWinData;
        
        public CarData GetCarData() =>
            _carData;

        public ZombieData GetZombieData() => 
            _zombieData;

        public ProjectileData GetProjectileData()=>
            _projectileData;
    }
}