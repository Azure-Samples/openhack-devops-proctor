import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TeamsComponent } from './teams.component';
import { TeamsAddComponent } from './teams-add/teams-add.component';
import { TeamsDeleteComponent } from './teams-delete/teams-delete.component';

@NgModule({
  imports: [
    CommonModule,
  ],
  declarations: [ TeamsComponent, TeamsAddComponent, TeamsDeleteComponent ],
})
export class TeamsModule { }
