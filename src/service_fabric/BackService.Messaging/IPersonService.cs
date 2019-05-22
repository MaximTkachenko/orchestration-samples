using System.Threading.Tasks;
using Microsoft.ServiceFabric.Services.Remoting;

namespace BackService.Messaging
{
    public interface IPersonService : IService
    {
        Task CreatePerson(PersonModel person);
        Task<PersonModel[]> GetPersons();
    }
}
