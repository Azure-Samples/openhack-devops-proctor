// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sentinel.Models
{
    public class Team
    {
        public String Id {get;set;}
        public string TeamName { get; set; }
        public int DownTimeMinutes { get; set; }
        public int Points { get; set; }
        public bool IsScoringEnabled { get; set; }

        public Team()
        {
            Id = Guid.NewGuid().ToString();
        }
    }
}
