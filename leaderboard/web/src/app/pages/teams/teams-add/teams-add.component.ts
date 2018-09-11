import { Component, OnInit } from '@angular/core';
import {Team} from '../team';
import {TeamsService} from '../../../services/teams.service';
@Component({
  selector: 'ngx-teams-add',
  templateUrl: './teams-add.component.html',
  styleUrls: ['./teams-add.component.scss'],
})
export class TeamsAddComponent implements OnInit {

  errorMessage = '';
  model = new Team();

  constructor(private teamService: TeamsService) { }

  ngOnInit() {
  }

  onSubmit() {
    this.teamService.createTeam(this.model)
    .subscribe(
      data => {
        this.model = data;
      },
      error => this.errorMessage = <any>error,
    );
  }

// TODO: Remove this when we're done
get diagnostic() { return JSON.stringify(this.model); }

}
