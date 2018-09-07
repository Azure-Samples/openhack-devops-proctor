import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TeamsComponent } from './teams.component';
import { TeamsAddComponent } from './teams-add/teams-add.component';
import { TeamsDeleteComponent } from './teams-delete/teams-delete.component';
import { FormsModule } from '@angular/forms';
// import {RouterModule} from '@angular/router';
@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    // RouterModule.forChild(
    //   [
    //     {path: 'teams-add', component:TeamsAddComponent}
    //   ]
    // )
  ],
  declarations: [ TeamsComponent, TeamsAddComponent, TeamsDeleteComponent ],
})
export class TeamsModule { }
