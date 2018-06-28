
using System.IO;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Host;
using System;
using Models;
using Services;
using System.Threading.Tasks;
using System.Net.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using Autofac;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Azure.Documents;
using System.Collections;
using SharedLibrary;

namespace Leaderboard
{
    public static class RestAPI
    {
        public static IContainer Container { get; set; }

        static RestAPI()
        {
            var builder = new ContainerBuilder();
            builder.RegisterType<DocumentService>().As<IDocumentService>().SingleInstance();
            builder.RegisterType<TeamService>().As<TeamService>().SingleInstance();
            builder.RegisterType<EventHubMessagingService>().As<MessagingService>().SingleInstance();
            Container = builder.Build();
        }

        /// Get HelthCheck report from the sentinel
        /// </summary>
        /// <param name="req"></param>
        /// <param name="log"></param>
        /// <returns></returns>
        [FunctionName("ReportStatus")]
        public static async Task<IActionResult> ReportStatus([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = null)]HttpRequest req, TraceWriter log)
        {
            try
            {
                // Get Downtime Report
                using (var scope = Container.BeginLifetimeScope())
                {
                    var service = scope.Resolve<IDocumentService>();
                    

                    var requestBody = new StreamReader(req.Body).ReadToEnd();
                    log.Info(requestBody);
                    var report = JsonConvert.DeserializeObject<DowntimeReport>(requestBody);

                    var targetService = await service.GetServiceAsync<Service>(report.ServiceId);

                    /// TODO Keep this logic until the new EventHub based service works. 
                    /// This logic might need when we create other leaderboard screens. 
                    /// Service current status update.  
                    if (targetService.CurrentStatus != report.Status)
                    {
                        targetService.CurrentStatus = report.Status;
                        await service.UpdateDocumentAsync<Service>(targetService);
                        var targetTeam = await service.GetServiceAsync<Team>(report.TeamId);
                        targetTeam.UpdateService(targetService);

                        await service.UpdateDocumentAsync<Team>(targetTeam);
                    }

                    // If status is failure, it write history. If you want to limit the number of inserting data, enable this.
                    // Currently, I dump all data to the History collection.
                    //if (!report.Status)
                    // {
                    await service.CreateDocumentAsync<History>(report.GetHistory());
                    // }

                    // Transfer message to the Event Hubs
                    var messagingService = scope.Resolve<MessagingService>();
                    await messagingService.SendMessageAsync(requestBody);

                    return new OkObjectResult("{'status': 'accepted'}");
                }
            }
            catch (Exception e)
            {
                log.Error($"Report Status error: {e.Message}");
                log.Error(e.StackTrace);
                return new BadRequestObjectResult("{'status': 'error', 'message': '{" + e.Message + "'}");
            }
        }

        [FunctionName("GetTeamsStatus")]
        public static async Task<IActionResult> GetTeamsStatus([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)]HttpRequest req, TraceWriter log)
        {
            using (var scope = Container.BeginLifetimeScope())
            {
                try
                {
                    var service = scope.Resolve<IDocumentService>();
                    // Get Openhack Start/End time.
                    var openhack = await service.GetDocumentAsync<Openhack>();
                    // Get Team list
                    var teams = await service.GetAllDocumentsAsync<Team>();
                    var list = new List<UptimeReport>();
                    foreach (var team in teams)
                    {
                        var downtimeSummaries = await service.GetDocumentsAsync<DowntimeSummary>(
                            (query) =>
                            {
                                return query.Where(f => f.TeamId == team.id);
                            });
                        TimeSpan downtime; 
                        if (downtimeSummaries != null && downtimeSummaries.Count != 0)
                        {
                            var downtimeSummary = downtimeSummaries.First<DowntimeSummary>();
                            downtime = TimeSpan.FromSeconds(downtimeSummary.Downtime);
                        } else
                        {
                            downtime = TimeSpan.FromSeconds(0);
                        }
                        
                        // TODO implement uptime and uppercent
                        list.Add(
                            new UptimeReport
                            {
                                Name = team.Name,
                                Uptime = (int)openhack.GetUpTime(downtime).TotalHours,
                                Uppercent = (int)openhack.GetTotalAvailavility(downtime),
                                Point = 300 // No logic until now. 
                            }
                            );
                    }
                    var result = JsonConvert.SerializeObject(list);
                    return new OkObjectResult(result);
                } catch (Exception e)
                {
                    log.Error($"Get Team status error: {e.Message}");
                    log.Error(e.StackTrace);
                    return new BadRequestObjectResult("{'status': 'error', 'message': '{" + e.Message + "'}");
                }
            }


        }
        [FunctionName("DowntimeBatch")]
        public static async Task DowntimeBatch([CosmosDBTrigger(
            databaseName: "leaderboard",
            collectionName: "DowntimeRecord",
            ConnectionStringSetting ="CosmosDBConnection",
            LeaseCollectionName = "leases",
            CreateLeaseCollectionIfNotExists = true)] IReadOnlyList<Document> documents,
            TraceWriter log)
        {
            if (documents != null && documents.Count > 0)
            {
                var ht = new Hashtable();
                foreach (var document in documents)
                {
                    log.Info(JsonConvert.SerializeObject(document));
                    // remove the duplication. 
                    ht[document.GetPropertyValue<string>("TeamId")] = "";
                }
                using (var scope = Container.BeginLifetimeScope())
                {
                    var service = scope.Resolve<IDocumentService>();
                    var teamService = scope.Resolve<TeamService>();
                    foreach (var teamId in ht.Keys)
                    {
                        // Read the document teamid and count with sum.
                        var downtime = await teamService.QueryDowntimeAsync((string)teamId);

                        var downtimeSummary = new DowntimeSummary()
                        {
                           Downtime = downtime,
                           TeamId = (string)teamId
                        };
                        downtimeSummary.TeamId = (string)teamId;
                        log.Info($"Sum----TeamId: {teamId}");
                        log.Info(JsonConvert.SerializeObject(downtimeSummary));
                        await service.UpdateDocumentAsync<DowntimeSummary>(downtimeSummary);
                    }
                }
            }
        }


        [FunctionName("SampleFunc")]
        public static async Task<IActionResult> SampleFunc([HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)]HttpRequest req, TraceWriter log)
        {
            var seed = Environment.TickCount;
            Random rnd = new System.Random();

            var list = new List<UptimeReport>(3);
            var report01 = new UptimeReport
            {
                Name = "Team01",
                Uptime = rnd.Next(10, 300),
                Uppercent = 30,
                Point = 100
            };
            var report02 = new UptimeReport
            {
                Name = "Team02",
                Uptime = rnd.Next(10, 300),
                Uppercent = 40,
                Point = 100
            };
            var report03 = new UptimeReport
            {
                Name = "Team03",
                Uptime = rnd.Next(10, 300),
                Uppercent = 50,
                Point = 100
            };
            list.Add(report01);
            list.Add(report02);
            list.Add(report03);
            var result = JsonConvert.SerializeObject(list);
            return new OkObjectResult(result);
        }



    }
}
