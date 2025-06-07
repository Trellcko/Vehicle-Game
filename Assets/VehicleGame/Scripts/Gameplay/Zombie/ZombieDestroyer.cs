using Trell.VehicleGame.GamePlay.Zombie;
using UnityEngine;
using UnityEngine.Pool;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	public class ZombieDestroyer : MonoBehaviour
	{
		[SerializeField] private ZombieFacade _zombieFacade;
		
		private ObjectPool<ZombieFacade> _pool;

		public void Init(ObjectPool<ZombieFacade> pool)
		{
			_pool = pool;
		}

		public void ReturnToPool()
		{
			_pool.Release(_zombieFacade);
		}
	}
}
