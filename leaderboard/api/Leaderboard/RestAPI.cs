
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

namespace Leaderboard
{
    public static class RestAPI
    {
        private static IContainer Container { get; set; }

        static RestAPI()
        {
            var builder = new ContainerBuilder();
            builder.RegisterType<DocumentService>().As<IDocumentService>().SingleInstance();
            builder.RegisterType<TeamService>().As<TeamService>().SingleInstance();
            Container = builder.Build();
        }

        /// Get HelthCheck report from the sentinel
        /// </summary>
        /// <param name="req"></param>
        /// <param name="log"></param>
        /// <returns></returns>
        [FunctionName("ReportStatus")]
        public static async Task<IActionResult> ReportStatus([HttpTrigger(AuthorizationLevel.Function, "post", Route = null)]HttpRequest req, TraceWriter log)
        {
            try
            {
                // Get Downtime Report
                using (var scope = Container.BeginLifetimeScope())
                {
                    var service = scope.Resolve<DocumentService>();

                    var requestBody = new StreamReader(req.Body).ReadToEnd();
                    log.Info(requestBody);
                    var report = JsonConvert.DeserializeObject<DowntimeReport>(requestBody);

                    var targetService = await service.GetServiceAsync<Service>(report.ServiceId);

                    //// Service current status update. 
                    if (targetService.CurrentStatus != report.Status)
                    {
                        await service.UpdateDocumentAsync<Service>(targetService);
                        var targetTeam = await service.GetServiceAsync<Team>(report.TeamId);
                        targetTeam.UpdateService(targetService);

                        await targetTeam.UpdateCurrentStateWithFunctionAsync(async () =>
                        {
                        // This method is called when CurrentStatus is changing. 
                        var statusHistory = new StatusHistory
                            {
                                TeamId = targetTeam.Id,
                                Date = DateTime.UtcNow,
                            // CurrentStatus is not updated in this time period
                            // If the ServiceStatusTotal(GetTotalStatus) is true, then it means recorver from failure.
                            // If it is false, then it means go to the failure state.
                            Status = targetTeam.GetTotalStatus() ? DowntimeStatus.Finished : DowntimeStatus.Started
                            };
                            await service.CreateDocumentAsync<StatusHistory>(statusHistory);
                        });
                        await service.UpdateDocumentAsync<Team>(targetTeam);
                    }

                    // If status is failure, it write history. If you want to limit the number of inserting data, enable this.
                    // Currently, I dump all data to the History collection.
                    //if (!report.Status)
                    // {
                    await service.CreateDocumentAsync<History>(report.GetHistory());
                    // }
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


}
