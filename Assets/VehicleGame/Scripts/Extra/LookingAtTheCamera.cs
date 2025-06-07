using UnityEngine;

namespace Trell.VehicleGame.Extra
{
	public class LookingAtTheCamera : MonoBehaviour
	{

		private Camera _mainCamera;

		private void Start()
		{
			_mainCamera = Camera.main;
		}

		public void LateUpdate()
		{
			transform.LookAt(transform.position + _mainCamera.transform.rotation * Vector3.forward,
				_mainCamera.transform.rotation * Vector3.up);
		}
	}
}
