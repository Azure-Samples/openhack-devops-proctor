import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { ChallengesService } from '../../../services/challenges.service';
import { Challenge } from '../challenge';

@Component({
  selector: 'ngx-challenges-manage',
  templateUrl: './challenges-manage.component.html',
  styleUrls: ['./challenges-manage.component.scss'],
})
export class ChallengesManageComponent implements OnInit {

  id: string;
  model = new Challenge();

  constructor(private route: ActivatedRoute,
    private router: Router,
    private cs: ChallengesService) { }

  ngOnInit() {
    this.id = this.route.snapshot.paramMap.get('id');
    if(this.id !== null || this.id !== undefined)
    {

    }

  }

}
