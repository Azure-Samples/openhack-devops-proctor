import {IChallenge} from '../../shared/challenge';
import { ITeam } from '../../shared/team';
import { IChallengeDefinition } from '../../shared/challengedefinition';

export enum ChallengeDateType {
    Start,
    End,
};
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



    constructor() {
        this.id = '';
        this.teamId = '';
        this.challengeDefinitionId = '';
        this.initStartDate();
        this.endDateTime = null;
        this.isCompleted = false;
        this.score = 0;
    }

    getChallengeDate(dt: ChallengeDateType): string {
       return dt === ChallengeDateType.Start ? this.startDateTime : this.endDateTime;
    }

    getDate(dt: ChallengeDateType): Date {
        return new Date(dt === ChallengeDateType.Start ? this.startDateTime : this.endDateTime);
    }

    getDay(dt: ChallengeDateType): number {
        const d: Date = new Date(this.getChallengeDate(dt));
        return d.getDay();
    }

    getDayString(dt: ChallengeDateType): string {
        const d: Date = new Date(this.getChallengeDate(dt));
        return ('0' + d.getDate().toString()).slice(-2);
    }

    getMonth(dt: ChallengeDateType): number {
        const d: Date = new Date(this.getChallengeDate(dt));
        // javascript getMonth returns 0-11 https://www.w3schools.com/jsref/jsref_getmonth.asp
        return d.getMonth() + 1;
    }

    getMonthString(dt: ChallengeDateType): string {
        const d: Date = new Date(this.getChallengeDate(dt));
        // javascript getMonth returns 0-11 https://www.w3schools.com/jsref/jsref_getmonth.asp
        const m: number = d.getMonth() + 1;
        return ('0' + m.toString()).slice(-2);
    }

    getYear(dt: ChallengeDateType): number {
        const d: Date = new Date(this.getChallengeDate(dt));
        return d.getFullYear();
    }

    getYearString(dt: ChallengeDateType): string {
        const d: Date = new Date(this.getChallengeDate(dt));
        const y: number = d.getFullYear();
        return ('0000' + y.toString()).slice(-4);
    }

    getHours(dt: ChallengeDateType): number {
        const d: Date = new Date(this.getChallengeDate(dt));
        return d.getHours();
    }

    gethoursString(dt: ChallengeDateType): string {
        const d: Date = new Date(this.getChallengeDate(dt));
        const h: number = d.getHours();
        return ('0' + h.toString()).slice(-2);
    }
    getMinutes(dt: ChallengeDateType): number {
        const d: Date = new Date(this.getChallengeDate(dt));
        return d.getMinutes();
    }

    getMinutesString(dt: ChallengeDateType): string {
        const d: Date = new Date(this.getChallengeDate(dt));
        const m: number = d.getMinutes();
        return ('0' + m.toString()).slice(-2);
    }

    initStartDate(): void {
        const d: Date = new Date();
        const h: number = d.getHours();
        const m: number = this.round5(d.getMinutes());

        this.setDate(ChallengeDateType.Start, d, h, m);
    }

    round5(x: number): number {
        if (x > 55) {
            return 55;
        }

        if (x < 0) {
            return 0;
        }
        return Math.ceil(x / 5) * 5;
    }

    setDate(dt: ChallengeDateType, dateCtrlValue: Date, h: number, m: number): void {
        const mRound: number = this.round5(m); // ensure we are in 5 min increment
        const day: string    = ('0' + dateCtrlValue.getDate().toString()).slice(-2);
        const month: string  = ('0' + (dateCtrlValue.getMonth() + 1).toString()).slice(-2);
        const year: string   = ('0000' + dateCtrlValue.getFullYear().toString()).slice(-4);
        const hour: string   = ('0' + h.toString()).slice(-2);
        const min: string    = ('0' + mRound.toString()).slice(-2);

        const dateString = year + '-' + month + '-' + day + 'T' + hour + ':' + min + ':00.0000000'

        dt === ChallengeDateType.Start ? this.startDateTime = dateString : this.endDateTime = dateString;
    }

}
