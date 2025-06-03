using Trell.VehicleGame.Infrastructure.AssetManagment;
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

        public void CleanUp()
        {
          
            _assetProvider.CleanUp();
        }

       
    }
}