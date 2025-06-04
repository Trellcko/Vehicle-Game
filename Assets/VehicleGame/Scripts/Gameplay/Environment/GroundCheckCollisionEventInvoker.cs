using System;
using Trell.VehicleGame.GamePlay.Car;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Environment
{
    [RequireComponent(typeof(Collider))]
    public class GroundCheckCollisionEventInvoker : MonoBehaviour
    {
        public event Action CarCollided;
        
        private void OnTriggerEnter(Collider other)
        {
            if (other.TryGetComponent(out CarFacade _))
            {
                CarCollided?.Invoke();
            }
        }
    }
}