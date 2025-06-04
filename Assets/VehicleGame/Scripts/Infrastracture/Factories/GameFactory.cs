using System.Threading.Tasks;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.Infrastructure.AssetManagment;
using UnityEngine;
using Zenject;

namespace Trell.VehicleGame.Infrastructure.Factories
{
    public class GameFactory : IGameFactory
    {
        private readonly IAssetProvider _assetProvider;
        private readonly IStaticDataService _staticDataService;
        
        [Inject]
        public GameFactory(IAssetProvider assetProvider, IStaticDataService staticDataService)
        {
            _assetProvider = assetProvider;
            _staticDataService = staticDataService;
        }

        public async Task<CarFacade> CreateCar()
        {
            CarData carData = _staticDataService.GetCarData();
            GameObject prefab = await _assetProvider.Load<GameObject>(carData.AssetReference);
            
            CarFacade carFacade = Object.Instantiate(prefab).GetComponent<CarFacade>();
            carFacade.CarMovement.Init(carData.Speed);
            
            return carFacade;
        }
        
        public void CleanUp()
        {
          
            _assetProvider.CleanUp();
        }

       
    }
}