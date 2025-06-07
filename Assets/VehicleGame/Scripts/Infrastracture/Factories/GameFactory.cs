using System;
using System.Threading.Tasks;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Zombie;
using Trell.VehicleGame.Infrastructure.AssetManagment;
using Trell.VehicleGame.Infrastructure.Input;
using UnityEngine;
using UnityEngine.Pool;
using Zenject;
using Object = UnityEngine.Object;

namespace Trell.VehicleGame.Infrastructure.Factories
{
    public class GameFactory : IGameFactory
    {
        public CarFacade CarFacade { get; private set; }
        
        private readonly IAssetProvider _assetProvider;
        private readonly IStaticDataService _staticDataService;
        
        private GameObject _zombiePrefab;
        private ZombieData ZombieData => _staticDataService.GetZombieData();
        
        private ObjectPool<ZombieFacade> _zombiePool;
        private IInput _input;

        public event Action<CarFacade> CarCreated;

        private GameObject _zombieParent;
        
        [Inject]
        public GameFactory(IAssetProvider assetProvider, IStaticDataService staticDataService, IInput input)
        {
            _input = input;
            _assetProvider = assetProvider;
            _staticDataService = staticDataService;
            CreatePool();
        }

        public async Task<ZombieFacade> CreateZombie(Vector3 position)
        {
            ZombieData zombieData = _staticDataService.GetZombieData();
            
            _zombiePrefab = await _assetProvider.Load<GameObject>(zombieData.AssetReference);
            ZombieFacade zombieFacade = _zombiePool.Get();
            zombieFacade.transform.position = position;

            if (!_zombieParent)
                _zombieParent = new("ZombieParent");
            
            zombieFacade.transform.parent = _zombieParent.transform;
            
            return zombieFacade;
        }

        public async Task<CarFacade> CreateCar()
        {
            CarData carData = _staticDataService.GetCarData();
            
            GameObject prefab = await _assetProvider.Load<GameObject>(carData.AssetReference);
            CarFacade carFacade = Object.Instantiate(prefab).GetComponent<CarFacade>();
            
            carFacade.CarMovement.Init(carData.Speed);
            carFacade.CarHealth.Init(carData.Health);
            carFacade.TurretShooting.Init(_input);
            CarFacade = carFacade;
            CarCreated?.Invoke(carFacade);
            return carFacade;
        }

        public void CleanUp()
        {
            _assetProvider.CleanUp();
        }

        private void CreatePool()
        {
            _zombiePool = new(
                () =>
                {
                    ZombieFacade zombie = Object.Instantiate(_zombiePrefab).GetComponent<ZombieFacade>();
                    InitZombie(zombie);
                    return zombie;
                },
                x =>
                {
                    InitZombie(x);
                    x.gameObject.SetActive(true);
                },
                x =>
                {
                    x.ZombieChaseTrigger.Release();
                    x.ZombieMovement.Release();
                    x.ZombieAnimator.Release();
                    x.ZombieHealth.Release();
                    x.gameObject.SetActive(false);
                }
            );
        }

        private void InitZombie(ZombieFacade zombieFacade)
        {
            zombieFacade.ZombieMovement.Init(ZombieData.RunSpeed, ZombieData.WalkSpeed, ZombieData.RotateSpeed, ZombieData.IdleTime);
            zombieFacade.ZombieAttacking.Init(ZombieData.Damage, CarFacade);
            zombieFacade.ZombieChaseTrigger.Init(CarFacade);
            zombieFacade.ZombieDestroyer.Init(_zombiePool);
            zombieFacade.ZombieHealth.Init(ZombieData.Health);
        }
    }
}