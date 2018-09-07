import { Component, OnInit, Input } from '@angular/core';
import {IServiceStatus} from '../../../shared/servicestatus';

@Component({
  selector: 'ngx-servicestatus',
  templateUrl: './servicestatus.component.html',
  styleUrls: ['./servicestatus.component.scss'],
})
export class ServiceStatusComponent implements OnInit {
  @Input() serviceStatusArray: IServiceStatus[];
  @Input() serviceType = 1;

  constructor( ) { }

  getStatusColor(): object {
    return {
      'color': this.serviceStatusArray.filter(
        s => s.serviceType === this.serviceType)[0]
        .status.toLocaleUpperCase(),
      'font-size': 48
    };
  }

  ngOnInit() {
  }

}
