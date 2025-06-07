using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
	public class ProjectileMovement : MonoBehaviour
	{
		private float _speed;
		
		private Vector3 _direction;

		public void Init(float speed, Vector3 direction)
		{
			_speed = speed;
			_direction = direction;
		}

		private void Update()
		{
			transform.position += _direction * (_speed * Time.deltaTime);
		}
	}
}
