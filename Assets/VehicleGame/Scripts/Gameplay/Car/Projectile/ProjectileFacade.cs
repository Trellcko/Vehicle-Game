using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
	public class ProjectileFacade : MonoBehaviour
	{
		[field: SerializeField] public ProjectileMovement ProjectileMovement { get; private set; }
		[field: SerializeField] public ProjectileCollisionEventInvoker ProjectileCollisionEventInvoker { get; private set; }
		[field: SerializeField] public ProjectileAttacking ProjectileAttacking { get; private set; }
		[field: SerializeField] public ProjectileDestroyer ProjectileDestroyer { get; private set; }
		[field: SerializeField] public TrailRenderer TrailRenderer { get; private set; }
	}
}
