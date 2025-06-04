using System;
using UnityEngine;

namespace Trell.VehicleGame.Infrastructure.Input
{
    public interface IInput
    {
        event Action<Vector2> Clicked;
    }
}