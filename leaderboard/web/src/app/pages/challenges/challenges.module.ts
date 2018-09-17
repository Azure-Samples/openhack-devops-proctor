import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { ChallengesComponent } from './challenges.component';
import { ChallengesManageComponent } from './challenges-manage/challenges-manage.component';
import { ChallengesDeleteComponent } from './challenges-delete/challenges-delete.component';

import { ChallengesAddComponent } from './challenges-add/challenges-add.component';
import {
  MatCardModule,
  MatFormFieldModule,
  MatDatepickerModule,
  MatInputModule,
  MatNativeDateModule,
  MatIconModule,
  MatSelectModule,
  MatOptionModule,
  MatButtonModule } from '@angular/material';
@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule,
    MatCardModule,
    MatFormFieldModule,
    MatDatepickerModule,
    MatInputModule,
    MatNativeDateModule,
    MatIconModule,
    MatSelectModule,
    MatOptionModule,
    MatButtonModule,
  ],
  exports: [
    MatCardModule,
    MatFormFieldModule,
    MatDatepickerModule,
    MatInputModule,
    MatNativeDateModule,
    MatIconModule,
    MatSelectModule,
    MatOptionModule,
    MatButtonModule,
  ],
  declarations: [
    ChallengesComponent,
    ChallengesManageComponent,
    ChallengesDeleteComponent,
    ChallengesAddComponent],
})
export class ChallengesModule { }
