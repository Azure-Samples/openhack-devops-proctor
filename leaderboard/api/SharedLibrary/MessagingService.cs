using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace SharedLibrary
{
    public interface MessagingService
    {
        Task SendMessageAsync(string message);
    }
}
