using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Trell.VehicleGame.GamePlay.Zombie
{
    [CreateAssetMenu(fileName = "ZombieData", menuName = "GamePlay/Zombie", order = 0)]
    public class ZombieData : ScriptableObject
    {
        [field: SerializeField] public AssetReference AssetReference { get; private set; }
        [field: SerializeField] public float RunSpeed { get; private set; }
        [field: SerializeField] public float RotateSpeed { get; private set; }
        [field: SerializeField] public float WalkSpeed { get; private set; }
    }
}