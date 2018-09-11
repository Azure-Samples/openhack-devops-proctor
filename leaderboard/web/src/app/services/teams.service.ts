import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse, HttpHeaders } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, tap } from 'rxjs/operators';
import {environment} from '../../environments/environment';
import { ITeam } from '../shared/team';

@Injectable({
  providedIn: 'root',
})
export class TeamsService {
  backendUrl = environment.backendUrl;

  constructor(private http: HttpClient) {}

  createTeam(tm: ITeam ): Observable<ITeam> {
    const url = this.backendUrl + 'teams';
    const payload = JSON.stringify(tm);
    const headers = new HttpHeaders({'Content-Type': 'application/json', 'Accept': '*/*'});
    const options =  {
        headers: headers,
    };

    return this.http.post<ITeam>(url, payload, options).pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  };

  getTeams(): Observable<ITeam[]> {
    return this.http.get<ITeam[]>(this.backendUrl + 'teams').pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  };

  getServiceHealth(): Observable<ITeam[]> {
    return this.http.get<ITeam[]>(this.backendUrl + 'servicehealth').pipe(
      // tslint:disable-next-line:no-console
      tap(data => console.log('All: ' + JSON.stringify(data))),
    catchError(this.handleError));
  };

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
