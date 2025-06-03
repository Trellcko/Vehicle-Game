using Trell.VehicleGame.Infrastructure;
using Trell.VehicleGame.Infrastructure.AssetManagment;
using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;
using Zenject;

public class BootstrapInstaller : MonoInstaller
{
    public override void InstallBindings()
    {
        BindSceneService();
        BindAssetProvider();
        BindGameFactory();
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
