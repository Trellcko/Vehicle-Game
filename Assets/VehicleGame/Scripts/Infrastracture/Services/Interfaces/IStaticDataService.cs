using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Zombie;

namespace Trell.VehicleGame.Infrastructure
{
    public interface IStaticDataService
    {
        public CarData GetCarData();
        public ZombieData GetZombieData();
    }
}