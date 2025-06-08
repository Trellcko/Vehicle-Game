using System;
using Constants;

namespace Trell.VehicleGame.Infrastructure
{
    public interface ISceneService
    {
        public void Load(SceneName sceneName, Action onLoaded = null);
        string CurrentScene { get; }
    }
}