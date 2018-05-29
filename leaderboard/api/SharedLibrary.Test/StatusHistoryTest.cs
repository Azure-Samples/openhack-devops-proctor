using Microsoft.VisualStudio.TestTools.UnitTesting;
using Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace SharedLibrary.Test
{
    [TestClass]
    public class StatusHistoryTest
    {

        private StatusHistory GetSampleStatusHistory(string teamId, DateTime date, DowntimeStatus status)
        {
            return new StatusHistory
            {
                TeamId = teamId,
                Date = date,
                Status = status
            };
        }
        private IList<StatusHistory> GetSampleStatusHistories()
        {
            var list = new StatusHistory[]
 {
                GetSampleStatusHistory(
                    "01",
                    new DateTime(2018, 5, 29, 10, 0, 0),
                    DowntimeStatus.Started),
                GetSampleStatusHistory(
                    "01",
                    new DateTime(2018, 5, 29, 10, 0, 0),
                    DowntimeStatus.Started
                ),
                GetSampleStatusHistory(
                    "01",
                    new DateTime(2018, 5, 29, 11, 0, 0),
                    DowntimeStatus.Finished
                ),
                GetSampleStatusHistory(
                    "01",
                    new DateTime(2018, 5, 29, 12, 0, 0),
                    DowntimeStatus.Started
                ),
                GetSampleStatusHistory(
                    "01",
                    new DateTime(2018, 5, 29, 13, 0, 0),
                    DowntimeStatus.Finished
                ),
 };
            return list;
        }
        [TestMethod]
        public void Get_Down_Time_Basic()
        {
            // Normal case. Two sequential Downtime.
            var list = GetSampleStatusHistories();
            var downtime = StatusHistory.GetDownTime(list);
            Assert.AreEqual(TimeSpan.FromHours(2), downtime);
        }

        [TestMethod]
        public void Get_Down_Time_Without_Finished()
        {
            var list = new List<StatusHistory>();
            list.AddRange(GetSampleStatusHistories());
            // This data is not finished. 
            list.Add(
                GetSampleStatusHistory(
                    "01",
                    new DateTime(2018, 5, 29, 14, 0, 0),
                    DowntimeStatus.Started
                    ));

            var downtime = StatusHistory.GetDownTime(list, new DateTime(2018, 5, 29, 15, 0, 0));
            Assert.AreEqual(TimeSpan.FromHours(3), downtime);
        }
    }
}
