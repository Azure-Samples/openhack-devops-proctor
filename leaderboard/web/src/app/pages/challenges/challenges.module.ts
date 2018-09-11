import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ChallengesComponent } from './challenges.component';
import { ChallengesAddComponent } from './challenges-add/challenges-add.component';
import { ChallengesDeleteComponent } from './challenges-delete/challenges-delete.component';

@NgModule({
  imports: [
    CommonModule,
  ],
  declarations: [ChallengesComponent, ChallengesAddComponent, ChallengesDeleteComponent],
})
export class ChallengesModule { }
