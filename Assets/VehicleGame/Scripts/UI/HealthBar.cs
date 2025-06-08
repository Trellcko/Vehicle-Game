using DG.Tweening;
using UnityEngine;
using UnityEngine.UI;

namespace Trell.VehicleGame.UI
{
	public class HealthBar : MonoBehaviour
	{
		[SerializeField] private Image _bg;
		[SerializeField] private Image _fill;
		[SerializeField] private Image _temporaryFill;

		[SerializeField] private float _animationTime = 0.2f;

		private void Awake()
		{
			_bg.enabled = _fill.enabled = _temporaryFill.enabled = false;
		}

		public void SetZero()
		{
			_temporaryFill.DOKill();
			
			_fill.fillAmount = 0;
			_temporaryFill.fillAmount = 0;
		}
		
		public void UpdateValue(float currentHealth, float maxHealth)
		{
			_bg.enabled = _fill.enabled = _temporaryFill.enabled = maxHealth - currentHealth > 0.01f;
		
			_temporaryFill.DOKill();
			
			float percent = currentHealth / maxHealth;
			
			_temporaryFill.fillAmount = _fill.fillAmount;
			_fill.fillAmount = percent;

			_temporaryFill.DOFillAmount(percent, _animationTime);
		}
	}
}
