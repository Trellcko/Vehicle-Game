using System;
using Trell.VehicleGame.GamePlay.Camera;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.Infrastructure.Factories;
using Trell.VehicleGame.Infrastructure.Input;
using UnityEngine;
using Zenject;

namespace Trell.VehicleGame.GamePlay
{
	public class LevelStarter : MonoBehaviour
	{
		[SerializeField] private CameraSwitcher _cameraSwitcher;
		
		private IInput _input;
		private IGameFactory _gameFactory;
		private CarFacade _car;

		[Inject]
		private void Construct(IInput input, IGameFactory gameFactory)
		{
			_gameFactory = gameFactory;
			_input = input;
			
			_gameFactory.CarCreated += OnCarCreated;
		}

		private void OnDisable()
		{
			_input.Clicked -= OnClicked;
			_gameFactory.CarCreated -= OnCarCreated;
		}

		private void OnCarCreated(CarFacade obj)
		{
			_gameFactory.CarCreated -= OnCarCreated;
			_car = obj;
			_input.Clicked += OnClicked;
		}

		private void OnClicked(Vector2 obj)
		{
			_input.Clicked -= OnClicked;
			_car.CarMovement.StartMovement();
			_cameraSwitcher.SwitchToGameCamera();
		}
	}
}
