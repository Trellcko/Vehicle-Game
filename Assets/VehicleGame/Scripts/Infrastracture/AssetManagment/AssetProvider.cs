using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

namespace Trell.VehicleGame.Infrastructure.AssetManagment
{
    public class AssetProvider : IAssetProvider
    {
        private readonly Dictionary<string, AsyncOperationHandle> _completed = new();
        private readonly Dictionary<string, List<AsyncOperationHandle>> _handles = new();

        public GameObject Instantiate(string path)
            => Instantiate(path, Vector3.zero, Quaternion.identity, null);

        public GameObject Instantiate(string path, Vector3 at)
            => Instantiate(path, at, Quaternion.identity, null);

        public GameObject Instantiate(string path, Vector3 at, Quaternion rotation)
            => Instantiate(path, at, rotation, null);

        public GameObject Instantiate(string path, Vector3 at, Quaternion rotation, Transform parent)
        {
            GameObject prefab = Resources.Load<GameObject>(path);
            if (prefab)
            {
                return Object.Instantiate(prefab, at, rotation, parent);
            }

            Debug.LogError(@"Wrong path: """ + path + @"""");
            return null;
        }

        public async Task<T> Load<T>(string path) where T : class
        {
            if (_completed.TryGetValue(path, out AsyncOperationHandle result))
            {
                return (T)result.Result;
            }

            AsyncOperationHandle<T> asyncOperationHandle = Addressables.LoadAssetAsync<T>(path);

            asyncOperationHandle.Completed += h =>
            {
                if (_completed.ContainsKey(path))
                {
                    _completed.Add(path, h);
                }
            };

            AddHandle(path, asyncOperationHandle);

            return await asyncOperationHandle.Task;
        }

        public async Task<T> Load<T>(AssetReference assetReference) where T : class
        {
            return await Load<T>(assetReference.AssetGUID);
        }

        public void CleanUp()
        {
            foreach (AsyncOperationHandle resourceHandle in _handles.Values.SelectMany(handleList => handleList))
            {
                Addressables.Release(resourceHandle);
            }

            _handles.Clear();
            _completed.Clear();
        }

        private void AddHandle<T>(string path, AsyncOperationHandle<T> asyncOperationHandle)
            where T : class
        {
            if (!_handles.TryGetValue(path, out List<AsyncOperationHandle> resourceHandle))
            {
                resourceHandle = new();
                _handles[path] = resourceHandle;
            }

            resourceHandle.Add(asyncOperationHandle);
        }
    }
}