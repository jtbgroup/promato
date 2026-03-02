import { TestBed } from '@angular/core/testing';
import { HttpTestingController, provideHttpClientTesting } from '@angular/common/http/testing';
import { provideHttpClient } from '@angular/common/http';
import { AuthService, UserDto } from './auth.service';

const mockUser: UserDto = { id: 1, username: 'admin', email: 'admin@promato.local', role: 'ADMIN' };

describe('AuthService', () => {
  let service: AuthService;
  let http: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({ providers: [provideHttpClient(), provideHttpClientTesting()] });
    service = TestBed.inject(AuthService);
    http = TestBed.inject(HttpTestingController);
  });

  afterEach(() => http.verify());

  it('login() success — updates currentUser$ and returns UserDto', () => {
    service.login('admin', 'Admin1234!').subscribe(user => expect(user).toEqual(mockUser));
    http.expectOne('/api/v1/auth/login').flush(mockUser);
    expect(service.currentUser$.value).toEqual(mockUser);
  });

  it('login() failure — currentUser$ stays null', () => {
    service.login('admin', 'wrong').subscribe({ error: () => {} });
    http.expectOne('/api/v1/auth/login').flush({ message: 'Invalid credentials' }, { status: 401, statusText: 'Unauthorized' });
    expect(service.currentUser$.value).toBeNull();
  });

  it('logout() success — clears currentUser$', () => {
    service.currentUser$.next(mockUser);
    service.logout().subscribe();
    http.expectOne('/api/v1/auth/logout').flush(null);
    expect(service.currentUser$.value).toBeNull();
  });

  it('me() success — returns UserDto', () => {
    service.me().subscribe(user => expect(user).toEqual(mockUser));
    http.expectOne('/api/v1/auth/me').flush(mockUser);
  });

  it('isAuthenticated() — true when currentUser$ has value', () => {
    service.currentUser$.next(mockUser);
    expect(service.isAuthenticated()).toBeTrue();
  });

  it('isAuthenticated() — false when currentUser$ is null', () => {
    service.currentUser$.next(null);
    expect(service.isAuthenticated()).toBeFalse();
  });
});
