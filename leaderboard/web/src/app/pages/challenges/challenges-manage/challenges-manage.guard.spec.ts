import { TestBed, async, inject } from '@angular/core/testing';

import { ChallengesManageGuard } from './challenges-manage.guard';

describe('ChallengesManageGuard', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [ChallengesManageGuard]
    });
  });

  it('should ...', inject([ChallengesManageGuard], (guard: ChallengesManageGuard) => {
    expect(guard).toBeTruthy();
  }));
});
