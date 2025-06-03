using Trell.VehicleGame.Infrastructure.Saving;

namespace Trell.VehicleGame.Infrastructure.States
{
    public class LoadProgressState : BaseStateWithoutPayload
    {
       

        public LoadProgressState(StateMachine machine, ISaveService saveService, IPersistantPlayerProgressService persistantPlayerProgress) : base(machine)
        {
           
        }

        public override void Enter()
        {
            GoToState<LoadGameState>();
        }

        private static SaveData InitNew() => 
            new()
            {
            };
    }
}