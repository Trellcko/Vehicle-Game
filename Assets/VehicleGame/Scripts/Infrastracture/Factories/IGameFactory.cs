using System.Threading.Tasks;
using Trell.VehicleGame.Gameplay.Car;

namespace Trell.VehicleGame.Infrastructure.Factories
{
    public interface IGameFactory
    {
        void CleanUp();

        Task<CarFacade> CreateCar();
    }
}