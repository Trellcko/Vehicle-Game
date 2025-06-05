using Trell.VehicleGame.Extra;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Trell.VehicleGame.GamePlay.Zombie
{
	public class ZombieMovement : MonoBehaviour
	{
		[SerializeField] private ZombieAnimator _zombieAnimator;

		[SerializeField] private Vector2 _patrollingOffset;
		[SerializeField] private float _idleTime;

		[SerializeField] private float _runSpeed;
		[SerializeField] private float _walkSpeed;
		[SerializeField] private float _rotateSpeed;

		[SerializeField] private Transform _target;

		[SerializeField] private bool _chaseTarget;

		private Vector3 _patrollingPoint;
		private BetterTimer _idleTimer;

		private void Start()
		{
			_patrollingPoint = transform.position;
			_idleTimer = new(_idleTime, offset: 0.1f);
			_idleTimer.Completed += CalculateNewPatrolPosition;
		}

		private void CalculateNewPatrolPosition()
		{
			_patrollingPoint.x += Random.Range(-_patrollingOffset.x, _patrollingOffset.x);
			_patrollingPoint.z += Random.Range(-_patrollingOffset.y, _patrollingOffset.y);
		}

		private void Update()
		{
			_idleTimer.Tick();
			
			if (_target && _chaseTarget)
			{
				_idleTimer.Pause();
				MoveToTarget();
			}
			else
			{
				Patrols();
			}
		}

		private void Patrols()
		{
			if (Vector3.Distance(_patrollingPoint, transform.position) < 0.1f)
			{
				if (_idleTimer.IsCompleted)
				{
					_idleTimer.Reset();
					_zombieAnimator.SetIdle();
				}
			}
			else
			{
				
				_zombieAnimator.SetWalk();
				Move(_patrollingPoint, _walkSpeed);
				Rotate(_patrollingPoint);
			}
		}

		private void MoveToTarget()
		{
			_zombieAnimator.SetRun();
			Move(_target.position, _runSpeed);
			Rotate(_target.position);
		}

		public void Init(float runSpeed, float walkSpeed, float rotateSpeed, Transform target)
		{
			_target = target;
			_runSpeed = runSpeed;
			_walkSpeed = walkSpeed;
			_rotateSpeed = rotateSpeed;
		}
		
		private void Rotate(Vector3 to)
		{
			Vector3 direction = (to - transform.position).normalized;
			transform.rotation = Quaternion.RotateTowards(transform.rotation, 
				Quaternion.LookRotation(direction), 
				Time.deltaTime * _rotateSpeed);
		}

		private void Move(Vector3 to, float speed)
		{
			transform.position = Vector3.MoveTowards(transform.position,to, speed * Time.deltaTime);
		}
	}
}
