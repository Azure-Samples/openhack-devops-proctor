// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sentinel.Models
{
    public class ChallengeDefinition
    {
        public String Id {get;set;}
        public string Name { get; set; }
        public int MaxPoints { get; set; }
        public string Description? { get; set; }
        public string ScoreEnabled {get;set;}

        public ChallengeDefinition()
        {
            Id = Guid.NewGuid().ToString();
        }
    }
}
