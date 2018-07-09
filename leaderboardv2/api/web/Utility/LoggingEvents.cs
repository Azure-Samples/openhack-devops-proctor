using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace Sentinel.Utility
{
    // You may need to install the Microsoft.AspNetCore.Http.Abstractions package into your project
    public class LoggingEvents
    {
        public const int Healthcheck = 1000;

        public const int GetLogMessagesForTeam = 2001;
        public const int CreateLogMessageForTeam = 2002;

    }

}
