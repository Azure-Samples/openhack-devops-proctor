import { Injectable } from '@angular/core';
import { CanDeactivate } from '@angular/router';
import { Observable } from 'rxjs';
import { ChallengesManageComponent } from './challenges-manage.component';

@Injectable({
  providedIn: 'root'
})
export class ChallengesManageGuard implements CanDeactivate<ChallengesManageComponent> {
  canDeactivate(component: ChallengesManageComponent): Observable<boolean> | Promise<boolean> | boolean {
    if (component.form.dirty) {
      const teamName = component.form.get('selectChallenge').value || 'New Challenge';
      return confirm(`Navigate away and lose all changes to ${teamName}?`);
    }
    return true;
  }
}
