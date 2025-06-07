using Trell.VehicleGame.GamePlay.Car.Turret;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Car
{
    public class CarFacade : MonoBehaviour
    {
        [field: SerializeField] public CarMovement CarMovement { get; private set; }
        [field: SerializeField] public Health CarHealth { get; private set; }
        [field: SerializeField] public TurretShooting TurretShooting { get; private set; }
    }
}