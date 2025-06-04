using System;
using UnityEngine;
using Zenject;

namespace Trell.VehicleGame.Infrastructure.Input
{
    public class TouchInput : IInput, ITickable
    {
        public event Action<Vector2> Clicked;
        
        public void Tick()
        {
            if (UnityEngine.Input.touchCount > 0 && UnityEngine.Input.GetTouch(0).phase == TouchPhase.Began)
            {
                Clicked?.Invoke(UnityEngine.Input.GetTouch(0).position);
            }
        }
    }
}
