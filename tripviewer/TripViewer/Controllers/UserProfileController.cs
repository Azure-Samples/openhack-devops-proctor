﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Simulator.DataObjects;
using Simulator.DataStore.Stores;

namespace TripViewer.Controllers
{
    public class UserProfileController : Controller
    {
        UserStore up = new UserStore("http://akstraefikopenhackut20.eastus.cloudapp.azure.com");
        // GET: UserProfile
        public ActionResult Index()
        {
            List<User> userColl = up.GetItemsAsync().Result;
            var user = userColl[0];
            user.ProfilePictureUri = $"https://cdn4.iconfinder.com/data/icons/danger-soft/512/people_user_business_web_man_person_social-512.png";

            if (user.TotalTrips > 0 && user.HardStops > 0)
            {
                var score = ((Convert.ToDouble(user.HardStops) / Convert.ToDouble(user.TotalTrips)) * 100);
                if (score < 100) { user.Rating = 80; } else { user.Rating = 50; }
            }

            return View(userColl);
        }

        // GET: UserProfile/Details/5
        public ActionResult Details(int id)
        {

            return View();
        }

        // GET: UserProfile/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: UserProfile/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: UserProfile/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: UserProfile/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        // GET: UserProfile/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: UserProfile/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }
    }
}