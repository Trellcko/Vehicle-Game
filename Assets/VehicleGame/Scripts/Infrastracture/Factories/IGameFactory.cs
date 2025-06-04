using System.Threading.Tasks;
using Trell.VehicleGame.GamePlay.Car;

namespace Trell.VehicleGame.Infrastructure.Factories
{
    public interface IGameFactory
    {
        void CleanUp();

        Task<CarFacade> CreateCar();
    }
}