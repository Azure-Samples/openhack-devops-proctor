import {IChallenge} from '../../shared/challenge';
import { ITeam } from '../../shared/team';
import { IChallengeDefinition } from '../../shared/challengedefinition';

export class Challenge implements IChallenge {
    public id: string;
    public teamId: string;
    public challengeDefinitionId: string;
    public startDateTime: string;
    public endDateTime: string;
    public isCompleted: boolean;
    public score: number;
    public challengeDefinition: IChallengeDefinition;
    public team: ITeam;

    constructor(){
        this.id = '';
        this.teamId = '';
        this.challengeDefinitionId = '';
        this.startDateTime = Date.now.toString();
        this.endDateTime = null;
        this.isCompleted = false;
        this.score = 0;
    }
}
