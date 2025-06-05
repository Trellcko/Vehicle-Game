using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Zombie
{
    public class ZombieFacade : MonoBehaviour
    {
        [field: SerializeField] public ZombieMovement ZombieMovement { get; private set; }
    }
}