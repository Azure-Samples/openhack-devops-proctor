import { Component, OnInit } from '@angular/core';
import {Router} from '@angular/router';
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

  constructor(private teamService: TeamsService,
    private router: Router) { }

  ngOnInit() {
  }

  onSubmit() {
    this.addTeam().then(r => this.router.navigate(['/pages/teams']));
  }

  addTeam() {
    return new Promise((resolve, reject) =>
    this.teamService.createTeam(this.model)
    .subscribe(
      data => {
        this.model = data;
        resolve(data);
      },
      error => {
        this.errorMessage = <any>error;
        reject(error);
      },
    ));
  }

// TODO: Remove this when we're done
get diagnostic() { return JSON.stringify(this.model); }

}
