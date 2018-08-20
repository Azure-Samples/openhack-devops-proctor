using DeviceSim.Helpers;
using Simulator.DataObjects;
using Simulator.DataStore.Stores;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DeviceSim.Controllers
{
    public class ApiTripController : BaseTripController
    {
        private Trip CurrentTrip;
        private List<TripPoint> CurrentTripPoints;
        private TripStore tripStore;
        private TripPointStore tripPointStore;
        private PoiStore poiStore;
        private UserStore userStore;
        private string endPoint;
        private DateTime dateTime;

        public ApiTripController(DBConnectionInfo dBConnectionInfo, string apiEndPoint) : base(dBConnectionInfo)
        {
            endPoint = apiEndPoint;
            tripStore = new TripStore(endPoint);
            tripPointStore = new TripPointStore(endPoint);
            poiStore = new PoiStore(endPoint);
            userStore = new UserStore(endPoint);
        }

        public async Task CreateTrip()
        {
            dateTime = DateTime.UtcNow;

            CurrentTrip = new Trip
            {
                Id = Guid.NewGuid().ToString(),
                UserId = "Hacker 1",
                Name = $"API-Trip {DateTime.Now}",
                RecordedTimeStamp = dateTime.AddTicks(-1 * dateTime.Ticks % 10000),
                EndTimeStamp = dateTime.AddTicks(-1 * dateTime.Ticks % 10000).AddMinutes(15),
                UpdatedAt = dateTime.AddTicks(-1 * dateTime.Ticks % 10000).AddMinutes(15),
                Distance = 5.95,
                Rating = 90,
                //Version = new byte[] { 201 },
                Created = dateTime.AddTicks(-1 * dateTime.Ticks % 10000).AddMinutes(15)
            };

            CurrentTrip = await tripStore.CreateItemAsync(CurrentTrip);

            await CreateTripPoints();

            await CreatePois();

            await UpdateTrip();

            await UpdateUserProfile();
        }

        public async Task CreateTripPoints()
        {
            try
            {
                CurrentTripPoints = new List<TripPoint>();
                DateTime dateTime = DateTime.UtcNow;
                Vin v = new Vin() { String = string.Empty, Valid = false };

                foreach (var tps in TripPointSourceInfo)
                {
                    TripPoint _tripPoint = new TripPoint()
                    {
                        Id = Guid.NewGuid().ToString(),
                        TripId = new Guid(CurrentTrip.Id),
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
                        //MassFlowRate = Convert.ToDouble(tps.Mafflowrate),
                        EngineFuelRate = Convert.ToDouble(tps.Enginefuelrate),
                        Vin = v,
                        CreatedAt = dateTime.AddTicks(-1 * dateTime.Ticks % 10000),
                        UpdatedAt = dateTime.AddTicks(-1 * dateTime.Ticks % 10000)
                    };
                    CurrentTripPoints.Add(_tripPoint);
                }

                //Update Time Stamps to current date and times before sending to IOT Hub
                UpdateTripPointTimeStamps(CurrentTrip);
                foreach (TripPoint tripPoint in CurrentTripPoints)
                {
                    try
                    {
                        await tripPointStore.CreateItemAsync(tripPoint);
                    }
                    catch (Exception)
                    {
                        throw new Exception($"Could not update Trip Time Stamps from Samples at {DateTime.Now.ToString()}.");
                    }

                    //Console.WriteLine($"Processing Sequence No: {tripPoint.Sequence} on Thread : {Thread.CurrentThread.ManagedThreadId}");
                }

                //Parallel.ForEach(CurrentTripPoints, tripPoint =>
                //{
                //    tripPointStore.CreateItemAsync(tripPoint);
                //    Console.WriteLine($"Processing Sequence No: {tripPoint.Sequence} on Thread : {Thread.CurrentThread.ManagedThreadId}");

                //});

                //Console.WriteLine("TripPoint Processing Completed");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Could not create/update Trip Points. For more detail see: {ex.Message}.");
            }
        }

        private void UpdateTripPointTimeStamps(Trip trip)
        {
            try
            {
                //Sort Trip Points By Sequence Number
                CurrentTripPoints = CurrentTripPoints.OrderBy(p => p.Sequence).ToList();

                List<timeInfo> timeToAdd = new List<timeInfo>();
                System.TimeSpan tDiff;

                //Create a Variable to Track the Time Range as it Changes
                System.DateTime runningTime = CurrentTrip.RecordedTimeStamp;

                //Calculate the Difference in time between Each Sequence Item
                for (int currentTripPoint = (CurrentTripPoints.Count - 1); currentTripPoint > -1; currentTripPoint--)
                {
                    if (currentTripPoint > 0)
                    {
                        tDiff = CurrentTripPoints.ElementAt(currentTripPoint).RecordedTimeStamp
                              - CurrentTripPoints.ElementAt(currentTripPoint - 1).RecordedTimeStamp;
                        timeToAdd.Add(new timeInfo() { evtSeq = CurrentTripPoints.ElementAt(currentTripPoint).Sequence, tSpan = tDiff });
                    }
                }

                //Sort List in order to Add time to Trip Points
                timeToAdd = timeToAdd.OrderBy(s => s.evtSeq).ToList();
                //Update Trip Points

                for (int currentTripPoint = 1, timeToAddCollIdx = 0; currentTripPoint < CurrentTripPoints.Count; currentTripPoint++, timeToAddCollIdx++)
                {
                    runningTime = runningTime.Add(timeToAdd[timeToAddCollIdx].tSpan);
                    CurrentTripPoints.ElementAt(currentTripPoint).RecordedTimeStamp = runningTime;
                }

                // Update Initial Trip Point
                CurrentTripPoints.ElementAt(0).RecordedTimeStamp = CurrentTrip.RecordedTimeStamp;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Could not update Trip Time Stamps from Samples. for more info see:{ex.Message}.");
            }
        }

        public async Task CreatePois()
        {
            //CurrentPois = new List<Poi>();
            foreach (var poi in TripPOIsource)
            {
                try
                {
                    dateTime = DateTime.Now;
                    await poiStore.CreateItemAsync(new Poi
                    {
                        TripId = new Guid(CurrentTrip.Id),
                        Latitude = poi.Latitude,
                        Longitude = poi.Longitude,
                        PoiType = poi.Poitype,
                        Deleted = false,
                        Id = Guid.NewGuid(),
                        Timestamp = dateTime.AddTicks(-1 * dateTime.Ticks % 10000)
                    });
                }
                catch (Exception)
                {
                    Console.WriteLine($"POI Creation Failure : {DateTime.Now.ToString()}");
                }
            }
        }

        private async Task UpdateTrip()
        {
            //Get Current Trip and Update it After TripPoints Creation
            CurrentTrip.Distance = 5.95;
            CurrentTrip.IsComplete = true;
            CurrentTrip.EndTimeStamp =
            CurrentTripPoints.Last<TripPoint>().RecordedTimeStamp.AddTicks(-1 * CurrentTripPoints.Last<TripPoint>().RecordedTimeStamp.Ticks % 10000);

            try
            {
                await tripStore.UpdateItemAsync(CurrentTrip);
            }
            catch (Exception)
            {
                Console.WriteLine($"Trip Statistics Update Failure : {DateTime.Now.ToString()}");
            }
        }

        private async Task UpdateUserProfile()
        {
            //Get User
            List<User> users = userStore.GetItemsAsync().Result;
            User CurrentUser = users.Where(u => u.UserId == "Hacker 1").SingleOrDefault();

            //Update USer

            CurrentUser.TotalTrips++;
            CurrentUser.TotalDistance += CurrentTrip.Distance;
            CurrentUser.HardStops += CurrentTrip.HardStops;
            CurrentUser.HardAccelerations += CurrentTrip.HardAccelerations;

            try
            {
                string json = CurrentUser.ToJson();
                await userStore.UpdateItemAsync(CurrentUser);
            }
            catch (Exception)
            {
                Console.WriteLine($"User Profile Update Failure : {DateTime.Now.ToString()}");
            }
        }
    }
}