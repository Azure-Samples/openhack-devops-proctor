using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace SharedLibrary
{
    public interface IMessagingService
    {
        Task SendMessageAsync(string message);
    }
}
