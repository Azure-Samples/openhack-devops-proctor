import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormGroup, FormControl, FormBuilder, Validators } from '@angular/forms';
import { Subscription } from 'rxjs';
import { ChallengesService } from '../../../services/challenges.service';
import { Challenge, ChallengeDateType } from '../challenge';
import { TeamsService } from '../../../services/teams.service';
import { ITeam } from '../../../shared/team';
import { IChallengeDefinition } from '../../../shared/challengedefinition';

@Component({
  selector: 'ngx-challenges-manage',
  templateUrl: './challenges-manage.component.html',
  styleUrls: ['./challenges-manage.component.scss'],
})
export class ChallengesManageComponent implements OnInit, OnDestroy {
  form: FormGroup;
  private sub: Subscription;
  hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
  minutes = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];
  teamNames: string[];
  challengeDefinitionNames: string[];


  id: string;
  teamName: string;
  addEdit = 'Add';
  teams: ITeam[];
  startDate: Date;
  challengeDefinitions: IChallengeDefinition[];
  challengesForTeam: Challenge[];
  model: Challenge;

  errorMessage = '';

  constructor(private route: ActivatedRoute,
    private router: Router,
    private cs: ChallengesService,
    private ts: TeamsService,
    private fb: FormBuilder) { }


  ngOnInit() {
    this.form = this.fb.group({
      selectTeam: ['',Validators.required],
      selectChallenge: ['', Validators.required],
      startDateTimeGroup: this.fb.group({
        startDateTime: [new Date(),Validators.required],
        startHours: [1,Validators.required],
        startMins: [0,Validators.required],
      }),
      endDateTimeGroup: this.fb.group({
        endDateTime: '',
        endHours: 1,
        endMins: 0,
      }),
    });

    this.sub = this.route.params.subscribe(params => {
      this.id = params['id'];
      this.teamName = params['teamname'];
    });

    Promise.all([
      this.getTeams(),
      this.getChallengeDefinitions(),
      this.teamName !== undefined && this.teamName !== null ? this.getChallengesForTeam(this.teamName) : null,
      this.id !== undefined && this.id !== null ? this.getChallenge(this.id) : null,
    ])
      .then((results: any[]) => {
        if (this.id !== null && this.id !== undefined) {
          //edit code path
          this.addEdit = 'Edit';

          if(this.form){
            this.form.reset();
          }

          this.filterChallengeDefinitions();
          this.setSelectedTeam();
          this.setSelectedChallenge();
        }
        else{
          // add code path
          this.model = new Challenge();
          this.startDate = this.model.getDate(ChallengeDateType.Start);
        }

        this.setDateTimes();
      });
  }

  ngOnDestroy(): void {
    this.sub.unsubscribe();
  }

  onSubmit() {
    this.model.challengeDefinitionId =
      this.challengeDefinitions.find(cd => cd.name == <string>this.form.controls.selectChallenge.value).id;
    this.model.teamId =
      this.teams.find(t => t.teamName == <string>this.form.controls.selectTeam.value).id;
    this.model.challengeDefinition = null;
    this.model.team = null;

    const startDateGroup: FormGroup = this.form.controls.startDateTimeGroup as FormGroup;
    const endDateGroup: FormGroup = this.form.controls.endDateTimeGroup as FormGroup;

    const d: Date = (<Date>(startDateGroup.controls.startDateTime as FormControl).value);
    const h:number = (<number>startDateGroup.controls.startHours.value);
    const m:number = (<number>startDateGroup.controls.startMins.value);

    this.model.setDate(ChallengeDateType.Start,d,h,m);

    this.createChallenge().then(r => {
      if(this.form){
        this.form.reset();
      }
      this.router.navigate(['/pages/challenges']);
    });
  }

  filterChallengeDefinitions() {
    if(this.challengesForTeam && this.challengesForTeam.length > 0){
      const challengeNamesForTeam = this.challengesForTeam.filter(c => c.endDateTime !== null).map(c => c.challengeDefinition.name);
      const challengesNotCompleted = this.challengeDefinitionNames
        .filter(item => challengeNamesForTeam.indexOf(item) < 0);
      this.challengeDefinitionNames = challengesNotCompleted;
    }
  }


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

  getChallengesForTeam(teamName: string) {
    return new Promise((resolve, reject) =>
    this.cs.getChallengesForTeam(teamName)
      .subscribe(
        data => {
          this.challengesForTeam = <Challenge[]>data;
          resolve(data);
        },
        error => {
          this.errorMessage = <any>error;
          reject(error);
        },
      ));
  }

  createChallenge() {
    return new Promise((resolve, reject) =>
    this.cs.createChallengeForTeam(this.model)
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

  setSelectedTeam(){
    const selectedTeamName = this.model.team.teamName;
    this.form.controls.selectTeam.patchValue(selectedTeamName);
  }
  setSelectedChallenge(){
    const selectedChallengeDefinitionName = this.model.challengeDefinition.name;
    this.form.controls.selectChallenge.patchValue(selectedChallengeDefinitionName);
  }

  setDateTimes(): void {
    const startTimeGroup: FormGroup = this.form.controls.startDateTimeGroup as FormGroup;
    const endTimeGroup: FormGroup = this.form.controls.endDateTimeGroup as FormGroup;

    let n: number =this.model.getHours(ChallengeDateType.Start);
    startTimeGroup.controls.startHours.patchValue(n);

    n = this.model.getMinutes(ChallengeDateType.Start);
    startTimeGroup.controls.startMins.patchValue(n);

    if(this.model.endDateTime != null){
      n = this.model.getHours(ChallengeDateType.End);
      endTimeGroup.controls.endHours.patchValue(n);

      n = this.model.getMinutes(ChallengeDateType.End);
      endTimeGroup.controls.endMins.patchValue(n);
    }
  }

  updateChallengeList(){
    const selTeam: string = this.form.controls.selectTeam.value;

    Promise.all([
      this.getChallengesForTeam(selTeam)
    ]).then((results: any[]) => {
      const cd:FormControl = this.form.controls.selectChallenge as FormControl;
      cd.reset();
      this.filterChallengeDefinitions();
    });

  }

  controlsValid(): string {
    const startDateTimeGroup: FormGroup = this.form.controls.startDateTimeGroup as FormGroup;

    return "selectTeam: " + this.form.controls.selectTeam.valid +
      ", selectChallenge: " + this.form.controls.selectChallenge.valid +
      ", startDateTime: " + startDateTimeGroup.controls.startDateTime.valid +
      ", startHours: " + startDateTimeGroup.controls.startHours.valid +
      ", startMins: " + startDateTimeGroup.controls.startMins.valid;
  }

  editEnabled(): boolean {
    return this.addEdit === 'Edit' ? true : false;
  }
}
