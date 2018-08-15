import { TeamsModule } from './teams.module';

describe('TeamsModule', () => {
  let teamsModule: TeamsModule;

  beforeEach(() => {
    teamsModule = new TeamsModule();
  });

  it('should create an instance', () => {
    expect(teamsModule).toBeTruthy();
  });
});
