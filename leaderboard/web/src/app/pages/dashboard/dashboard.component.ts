import { Component } from '@angular/core';

@Component({
  selector: 'ngx-dashboard',
  styleUrls: ['./dashboard.component.scss'],
  templateUrl: './dashboard.component.html',
})
export class DashboardComponent {
  private teams = [
    {"name" : "Team1",
     "uptime": 30,
     "uppercent": 50,
     "point": 120},
     {"name" : "Team2",
     "uptime": 120,
     "uppercent": 90,
     "point": 530},
     {"name" : "Team3",
     "uptime": 100,
     "uppercent": 90,
     "point": 120},
     {"name" : "Team4",
     "uptime": 120,
     "uppercent": 90,
     "point": 530
     },
     {"name" : "Team5",
     "uptime": 30,
     "uppercent": 50,
     "point": 120},
     {"name" : "Team6",
     "uptime": 120,
     "uppercent": 90,
     "point": 530},
     {"name" : "Team7",
     "uptime": 100,
     "uppercent": 90,
     "point": 120},
     {"name" : "Team8",
     "uptime": 120,
     "uppercent": 90,
     "point": 530
     },
     {"name" : "Team9",
     "uptime": 30,
     "uppercent": 50,
     "point": 120},
     {"name" : "Team10",
     "uptime": 120,
     "uppercent": 90,
     "point": 530},
     {"name" : "Team11",
     "uptime": 100,
     "uppercent": 90,
     "point": 120},
     {"name" : "Team12",
     "uptime": 120,
     "uppercent": 90,
     "point": 530
     },
     {"name" : "Team13",
     "uptime": 30,
     "uppercent": 50,
     "point": 120},
     {"name" : "Team14",
     "uptime": 120,
     "uppercent": 90,
     "point": 530},
     {"name" : "Team15",
     "uptime": 100,
     "uppercent": 90,
     "point": 120},
     {"name" : "Team16",
     "uptime": 120,
     "uppercent": 90,
     "point": 530
     }
  ]

  private viewTeams:{[k:string]: any}[];

  constructor() {
    console.log("constructor ran.");
    this.Convert();
    console.log("length:" + this.viewTeams.length);
  }

  Convert() {
    var numberOfRow = 4;
    var viewTeams:{[k:string]: any}[] = [];

    var localTeams = [];
    var lastRow = -1;
    this.teams.forEach((team, index) => {
        var row = Math.floor(index / numberOfRow);
        if (row != lastRow && lastRow != -1) {
          viewTeams.push(
            {
              "row": lastRow,
              "teams": localTeams
            }
          )
          localTeams = [];
          lastRow = row;
        }

        if (lastRow == -1) {
          lastRow = row;
        }
        localTeams.push(team);
    });
    viewTeams.push(
      { "row": lastRow,
     "teams": localTeams}
    );
    this.viewTeams = viewTeams;
    console.log("****converted****");
    console.log(this.viewTeams);
  }
}
