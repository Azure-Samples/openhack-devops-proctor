import { ITeam } from './team';
import { IChallengeDefinition } from './challengedefinition';

export interface IChallenge {
    id: string;
    teamId: string;
    challengeDefinitionId: string;
    startDateTime: string;
    endDateTime: string;
    isCompleted: boolean;
    score: number;
    challengeDefinition: IChallengeDefinition;
    team: ITeam;
}
