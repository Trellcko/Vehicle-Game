using System;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
	public class ProjectileMovement : MonoBehaviour
	{
		[SerializeField] private Rigidbody _rigidbody;
		public event Action<GameObject> WentThroughSomething;
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
			Vector3 movement = _direction * (_speed * Time.deltaTime);
			if (Physics.SphereCast(transform.position, 0.5f, _direction, out RaycastHit hit, movement.magnitude))
			{
				WentThroughSomething?.Invoke(hit.collider.gameObject);
			}
			transform.position += movement;
		}


	}
}

