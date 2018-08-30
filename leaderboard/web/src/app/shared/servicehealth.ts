import { ITeam } from './team';

export interface IServiceHealth {
    teamId: string;
    team: ITeam;
    healthStatus: string;
    serviceType: string;
}
