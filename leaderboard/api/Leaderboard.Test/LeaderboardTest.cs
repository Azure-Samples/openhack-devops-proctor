using Microsoft.Azure.Documents;
using Microsoft.Azure.Documents.Client;
using Microsoft.Azure.EventHubs;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Models;
using Newtonsoft.Json;
using Services;
using SharedLibrary;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Leaderboard.Test
{
    /// <summary>
    /// E2E testing for the EventHubs, Stream Analytics, and CosmosDB 
    /// </summary>
    [TestClass]
    public class LeaderboardTest
    {
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

        private DowntimeRecord GetDownTimeRecord(string teamId, DateTime time, int count)
        {
            return new DowntimeRecord()
            {
                TeamId = teamId, 
                Time = time, 
                Count = count
            };
        }

        private DowntimeReport[] GetPatternSample(int patternNumber, DateTime date)
        {

            switch(patternNumber)
            {
                case 0:
                    // Normal case failure
                    return new DowntimeReport[] {
                        GetFailureDowntimeReport("Team01", "Team01POI", date),
                        GetFailureDowntimeReport("Team01", "Team01POI", (date + TimeSpan.FromSeconds(1))),
                        GetFailureDowntimeReport("Team01", "Team01POI", (date + TimeSpan.FromSeconds(2)))
                    };
                case 1:
                    return new DowntimeReport[]
                    {
                    // Multiple service failure at the same time
                        GetFailureDowntimeReport("Team01", "Team01POI", date),
                        GetFailureDowntimeReport("Team01", "Team01USER", date),
                        GetFailureDowntimeReport("Team01", "Team01USER", (date + TimeSpan.FromSeconds(1)))
                    };
                case 2:
                    return new DowntimeReport[]
                    {
                        // Multiple teams failure at the same time
                        GetFailureDowntimeReport("Team01", "Team01TRIP", date),
                        GetFailureDowntimeReport("Team02", "Team02POI", date),
                        GetFailureDowntimeReport("Team01", "Team01TRIP", (date + TimeSpan.FromSeconds(1))),
                        GetFailureDowntimeReport("Team02", "Team02POI", (date + TimeSpan.FromSeconds(2)))
                    };
                default:
                    return new DowntimeReport[]
                    {
                        // Multiple teams/services failure at the same time.
                        GetFailureDowntimeReport("Team01", "Team01TRIP", date),
                        GetFailureDowntimeReport("Team01", "Team01POI", date),
                        GetFailureDowntimeReport("Team02", "Team02POI", date),
                        GetFailureDowntimeReport("Team02", "Team02USER", date),
                        GetFailureDowntimeReport("Team01", "Team01TRIP", (date + TimeSpan.FromSeconds(1))),
                        GetFailureDowntimeReport("Team02", "Team02POI", (date + TimeSpan.FromSeconds(2)))

                    };
            }
        }

        private DowntimeRecord[] GetExpectedDowntimeRecords()
        {
            return new DowntimeRecord[]
            {
                GetDownTimeRecord("Team01", new DateTime(2018, 6, 22, 15, 41, 0), 3),
                GetDownTimeRecord("Team01", new DateTime(2018, 6, 22, 15, 46, 0), 2),

                GetDownTimeRecord("Team01", new DateTime(2018, 6, 22, 15, 51, 0), 2),
                GetDownTimeRecord("Team02", new DateTime(2018, 6, 22, 15, 51, 0), 2),

                GetDownTimeRecord("Team01", new DateTime(2018, 6, 22, 15, 56, 0), 2),
                GetDownTimeRecord("Team02", new DateTime(2018, 6, 22, 15, 56, 0), 2)
            };

        }
        
        private async Task<List<DowntimeReport>> SendMessagesAsync(MessagingService service)
        {
            Console.WriteLine("-----Send Messages");

            var result = new List<DowntimeReport>();
            for (int i = 0; i < 4; i++)
            {
                var reports = GetPatternSample(i, DateTime.Now);
                foreach(var report in reports)
                {

                    result.Add(report);
                    var message = JsonConvert.SerializeObject(report);
                    Console.WriteLine(message);
                    await service.SendMessageAsync(message);
                }

                await Task.Delay(TimeSpan.FromMinutes(3));
            }
            return result;
        }

        private async Task<List<DowntimeRecord>> GetAllDowntimeRecordAsync(IDocumentService service, string teamId)
        {
            var client = service.GetClient();
            var query = client.CreateDocumentQuery<DowntimeRecord>(
                UriFactory.CreateDocumentCollectionUri("leaderboard", "DowntimeRecord"))
                .Where(f => f.TeamId == teamId)
                .AsEnumerable();
            return query.ToList<DowntimeRecord>();
        }

        private async Task DeleteAllDocuments(IDocumentService service, string teamId)
        {
            var client = service.GetClient();
            var records = await GetAllDowntimeRecordAsync(service, teamId);
            foreach(var record in records)
            {
                await client.DeleteDocumentAsync(UriFactory.CreateDocumentUri("leaderboard", typeof(DowntimeRecord).Name , record.id)
                , new RequestOptions() { PartitionKey = new PartitionKey(teamId) });
            }
        }

        /// <summary>
        /// E2E test from EventHubs to CosmosDB
        /// </summary>
        /// <returns></returns>
        [TestMethod]
        public async Task TestEventHubAndStreamAnalyticsAsync()
        {
            // Cleanup the cosmos db
            IDocumentService service = new DocumentService();

            await DeleteAllDocuments(service, "Team01");
            await DeleteAllDocuments(service, "Team02");

            // Send it to the eventhubs
            MessagingService messagingService = new EventHubMessagingService();
            // await messagingService.SendMessageAsync(jsonMessages);

            // Send message from Input sample data with current time
            var sentDowntimeRports =  await SendMessagesAsync(messagingService);
            // Wait for a while 
            await Task.Delay(TimeSpan.FromSeconds(10));

            // Check the cosmosDB if the result is expected.
            var actualDowntimeRecords = await service.GetAllDocumentsAsync<DowntimeRecord>();
            var expectedDowntimeRecords = GetExpectedDowntimeRecords();
            Console.WriteLine("Expected Recrds: --- NOTE: you can ignore the time");
            Console.WriteLine(JsonConvert.SerializeObject(expectedDowntimeRecords));
            Console.WriteLine("Actual Records: --- NOTE: you can ignore the time");
            Console.WriteLine(JsonConvert.SerializeObject(actualDowntimeRecords));
            Console.WriteLine("We can compare the total downtime for each team");

            var actualTeam01 = DowntimeRecord.TotalCount(((List<DowntimeRecord>)actualDowntimeRecords).ToArray(), "Team01");
            var actualTeam02 = DowntimeRecord.TotalCount(((List<DowntimeRecord>)actualDowntimeRecords).ToArray(), "Team02");

            var expectedTeam01 = DowntimeRecord.TotalCount(expectedDowntimeRecords, "Team01");
            var expectedTeam02 = DowntimeRecord.TotalCount(expectedDowntimeRecords, "Team02");
            
            Assert.AreEqual(expectedTeam01, actualTeam01);
            Assert.AreEqual(expectedTeam02, actualTeam02);
        }
    }
}
