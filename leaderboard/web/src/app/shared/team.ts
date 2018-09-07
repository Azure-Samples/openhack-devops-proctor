import {IServiceStatus} from './servicestatus';
export interface ITeam {
    id: String;
    teamName: string;
    downTimeMinutes: number;
    points: number;
    isScoringEnabled: boolean;
    serviceStatus: IServiceStatus[];
}
