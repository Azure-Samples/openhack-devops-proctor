﻿using DeviceSim.Controllers;
using DeviceSim.Helpers;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.Devices.Client;
using Newtonsoft.Json;
using System.IO;

using System.Configuration;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Configuration.EnvironmentVariables;
using System.Timers;
using System.Threading;

namespace DeviceSim
{
    class Program
    {

        #region Variables

        private static DBConnectionInfo dBConnectionInfo;
        private static int WaitTime;
        private static string TeamName;
        //private static bool UseApi; Will use later to switch between SQL and API Simulation
       
        #endregion

        static void Main(string[] args)
        {
            InitializeApp();

            Console.WriteLine($"***** {TeamName}-Driving Simulator *****");
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
            Console.WriteLine($"Trip Started at : {DateTime.Now}. ");
            await CreateTrip();
            Console.WriteLine($"Trip Completed at : {DateTime.Now}. ");    
        }

        private static void InitializeApp()
        {
            IConfiguration funcConfiguration;
            var builder = new ConfigurationBuilder().AddEnvironmentVariables();
            funcConfiguration = builder.Build();

            //Environmental Variables - Pass to Container

            //Database Connection Information
            dBConnectionInfo.DBServer = funcConfiguration.GetSection("SQL_SERVER").Value ?? ("team1sqlxs76.database.windows.net");
            dBConnectionInfo.DBUserName = funcConfiguration.GetSection("SQL_USER").Value ?? ("team1saxs76");
            dBConnectionInfo.DBPassword = funcConfiguration.GetSection("SQL_PASSWORD").Value ?? ("team1pwd-xs76");
            dBConnectionInfo.DBCatalog = "mydrivingDB";
            //Execution Information
            WaitTime = Convert.ToInt32(funcConfiguration.GetSection("TRIP_FREQUENCY").Value ?? ("180000"));
            TeamName = funcConfiguration.GetSection("TEAM_NAME").Value ?? ("TEAM 01");

        }

 

        private static async Task CreateTrip()
        {
            TripController CurrentTrip = new TripController();
            await CurrentTrip.CreateTrip(dBConnectionInfo);
        }




    }
}
