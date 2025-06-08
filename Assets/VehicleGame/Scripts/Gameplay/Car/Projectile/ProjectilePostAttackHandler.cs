using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
	public class ProjectilePostAttackHandler : MonoBehaviour
	{
		[SerializeField] private ProjectileFacade _facade;

		private void OnEnable()
		{
			_facade.ProjectileAttacking.AttackCompleted += OnAttackCompleted;
		}

		private void OnDisable()
		{
			_facade.ProjectileAttacking.AttackCompleted -= OnAttackCompleted;
		}

		private void OnAttackCompleted()
		{
			_facade.ProjectileDestroyer.ReturnToPool();
		}
	}
}
