import { Component, OnInit, Injectable, OnDestroy } from '@angular/core';
import {interval, Subscription} from 'rxjs';
import { ITeam } from '../../shared/team';
import { TeamsService } from '../../services/teams.service';


@Injectable()
@Component({
  selector: 'ngx-dashboard',
  styleUrls: ['./dashboard.component.scss'],
  templateUrl: './dashboard.component.html',
})
export class DashboardComponent implements OnInit, OnDestroy {
  teams: ITeam[];
  private pollingData: Subscription; // tslint:disable-line
  errorMessage = '';

  constructor(private teamService: TeamsService) {

  }


  ngOnInit(): void {
    const pollingInterval = interval(5000);
    this.pollingData = pollingInterval
      .subscribe((value) => {
        this.teamService.getServiceHealth()
        .subscribe(
          data => {
            this.teams = data;
          },
          error => this.errorMessage = <any>error,
        );
      });
  }

  ngOnDestroy(): void {
    // Called once, before the instance is destroyed.
    // Add 'implements OnDestroy' to the class.
    this.pollingData.unsubscribe();
  }
}
