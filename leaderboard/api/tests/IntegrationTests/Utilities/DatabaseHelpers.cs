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
                    TeamName = "team01",
                    CreatedDate = Round(dt),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = 500,
                    Type = EndpointType.POI
                },
                new LogMessage {
                    TeamName = "team01",
                    CreatedDate = Round(dt.AddSeconds(5)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = 403,
                    Type = EndpointType.POI
                },
                new LogMessage {
                    TeamName = "team01",
                    CreatedDate = Round(dt.AddSeconds(5)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = 404,
                    Type = EndpointType.TRIPS
                },
                new LogMessage {
                    TeamName = "team02",
                    CreatedDate = Round(dt.AddSeconds(3)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = -1,
                    Type = EndpointType.USER
                },
                new LogMessage {
                    TeamName = "team03",
                    CreatedDate = Round(dt.AddSeconds(20)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = -1,
                    Type = EndpointType.POI
                },
                new LogMessage {
                    TeamName = "team03",
                    CreatedDate = Round(dt.AddSeconds(25)),
                    EndpointUri = "http://iontegrationtests1",
                    StatusCode = -1,
                    Type = EndpointType.TRIPS
                },
            };
        }
    }
}