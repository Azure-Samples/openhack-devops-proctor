import { Component, OnInit } from '@angular/core';
import 'rxjs/add/observable/interval';
import 'rxjs/add/operator/map';
import { ITeam } from '../../shared/team';
import { TeamsService } from '../../services/teams.service';

@Component({
  selector: 'ngx-teams',
  templateUrl: './teams.component.html',
  styleUrls: ['./teams.component.scss'],
})
export class TeamsComponent implements OnInit {
  pageTitle = 'Team Management';
  errorMessage = '';
  teams: ITeam[] = [];
  filteredTeams: ITeam[] = [];
  _listFilter = '';

  constructor(private teamService: TeamsService) { }

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

  ngOnInit() {
    this.teamService.getTeams()
        .subscribe(
          data => {
            this.teams = data;
            this.filteredTeams = this.teams;
          },
          error => this.errorMessage = <any>error,
        );
  }

}
