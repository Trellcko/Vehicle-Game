using Trell.VehicleGame.GamePlay.Car;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Zombie
{
    public class ZombieFacade : MonoBehaviour
    {
        [field: SerializeField] public ZombieMovement ZombieMovement { get; private set; }
        [field: SerializeField] public ZombieChaseTrigger ZombieChaseTrigger { get; private set; }
        [field: SerializeField] public ZombieDestroyer ZombieDestroyer { get; private set; }
        [field: SerializeField] public Health ZombieHealth { get; private set; }
        [field: SerializeField] public ZombieCollisionEventInvoker ZombieCollisionEventInvoker { get; private set; }
        [field: SerializeField] public ZombieAnimator ZombieAnimator { get; private set; }
        [field: SerializeField] public ZombieAttacking ZombieAttacking { get; private set; }
    }
}