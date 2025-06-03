using System;
using Constants;
using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure.States
{
    public class LoadGameState : BaseStateWithoutPayload
    {
        private readonly ISceneService _sceneService;

        public LoadGameState(StateMachine machine, ISceneService sceneService) : base(machine)
        {
            _sceneService = sceneService;
        }

        public override void  Enter()
        {
            _sceneService.Load(nameof(SceneNames.GameScene), OnLoaded);
        }

        private void OnLoaded()
        {
            try
            {
                GoToState<GameLoopState>();
            }
            catch (Exception e)
            {
                Debug.Log(e.Message + "\n" + e.StackTrace);
            }
        }
    }
}