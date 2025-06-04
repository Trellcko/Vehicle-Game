using Trell.VehicleGame.UI;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay
{
	public class HealthUIActor : MonoBehaviour
	{
		[SerializeField] private Health _health;
		[SerializeField] private HealthBar _healthBar;
		

		private void OnEnable()
		{
			_health.Damaged += OnDamaged;
			_health.Died += OnDied;
		}

		private void OnDied()
		{
			_healthBar.SetZero();
		}

		private void OnDamaged()
		{
			_healthBar.UpdateValue(_health.CurrentHealth, _health.MaxHealth);
		}

		private void OnDisable()
		{
			_health.Damaged -= OnDamaged;
			_health.Died -= OnDied;
		}
	}
}
