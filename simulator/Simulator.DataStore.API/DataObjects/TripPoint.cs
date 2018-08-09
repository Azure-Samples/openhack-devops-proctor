
namespace ApiClient.DataObjects
{
    //public partial class TripPoint
    //{
    //    public string Id { get; set; }
    //    public string TripId { get; set; }
    //    public double Latitude { get; set; }
    //    public double Longitude { get; set; }
    //    public double Speed { get; set; }
    //    public DateTime RecordedTimeStamp { get; set; }
    //    public int Sequence { get; set; }
    //    public double Rpm { get; set; }
    //    public double ShortTermFuelBank { get; set; }
    //    public double LongTermFuelBank { get; set; }
    //    public double ThrottlePosition { get; set; }
    //    public double RelativeThrottlePosition { get; set; }
    //    public double Runtime { get; set; }
    //    public double DistanceWithMalfunctionLight { get; set; }
    //    public double EngineLoad { get; set; }
    //    public double MassFlowRate { get; set; }
    //    public double EngineFuelRate { get; set; }
    //    public string Vin { get; set; }
    //    public bool HasObddata { get; set; }
    //    public bool HasSimulatedObddata { get; set; }
    //    public byte[] Version { get; set; }
    //    public DateTimeOffset CreatedAt { get; set; }
    //    public DateTimeOffset? UpdatedAt { get; set; }
    //    public bool Deleted { get; set; }

    //}


    // To parse this JSON data, add NuGet 'Newtonsoft.Json' then do:
    //
    //    using QuickType;
    //
    //    var welcome = Welcome.FromJson(jsonString);
        using System;
        using System.Collections.Generic;

        using System.Globalization;
        using Newtonsoft.Json;
        using Newtonsoft.Json.Converters;

        public partial class TripPoint: BaseDataObject
    {
            [JsonProperty("Id")]
            public string Id { get; set; }

            [JsonProperty("TripId")]
            public Guid TripId { get; set; }

            [JsonProperty("Latitude")]
            public double Latitude { get; set; }

            [JsonProperty("Longitude")]
            public double Longitude { get; set; }

            [JsonProperty("Speed")]
            public long Speed { get; set; }

            [JsonProperty("RecordedTimeStamp")]
            public DateTime RecordedTimeStamp { get; set; }

            [JsonProperty("Sequence")]
            public long Sequence { get; set; }

            [JsonProperty("RPM")]
            public long Rpm { get; set; }

            [JsonProperty("ShortTermFuelBank")]
            public long ShortTermFuelBank { get; set; }

            [JsonProperty("LongTermFuelBank")]
            public long LongTermFuelBank { get; set; }

            [JsonProperty("ThrottlePosition")]
            public long ThrottlePosition { get; set; }

            [JsonProperty("RelativeThrottlePosition")]
            public long RelativeThrottlePosition { get; set; }

            [JsonProperty("Runtime")]
            public long Runtime { get; set; }

            [JsonProperty("DistanceWithMalfunctionLight")]
            public long DistanceWithMalfunctionLight { get; set; }

            [JsonProperty("EngineLoad")]
            public long EngineLoad { get; set; }

            [JsonProperty("EngineFuelRate")]
            public long EngineFuelRate { get; set; }

            [JsonProperty("VIN")]
            public Vin Vin { get; set; }

            [JsonProperty("CreatedAt")]
            public DateTime CreatedAt { get; set; }

            [JsonProperty("UpdatedAt")]
            public DateTime UpdatedAt { get; set; }
        }

        public partial class Vin
        {
            [JsonProperty("String")]
            public string String { get; set; }

            [JsonProperty("Valid")]
            public bool Valid { get; set; }
        }

        public partial class TripPoint
        {
            public static TripPoint FromJson(string json) => JsonConvert.DeserializeObject<TripPoint>(json, Converter.Settings);
        }

        public static class TripPointSerializer
        {
            public static string ToJson(this TripPoint self) => JsonConvert.SerializeObject(self, Converter.Settings);
        }


        internal static class Converter
    {
        public static readonly JsonSerializerSettings Settings = new JsonSerializerSettings
        {
            MetadataPropertyHandling = MetadataPropertyHandling.Ignore,
            //DateParseHandling = DateParseHandling.None,
            //Converters = {new IsoDateTimeConverter { DateTimeStyles = DateTimeStyles.None } },
        };
    }

}
