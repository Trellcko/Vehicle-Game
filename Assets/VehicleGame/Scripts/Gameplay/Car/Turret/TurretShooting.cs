using Constants;
using Trell.VehicleGame.Infrastructure.Input;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car.Turret
{
	public class TurretShooting : MonoBehaviour
	{
		private IInput _input;

		private UnityEngine.Camera _camera;

		private void Awake()
		{
			_camera = UnityEngine.Camera.main;
		}

		public void Init(IInput input)
		{
			_input = input;
			_input.Clicked += OnClicked;
		}

		private void OnDisable()
		{
			_input.Clicked -= OnClicked;
		}

		private void OnClicked(Vector2 obj)
		{
			Ray ray =  _camera.ScreenPointToRay(obj);

			if (Physics.Raycast(ray, out RaycastHit hit, 1000f, LayerNames.GroundLayer))
			{
				Vector3 hitPoint = hit.point;
				hitPoint.y = transform.position.y;
				transform.rotation = Quaternion.LookRotation((transform.position - hitPoint).normalized);
			}
		}
	}
}
