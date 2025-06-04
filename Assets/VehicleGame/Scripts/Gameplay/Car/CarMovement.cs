using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car
{
    public class CarMovement : MonoBehaviour
    {
        [SerializeField] private float _speed;

        [SerializeField] private bool _isMovementStarted;

        private void Update()
        {
            if (_isMovementStarted)
                transform.position += transform.forward * (_speed * Time.deltaTime);
        }

        public void StartMovement()
        {
            _isMovementStarted = true;
        }

        public void StopMovement()
        {
            _isMovementStarted = false;
        }
        
        public void Init(float carDataSpeed)
        {
            _speed = carDataSpeed;
        }
    }
}