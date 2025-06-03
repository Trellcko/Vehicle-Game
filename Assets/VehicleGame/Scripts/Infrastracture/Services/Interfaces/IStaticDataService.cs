using Trell.VehicleGame.Gameplay.Car;

namespace Trell.VehicleGame.Infrastructure
{
    public interface IStaticDataService
    {
        public CarData GetCarData();
    }
}