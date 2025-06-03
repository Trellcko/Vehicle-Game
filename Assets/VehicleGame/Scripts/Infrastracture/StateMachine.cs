using System;
using System.Collections.Generic;
using Trell.VehicleGame.Infrastructure.States;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure
{
    public class StateMachine
    {
        private Dictionary<Type, BaseState> _states;

        private BaseState _currentBaseState;

        public StateMachine(params BaseState[] states)
        {
            _states = new();
            foreach (BaseState state in states)
            {
                _states.Add(state.GetType(), state);
            }

            AddState(new EmptyState(this));
            _currentBaseState = _states[typeof(EmptyState)];
        }

        public void AddState(params BaseState[] states)
        {
            foreach (BaseState state in states)
            {
                _states.Add(state.GetType(), state);
            }
        }

        public void Update()
        {
            _currentBaseState.CheckTransition();
            _currentBaseState.Update();
        }

        public void FixedUpdate()
        {
            _currentBaseState.FixedUpdate();
        }

        public void SetState<T>() where T : BaseStateWithoutPayload
        {
            SetState(typeof(T), x => ((BaseStateWithoutPayload)x).Enter());
        }

        public void SetState<T, TPayload>(TPayload payload) where T : BaseStateWithPayLoad<TPayload>
        {
            SetState(typeof(T), x => ((BaseStateWithPayLoad<TPayload>)x).Enter(payload));
        }

        private void SetState(Type type, Action<BaseState> enterAction)
        {
            if (_states.ContainsKey(type))
            {
                ExitCurrentState();
                ChangeState(type, enterAction);
                return;
            }

            Debug.LogError("State: " + type.Name + " is not inclued");
        }

        private void ChangeState(Type type, Action<BaseState> enterAction)
        {
            BaseState baseState = _states[type];
            _currentBaseState = baseState;
            enterAction(_currentBaseState);
        }

        private void ExitCurrentState()
        {
            _currentBaseState?.Exit();
        }
    }
}
