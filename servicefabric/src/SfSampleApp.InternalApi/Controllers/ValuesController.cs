using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;

namespace SfSampleApp.InternalApi.Controllers
{
    [ApiController]
    public class ValuesController : ControllerBase
    {
        [HttpGet]
        [Route("api/values")]
        public ActionResult<IEnumerable<string>> Get()
        {
            return new string[] { "value1", "value2" };
        }

        [HttpGet]
        [Route("api/env")]
        public ActionResult<IDictionary<string, string>> Env()
        {
            return new Dictionary<string, string>
            {
                {"ASPNETCORE_ENVIRONMENT", Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")},
                {"APPINSIGHTS_INSTRUMENTATIONKEY", Environment.GetEnvironmentVariable("APPINSIGHTS_INSTRUMENTATIONKEY")}
            };
        }
    }
}
