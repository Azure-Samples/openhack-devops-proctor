import { Component, OnInit, VERSION } from '@angular/core';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { ChallengesService } from '../../../services/challenges.service';
import { Challenge } from '../challenge';
import { TeamsService } from '../../../services/teams.service';
import { ITeam } from '../../../shared/team';
import { IChallengeDefinition } from '../../../shared/challengedefinition';
@Component({
  selector: 'challenges-add',
  templateUrl: './challenges-add.component.html',
  styleUrls: ['./challenges-add.component.scss']
})
export class ChallengesAddComponent implements OnInit {
  id: string;
  model = new Challenge();
  teams: ITeam[];
  challengeDefinitions: IChallengeDefinition[];
  errorMessage = '';

  model_test: Challenge = new Challenge();
  // {
  //   id: "0CC7CD9E-315F-42D2-9FFD-E6E23C856610",
  //   teamId: "931EA0C8-62CA-4663-BD56-7693AC09994C",
  //   challengeDefinitionId: "4C9B8D9A-62F0-45C7-ABD5-C44F92438D7A",
  //   startDateTime: "2018-08-29T12:30:00",
  //   endDateTime: null,
  //   isCompleted: false,
  //   score: 0,
  //   challengeDefinition: {
  //     id: "4C9B8D9A-62F0-45C7-ABD5-C44F92438D7A",
  //     name: "Challenge 3",
  //     maxPoints: 50,
  //     description: "Implement a monitoring solution for your MyDriving",
  //     scoreEnabled: true
  //   },
  //   team: {
  //     id: "931EA0C8-62CA-4663-BD56-7693AC09994C",
  //     teamName: "otaprd510",
  //     downTimeMinutes: 184,
  //     points: 41,
  //     isScoringEnabled: false,
  //     serviceStatus: null,
  //   }
  // };

  constructor(private route: ActivatedRoute,
    private router: Router,
    private cs: ChallengesService,
    private ts: TeamsService,
    private fb: FormBuilder) {

  }

  addChallengeForm = this.fb.group({
    teamSelect: this.fb.group({
      team:['', Validators.required],
    }),
    challengeDefinitionSelect: this.fb.group({
      challengeDefinition: [''],
    }),
    startDateTimeGroup: this.fb.group({
    }),
  });

  ngOnInit() {

    Promise.all([
      this.getTeams(),
      this.getChallengeDefinitions()])
      .then((results: any[]) => {
        // let dt = new Date();
        // this.model.startDateTime = dt.toLocaleDateString();
        // let startDateTimeGroup: FormGroup =this.addChallengeForm.controls.startDateTimeGroup as FormGroup;
        // startDateTimeGroup.controls.startDateTime.setValue(this.model.startDateTime);
      });
  }

  onSubmit() {
    let teamSelect: FormGroup = this.addChallengeForm.controls.teamSelect as FormGroup;
    this.model.team = <ITeam>teamSelect.controls.team.value;
    this.model.teamId = this.model.team.id;

    let challengeSelect: FormGroup = this.addChallengeForm.controls.challengeDefinitionSelect as FormGroup;
    this.model.challengeDefinition = <IChallengeDefinition>challengeSelect.controls.team.value;
    this.model.challengeDefinitionId = this.model.challengeDefinition.id;

    let startDateTimeGroup: FormGroup =this.addChallengeForm.controls.startDateTimeGroup as FormGroup;

    var d = new Date(startDateTimeGroup.controls.startDateTime.value);
    this.model.startDateTime = d.toString()

    console.log(this.model);
  }

  updateStartDateTime(changes) {
    console.log(changes);
  }

  getTeams() {
    return new Promise((resolve, reject) =>
      this.ts.getTeams()
        .subscribe(
          data => {
            this.teams = data;
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
            resolve(data);
          },
          error => {
            this.errorMessage = <any>error;
            reject(error);
          },
        ));
  }
}
