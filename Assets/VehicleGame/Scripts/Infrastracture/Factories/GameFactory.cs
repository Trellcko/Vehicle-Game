using System;
using System.Threading.Tasks;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.GamePlay.Car.Projectile;
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
        private readonly IInput _input;

        private GameObject _zombiePrefab;
        private GameObject _projectilePrefab;
        
        private ZombieData ZombieData => _staticDataService.GetZombieData();
        private ProjectileData ProjectileData => _staticDataService.GetProjectileData();
        
        private ObjectPool<ZombieFacade> _zombiePool;
        private ObjectPool<ProjectileFacade> _projectilePool;
        public event Action CarCreated;

        private GameObject _projectileParent;
        private GameObject _zombieParent;
        private DiContainer _container;

        [Inject]
        public GameFactory(DiContainer container, IAssetProvider assetProvider, IStaticDataService staticDataService, IInput input)
        {
            _container = container;
            _input = input;
            _assetProvider = assetProvider;
            _staticDataService = staticDataService;
            CreateZombiePool();
            CreateProjectilePool();
        }

        public async Task<GameObject> CreateWinPopup()
        {
            GameObject prefab = await _assetProvider.Load<GameObject>("WinPopup");
            GameObject winPopup = Object.Instantiate(prefab);
            _container.InjectGameObject(winPopup);
            return winPopup;
        }

        public async Task<GameObject> CreateLosePopup()
        {
            GameObject prefab = await _assetProvider.Load<GameObject>("LosePopup");
            GameObject losePopup = Object.Instantiate(prefab);
            _container.InjectGameObject(losePopup);
            return losePopup;
        }
        
        public async Task<ProjectileFacade> CreateProjectile(Vector3 position, Vector3 direction)
        {
            _projectilePrefab = await _assetProvider.Load<GameObject>(ProjectileData.AssetReference);
            ProjectileFacade projectileFacade = _projectilePool.Get();
            projectileFacade.transform.position = position;
            projectileFacade.ProjectileMovement.SetDirection(direction);
            
            if (!_projectileParent)
                _projectileParent = new("ProjectileParent");
            
            projectileFacade.transform.parent = _projectileParent.transform;
            return projectileFacade;
        }
        
        public async Task<ZombieFacade> CreateZombie(Vector3 position)
        {
            _zombiePrefab = await _assetProvider.Load<GameObject>(ZombieData.AssetReference);
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
            carFacade.TurretShooting.Init(_input, this);
            CarFacade = carFacade;
            CarCreated?.Invoke();
            return carFacade;
        }

        public void CleanUp()
        {
            _assetProvider.CleanUp();
        }

        private void CreateProjectilePool()
        {
            _projectilePool = new(() =>
                {
                    ProjectileFacade projectileFacade =
                        Object.Instantiate(_projectilePrefab).GetComponent<ProjectileFacade>();
                    InitProjectile(projectileFacade);
                    return projectileFacade;
                },
                x =>
                {
                    x.gameObject.SetActive(true);
                    x.TrailRenderer.enabled = false;
                    x.TrailRenderer.Clear();
                    x.TrailRenderer.enabled = true;
                },
                x => x.gameObject.SetActive(false)
            );
        }

        private void InitProjectile(ProjectileFacade projectileFacade)
        {
            projectileFacade.ProjectileAttacking.Init(ProjectileData.Damage);
            projectileFacade.ProjectileMovement.Init(ProjectileData.Speed);
            projectileFacade.ProjectileDestroyer.Init(_projectilePool);
        }

        private void CreateZombiePool()
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