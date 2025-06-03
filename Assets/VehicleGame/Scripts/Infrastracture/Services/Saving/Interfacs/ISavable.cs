namespace Trell.VehicleGame.Infrastructure.Saving
{
    public interface ISavable : IReadable
    {
        public void Save(SaveData saveData);
    }
}