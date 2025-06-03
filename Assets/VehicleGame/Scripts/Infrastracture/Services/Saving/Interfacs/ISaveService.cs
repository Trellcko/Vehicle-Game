namespace Trell.VehicleGame.Infrastructure.Saving
{
    public interface ISaveService
    {
        SaveData Load();
        void Save();
    }
}