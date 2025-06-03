using Trell.VehicleGame.Infrastructure.States;
using UnityEngine;
using Zenject;

namespace Trell.VehicleGame.Infrastructure
{
    public class GameBehaviour : MonoBehaviour
    {
        private readonly StateMachine _stateMachine = new();

        private ISceneService _sceneService;

        [Inject]
        private void Construct(ISceneService sceneService)
        {
            _sceneService = sceneService;
        }
        private void Awake()
        {
            DontDestroyOnLoad(gameObject);
            InitGameStateMachine();
        }

        private void InitGameStateMachine()
        {
            _stateMachine.AddState(
                new LoadGameState(_stateMachine, _sceneService),
                
                new GameLoopState(_stateMachine),
                
                new LostState(_stateMachine));
            
            _stateMachine.SetState<LoadGameState>();
        }
    }
    
}
