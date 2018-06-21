using Microsoft.Azure.EventHubs;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Models;
using Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace Leaderboard.Test
{
    /// <summary>
    /// E2E testing for the EventHubs, Stream Analytics, and CosmosDB 
    /// </summary>
    [TestClass]
    public class LeaderboardTest
    {
        private static EventHubClient eventHubClient = null;
        private static string eventHubName = null;
        private static string connectionString = null;
        static LeaderboardTest () {
            eventHubName = Environment.GetEnvironmentVariable("EVENTHUB_NAME");
            connectionString = Environment.GetEnvironmentVariable("EVENTHUB_CONNECTION_STRING");
            // If we can't find the environment variables, we load the value from appsettings.json
            if (string.IsNullOrEmpty(eventHubName) || string.IsNullOrEmpty(connectionString))
            {
                var builder = new ConfigurationBuilder()
                    .SetBasePath(Directory.GetCurrentDirectory())
                    .AddJsonFile("appsettings.json");
                var configration = builder.Build();
                eventHubName = configration["EVENTHUB_NAME"];
                connectionString = configration["EVENTHUB_CONNECTION_STRING"];
            }

            eventHubClient = EventHubClient.CreateFromConnectionString(connectionString);

        }

        private DowntimeReport GetDowntimeReport (string teamId, string serviceId, DateTime date, int statusCode, Boolean status)
        {
            return new DowntimeReport()
            {
                TeamId = teamId,
                ServiceId = serviceId,
                Date = date,
                StatusCode = statusCode,
                Status = status
            };

        }

        private DowntimeReport GetSuccessDownTimeReport(string teamId, string serviceId, DateTime date)
        {
            return GetDowntimeReport(teamId, serviceId, date, 200, true);
        }

        private DowntimeReport GetFailureDowntimeReport(string teamId, string serviceId, DateTime date)
        {
            return GetDowntimeReport(teamId, serviceId, date, 404, false);
        }

        private DowntimeReport[] GetInputMessages()
        {
            return new DowntimeReport[]
            {
                // Normal case failure
                GetFailureDowntimeReport("Team01", "Team01POI", new DateTime(2018, 1, 10, 10, 10 , 10)),
                GetFailureDowntimeReport("Team01", "Team01POI", new DateTime(2018, 1, 10, 10, 10 , 11)),
                GetFailureDowntimeReport("Team01", "Team01POI", new DateTime(2018, 1, 10, 10, 10 , 12)),

                // Multiple service failure at the same time
                GetFailureDowntimeReport("Team01", "Team01POI", new DateTime(2018, 1, 10, 10, 15 , 10)),
                GetFailureDowntimeReport("Team01", "Team01USER", new DateTime(2018, 1, 10, 10, 15 , 10)),
                GetFailureDowntimeReport("Team01", "Team01USER", new DateTime(2018, 1, 10, 10, 15, 11)),

                // Multiple teams failure at the same time
                GetFailureDowntimeReport("Team01", "Team01TRIP", new DateTime(2018, 1, 10, 10, 20 , 10)),
                GetFailureDowntimeReport("Team02", "Team02POI", new DateTime(2018, 1, 10, 10, 20 , 10)),
                GetFailureDowntimeReport("Team01", "Team01TRIP", new DateTime(2018, 1, 10, 10, 20 , 11)),
                GetFailureDowntimeReport("Team02", "Team02POI", new DateTime(2018, 1, 10, 10, 20 , 12)),

                // Multiple teams/services failure at the same time.
                GetFailureDowntimeReport("Team01", "Team01TRIP", new DateTime(2018, 1, 10, 10, 25 , 10)),
                GetFailureDowntimeReport("Team01", "Team01POI", new DateTime(2018, 1, 10, 10, 25 , 10)),
                GetFailureDowntimeReport("Team02", "Team02POI", new DateTime(2018, 1, 10, 10, 25 , 10)),
                GetFailureDowntimeReport("Team02", "Team02USER", new DateTime(2018, 1, 10, 10, 25 , 10)),
                GetFailureDowntimeReport("Team01", "Team01TRIP", new DateTime(2018, 1, 10, 10, 25 , 11)),
                GetFailureDowntimeReport("Team02", "Team02POI", new DateTime(2018, 1, 10, 10, 25 , 12)),
            };
        }
        private DowntimeRecord GetDownTimeRecord(string teamId, DateTime time)
        {
            return new DowntimeRecord()
            {
                TeamId = teamId, 
                Time = time
            };
        }

        private DowntimeRecord[] GetExpectedDowntimeRecords()
        {
            return new DowntimeRecord[]
            {
                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 10, 10)),
                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 10, 11)),
                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 10, 12)),

                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 15, 10)),
                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 15, 11)),

                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 20, 10)),
                GetDownTimeRecord("Team02", new DateTime(2018, 1, 10, 10, 20, 10)),
                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 20, 11)),
                GetDownTimeRecord("Team02", new DateTime(2018, 1, 10, 10, 20, 12)),

                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 25, 10)),
                GetDownTimeRecord("Team02", new DateTime(2018, 1, 10, 10, 25, 10)),
                GetDownTimeRecord("Team01", new DateTime(2018, 1, 10, 10, 25, 11)),

                GetDownTimeRecord("Team02", new DateTime(2018, 1, 10, 10, 25, 12))
            };

        }

        [TestMethod]
        public async Task TestEventHubAndStreamAnalyticsAsync()
        {
            // Cleanup the cosmos db
            IDocumentService service = new DocumentService();
            await service.RemoveCollectionIfExists<DowntimeRecord>();
            await service.CreateCollectionIfExists<DowntimeRecord>("/TeamId", 2500);

            // Get the input data
            var messages = GetInputMessages();
            // Send it to the eventhubs


            // Wait for a while 

            // Check the cosmosDB if the result is expected. 

        }
    }
}
