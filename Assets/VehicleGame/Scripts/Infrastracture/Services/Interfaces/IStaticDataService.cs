using Trell.VehicleGame.GamePlay;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Car.Projectile;
using Trell.VehicleGame.GamePlay.Zombie;

namespace Trell.VehicleGame.Infrastructure
{
    public interface IStaticDataService
    {
        CarData GetCarData(); 
        ZombieData GetZombieData();
       ProjectileData  GetProjectileData();
       LevelWinData GetLevelWinData();
    }
}