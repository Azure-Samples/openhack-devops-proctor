import { Component } from '@angular/core';

@Component({
  selector: 'ngx-footer',
  styleUrls: ['./footer.component.scss'],
  template: `
    <span class="created-by"><b>DevOps Open Hack Team</b> 2018</span>
    <div class="socials">
      <a href="https://github.com/Azure-Samples/openhack-devops-proctor/tree/master/leaderboard/web" \
      target="_blank" class="ion ion-social-github"></a>
    </div>
  `,
})
export class FooterComponent {
}
