import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { ChallengesService } from '../../../services/challenges.service';
@Component({
  selector: 'ngx-challenges-delete',
  templateUrl: './challenges-delete.component.html',
  styleUrls: ['./challenges-delete.component.scss'],
})
export class ChallengesDeleteComponent implements OnInit {

  constructor(private route: ActivatedRoute,
    private router: Router,
    private cs: ChallengesService) { }

  ngOnInit() {
  }

}
