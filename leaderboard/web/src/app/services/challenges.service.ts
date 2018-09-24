import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, tap } from 'rxjs/operators';
import {environment} from '../../environments/environment';
import { IChallenge } from '../shared/challenge';
import { IChallengeDefinition } from '../shared/challengedefinition';

@Injectable({
  providedIn: 'root',
})
export class ChallengesService {
  backendUrl = environment.backendUrl;

  constructor(private http: HttpClient) { }

  getChallenges(): Observable<IChallenge[]> {
    return this.http.get<IChallenge[]>(this.backendUrl + 'challenges').pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  };

  getChallengeDefinitions(): Observable<IChallengeDefinition[]> {
    return this.http.get<IChallengeDefinition[]>(this.backendUrl + 'challengeDefinitions').pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  };

  getChallenge(id: string): Observable<IChallenge> {
    return this.http.get<IChallenge>(this.backendUrl + 'challenges/id/' + id).pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  }

  getChallengesForTeam(teamName: string): Observable<IChallenge[]> {
    return this.http.get<IChallenge[]>(this.backendUrl + 'challenges/' + teamName).pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  }

  createChallengeForTeam(c: IChallenge): Observable<IChallenge> {
    const url = this.backendUrl + 'challenges';
    const payload = JSON.stringify(c);
    const headers = new HttpHeaders({'Content-Type': 'application/json', 'Accept': '*/*'});
    const options =  {
        headers: headers,
    };

    return this.http.post<IChallenge>(url, payload, options).pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  }

  updateChallengeForTeam(c: IChallenge): Observable<IChallenge> {
    const url = this.backendUrl + 'challenges/' + c.id;
    const payload = JSON.stringify(c);
    const headers = new HttpHeaders({'Content-Type': 'application/json', 'Accept': '*/*'});
    const options =  {
        headers: headers,
    };

    return this.http.patch<IChallenge>(url, payload, options).pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  }

  deleteChallengeForTeam(c: IChallenge): Observable<void> {
    const url = this.backendUrl + 'challenges/' + c.id;
    const headers = new HttpHeaders({'Content-Type': 'application/json', 'Accept': '*/*'});
    const options =  {
        headers: headers,
    };

    return this.http.delete<void>(url, options).pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  }

  private handleError(err: HttpErrorResponse) {
    // logging it to the console
    let errorMessage = '';
    if (err.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      errorMessage = `An error occurred: ${err.error.message}`;
    } else {
      // The backend returned an unsuccessful response code.
      // response body may contain clues as to what went wrong,
      errorMessage = `Server returned code: ${err.status}, error message is: ${err.message}`;
    }
    console.error(errorMessage);
    return throwError(errorMessage);
  }
}

