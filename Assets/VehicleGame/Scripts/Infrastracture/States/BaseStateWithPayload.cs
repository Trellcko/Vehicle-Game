namespace Trell.VehicleGame.Infrastructure.States
{
    public abstract class BaseStateWithPayLoad<TPayLoad> : BaseState
    {
        protected BaseStateWithPayLoad(StateMachine machine) : base(machine)
        {

        }

        public virtual void Enter(TPayLoad payLoad)
        {
        }
    }
}