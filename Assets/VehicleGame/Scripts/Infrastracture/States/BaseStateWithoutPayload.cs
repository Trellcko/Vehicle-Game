using System.Threading.Tasks;
using Trell.VehicleGame.Infrastructure;

namespace Trell.VehicleGame.Infrastructure.States
{
    public abstract class BaseStateWithoutPayload : BaseState
    {
        protected BaseStateWithoutPayload(StateMachine machine) : base(machine)
        {

        }

        public virtual void Enter()
        {
        }

    }
}