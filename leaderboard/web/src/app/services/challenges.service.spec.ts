import { TestBed } from '@angular/core/testing';

import { ChallengesService } from './challenges.service';

describe('ChallengesService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: ChallengesService = TestBed.get(ChallengesService);
    expect(service).toBeTruthy();
  });
});
