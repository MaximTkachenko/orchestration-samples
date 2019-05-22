using System;

namespace BackService.Messaging
{
    public sealed class PersonModel
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
