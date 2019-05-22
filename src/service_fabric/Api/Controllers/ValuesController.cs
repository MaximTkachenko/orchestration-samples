using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Api.Models;
using BackService.Messaging;
using Microsoft.AspNetCore.Mvc;
using Microsoft.ServiceFabric.Services.Remoting.Client;

namespace Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        private readonly IPersonService _personService;

        public ValuesController()
        {
            _personService = ServiceProxy.Create<IPersonService>(new Uri("fabric:/AsfSample/BackService"));
        }

        // GET api/values
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            return Ok((await _personService.GetPersons()).Select(x => x.Id).ToArray());
        }

        // POST api/values
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] PostViewModel model)
        {
            await _personService.CreatePerson(new PersonModel
            {
                Id = Guid.NewGuid(),
                FirstName = model.FirstName,
                LastName = model.LastName
            });
            return Ok();
        }
    }
}
