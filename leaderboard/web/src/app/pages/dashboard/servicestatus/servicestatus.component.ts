import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'service-status',
  templateUrl: './servicestatus.component.html',
  styleUrls: ['./servicestatus.component.scss'],
})
export class ServiceStatusComponent implements OnInit {
  @Input() teamId = 4;
  constructor() { }

  ngOnInit() {
  }

}
