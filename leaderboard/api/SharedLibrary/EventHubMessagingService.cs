using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.Azure.EventHubs;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using System.IO;

namespace SharedLibrary
{
    public class EventHubMessagingService : IMessagingService
    {
        private static EventHubClient eventHubClient;
        private const string CONFIG_FILE = "appsettings.json";

        static EventHubMessagingService()
        {

            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory());


            if (File.Exists(CONFIG_FILE))
            {
                builder.AddJsonFile(CONFIG_FILE);
            }

            builder.AddEnvironmentVariables();

            var configration = builder.Build();


            var eventHubsConnectionString = configration["EvebtHubsConnectionString"];
            var eventHubsEntityPath = configration["EventHubsEntityPath"];

            var connectionStringBuilder = new EventHubsConnectionStringBuilder(eventHubsConnectionString)
            {
                EntityPath = eventHubsEntityPath
            };
            eventHubClient = EventHubClient.CreateFromConnectionString(connectionStringBuilder.ToString());

        }
        public async Task SendMessageAsync(string message)
        {
            await eventHubClient.SendAsync(new EventData(Encoding.UTF8.GetBytes(message)));
        }
    }
}
