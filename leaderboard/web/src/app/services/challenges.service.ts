import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, tap } from 'rxjs/operators';
import {environment} from '../../environments/environment';
import { IChallenge } from '../shared/challenge';

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

  getChallenge(id: string): Observable<IChallenge> {
    return this.http.get<IChallenge>(this.backendUrl + 'challenges/' + id).pipe(
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

