using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure.States
{
    public class LostState : BaseStateWithoutPayload
    {
        private readonly IGameFactory _gameFactory;

        public LostState(StateMachine machine, IGameFactory gameFactory) : base(machine)
        {
            _gameFactory = gameFactory;
        }

        public override void Enter()
        {
            _gameFactory.CreateLosePopup();
        }

        public override void Exit()
        {

        }
    }
}