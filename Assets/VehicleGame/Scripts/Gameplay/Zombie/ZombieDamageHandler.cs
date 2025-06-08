using System.Collections;
using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	public class ZombieDamageHandler : MonoBehaviour
	{
		[SerializeField] private Renderer _renderer;
		[SerializeField] private Health _health;

		private MaterialPropertyBlock _materialPropertyBlock;
		private Coroutine _coroutine;
		
		private static readonly int BaseColor = Shader.PropertyToID("_BaseColor");
		
		private void Awake()
		{
			_materialPropertyBlock = new();
		}

		private void OnEnable()
		{
			_health.Damaged += OnDamaged;
			_materialPropertyBlock.SetColor(BaseColor, Color.red);
			_renderer.SetPropertyBlock(_materialPropertyBlock);

		}

		private void OnDisable()
		{
			_health.Damaged -= OnDamaged;
			if(_coroutine != null)
				StopCoroutine(_coroutine);
			SetRedColor();
			
		}

		private void OnDamaged()
		{
			_coroutine = StartCoroutine(DamageCorun());
		}

		private IEnumerator DamageCorun()
		{
			SetWhiteColor();
			yield return new WaitForSeconds(0.1f);
			SetRedColor();
		}

		private void SetWhiteColor()
		{
			_materialPropertyBlock.SetColor(BaseColor, Color.white);
			_renderer.SetPropertyBlock(_materialPropertyBlock);
		}

		private void SetRedColor()
		{
			_materialPropertyBlock.SetColor(BaseColor, Color.red);
			_renderer.SetPropertyBlock(_materialPropertyBlock);
		}
	}
}
