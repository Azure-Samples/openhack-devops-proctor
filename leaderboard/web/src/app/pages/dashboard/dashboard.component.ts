import { Component, OnInit, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/observable/interval';
import 'rxjs/add/operator/map';

interface TeamResponse {
  teamName: string;
  downTimeSeconds: number;
  points: number;
}

interface Team {
  name: string;
  downTimeSeconds: number;
  point: number;
}
const TOTAL_TIME = 68400;
function convertTeam(teamResponse: TeamResponse): Team {
   return {
    'name': teamResponse.teamName,
    'downTimeSeconds': teamResponse.downTimeSeconds,
    'point': teamResponse.points,
  }
}

@Injectable()
@Component({
  selector: 'ngx-dashboard',
  styleUrls: ['./dashboard.component.scss'],
  templateUrl: './dashboard.component.html',
})
export class DashboardComponent implements OnInit {
  private teams = [];
  public viewTeams: {[k: string]: any}[]; // tslint:disable-line
  private pollingData: any; // tslint:disable-line

  constructor(private http: HttpClient) {

  }


  ngOnInit(): void {

    const url = environment.backendUrl; // environment.backendUrl;
    this.pollingData = Observable.interval(5000)
      .subscribe((value) => {
        this.http.get(url)
        .map(response => response as TeamResponse[])
        .subscribe(
          data => {
            this.teams = data;
            this.Convert();
          },
        );
      });


//    this.Convert();
//    console.log("length:" + this.viewTeams.length);
  }






  Convert() {
    const numberOfRow = 4;
    const viewTeams: {[k: string]: any}[] = [];

    let localTeams = [];
    let lastRow = -1;
    this.teams.forEach((team, index) => {
        const row = Math.floor(index / numberOfRow);
        if (row !== lastRow && lastRow !== -1) {
          viewTeams.push(
            {
              'row': lastRow,
              'teams': localTeams,
            },
          )
          localTeams = [];
          lastRow = row;
        }

        if (lastRow === -1) {
          lastRow = row;
        }
        localTeams.push(convertTeam(team));
    });
    viewTeams.push(
      {
        'row': lastRow,
        'teams': localTeams,
      },
    );
    this.viewTeams = viewTeams;
  }
}

