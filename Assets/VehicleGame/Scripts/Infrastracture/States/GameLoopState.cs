using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure.States
{
    public class GameLoopState : BaseStateWithoutPayload
    {
        private CarFacade _car;

        private readonly IStaticDataService _staticDataService;
        private readonly IGameFactory _gameFactory;

        public GameLoopState(StateMachine machine, IGameFactory gameFactory, IStaticDataService staticDataService) :
            base(machine)
        {
            _gameFactory = gameFactory;
            _staticDataService = staticDataService;
        }

        public override void Enter()
        {
            if (_gameFactory.CarFacade)
            {
                RegistrationCar();
            }
            else
            {
                _gameFactory.CarCreated += RegistrationCar;
            }
        }

        public override void Update()
        {
            if(!_car)
                return;
            
            if (_car && _car.transform.position.z >= _staticDataService.GetLevelWinData().DistanceToWin)
            {
                GoToState<WinState>();
            }
        }


        public override void Exit()
        {
            
            _gameFactory.CarCreated -= RegistrationCar;
            if(_car)
                _car.CarHealth.Died -= OnDied;
        }

        private void RegistrationCar()
        {
            _car = _gameFactory.CarFacade;

            _car.CarHealth.Died += OnDied;
        }

        private void OnDied()
        {
            GoToState<LostState>();
        }
    }
}