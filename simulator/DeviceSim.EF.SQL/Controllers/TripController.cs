using DeviceSim.DataObjects.Models;
using DeviceSim.Helpers;

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace DeviceSim.Controllers
{
    public class TripController
    {
        #region Variables
       
            //DBContext
            private Trips CurrentTrip;
            private List<Pois> poiList;
            private List<TripPointSource> tripInfo;
            private List<Poisource> tripPOIsource;
            private mydrivingDBContext ctx;

            private int tripCount = 0;
        #endregion

        #region Constructor

        //Create Trips from Data in the Database
        public TripController()
        {
            //Default Constructor
        }
        #endregion


        public async Task CreateTrip(DBConnectionInfo dBConnectionInfo)
        {

            ctx = new mydrivingDBContext(dBConnectionInfo);
            //Use to AutoGenerate Trip Number
            Random r = new Random();
            tripCount += ctx.Trips.Count();

            //Initialize Trip
            CurrentTrip = new Trips();
            //Simulation trip selection
            List<string> tripNames = ctx.TripPointSource
                                        .Select(p => p.Name)
                                        .Distinct()
                                        .ToList();

            var tName = tripNames.ElementAt(r.Next(0, tripNames.Count));

            //Choose Random Trip
            tripInfo = ctx.TripPointSource
                .Where(p => p.Name == tName)
                .ToList();

            Console.WriteLine($"Sample Trip Selected: {tName}");

            CreateTripPoints(tripInfo.FirstOrDefault().Name);

            //TODO : Do proper Distance Calculation and Add a method to determine Rating
            CurrentTrip.EndTimeStamp = CurrentTrip.TripPoints.Last<TripPoints>().RecordedTimeStamp;
            CurrentTrip.Rating = 90;
            //TODO : DO BingMaps Call to determine distance
            CurrentTrip.Distance = 5.95;

            //Get Trip POIs and Update Trip Summary Information 
            GetTripPois();
            //Update Driver Profile with Trip Data
            UpdateUserProfile();
            //Add trips to DB Instance
            await ctx.Trips.AddAsync(CurrentTrip);
            await ctx.Pois.AddRangeAsync(poiList);
            //Save Changes and Update Database
            await ctx.SaveChangesAsync();

            ctx.Dispose();

                     

        }

        private void GetTripPois()
        {
            poiList = ctx.Pois.Where(p => p.TripId == CurrentTrip.Id).ToList<Pois>();
           
            //Generate POIs from Source
            foreach (var sPOI in tripPOIsource)
            {
                poiList.Add(new Pois
                {
                    Id = Convert.ToString(Guid.NewGuid()), //New Guid
                    TripId = CurrentTrip.Id, //Current Trips Id
                    Latitude = sPOI.Latitude,
                    Longitude = sPOI.Longitude,
                    Poitype = sPOI.Poitype,
                    RecordedTimeStamp = DateTime.Now.ToLongTimeString()
                });
            }

            CurrentTrip.HardStops = poiList.Where(p => p.Poitype == 2).Count();
            CurrentTrip.HardAccelerations = poiList.Where(p => p.Poitype == 1).Count();
        }

        private void UpdateUserProfile()
        {
            UserProfiles up = ctx.UserProfiles
                            .Where(user => user.UserId == CurrentTrip.UserId)
                            .SingleOrDefault();


            up.TotalTrips++;
            up.TotalDistance += CurrentTrip.Distance;
            up.HardStops += CurrentTrip.HardStops;
            up.HardAccelerations += CurrentTrip.HardAccelerations;
        }

        private void CreateTripPoints(string SourceTrip)
        {
            
            CurrentTrip.RecordedTimeStamp = DateTime.UtcNow;
            //CurrentTrip.Name = $"Trip {tripCount}";
            CurrentTrip.Name = $"Trip {DateTime.Now}";
            CurrentTrip.Id = Guid.NewGuid().ToString(); //Create trip ID
            //TODO: Make this so that once Authenticated we use the Login Information from the JWT Token if Authentication will be used
            CurrentTrip.UserId = "Hacker1";//_toProcess[0][1]; //"MicrosoftAccount:cd3744e78c2d3d2d" //"Twitter:128169747"


            foreach (var tps in tripInfo)
            {
                TripPoints _tripPoint = new TripPoints()
                {
                    TripId = CurrentTrip.Id,
                    Id = Guid.NewGuid().ToString(),
                    Latitude = Convert.ToDouble(tps.Lat),
                    Longitude = Convert.ToDouble(tps.Lon),
                    Speed = Convert.ToDouble(tps.Speed),
                    RecordedTimeStamp = Convert.ToDateTime(tps.Recordedtimestamp),
                    Sequence = Convert.ToInt32(tps.Sequence),
                    Rpm = Convert.ToDouble(tps.Enginerpm),
                    ShortTermFuelBank = Convert.ToDouble(tps.Shorttermfuelbank),
                    LongTermFuelBank = Convert.ToDouble(tps.Longtermfuelbank),
                    ThrottlePosition = Convert.ToDouble(tps.Throttleposition),
                    RelativeThrottlePosition = Convert.ToDouble(tps.Relativethrottleposition),
                    Runtime = Convert.ToDouble(tps.Runtime),
                    DistanceWithMalfunctionLight = Convert.ToDouble(tps.Distancewithmil),
                    EngineLoad = Convert.ToDouble(tps.Engineload),
                    MassFlowRate = Convert.ToDouble(tps.Mafflowrate),
                    EngineFuelRate = Convert.ToDouble(tps.Enginefuelrate)

                };
                CurrentTrip.TripPoints.Add(_tripPoint);
             }


            //Get Source POIs
            tripPOIsource = ctx.Poisource.Where(p => p.TripId == SourceTrip).ToList();
                        
            //Update Time Stamps to current date and times before sending to IOT Hub
            UpdateTripPointTimeStamps(CurrentTrip);
        }

        private  void UpdateTripPointTimeStamps(Trips trip)
        {
            //Sort Trip Points By Sequence Number
            CurrentTrip.TripPoints = CurrentTrip.TripPoints.OrderBy(p => p.Sequence).ToList();

            List<timeInfo> timeToAdd = new List<timeInfo>();
            System.TimeSpan tDiff;

            //Create a Variable to Track the Time Range as it Changes
            System.DateTime runningTime = CurrentTrip.RecordedTimeStamp;

            //Calculate the Difference in time between Each Sequence Item 
            for (int currentTripPoint = (CurrentTrip.TripPoints.Count - 1); currentTripPoint > -1; currentTripPoint--)
            {
                if (currentTripPoint > 0)
                {
                    tDiff = CurrentTrip.TripPoints.ElementAt(currentTripPoint).RecordedTimeStamp 
                          - CurrentTrip.TripPoints.ElementAt(currentTripPoint - 1).RecordedTimeStamp;
                    timeToAdd.Add(new timeInfo() { evtSeq = CurrentTrip.TripPoints.ElementAt(currentTripPoint).Sequence, tSpan = tDiff });
                 
                }

            }

            //Sort List in order to Add time to Trip Points
            timeToAdd = timeToAdd.OrderBy(s => s.evtSeq).ToList();
            //Update Trip Points

            for (int currentTripPoint = 1, timeToAddCollIdx = 0; currentTripPoint < CurrentTrip.TripPoints.Count; currentTripPoint++, timeToAddCollIdx++)
            {
                runningTime = runningTime.Add(timeToAdd[timeToAddCollIdx].tSpan);
                CurrentTrip.TripPoints.ElementAt(currentTripPoint).RecordedTimeStamp = runningTime;
            }

            // Update Initial Trip Point
            CurrentTrip.TripPoints.ElementAt(0).RecordedTimeStamp = CurrentTrip.RecordedTimeStamp;
        }
    }


    public struct timeInfo
    {
        public int evtSeq;
        public TimeSpan tSpan;
    }
}
