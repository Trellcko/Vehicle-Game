using UnityEngine;

namespace Trell.VehicleGame.GamePlay
{
	[CreateAssetMenu(fileName = "LevelWinData", menuName = "GamePlay/LevelWinData")]
	public class LevelWinData : ScriptableObject
	{
		[field: SerializeField] public float DistanceToWin { get; private set; }
	}
}
