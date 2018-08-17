
using Sentinel.Models.View.Validations;
using FluentValidation.Attributes;

namespace Sentinel.Models.View
{
    [Validator(typeof(CredentialsViewModelValidator))]
    public class CredentialsViewModel
    {
        public string UserName { get; set; }
        public string Password { get; set; }
    }
}
