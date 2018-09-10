import { ITeam } from "../../shared/team";
import { IServiceStatus } from "../../shared/servicestatus";

export class Team implements ITeam{

    public teamName: string;
    public serviceStatus: IServiceStatus[];
    public id: string;

    public downTimeMinutes: number;
    public points: number;
    public isScoringEnabled: boolean;
    constructor (
    ){
        this.downTimeMinutes = 0;
        this.points = 0;
        this.isScoringEnabled = false;
        this.teamName = 'Enter Team Name'
        this.serviceStatus = null;
    }

}
