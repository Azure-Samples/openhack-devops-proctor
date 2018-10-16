import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { FormGroup, FormControl, FormBuilder, Validators, AsyncValidatorFn, AbstractControl, ValidationErrors } from '@angular/forms';
import { Subscription, Observable } from 'rxjs';
import { ChallengesService } from '../../../services/challenges.service';
import { Challenge, ChallengeDateType } from '../challenge';
import { TeamsService } from '../../../services/teams.service';
import { ITeam } from '../../../shared/team';
import { IChallengeDefinition } from '../../../shared/challengedefinition';
import { environment } from '../../../../environments/environment';

class BusinessRuleValidationError {
  key: string;
  errorMessage: string;
}

export function challengeOpenForTeamValidator(cs: ChallengesService, addEdit: string): AsyncValidatorFn {
  return (control: AbstractControl): Promise<ValidationErrors | null> | Observable<ValidationErrors | null> => {
    return cs.getChallengesForTeam(control.value).map(
      challenges => {
        return (challenges && challenges.filter(c => addEdit === 'Edit' ?
          c.team.teamName !== control.value && c.endDateTime === null :
          c.endDateTime === null)
          .length > 0) ? {'challengeOpenForTeam': true} : null;
      },
    );
  };
}

@Component({
  selector: 'ngx-challenges-manage',
  templateUrl: './challenges-manage.component.html',
  styleUrls: ['./challenges-manage.component.scss'],
})
export class ChallengesManageComponent implements OnInit, OnDestroy {
  form: FormGroup;
  private sub: Subscription;
  hours = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
  minutes = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55];
  teamNames: string[];
  challengeDefinitionNames: string[];
  env = environment;

  id: string;
  teamName: string;
  addEdit = 'Add';
  teams: ITeam[];
  startDate: Date;
  endDate: Date;
  challengeDefinitions: IChallengeDefinition[];
  challengesForTeam: Array<Challenge>;
  model: Challenge;
  validationErrors: BusinessRuleValidationError[];
  currentUTCDateTime: string;
  currentLocalDateTime: string;
  timeTooltip: string;
  errorMessage = '';

  constructor(private route: ActivatedRoute,
    private router: Router,
    private cs: ChallengesService,
    private ts: TeamsService,
    private fb: FormBuilder) { }


  ngOnInit() {
    const currentDate: Date = new Date();
    this.currentLocalDateTime = currentDate.toLocaleString();
    this.currentUTCDateTime = currentDate.toUTCString();

    this.form = this.fb.group({
      selectTeam: ['', [ Validators.required ], [ challengeOpenForTeamValidator(this.cs, 'Add') ]],
      selectChallenge: ['', Validators.required],
      startDateTimeGroup: this.fb.group({
        startDateTime: [new Date(), Validators.required],
        startHours: [1, Validators.required],
        startMins: [0, Validators.required],
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
          // edit code path
          this.addEdit = 'Edit';

          this.form.controls.selectTeam.clearAsyncValidators();
          this.form.controls.selectTeam.setAsyncValidators(challengeOpenForTeamValidator(this.cs, 'Edit'))
          this.enableDisableControls();

          if (this.form) {
            this.form.reset();
          }

          this.filterChallengeDefinitions();
          this.setSelectedTeam();
          this.setSelectedChallenge();
          this.checkSetEndDateTime();
          this.endDate = this.model.getDate(ChallengeDateType.End);
        } else {
          // add code path
          this.model = new Challenge();

        }
        this.startDate = this.model.getDate(ChallengeDateType.Start);
        this.setDateTimes();

      });
  }

  ngOnDestroy(): void {
    this.sub.unsubscribe();
  }

  onSubmit() {
    this.validationErrors = null;
    this.errorMessage = '';

    this.model.challengeDefinitionId =
      this.challengeDefinitions.find(cd => cd.name === <string>this.form.controls.selectChallenge.value).id;
    this.model.teamId =
      this.teams.find(t => t.teamName === <string>this.form.controls.selectTeam.value).id;
    this.model.challengeDefinition = null;
    this.model.team = null;

    const startDateGroup: FormGroup = this.form.controls.startDateTimeGroup as FormGroup;

    const ds: Date = (<Date>(startDateGroup.controls.startDateTime as FormControl).value);
    const hs: number = (<number>startDateGroup.controls.startHours.value);
    const ms: number = (<number>startDateGroup.controls.startMins.value);

    this.model.setDate(ChallengeDateType.Start, ds, hs, ms);

    // TODO - this is a hacky way of validating across from groups.  Neew to fix.
    this.checkStartTimeGreaterThanClosedChallenges().then((e: BusinessRuleValidationError) => {


      if (e !== null) {
        // abandon save, business rule check failed
        this.errorMessage = e.key + ': ' + e.errorMessage;
        return;
      }

      if (this.addEdit === 'Edit') {
        const endDateGroup: FormGroup = this.form.controls.endDateTimeGroup as FormGroup;

        const de: Date = (<Date>(endDateGroup.controls.endDateTime as FormControl).value);
        const he: number = (<number>endDateGroup.controls.endHours.value);
        const me: number = (<number>endDateGroup.controls.endMins.value);

        this.model.setDate(ChallengeDateType.End, de, he, me);

        this.model.isCompleted = true;

            // TODO - this is a hacky way of validating across from groups.  Neew to fix.
        e = this.checkEndTimeGreaterThanStartTime();

        if (e !== null) {
          // abandon save, business rule check failed
          this.errorMessage = e.key + ': ' + e.errorMessage;
          return;
        }
      }

      if (this.addEdit === 'Edit') {
        this.updateChallenge().then(r => {
          if (this.form) {
            this.form.reset();
          }
          this.router.navigate(['/pages/challenges']);
        });
      } else {
        this.createChallenge().then(r => {
          if (this.form) {
            this.form.reset();
          }
          this.router.navigate(['/pages/challenges']);
        });
      }
    });



  }

  enableDisableControls() {
    if (this.addEdit === 'Edit') {
      this.form.controls.selectTeam.disable();
      this.form.controls.selectChallenge.disable();
    } else {

    }
  }

  filterChallengeDefinitions() {
    if (this.challengesForTeam && this.challengesForTeam.length > 0) {
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
            this.model = new Challenge();
            Object.assign(this.model, data);
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
            const cArr: Array<Challenge> = new Array<Challenge>();
            if (data.length > 0) {
              for (let i: number = 0; i < data.length; i++) {
                  const cAssign: Challenge = new Challenge();
                  Object.assign(cAssign, data[i]);
                  cArr.push(cAssign);
                };
            }

            this.challengesForTeam = cArr;
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
    // end time > start time
  checkEndTimeGreaterThanStartTime(): BusinessRuleValidationError {
    let e: BusinessRuleValidationError = new BusinessRuleValidationError();

    e = new Date(this.model.endDateTime) < new Date(this.model.startDateTime) ?
      { key: 'Invalid Start Date/Time',
        errorMessage: 'End Date/Time must be after Challenge Start Date/Time' } : null;

    return e;
  }

  // startTime > end time of all closed challenges
  checkStartTimeGreaterThanClosedChallenges(): Promise<BusinessRuleValidationError | null> {
    let e: BusinessRuleValidationError = new BusinessRuleValidationError();

    return new Promise<BusinessRuleValidationError>((resolve, reject) => {
      this.getChallengesForTeam(this.form.controls.selectTeam.value).then((results: any[]) => {
        if (this.challengesForTeam === undefined || this.challengesForTeam === null || this.challengesForTeam.length < 2) {
          resolve(null);
          return;
        }

        const maxChallenge = this.challengesForTeam.reduce(function (prev, current) {
          return (new Date(prev.endDateTime) > new Date(current.endDateTime)) ? prev : current;
        });

        e = (new Date(maxChallenge.endDateTime) > new Date(this.model.startDateTime)) ?
          {
            key: 'Invalid Start Date/Time',
            errorMessage: 'The selected start date/time needs to be set to a date/time after ' + maxChallenge.endDateTime,
          } : null;
        e === null ? resolve(null) : resolve(e);
      });

    },
    );

  }

  updateChallenge() {
    return new Promise((resolve, reject) =>
    this.cs.updateChallengeForTeam(this.model)
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

  setSelectedTeam() {
    const selectedTeamName = this.model.team.teamName;
    this.form.controls.selectTeam.patchValue(selectedTeamName);
  }
  setSelectedChallenge() {
    const selectedChallengeDefinitionName = this.model.challengeDefinition.name;
    this.form.controls.selectChallenge.patchValue(selectedChallengeDefinitionName);
  }

  checkSetEndDateTime() {
    if (this.model.endDateTime === null) {
      // set endDateTime to a time after StartDateTime if null
      const sd: Date = new Date(this.model.startDateTime);
      const ed: Date = new Date(sd.getTime() + 5 * 60000);
      const h: number = ed.getHours();
      const m: number = ed.getMinutes();
      this.model.setDate( ChallengeDateType.End, ed, h, m);
    }
  }

  setDateTimes(): void {
    const startTimeGroup: FormGroup = this.form.controls.startDateTimeGroup as FormGroup;
    const endTimeGroup: FormGroup = this.form.controls.endDateTimeGroup as FormGroup;

    let d: Date = this.model.getDate(ChallengeDateType.Start);
    startTimeGroup.controls.startDateTime.patchValue(d);

    let n: number = this.model.getHours(ChallengeDateType.Start);
    startTimeGroup.controls.startHours.patchValue(n);

    n = this.model.getMinutes(ChallengeDateType.Start);
    startTimeGroup.controls.startMins.patchValue(n);

    if (this.model.endDateTime != null) {
      d = this.model.getDate(ChallengeDateType.End);
      endTimeGroup.controls.endDateTime.patchValue(d);

      n = this.model.getHours(ChallengeDateType.End);
      endTimeGroup.controls.endHours.patchValue(n);

      n = this.model.getMinutes(ChallengeDateType.End);
      endTimeGroup.controls.endMins.patchValue(n);
    }
  }

  updateChallengeList() {
    const selTeam: string = this.form.controls.selectTeam.value;

    Promise.all([
      this.getChallengesForTeam( selTeam ),
    ]).then((results: any[]) => {
      const cd: FormControl = this.form.controls.selectChallenge as FormControl;
      cd.reset();
      this.filterChallengeDefinitions();
    });

  }

  controlsValid(): string {
    const startDateTimeGroup: FormGroup = this.form.controls.startDateTimeGroup as FormGroup;

    return 'selectTeam: ' + this.form.controls.selectTeam.valid +
      ', selectChallenge: ' + this.form.controls.selectChallenge.valid +
      ', startDateTime: ' + startDateTimeGroup.controls.startDateTime.valid +
      ', startHours: ' + startDateTimeGroup.controls.startHours.valid +
      ', startMins: ' + startDateTimeGroup.controls.startMins.valid;
  }

  editEnabled(): boolean {
    return this.addEdit === 'Edit' ? true : false;
  }
}
