using System;
using Constants;
using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure.States
{
    public class LoadGameState : BaseStateWithoutPayload
    {
        private readonly ISceneService _sceneService;
        private IGameFactory _factory;

        public LoadGameState(StateMachine machine, ISceneService sceneService, IGameFactory factory) : base(machine)
        {
            _factory = factory;
            _sceneService = sceneService;
        }

        public override void  Enter()
        {
            _sceneService.Load(SceneName.GameScene, OnLoaded);
            _factory.CleanUp();
        }

        private void OnLoaded()
        {
            _factory.CreateCar();
            GoToState<GameLoopState>();
        }
    }
}