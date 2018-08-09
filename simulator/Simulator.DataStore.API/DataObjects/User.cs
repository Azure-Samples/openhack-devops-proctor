
namespace ApiClient.DataObjects
{
    
        using System;
        using System.Collections.Generic;

        using System.Globalization;
        using Newtonsoft.Json;
        using Newtonsoft.Json.Converters;

        public partial class User : BaseDataObject
    {
            [JsonProperty("Id")]
            public Guid Id { get; set; }

            [JsonProperty("FirstName")]
            public string FirstName { get; set; }

            [JsonProperty("LastName")]
            [JsonConverter(typeof(ParseStringConverter))]
            public long LastName { get; set; }

            [JsonProperty("UserId")]
            public string UserId { get; set; }

            [JsonProperty("ProfilePictureUri")]
            public string ProfilePictureUri { get; set; }

            [JsonProperty("Rating")]
            public long Rating { get; set; }

            [JsonProperty("Ranking")]
            public long Ranking { get; set; }

            [JsonProperty("TotalDistance")]
            public double TotalDistance { get; set; }

            [JsonProperty("TotalTrips")]
            public long TotalTrips { get; set; }

            [JsonProperty("TotalTime")]
            public long TotalTime { get; set; }

            [JsonProperty("HardStops")]
            public long HardStops { get; set; }

            [JsonProperty("HardAccelerations")]
            public long HardAccelerations { get; set; }

            [JsonProperty("FuelConsumption")]
            public long FuelConsumption { get; set; }

            [JsonProperty("MaxSpeed")]
            public long MaxSpeed { get; set; }

            [JsonProperty("Version")]
            public string Version { get; set; }

            [JsonProperty("CreatedAt")]
            public DateTime CreatedAt { get; set; }

            [JsonProperty("UpdatedAt")]
            public DateTime UpdatedAt { get; set; }

            [JsonProperty("Deleted")]
            public bool Deleted { get; set; }
        }

        public partial class User
        {
            public static User FromJson(string json) => JsonConvert.DeserializeObject<User>(json, Converter.Settings);
        }

        public static class UserSerializer
        {
            public static string ToJson(this User self) => JsonConvert.SerializeObject(self, Converter.Settings);
        }

        
        internal class ParseStringConverter : JsonConverter
        {
            public override bool CanConvert(Type t) => t == typeof(long) || t == typeof(long?);

            public override object ReadJson(JsonReader reader, Type t, object existingValue, JsonSerializer serializer)
            {
                if (reader.TokenType == JsonToken.Null) return null;
                var value = serializer.Deserialize<string>(reader);
                long l;
                if (Int64.TryParse(value, out l))
                {
                    return l;
                }
                throw new Exception("Cannot unmarshal type long");
            }

            public override void WriteJson(JsonWriter writer, object untypedValue, JsonSerializer serializer)
            {
                if (untypedValue == null)
                {
                    serializer.Serialize(writer, null);
                    return;
                }
                var value = (long)untypedValue;
                serializer.Serialize(writer, value.ToString());
                return;
            }

            public static readonly ParseStringConverter Singleton = new ParseStringConverter();
        }
    

}
