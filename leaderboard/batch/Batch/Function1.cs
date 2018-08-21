using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using System.Data;
using System.Data.SqlClient;

namespace Batch
{
    public static class Batch
    {
        private static SqlConnection connection;
        private static string queryString = "some batch execution sql";

        static Batch()
        {
            var connectionString = Environment.GetEnvironmentVariable("SqlConnectionString");
            connection = new SqlConnection(connectionString);
            connection.Open();
        }

        [FunctionName("Function1")]
        public static void Run([TimerTrigger("0 */1 * * * *")]TimerInfo myTimer, ILogger log)
        {

            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");
            var command = new SqlCommand(queryString, connection);

            command.ExecuteNonQuery();
            
        }
    }
}
