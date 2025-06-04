using Cinemachine;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;
using Zenject;

namespace Trell.VehicleGame.GamePlay.Camera
{
    public class CameraSwitcher : MonoBehaviour
    {
        [SerializeField] private CinemachineVirtualCamera _startCamera;
        [SerializeField] private CinemachineVirtualCamera _gameCamera;
        
        private IGameFactory _gameFactory;

        [Inject]
        private void Construct(IGameFactory gameFactory)
        {
            _gameFactory = gameFactory;
            _gameFactory.CarCreated += OnCarCreated;
        }

        private void OnDisable()
        {
            _gameFactory.CarCreated -= OnCarCreated;
        }

        public void SwitchToStartCamera()
        {
            _startCamera.gameObject.SetActive(true);
        }
        
        public void SwitchToGameCamera()
        {
            _startCamera.gameObject.SetActive(false);
        }
        
        private void OnCarCreated(CarFacade obj)
        {
            _gameFactory.CarCreated -= OnCarCreated;
            _startCamera.Follow = _startCamera.LookAt = _gameCamera.Follow = _gameCamera.LookAt = obj.transform;
        }
    }
}
