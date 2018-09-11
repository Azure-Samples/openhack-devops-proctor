// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;

namespace Sentinel.Models
{
    public class ChallengeDefinition
    {

        public String Id {get;set;}
        public string Name { get; set; }
        public int MaxPoints { get; set; }
        public string Description { get; set; }
        public bool ScoreEnabled {get;set;}

        // [JsonProperty(NullValueHandling=NullValueHandling.Ignore)]
        // public List<Challenge> Challenges {get;set;}

        public ChallengeDefinition()
        {
            Id = Guid.NewGuid().ToString();
        }
    }
}
