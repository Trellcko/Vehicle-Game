using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure.States
{
    public class WinState : BaseStateWithoutPayload
    {
        private readonly IGameFactory _gameFactory;

        public WinState(StateMachine machine, IGameFactory gameFactory) : base(machine)
        {
            _gameFactory = gameFactory;
        }

        public override void Enter()
        {
            _gameFactory.CreateWinPopup();
        }
    }
}