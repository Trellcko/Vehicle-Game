using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Trell.VehicleGame.GamePlay.Car.Projectile
{
    [CreateAssetMenu(fileName = "ProjectileData", menuName = "GamePlay/Projectile", order = 0)]
    public class ProjectileData : ScriptableObject
    {
        [field: SerializeField] public float Speed { get; private set; }
        [field: SerializeField] public float Damage { get; private set; }
        [field: SerializeField] public AssetReference AssetReference { get; private set; }
    }
}