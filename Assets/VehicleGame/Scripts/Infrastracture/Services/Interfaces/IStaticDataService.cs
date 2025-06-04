using Trell.VehicleGame.GamePlay.Car;

namespace Trell.VehicleGame.Infrastructure
{
    public interface IStaticDataService
    {
        public CarData GetCarData();
    }
}