import { Component, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
import { IChallenge } from '../../shared/challenge';
import { ChallengesService } from '../../services/challenges.service';

@Component({
  selector: 'challenges', // tslint:disable-line
  templateUrl: './challenges.component.html',
  styleUrls: ['./challenges.component.scss'],
})
export class ChallengesComponent implements OnInit {

  pageTitle = "Manage Challenges";
  _listFilter = '';
  errorMessage='';

  filteredChallenges: IChallenge[];
  challenges: IChallenge[];

  get listFilter(): string {
    return this._listFilter;
  }

  set listFilter(value: string) {
    this._listFilter = value;
    this.filteredChallenges = this.listFilter ?
      this.performFilter(this.listFilter): this.challenges;
  }

  onTeamClicked() {

  }

  performFilter(filterBy: string): IChallenge[] {
    filterBy = filterBy.toLocaleLowerCase();
    return this.challenges.filter((challenge: IChallenge) =>
      challenge.team.teamName.toLocaleLowerCase().indexOf(filterBy) !== -1);
  }

  constructor(private challengeService: ChallengesService) { }

  ngOnInit() {
    this.challengeService.getChallenges()
    .subscribe(
      data => {
        this.challenges = data;
        this.filteredChallenges = this.challenges;
      },
      error => this.errorMessage = <any>error,
    );
  }

}
