using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	[RequireComponent(typeof(Animator))]
	public class ZombieAnimator : MonoBehaviour
	{
		[SerializeField] private Animator _animator;
		
		private static readonly int IsIdle = Animator.StringToHash("IsIdle");
		private static readonly int Attack = Animator.StringToHash("Attack");
		private static readonly int Die = Animator.StringToHash("Die");
		private static readonly int Damage = Animator.StringToHash("Damage");
		private static readonly int Speed = Animator.StringToHash("Speed");

		public void SetIdle()
		{
			_animator.SetBool(IsIdle, true);
		}

		public void SetWalk()
		{
			_animator.SetBool(IsIdle, false);
			_animator.SetFloat(Speed, 1);
		}

		public void SetRun()
		{
			_animator.SetBool(IsIdle, false);
			_animator.SetFloat(Speed, 2);
		}
		
		public void SetAttackTrigger()
		{
			_animator.SetTrigger(Attack);	
		}

		public void SetDamageTrigger()
		{
			_animator.SetTrigger(Damage);
		}

		public void SetDieTrigger()
		{
			_animator.SetTrigger(Die);
		}
	}
}
