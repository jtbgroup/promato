import { TestBed } from '@angular/core/testing';
import { Router } from '@angular/router';
import { of, throwError } from 'rxjs';
import { authGuard } from './auth.guard';
import { AuthService, UserDto } from './auth.service';
import { ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';

const mockUser: UserDto = { id: 1, username: 'admin', email: 'admin@promato.local', role: 'ADMIN' };

describe('authGuard', () => {
  let authService: jasmine.SpyObj<AuthService>;
  let router: jasmine.SpyObj<Router>;

  beforeEach(() => {
    authService = jasmine.createSpyObj('AuthService', ['me']);
    router = jasmine.createSpyObj('Router', ['navigate']);

    TestBed.configureTestingModule({
      providers: [
        { provide: AuthService, useValue: authService },
        { provide: Router, useValue: router },
      ],
    });
  });

  const runGuard = (url = '/dashboard') =>
    TestBed.runInInjectionContext(() =>
      authGuard({} as ActivatedRouteSnapshot, { url } as RouterStateSnapshot)
    );

  it('authenticated user — returns true', done => {
    authService.me.and.returnValue(of(mockUser));
    (runGuard() as any).subscribe((result: boolean) => {
      expect(result).toBeTrue();
      done();
    });
  });

  it('unauthenticated (401) — redirects to /login with returnUrl', done => {
    authService.me.and.returnValue(throwError(() => ({ status: 401 })));
    (runGuard('/dashboard') as any).subscribe((result: boolean) => {
      expect(result).toBeFalse();
      expect(router.navigate).toHaveBeenCalledWith(['/login'], { queryParams: { returnUrl: '/dashboard' } });
      done();
    });
  });
});
