using Microsoft.VisualStudio.TestTools.UnitTesting;
using Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace SharedLibrary.Test
{
    [TestClass]
    public class OpenhackTest
    {
        [TestMethod]
        public void Get_Total_Time()
        {
            var openhack = new Openhack
            {
                StartTime = new DateTime(2018, 10, 10, 10, 0, 0),
                EndTime   = new DateTime(2018, 10, 12, 17, 0, 0)
            };
            
            Assert.AreEqual(55, openhack.GetTotalTime().TotalHours);
        }

        [TestMethod]
        public void Get_Total_Availability()
        {
            var openhack = new Openhack
            {
                StartTime = new DateTime(2018, 10, 10, 10, 0, 0),
                EndTime = new DateTime(2018, 10, 12, 17, 0, 0)
            };
            var serviceDownTime = TimeSpan.FromHours(1);
            Assert.AreEqual("98.181818", openhack.GetTotalAvailavilityAsString(serviceDownTime));

        }
    }
}
