using System;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.Infrastructure;
using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;
using UnityEngine.UI;
using Zenject;

namespace Trell.VehicleGame.UI
{
	public class LevelProgressBar : MonoBehaviour
	{
		[SerializeField] private Slider _slider;

		private IGameFactory _gameFactory;
		private IStaticDataService _staticDataService;
		private CarFacade _car;

		[Inject]
		private void Construct(IGameFactory gameFactory, IStaticDataService staticDataService)
		{
			_staticDataService = staticDataService;
			_gameFactory = gameFactory;
		}

		private void Update()
		{
			if (_gameFactory.CarFacade)
			{
				_slider.value = Mathf.Clamp01(_gameFactory.CarFacade.transform.position.z /
				                _staticDataService.GetLevelWinData().DistanceToWin);
			}
		}
	}
}
