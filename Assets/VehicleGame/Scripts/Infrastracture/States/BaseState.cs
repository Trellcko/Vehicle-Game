using System;
using System.Collections.Generic;
using System.Linq;

namespace Trell.VehicleGame.Infrastructure.States
{
    public abstract class BaseState
    {
        public event Action<Type> StateCompleted;
        private Dictionary<Func<bool>, Action> _transitions = new();

        private StateMachine StateMachine { get; set; }

        protected BaseState(StateMachine machine)
        {
            StateMachine = machine;
        }

        public void CheckTransition()
        {
            foreach (KeyValuePair<Func<bool>, Action> transition
                     in _transitions.Where(transition => transition.Key()))
            {
                transition.Value();
                break;
            }
        }

        public virtual void Update()
        {
        }

        public virtual void FixedUpdate()
        {
        }

        public virtual void Exit()
        {
        }

        protected void GoToState<T>(Func<bool> when) where T : BaseStateWithoutPayload
        {
            _transitions.Add(when, StateMachine.SetState<T>);
        }

        protected void GoToState<T>() where T : BaseStateWithoutPayload
        {
            StateMachine.SetState<T>();
        }

        protected void GoToState<T, TPayLoad>(Func<bool> when, TPayLoad payLoad)
            where T : BaseStateWithPayLoad<TPayLoad>
        {
            _transitions.Add(when, () => StateMachine.SetState<T, TPayLoad>(payLoad));
        }

        protected void GoToState<T, TPayLoad>(TPayLoad payLoad) where T : BaseStateWithPayLoad<TPayLoad>
        {
            StateMachine.SetState<T, TPayLoad>(payLoad);
        }
    }
}