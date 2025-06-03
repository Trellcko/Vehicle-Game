using Constants;
using UnityEngine;
using UnityEngine.Serialization;
using Zenject;

namespace Trell.VehicleGame.Infrastructure
{
    public class GameRunner : MonoBehaviour
    {
        private ISceneService _sceneService;

        [Inject]
        private void Construct(ISceneService sceneService)
        {
            _sceneService = sceneService;
        }
        
        private void Awake()
        {
            GameBehaviour gameBehaviour = FindObjectOfType<GameBehaviour>();

            if (gameBehaviour)
                return;
            
            _sceneService.Load(nameof(SceneNames.BootstrapScene));
        }
    }
}