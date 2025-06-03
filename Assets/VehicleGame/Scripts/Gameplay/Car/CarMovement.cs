using UnityEngine;

namespace Trell.VehicleGame.Gameplay.Car
{
    public class CarMovement : MonoBehaviour
    {
        [SerializeField] private float _speed;

        private void Update()
        {
            transform.position += transform.forward * (_speed * Time.deltaTime);
        }

        public void Init(float carDataSpeed)
        {
            _speed = carDataSpeed;
        }
    }
}