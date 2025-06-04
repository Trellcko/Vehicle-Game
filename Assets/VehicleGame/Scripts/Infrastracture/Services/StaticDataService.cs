using Trell.VehicleGame.GamePlay.Car;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure
{
    public class StaticDataService : MonoBehaviour, IStaticDataService
    {
        [SerializeField] private CarData _carData;

        public CarData GetCarData() =>
            _carData;
    }
}