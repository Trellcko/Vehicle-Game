using Constants;
using Trell.VehicleGame.Infrastructure.Factories;
using Trell.VehicleGame.Infrastructure.Input;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car
{
	public class TurretShooting : MonoBehaviour
	{
		[SerializeField] private Transform _shootPoint;
		
		private UnityEngine.Camera _camera;

		private bool _isWorking;
		
		private IInput _input;
		private IGameFactory _gameFactory;

		private void Awake()
		{
			_camera = UnityEngine.Camera.main;
		}

		public void Init(IInput input, IGameFactory gameFactory)
		{
			_gameFactory = gameFactory;
			_input = input;
			_input.Clicked += OnClicked;
		}

		private void OnDisable()
		{
			_input.Clicked -= OnClicked;
		}

		private void OnClicked(Vector2 obj)
		{
			if (!_isWorking)
			{
				_isWorking = true;
				return;
			}
			Ray ray =  _camera.ScreenPointToRay(obj);

			if (Physics.Raycast(ray, out RaycastHit hit, 1000f, LayerNames.GroundLayer))
			{
				Vector3 hitPoint = hit.point;
				hitPoint.y = transform.position.y;
				transform.rotation = Quaternion.LookRotation((transform.position - hitPoint).normalized);

				Shoot((hitPoint - transform.position).normalized);
			}
		}

		private void Shoot(Vector3 direction)
		{
			_gameFactory.CreateProjectile(_shootPoint.transform.position, direction);
		}
	}
}
