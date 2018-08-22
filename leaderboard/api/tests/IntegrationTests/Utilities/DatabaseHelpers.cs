using System;
using System.Collections.Generic;
using Sentinel.Data;
using Sentinel.Models;

namespace IntegrationTests.Utilities {
    public static class DatabaseHelpers {
        public static void InitializeDbForTests (LogMessageContext db) {
            db.LogMessages.AddRange (GetSeedingMsgs ());
            db.SaveChanges ();
        }

        private static DateTime Round(DateTime dt){
            TimeSpan span = new TimeSpan(0, 0, 1);
            long ticks = (dt.Ticks + (span.Ticks / 2) + 1) / span.Ticks;

            return new DateTime(ticks * span.Ticks);
        }

        public static List<LogMessage> GetSeedingMsgs () {
            DateTime dt = DateTime.Now;

            return new List<LogMessage>() {
                new LogMessage {
                    TeamName = "team1",
                    CreatedDate = dt,
                    TimeSlice = Round(dt),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = 500,
                    Type = EndpointType.POI
                },
                new LogMessage {
                    TeamName = "team1",
                    CreatedDate = dt.AddSeconds(5),
                    TimeSlice = Round(dt.AddSeconds(5)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = 403,
                    Type = EndpointType.POI
                },
                new LogMessage {
                    TeamName = "team1",
                    CreatedDate = dt.AddSeconds(5),
                    TimeSlice = Round(dt.AddSeconds(5)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = 404,
                    Type = EndpointType.TRIPS
                },
                new LogMessage {
                    TeamName = "team2",
                    CreatedDate = dt.AddSeconds(3),
                    TimeSlice = Round(dt.AddSeconds(3)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = -1,
                    Type = EndpointType.USER
                },
                new LogMessage {
                    TeamName = "team3",
                    CreatedDate = dt.AddSeconds(20),
                    TimeSlice = Round(dt.AddSeconds(20)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = -1,
                    Type = EndpointType.POI
                },
                new LogMessage {
                    TeamName = "team3",
                    CreatedDate = dt.AddSeconds(25),
                    TimeSlice = Round(dt.AddSeconds(25)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = -1,
                    Type = EndpointType.TRIPS
                },
            };
        }
    }
}