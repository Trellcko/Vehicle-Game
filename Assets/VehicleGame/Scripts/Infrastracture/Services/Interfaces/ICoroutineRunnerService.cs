using System.Collections;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure
{
    public interface ICoroutineRunnerService
    {
        Coroutine StartCoroutine(IEnumerator name);
    }
}