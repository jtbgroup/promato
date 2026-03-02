import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable, tap } from 'rxjs';
import { environment } from '../../../environments/environment';

export interface UserDto {
  id: number;
  username: string;
  email: string;
  role: string;
}

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly baseUrl = `${environment.apiUrl}/auth`;

  currentUser$ = new BehaviorSubject<UserDto | null>(null);

  constructor(private http: HttpClient) {}

  login(username: string, password: string): Observable<UserDto> {
    return this.http
      .post<UserDto>(`${this.baseUrl}/login`, { username, password }, { withCredentials: true })
      .pipe(tap(user => this.currentUser$.next(user)));
  }

  logout(): Observable<void> {
    return this.http
      .post<void>(`${this.baseUrl}/logout`, {}, { withCredentials: true })
      .pipe(tap(() => this.currentUser$.next(null)));
  }

  me(): Observable<UserDto> {
    return this.http
      .get<UserDto>(`${this.baseUrl}/me`, { withCredentials: true })
      .pipe(tap(user => this.currentUser$.next(user)));
  }

  isAuthenticated(): boolean {
    return this.currentUser$.value !== null;
  }
}
