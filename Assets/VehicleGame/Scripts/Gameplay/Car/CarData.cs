using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Trell.VehicleGame.GamePlay.Car
{
    [CreateAssetMenu(fileName = "CarData", menuName = "GamePlay/Car", order = 0)]
    public class CarData : ScriptableObject
    {
        [field: SerializeField] public AssetReference AssetReference { get; private set; }
        [field: SerializeField] public float Speed { get; private set; } = 6;
        [field: SerializeField] public float Health { get; private set; } = 100;
    }
}