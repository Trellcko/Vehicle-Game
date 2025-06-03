using System;

namespace Trell.VehicleGame.Infrastructure
{
    public interface ISceneService
    {
        public void Load(string sceneName, Action onLoaded = null);
    }
}