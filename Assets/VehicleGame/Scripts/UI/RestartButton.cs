using Constants;
using Trell.Skyroads.UI;
using Trell.VehicleGame.Infrastructure;
using Zenject;

namespace Trell.VehicleGame.UI
{
	public class RestartButton : ButtonWrapper
	{
		private IGameBehaviour _gameBehaviour;

		[Inject]
		private void Construct(IGameBehaviour gameBehaviour)
		{
			_gameBehaviour = gameBehaviour;
		}
		
		protected override void InvokeClickLogic()
		{
			_gameBehaviour.ReloadGame();
		}
	}
}
