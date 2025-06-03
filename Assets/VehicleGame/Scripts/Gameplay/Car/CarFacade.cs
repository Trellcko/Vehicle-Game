using UnityEngine;

namespace Trell.VehicleGame.Gameplay.Car
{
    public class CarFacade : MonoBehaviour
    {
        [field: SerializeField] public CarMovement CarMovement { get; private set; }
    }
}