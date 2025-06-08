using Constants;
using Trell.VehicleGame.Infrastructure.States;

namespace Trell.VehicleGame.Infrastructure
{
    public class BootstrapSceneLoadState : BaseStateWithoutPayload
    {
        private readonly ISceneService _sceneService;

        public BootstrapSceneLoadState(StateMachine machine, ISceneService sceneService) : base(machine)
        {
            _sceneService = sceneService;
        }

        public override void Enter()
        {
            _sceneService.Load(SceneName.BootstrapScene, GoToState<LoadGameState>);
        }
    }
}