using System;
using Trell.VehicleGame.UI;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay
{
	public class HealthUIActor : MonoBehaviour
	{
		[SerializeField] private Health _health;
		[SerializeField] private HealthBar _healthBar;

		private void Awake()
		{
			_health.Inited += OnDamaged;
		}

		private void OnEnable()
		{
			_health.Damaged += OnDamaged;
			_health.Died += OnDied;
		}

		private void OnDisable()
		{
			_health.Damaged -= OnDamaged;
			_health.Died -= OnDied;
		}

		private void OnDestroy()
		{
			_health.Inited -= OnDamaged;
		}

		private void OnDied()
		{
			_healthBar.SetZero();
		}

		private void OnDamaged()
		{
			_healthBar.UpdateValue(_health.CurrentHealth, _health.MaxHealth);
		}
	}
}
