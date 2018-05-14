
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

namespace Leaderboard
{
    public static class RestAPI
    {

        private static DocumentService service = new DocumentService();
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
           
                var requestBody = new StreamReader(req.Body).ReadToEnd();
                log.Info(requestBody);
                var report = JsonConvert.DeserializeObject<DowntimeReport>(requestBody);

                var targetService = await service.GetServiceAsync(report.ServiceId);

                //// Service current status update. 
                if (targetService.CurrentStatus != report.Status)
                {
                    await service.UpdateDocumentAsync<Service>(targetService);
                }

                // If status is failure, it write history. If you want to limit the number of inserting data, enable this.
                // Currently, I dump all data to the History collection.
                //if (!report.Status)
                // {
                await service.CreateDocumentAsync<History>(report.GetHistory());
               // }
                return new OkObjectResult("{'status': 'accepted'}");

            }
            catch (Exception e)
            {
                log.Error($"Report Status error: {e.Message}");
                log.Error(e.StackTrace);
                return new BadRequestObjectResult("{'status': 'error', 'message': '{" + e.Message + "'}");
            }
        }

    }
}
