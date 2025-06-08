using UnityEngine;
using UnityEngine.Pool;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
	public class ProjectileDestroyer : MonoBehaviour
	{
		[SerializeField] private ProjectileFacade _projectileFacade;
		private ObjectPool<ProjectileFacade> _pool;


		public void Init(ObjectPool<ProjectileFacade> pool)
		{
			_pool = pool;
		}
		
		public void ReturnToPool()
		{
			_pool.Release(_projectileFacade);
		}
	}
}
