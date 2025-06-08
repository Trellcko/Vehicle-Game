using System;
using Trell.VehicleGame.GamePlay.Car;
using Trell.VehicleGame.Infrastructure.Factories;
using UnityEngine;
using Zenject;
using Random = UnityEngine.Random;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	public class ZombieSpawner : MonoBehaviour
	{
		[SerializeField] private Vector2 _spawnDistanceFromCarMinMaxZ;
		[SerializeField] private Vector2 _spawnDistanceMinMaxX;

		[SerializeField] private float _spawnDistanceThreshold;
		[SerializeField] private Vector2Int _count;
		
		private IGameFactory _gameFactory;

		private float _lastSpawnDistance;

		[Inject]
		private void Construct(IGameFactory gameFactory)
		{
			_gameFactory = gameFactory;
		}
		
		private void Update()
		{
			if(!_gameFactory.CarFacade)
				return;
			
			if (_gameFactory.CarFacade.transform.position.z > _lastSpawnDistance)
			{
				_lastSpawnDistance += _spawnDistanceThreshold;
				SpawnZombies();
			}
		}

		private void SpawnZombies()
		{
			int count = Random.Range(_count.x, _count.y + 1);
			
			for(int  i = 0; i < count; i++)
				_gameFactory.CreateZombie(GetSpawnPosition());
		}

		private Vector3 GetSpawnPosition()
		{
			Vector3 spawnPosition =	new()
			{
				x = Random.Range(_spawnDistanceMinMaxX.x, _spawnDistanceMinMaxX.y),
				z = Random.Range(_gameFactory.CarFacade.transform.position.z + _spawnDistanceFromCarMinMaxZ.x,
					_gameFactory.CarFacade.transform.position.z + _spawnDistanceFromCarMinMaxZ.y)
			};
			return spawnPosition;
		}
	}
}
