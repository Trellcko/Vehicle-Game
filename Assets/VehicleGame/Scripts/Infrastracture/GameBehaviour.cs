using Trell.VehicleGame.Infrastructure.Factories;
using Trell.VehicleGame.Infrastructure.States;
using UnityEngine;
using Zenject;

namespace Trell.VehicleGame.Infrastructure
{
    public class GameBehaviour : MonoBehaviour
    {
        private readonly StateMachine _stateMachine = new();

        private ISceneService _sceneService;
        private IGameFactory _gameFactory;

        [Inject]
        private void Construct(ISceneService sceneService, IGameFactory gameFactory)
        {
            _gameFactory = gameFactory;
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
                new LoadGameState(_stateMachine, _sceneService, _gameFactory),
                
                new GameLoopState(_stateMachine),
                
                new LostState(_stateMachine));
            
            _stateMachine.SetState<LoadGameState>();
        }
    }
    
}
