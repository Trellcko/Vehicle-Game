using System;
using System.Threading.Tasks;
using Trell.VehicleGame.GamePlay.Car;

namespace Trell.VehicleGame.Infrastructure.Factories
{
    public interface IGameFactory
    {
        void CleanUp();
        event Action<CarFacade> CarCreated;
        Task<CarFacade> CreateCar();
    }
}