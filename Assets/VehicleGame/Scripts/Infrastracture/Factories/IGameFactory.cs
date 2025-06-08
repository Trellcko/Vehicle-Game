using System;
using System.Threading.Tasks;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Car.Projectile;
using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure.Factories
{
    public interface IGameFactory
    {
        void CleanUp();
        event Action CarCreated;
        Task<CarFacade> CreateCar();
        Task<ZombieFacade> CreateZombie(Vector3 position);
        Task<ProjectileFacade> CreateProjectile(Vector3 position, Vector3 direction);
        CarFacade CarFacade { get; }
        Task<GameObject> CreateWinPopup();
        Task<GameObject> CreateLosePopup();
    }
}