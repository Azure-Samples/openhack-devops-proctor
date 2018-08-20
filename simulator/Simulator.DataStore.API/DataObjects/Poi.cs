namespace Simulator.DataObjects
{
   
   
        using System;
        using System.Collections.Generic;

        using System.Globalization;
        using Newtonsoft.Json;
        using Newtonsoft.Json.Converters;

        public partial class Poi //: BaseDataObject
        {
            [JsonProperty("tripId")]
            public Guid TripId { get; set; }

            [JsonProperty("latitude")]
            public double Latitude { get; set; }

            [JsonProperty("longitude")]
            public double Longitude { get; set; }

            [JsonProperty("poiType")]
            public long PoiType { get; set; }

        
            [JsonProperty("timestamp")]
            public DateTime Timestamp { get; set; }

            [JsonProperty("deleted")]
            public bool Deleted { get; set; }

            [JsonProperty("id")]
            public Guid Id { get; set; }
        }

        public partial class Poi
        {
            public static Poi FromJson(string json) => JsonConvert.DeserializeObject<Poi>(json, Converter.Settings);
        }

        public static class PoiSerializer
        {
            public static string ToJson(this Poi self) => JsonConvert.SerializeObject(self, Converter.Settings);
        }

        




}
