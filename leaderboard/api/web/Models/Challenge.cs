// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations.Schema;

namespace Sentinel.Models
{
    public class Challenge
    {
        public String Id { get; set;}
        public String TeamId { get; set; }

        public String ChallengeDefinitionId { get; set; }
        public DateTime StartDateTime { get; set; }
        public DateTime EndDateTime { get; set; }
        public boolean IsCompleted {get; set;}
        public int Score { get; set; }

        public Challenge()
        {
            Id = Guid.NewGuid().ToString();
        }
    }
}
