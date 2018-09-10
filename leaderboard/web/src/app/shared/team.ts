import {IServiceStatus} from './servicestatus';
export interface ITeam {
    id: string;
    teamName: string;
    downTimeMinutes: number;
    points: number;
    isScoringEnabled: boolean;
    serviceStatus: IServiceStatus[];
}
