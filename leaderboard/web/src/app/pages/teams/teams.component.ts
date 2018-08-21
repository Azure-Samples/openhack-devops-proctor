import { Component, OnInit, ChangeDetectionStrategy } from '@angular/core';

@Component({
  selector: 'ngx-teams',
  templateUrl: './teams.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  styleUrls: ['./teams.component.scss'],
})
export class TeamsComponent implements OnInit {

  constructor() { }

  ngOnInit() {
  }

}
