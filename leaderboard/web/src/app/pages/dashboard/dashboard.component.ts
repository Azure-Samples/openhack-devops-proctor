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
  filteredTeams: ITeam[] = [];
  _listFilter = '';
  private pollingData: Subscription; // tslint:disable-line
  errorMessage = '';

  constructor(private teamService: TeamsService) {

  }

  get listFilter(): string {
    return this._listFilter;
  }

  set listFilter(value: string) {
    this._listFilter = value;
    this.filteredTeams = this.listFilter ? this.performFilter(this.listFilter) : this.teams;
  }

  performFilter(filterBy: string): ITeam[] {
    filterBy = filterBy.toLocaleLowerCase();
    return this.teams.filter((team: ITeam) =>
      team.teamName.toLocaleLowerCase().indexOf(filterBy) !== -1);
  }

  ngOnInit(): void {
    const pollingInterval = interval(5000);
    this.pollingData = pollingInterval
      .subscribe((value) => {
        this.teamService.getServiceHealth()
        .subscribe(
          data => {
            this.teams = data;
            this.filteredTeams = this.listFilter ? this.performFilter(this.listFilter) : this.teams;
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
