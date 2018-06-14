import { Component, OnInit, Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/observable/interval';
import 'rxjs/add/operator/map';

interface TeamResponse {
  name: string;
  uptime: number;
  uppercent: number;
  point: number;
}

@Injectable()
@Component({
  selector: 'ngx-dashboard',
  styleUrls: ['./dashboard.component.scss'],
  templateUrl: './dashboard.component.html',
})
export class DashboardComponent implements OnInit {
  private teams =[];

  private viewTeams:{[k:string]: any}[];
  
  private pollingData: any;

  constructor(private http: HttpClient) {
    console.log('constructor');
  }


  ngOnInit(): void {
    console.log("constructor ran.");
    let url = environment.backendUrl;
    this.pollingData = Observable.interval(5000)
      .subscribe((data) => {
        this.http.get(url)
        .map(response => response as TeamResponse[])
        .subscribe(
          data => {
            this.teams = data;
            this.Convert();
            console.log(data);
          }
        );
      });


//    this.Convert();
//    console.log("length:" + this.viewTeams.length);
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

