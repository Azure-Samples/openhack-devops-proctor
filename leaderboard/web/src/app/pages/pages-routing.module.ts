import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';

import { PagesComponent } from './pages.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { TeamsComponent } from './teams/teams.component';
import { TeamsAddComponent } from './teams/teams-add/teams-add.component';
import { TeamsDeleteComponent } from './teams/teams-delete/teams-delete.component';
import { ChallengesComponent } from './challenges/challenges.component';
import { ChallengesManageComponent } from './challenges//challenges-manage/challenges-manage.component';
import { ChallengesAddComponent } from './challenges//challenges-add/challenges-add.component';
import { ChallengesDeleteComponent } from './challenges/challenges-delete/challenges-delete.component';
import { ChallengesManageGuard } from './challenges/challenges-manage/challenges-manage.guard';
const routes: Routes = [{
  path: '',
  component: PagesComponent,
  children: [
    {
      path: 'dashboard',
      component: DashboardComponent,
    },
    {
      path: 'teams/teams-add',
      component: TeamsAddComponent,
    },
    {
      path: 'teams/teams-delete',
      component: TeamsDeleteComponent,
    },
    {
      path: 'teams',
      component: TeamsComponent,
    },
    {
      path: 'challenges',
      component: ChallengesComponent,
    },
    {
      path: 'challenges/challenges-manage/:id/:teamname',
      component: ChallengesManageComponent,
      canDeactivate: [ ChallengesManageGuard ],
    },
    {
      path: 'challenges/challenges-manage',
      component: ChallengesManageComponent,
      canDeactivate: [ ChallengesManageGuard ] ,
    },
    {
      path: 'challenges/challenges-add',
      component: ChallengesAddComponent,
    },
    {
      path: 'challenges/challenges-delete/:id',
      component: ChallengesDeleteComponent,
    },
    {
      path: '',
      redirectTo: 'dashboard',
      pathMatch: 'full',
    },
  ],
}];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class PagesRoutingModule {
}
