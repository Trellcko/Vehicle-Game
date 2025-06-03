using System;
using UnityEngine;
using UnityRandom = UnityEngine.Random;

namespace Trell.VehicleGame.Extra
{
    public class BetterTimer
    {
        private float _offset;
        private float _time;
        private bool _loop;
        private float _speed = 1f;
        private readonly bool _playAwake;
        
        public event Action Updated;
        public event Action Completed;
        public event Action Playing;


        public bool IsCompleted { get; private set; }
        public bool IsPaused { get; private set; }
        public float CurrentValue { get; private set; }
        public float PreviousTime { get; private set; }

        public float MaxValue => _time;

        public BetterTimer()
        {
            IsCompleted = true;
        }

        public BetterTimer(float time, float offset = 0f, bool loop = false, bool playAwake = false)
        {
            _time = time;
            _offset = offset;
            PreviousTime = CurrentValue = _time + UnityRandom.Range(-_offset, _offset);
            _loop = loop;
            _playAwake = playAwake;
            
            if (!_playAwake)
            {
                IsCompleted = true;
                PreviousTime = CurrentValue = 0f;
            }
        }


        public void Pause()
        {
            IsPaused = true;
        }

        public void UnPause()
        {
            IsPaused = false;
        }

        public void SetSpeed(float speed)
        {
            _speed = Mathf.Clamp(speed, 0, float.MaxValue);
        }
        
        public void AddToCurrentTime(float value)
        {
            CurrentValue += value;
            Tick();
        }

        public void SetTime(float time)
        {
            _time = time;
        }

        public void SetLoop(bool isLoop)
        {
            _loop = isLoop;
        }

        public void SetOffset(float offset)
        {
            _offset = offset;
        }

        public void Reset()
        {
            UnPause();
            CurrentValue = _time + UnityRandom.Range(-_offset, _offset);
            Playing?.Invoke();
            IsCompleted = false;
        }

        public void Tick()
        {
            if (IsCompleted || IsPaused)
            {
                return;
            }

            PreviousTime = CurrentValue;
            CurrentValue -= Time.deltaTime * _speed;

            Updated?.Invoke();

            if (CurrentValue <= 0)
            {
                CurrentValue = 0f;

                IsCompleted = true;

                Completed?.Invoke();

                if (_loop)
                {
                    CurrentValue = _time + UnityRandom.Range(-_offset, _offset);
                    IsCompleted = false;
                    Playing?.Invoke();
                    return;
                }
            }
        }
    }
}