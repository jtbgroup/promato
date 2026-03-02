import { ComponentFixture, TestBed } from '@angular/core/testing';
import { BehaviorSubject, of, throwError } from 'rxjs';
import { ActivatedRoute, Router } from '@angular/router';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { LoginComponent } from './login.component';
import { AuthService, UserDto } from '../../../core/auth/auth.service';

const mockUser: UserDto = { id: 1, username: 'admin', email: 'admin@promato.local', role: 'ADMIN' };

describe('LoginComponent', () => {
  let component: LoginComponent;
  let fixture: ComponentFixture<LoginComponent>;
  let authService: jasmine.SpyObj<AuthService>;
  let router: jasmine.SpyObj<Router>;

  beforeEach(async () => {
    authService = jasmine.createSpyObj('AuthService', ['login', 'isAuthenticated'], {
      currentUser$: new BehaviorSubject<UserDto | null>(null),
    });
    router = jasmine.createSpyObj('Router', ['navigate', 'navigateByUrl']);

    await TestBed.configureTestingModule({
      imports: [LoginComponent, NoopAnimationsModule],
      providers: [
        { provide: AuthService, useValue: authService },
        { provide: Router, useValue: router },
        { provide: ActivatedRoute, useValue: { snapshot: { queryParamMap: { get: () => null } } } },
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(LoginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('renders form with username and password fields', () => {
    const compiled = fixture.nativeElement as HTMLElement;
    expect(compiled.querySelector('input[formControlName="username"]')).toBeTruthy();
    expect(compiled.querySelector('input[formControlName="password"]')).toBeTruthy();
  });

  it('submit button disabled when form is invalid', () => {
    const btn = fixture.nativeElement.querySelector('button[type="submit"]') as HTMLButtonElement;
    expect(btn.disabled).toBeTrue();
  });

  it('shows error message on 401 response', () => {
    authService.login.and.returnValue(throwError(() => ({ status: 401 })));
    component.form.setValue({ username: 'admin', password: 'wrong' });
    component.submit();
    fixture.detectChanges();
    const error = fixture.nativeElement.querySelector('.error-message');
    expect(error?.textContent).toContain('Invalid username or password');
  });

  it('redirects to /dashboard on successful login (no returnUrl)', () => {
    authService.login.and.returnValue(of(mockUser));
    component.form.setValue({ username: 'admin', password: 'Admin1234!' });
    component.submit();
    expect(router.navigateByUrl).toHaveBeenCalledWith('/dashboard');
  });

  it('redirects to /dashboard if already authenticated', () => {
    authService.isAuthenticated.and.returnValue(true);
    component.ngOnInit();
    expect(router.navigate).toHaveBeenCalledWith(['/dashboard']);
  });
});
