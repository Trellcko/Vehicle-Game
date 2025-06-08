using Trell.VehicleGame.Infrastructure;
using Trell.VehicleGame.Infrastructure.AssetManagment;
using Trell.VehicleGame.Infrastructure.Factories;
using Trell.VehicleGame.Infrastructure.Input;
using UnityEngine;
using Zenject;

public class BootstrapInstaller : MonoInstaller
{
    [SerializeField] private StaticDataService _staticDataService;
    
    public override void InstallBindings()
    {
        BindSceneService();
        BindAssetProvider();
        BindStaticDataService();
        BindGameFactory();
        BindInput();
        BindGameBehaiour();
    }

    private void BindGameBehaiour()
    {
        Container.BindInterfacesTo<GameBehaviour>()
            .AsSingle();
    }

    private void BindInput()
    {
        Container.BindInterfacesTo<TouchInput>()
            .AsSingle();
    }

    private void BindStaticDataService()
    {
        Container.Bind<IStaticDataService>()
            .FromInstance(_staticDataService)
            .AsSingle();
    }

    private void BindGameFactory()
    {
        Container.Bind<IGameFactory>()
            .To<GameFactory>()
            .AsSingle();
    }

    private void BindAssetProvider()
    {
        Container.Bind<IAssetProvider>()
            .To<AssetProvider>()
            .AsSingle();
    }

    private void BindSceneService()
    {
        Container.Bind<ISceneService>()
            .To<SceneService>()
            .AsSingle();
    }
}
