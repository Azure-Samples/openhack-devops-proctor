using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace TripViewer.Utility
{

    public class TripViewerConfiguration
    {
       public string TEAM_API_ENDPOINT { get; set; }
       public string BING_MAPS_KEY { get;set; }
    }
}