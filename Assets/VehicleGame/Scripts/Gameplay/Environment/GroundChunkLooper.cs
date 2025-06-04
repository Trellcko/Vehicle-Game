using UnityEngine;

namespace Trell.VehicleGame.GamePlay.Environment
{
    public class GroundChunkLooper : MonoBehaviour
    {
        [SerializeField] private GroundCheckCollisionEventInvoker _groundCheckCollisionEventInvoker1;
        [SerializeField] private GroundCheckCollisionEventInvoker _groundCheckCollisionEventInvoker2;
        
        private const float GroundLength = 105f;

        private void OnEnable()
        {
            _groundCheckCollisionEventInvoker1.CarCollided += MoveSecondChunk;
            _groundCheckCollisionEventInvoker2.CarCollided += MoveFirstChunk;
        }

        private void OnDisable()
        {
            _groundCheckCollisionEventInvoker1.CarCollided -= MoveSecondChunk;
            _groundCheckCollisionEventInvoker2.CarCollided -= MoveFirstChunk;
        }

        private void MoveFirstChunk()
        {
            MoveChunk(_groundCheckCollisionEventInvoker1.transform.parent);
        }

        private void MoveSecondChunk()
        {
            MoveChunk(_groundCheckCollisionEventInvoker2.transform.parent);
        }

        private void MoveChunk(Transform chunk)
        {
            chunk.position += Vector3.forward * GroundLength * 2;
        }
    }
}