using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Trell.VehicleGame.GamePlay.Zombie
{
    [CreateAssetMenu(fileName = "ZombieData", menuName = "GamePlay/Zombie", order = 0)]
    public class ZombieData : ScriptableObject
    {
        [field: SerializeField] public AssetReference AssetReference { get; private set; }
        [field: SerializeField] public float RunSpeed { get; private set; } = 2f;
        [field: SerializeField] public float RotateSpeed { get; private set; } = 180f;
        [field: SerializeField] public float WalkSpeed { get; private set; } = 1f;
        [field: SerializeField] public float IdleTime { get; private set; } = 1f;
        [field: SerializeField] public float Damage { get; private set; } = 10f;
        [field: SerializeField] public float Health { get; private set; } = 50f;
    }
}