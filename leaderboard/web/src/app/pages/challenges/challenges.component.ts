import { Component, OnInit } from '@angular/core';
import { IChallenge } from '../../shared/challenge';
import { ChallengesService } from '../../services/challenges.service';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { ChallengesDeleteComponent } from './challenges-delete/challenges-delete.component';
import { Challenge } from './challenge';
@Component({
  selector: 'challenges', // tslint:disable-line
  templateUrl: './challenges.component.html',
  styleUrls: ['./challenges.component.scss'],
})
export class ChallengesComponent implements OnInit {
  pageTitle = 'Manage Challenges';

  errorMessage = '';
  _listFilter = '';

  get listFilter(): string {
    return this._listFilter;
}

set listFilter(value: string) {
    this._listFilter = value;
    this.filteredChallenges = this.listFilter ? this.performFilter(this.listFilter) : this.challenges;
}

filteredChallenges: IChallenge[];
challenges: IChallenge[];
challenge: Challenge;

performFilter(filterBy: string): IChallenge[] {
  filterBy = filterBy.toLocaleLowerCase();
  return this.challenges.filter((c: IChallenge) =>
    c.team.teamName.toLocaleLowerCase().indexOf(filterBy) !== -1);
}

  constructor(private challengeService: ChallengesService,
    public dialog: MatDialog) { }

  ngOnInit() {
    this.challengeService.getChallenges().subscribe(
      challenges => {
          this.challenges = challenges;
          this.filteredChallenges = this.challenges;
      },
      error => this.errorMessage = <any> error,
  );
  }

  openDeleteDialog(id: string) {

    this.getChallenge(id).then(r =>{
      const dialogRef = this.dialog.open(ChallengesDeleteComponent, {
        width: '250px',
        data: this.challenge,
      });

      dialogRef.afterClosed().subscribe(result => {
        this.challengeService.getChallenges().subscribe(
          challenges => {
              this.challenges = challenges;
              this.filteredChallenges = this.challenges;
          },
          error => this.errorMessage = <any> error,
        );
      });
    });
  }

  getChallenge(id: string) {
    return new Promise((resolve, reject) =>
      this.challengeService.getChallenge(id)
        .subscribe(
          data => {
            this.challenge = new Challenge();
            Object.assign(this.challenge,data);
            resolve(data);
          },
          error => {
            this.errorMessage = <any>error;
            reject(error);
          },
        ));
  }

}
