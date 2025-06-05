using System;
using System.Threading.Tasks;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure.Factories
{
    public interface IGameFactory
    {
        void CleanUp();
        event Action<CarFacade> CarCreated;
        Task<CarFacade> CreateCar();
        Task<ZombieFacade> CreateZombie(Vector3 position);
    }
}