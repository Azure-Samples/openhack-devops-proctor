import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { Subscription } from 'rxjs';
import { ChallengesService } from '../../../services/challenges.service';
import { Challenge } from '../challenge';
import { TeamsService } from '../../../services/teams.service';
import { ITeam } from '../../../shared/team';
import { IChallengeDefinition } from '../../../shared/challengedefinition';


@Component({
  selector: 'ngx-challenges-delete',
  templateUrl: './challenges-delete.component.html',
  styleUrls: ['./challenges-delete.component.scss'],
})
export class ChallengesDeleteComponent implements OnInit, OnDestroy {
  form: FormGroup;
  private sub: Subscription;
  hours = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];
  minutes = [0,5,10,15,20,25,30,35,40,45,50];
  teamNames: string[];
  challengeDefinitionNames: string[];


  id: string;
  teamName: string;
  addEdit = 'Add';
  teams: ITeam[];
  challengeDefinitions: IChallengeDefinition[];
  challenges: Challenge[];
  model: Challenge = new Challenge();

  errorMessage = '';

  constructor(private route: ActivatedRoute,
    private router: Router,
    private cs: ChallengesService,
    private ts: TeamsService,
    private fb: FormBuilder) { }


  ngOnInit() {
    this.form = this.fb.group({
      selectTeam: '',
      selectChallenge: '',
      startDateTime: '',
      startHours: 1,
      startMins: 0,
      endDateTime: '',
      endHours: 1,
      endMins: 0,
    });

    this.sub = this.route.params.subscribe(params => {
      this.id = params['id'];
      this.teamName = params['teamname'];
    });
    this.id = this.route.snapshot.paramMap.get('id');

    Promise.all([
    this.getTeams(),
    this.getChallengeDefinitions(),
    //this.getChallengesForTeam(),
    ])
    .then((results: any[]) => {
      if (this.id !== null && this.id !== undefined) {
        this.addEdit = 'Edit';

      }
    });
  }

  ngOnDestroy(): void {

  }

  onSubmit() { }


  getTeams() {
    return new Promise((resolve, reject) =>
      this.ts.getTeams()
        .subscribe(
          data => {
            this.teams = data;
            this.teamNames = this.teams.map(tm => tm.teamName);
            resolve(data);
          },
          error => {
            this.errorMessage = <any>error;
            reject(error);
          },
        ));
  }

  getChallenge(id: string) {
    return new Promise((resolve, reject) =>
      this.cs.getChallenge(id)
        .subscribe(
          data => {
            this.model = <Challenge>data;
            resolve(data);
          },
          error => {
            this.errorMessage = <any>error;
            reject(error);
          },
        ));
  }

  getChallengeDefinitions() {
    return new Promise((resolve, reject) =>
      this.cs.getChallengeDefinitions()
        .subscribe(
          data => {
            this.challengeDefinitions = data;
            this.challengeDefinitionNames = this.challengeDefinitions.map(cd => cd.name);
            resolve(data);
          },
          error => {
            this.errorMessage = <any>error;
            reject(error);
          },
        ));
  }
}
