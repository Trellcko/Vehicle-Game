using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;

namespace Trell.VehicleGame.Infrastructure.AssetManagment
{
    public interface IAssetProvider
    {
        void CleanUp();
        GameObject Instantiate(string path);
        GameObject Instantiate(string path, Vector3 at);
        GameObject Instantiate(string path, Vector3 at, Quaternion rotation);
        GameObject Instantiate(string path, Vector3 at, Quaternion rotation, Transform parent);
        Task<T> Load<T>(string path) where T : class;
        Task<T> Load<T>(AssetReference assetReference) where T : class;
    }
}