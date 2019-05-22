using Newtonsoft.Json;

namespace Api.Models
{
    public class PostViewModel
    {
        [JsonProperty("firstName")]
        public string FirstName { get; set; }

        [JsonProperty("lastName")]
        public string LastName { get; set; }
    }
}
