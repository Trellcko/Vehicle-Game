using System;
using System.Threading.Tasks;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Zombie;
using Trell.VehicleGame.Infrastructure.AssetManagment;
using UnityEngine;
using Zenject;
using Object = UnityEngine.Object;

namespace Trell.VehicleGame.Infrastructure.Factories
{
    public class GameFactory : IGameFactory
    {
        private readonly IAssetProvider _assetProvider;
        private readonly IStaticDataService _staticDataService;

        public event Action<CarFacade> CarCreated;

        public CarFacade CarFacade { get; private set; }

        [Inject]
        public GameFactory(IAssetProvider assetProvider, IStaticDataService staticDataService)
        {
            _assetProvider = assetProvider;
            _staticDataService = staticDataService;
        }

        public async Task<ZombieFacade> CreateZombie(Vector3 position)
        {
            ZombieData zombieData = _staticDataService.GetZombieData();
            
            GameObject prefab = await _assetProvider.Load<GameObject>(zombieData.AssetReference);
            ZombieFacade zombieFacade = Object.Instantiate(prefab, position, Quaternion.identity).GetComponent<ZombieFacade>();
            zombieFacade.ZombieMovement.Init(zombieData.RunSpeed, zombieData.WalkSpeed, zombieData.RotateSpeed, CarFacade.transform);
            return zombieFacade;
        }
        
        public async Task<CarFacade> CreateCar()
        {
            CarData carData = _staticDataService.GetCarData();
            
            GameObject prefab = await _assetProvider.Load<GameObject>(carData.AssetReference);
            CarFacade carFacade = Object.Instantiate(prefab).GetComponent<CarFacade>();
            
            carFacade.CarMovement.Init(carData.Speed);
            carFacade.CarHealth.Init(carData.Health);
            CarFacade = carFacade;
            CarCreated?.Invoke(carFacade);
            return carFacade;
        }

        public void CleanUp()
        {
            _assetProvider.CleanUp();
        }
    }
}