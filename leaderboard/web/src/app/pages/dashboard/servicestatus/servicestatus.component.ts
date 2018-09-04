import { Component, OnInit, Input } from '@angular/core';
import {IServiceHealth} from '../../../shared/servicehealth';
@Component({
  selector: 'ngx-servicestatus',
  templateUrl: './servicestatus.component.html',
  styleUrls: ['./servicestatus.component.scss'],
})
export class ServiceStatusComponent implements OnInit {
  @Input() serviceHealth: IServiceHealth;
  constructor() { }

  ngOnInit() {
  }

}
