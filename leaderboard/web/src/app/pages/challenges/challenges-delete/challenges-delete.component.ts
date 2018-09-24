import { Component, OnInit, Inject } from '@angular/core';
import { Router } from '@angular/router';
import { MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { ChallengesService } from '../../../services/challenges.service';
import { Challenge } from '../challenge';


@Component({
  selector: 'ngx-challenges-delete',
  templateUrl: './challenges-delete.component.html',
  styleUrls: ['./challenges-delete.component.scss'],
})
export class ChallengesDeleteComponent implements OnInit {
  model: Challenge = new Challenge();

  errorMessage = '';

  constructor(
    private router: Router,
    private cs: ChallengesService,
    public dialogRef: MatDialogRef<ChallengesDeleteComponent>,
    @Inject(MAT_DIALOG_DATA) public c: Challenge) {
      this.model = c;
}


  ngOnInit() {
  }

  onNoClick() {

  }

  onYesClick() {
    this.deleteChallenge().then(
      r => {
        this.dialogRef.close();
        this.router.navigate(['/pages/challenges']);
      });

  }

  deleteChallenge() {
    return new Promise((resolve, reject) =>
    this.cs.deleteChallengeForTeam(this.model)
    .subscribe(
      data => {
        resolve();
      },
      error => {
        this.errorMessage = <any>error;
        reject(error);
      },
    ));
  }
}
