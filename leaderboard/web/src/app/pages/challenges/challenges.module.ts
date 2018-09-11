import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { ChallengesComponent } from './challenges.component';
import { ChallengesManageComponent } from './challenges-manage/challenges-manage.component';
import { ChallengesDeleteComponent } from './challenges-delete/challenges-delete.component';
import { FormsModule } from '@angular/forms';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    RouterModule,
  ],
  declarations: [ChallengesComponent, ChallengesManageComponent, ChallengesDeleteComponent],
})
export class ChallengesModule { }
