using Models;
using Newtonsoft.Json;
using System;
using System.IO;

namespace TestDataGenerator
{
    class Program
    {

        private DowntimeReport GetDowntimeReport(string teamId, string serviceId, DateTime date, int statusCode, Boolean status)
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
        static void Main(string[] args)
        {
            var program = new Program();
            var messages = program.GetInputMessages();
            // Write a Jsonfile

            var jsonMessages = JsonConvert.SerializeObject(messages);
            var currentDir = Directory.GetCurrentDirectory();
            var fileName = "injestionTest.json";
            File.WriteAllText(currentDir + "/" + fileName, jsonMessages);

            Console.WriteLine($"{fileName} is created at the {currentDir}. Please have a look");
            Console.ReadLine();
        }
    }
}
