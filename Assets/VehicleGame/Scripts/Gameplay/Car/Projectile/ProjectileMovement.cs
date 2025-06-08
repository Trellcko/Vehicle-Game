using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
	public class ProjectileMovement : MonoBehaviour
	{
		[SerializeField] private Rigidbody _rigidbody;
		
		private float _speed;
		
		private Vector3 _direction;

		public void Init(float speed)
		{
			_speed = speed;
		}

		public void SetDirection(Vector3 direction)
		{
			_direction = direction;
		}

		private void Update()
		{
			_rigidbody.MovePosition(_rigidbody.position + _direction * (_speed * Time.deltaTime));
		}
	}
}
