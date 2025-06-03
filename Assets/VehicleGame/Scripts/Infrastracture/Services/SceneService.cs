using System;
using System.Collections;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Trell.VehicleGame.Infrastructure
{
    public class SceneService : ISceneService
    {
        public string CurrentScene => SceneManager.GetActiveScene().name;
        
        public async void Load(string sceneName, Action onLoaded = null)
        {
            try
            {
                AsyncOperation waitNextScene = SceneManager.LoadSceneAsync(sceneName);

                while (!waitNextScene.isDone)
                {
                    await Task.Yield();
                }

                onLoaded?.Invoke();
            }
            catch (Exception e)
            {
                Debug.Log(e.Message + "\n" + e.StackTrace);
            }
        }
    }
}