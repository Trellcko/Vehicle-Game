using Trell.VehicleGame.Infrastructure.Factories;

namespace Trell.VehicleGame.Infrastructure.States
{
    public class LostState : BaseStateWithPayLoad<bool>
    {
        private readonly IGameFactory _gameFactory;

        public LostState(StateMachine machine) : base(machine)
        {

        }

        public override void Enter(bool beatTheRecord)
        {
         
        }

        public override void Exit()
        {

        }
    }
}