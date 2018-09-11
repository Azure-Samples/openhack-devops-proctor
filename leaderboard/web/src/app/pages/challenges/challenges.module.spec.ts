import { ChallengesModule } from './challenges.module';

describe('ChallengesModule', () => {
  let challengesModule: ChallengesModule;

  beforeEach(() => {
    challengesModule = new ChallengesModule();
  });

  it('should create an instance', () => {
    expect(challengesModule).toBeTruthy();
  });
});
