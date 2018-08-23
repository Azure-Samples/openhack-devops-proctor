import { Component, OnInit, Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/observable/interval';
import 'rxjs/add/operator/map';
import { ITeam } from '../../shared/team';
import { TeamsService } from '../../services/teams.service';

@Injectable()
@Component({
  selector: 'ngx-dashboard',
  styleUrls: ['./dashboard.component.scss'],
  templateUrl: './dashboard.component.html',
})
export class DashboardComponent implements OnInit {
  teams: ITeam[];
  private pollingData: any; // tslint:disable-line
  errorMessage = '';

  constructor(private teamService: TeamsService) {

  }


  ngOnInit(): void {

    this.pollingData = Observable.interval(5000)
      .subscribe((value) => {
        this.teamService.getTeams()
        .subscribe(
          data => {
            this.teams = data;
          },
          error => this.errorMessage = <any>error,
        );
      });
  }
}
