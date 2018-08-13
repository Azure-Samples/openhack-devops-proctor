using DeviceSim.Controllers;
using DeviceSim.Helpers;
using Microsoft.Extensions.Configuration;
using System;
using System.Threading;
using System.Threading.Tasks;


namespace DeviceSim
{
    internal class Program
    {
        #region Variables

        private static DBConnectionInfo dBConnectionInfo;
        public static int WaitTime { get; private set; }       
        public static string TeamName { get; private set; }
        public static bool UseApi { get; private set; }
        public static string ApiEndPoint { get; private set; } 

        #endregion Variables

        private static void Main(string[] args)
        {
            InitializeApp();

            Console.WriteLine($"***** {TeamName}-Driving Simulator *****");
            Console.WriteLine($"Currently Using API Routes : {UseApi.ToString()}");
            Console.WriteLine($"*Starting Simulator - A new trip will be created every {WaitTime / 1000} seconds *");

            while (true)
            {
                try
                {
                    CreateTripAsync().Wait();
                    Thread.Sleep(WaitTime);
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }
        }

        private static async Task CreateTripAsync()
        {
            try
            {
                Console.WriteLine($"Starting Trip Creation : {DateTime.Now}. ");
                await CreateTrip();
                Console.WriteLine($"Trip Completed at : {DateTime.Now}. ");
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        private static void InitializeApp()
        {
            IConfiguration funcConfiguration;
            var builder = new ConfigurationBuilder().AddEnvironmentVariables();
            funcConfiguration = builder.Build();

            //Environmental Variables - Pass to Container

            //Database Connection Information
            dBConnectionInfo.DBServer = funcConfiguration.GetSection("SQL_SERVER").Value ?? ("davete02ted2sql.database.windows.net");
            dBConnectionInfo.DBUserName = funcConfiguration.GetSection("SQL_USER").Value ?? ("davete02ted2sa");
            dBConnectionInfo.DBPassword = funcConfiguration.GetSection("SQL_PASSWORD").Value ?? ("5N6nk3La2pwd");
            dBConnectionInfo.DBCatalog = "mydrivingDB";
            //Api Connection Information
            UseApi = Convert.ToBoolean(funcConfiguration.GetSection("USE_API").Value);
            ApiEndPoint = funcConfiguration.GetSection("SIMULATOR_API_ENDPOINT").Value ?? ("http://akstraefikdavete02ted2.westus2.cloudapp.azure.com/");
            //Execution Information
            WaitTime = Convert.ToInt32(funcConfiguration.GetSection("TRIP_FREQUENCY").Value ?? ("180000"));
            TeamName = funcConfiguration.GetSection("TEAM_NAME").Value ?? ("TEAM 01");
                        
        }

        private static async Task CreateTrip()
        {
            try
            {
                if (!UseApi)
                {
                    EFTripController CurrentTrip = new EFTripController(dBConnectionInfo);
                    await CurrentTrip.CreateTrip();
                    await CurrentTrip.SaveChangesAsync();
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}