# Dev Prompt — UC-01 Login (Ready to use)

Copy and paste the block below into your AI assistant to generate the full implementation of UC-01.

---

```
You are implementing UC-01 (Login / Logout / Current User) for "Promato", a web-based project management tool.

Generate the complete, functional, production-ready code for both backend and frontend simultaneously.
Include unit tests for all components.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
STACK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Backend  : Java 21, Spring Boot 3, Spring Security, Spring Data JPA, PostgreSQL 17
- Frontend : Angular 19, Angular Material, standalone components, no NgModules
- Auth     : Session-based (HttpOnly cookie, SameSite=Strict, timeout 30min)
- Passwords: BCrypt cost factor 12
- Base API : /api/v1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DATABASE SCHEMA (already exists via Flyway — do NOT regenerate)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- V001: app_user
CREATE TABLE app_user (
    id            BIGSERIAL    PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    role          VARCHAR(20)  NOT NULL DEFAULT 'ADMIN',
    active        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- V007: default admin (password = Admin1234!, BCrypt 12)
INSERT INTO app_user (username, password_hash, email, role, active)
VALUES ('admin', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj6ukx/LwCOi', 'admin@promato.local', 'ADMIN', true)
ON CONFLICT (username) DO NOTHING;

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BACKEND — FILES TO GENERATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Package root: com.promato

1. security/SecurityConfig.java
   - SecurityFilterChain bean, session-based (SessionCreationPolicy.IF_REQUIRED)
   - BCryptPasswordEncoder bean (strength = 12)
   - Permit: POST /api/v1/auth/login, GET /actuator/health
   - All other /api/** require authentication
   - On unauthenticated access: return HTTP 401 JSON (custom AuthenticationEntryPoint), NOT a redirect
   - CSRF disabled (REST API — SameSite cookie handles it)
   - IMPORTANT: Add a clearly marked comment block showing exactly where to plug in
     OAuth2 resource server config in Phase 2 (Keycloak), so the switch only requires
     adding the starter dependency and replacing the SecurityFilterChain bean

2. security/AppUserDetailsService.java
   - Implements UserDetailsService
   - Loads user by username from app_user table via AppUserRepository
   - Throws UsernameNotFoundException if user not found
   - Throws DisabledException if active = false
   - Maps role column to GrantedAuthority (prefix: ROLE_)

3. auth/AuthController.java
   - POST /api/v1/auth/login
     * Accepts LoginRequest { username, password }
     * Authenticates via AuthenticationManager
     * On success: stores Authentication in SecurityContext + session, returns UserDto (HTTP 200)
     * On failure: returns HTTP 401 { "message": "Invalid credentials" }
       — same message for wrong password AND inactive account (no enumeration)
   - POST /api/v1/auth/logout
     * Invalidates HttpSession via SecurityContextLogoutHandler
     * Returns HTTP 200
   - GET /api/v1/auth/me
     * Returns UserDto for current authenticated user
     * Returns HTTP 401 if not authenticated

4. auth/LoginRequest.java      — record { String username, String password }
5. auth/UserDto.java           — record { Long id, String username, String email, String role }
6. user/AppUser.java           — JPA @Entity mapping app_user table
7. user/AppUserRepository.java — JpaRepository, findByUsername(String username)

BACKEND UNIT TESTS TO GENERATE:

8. security/AppUserDetailsServiceTest.java
   - loadUserByUsername: user found and active → returns UserDetails
   - loadUserByUsername: user not found → throws UsernameNotFoundException
   - loadUserByUsername: user found but inactive → throws DisabledException

9. auth/AuthControllerTest.java (use @WebMvcTest + MockMvc)
   - POST /api/v1/auth/login with valid credentials → HTTP 200 + UserDto body
   - POST /api/v1/auth/login with invalid credentials → HTTP 401 + error message
   - POST /api/v1/auth/logout → HTTP 200, session invalidated
   - GET /api/v1/auth/me authenticated → HTTP 200 + UserDto
   - GET /api/v1/auth/me unauthenticated → HTTP 401

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FRONTEND — FILES TO GENERATE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. core/auth/auth.service.ts
   - login(username: string, password: string): Observable<UserDto>
     → POST /api/v1/auth/login, { withCredentials: true }
   - logout(): Observable<void>
     → POST /api/v1/auth/logout, { withCredentials: true }
   - me(): Observable<UserDto>
     → GET /api/v1/auth/me, { withCredentials: true }
   - currentUser$: BehaviorSubject<UserDto | null>
   - isAuthenticated(): boolean

2. core/auth/auth.guard.ts
   - Functional guard (CanActivateFn)
   - Calls AuthService.me() to verify session server-side on each protected route activation
   - On success: sets currentUser$, returns true
   - On HTTP 401: redirects to /login with queryParam returnUrl=<attempted route>

3. core/auth/auth.interceptor.ts
   - Adds { withCredentials: true } to every outgoing HTTP request
   - On HTTP 401 response: clears currentUser$, redirects to /login

4. features/auth/login/login.component.ts + .html + .scss
   - Standalone component, route: /login
   - Angular Material layout: centered card with mat-form-field for username and password
   - Password field: show/hide toggle (mat-icon-button + matSuffix + eye icon)
   - Reactive form with Validators.required on both fields
   - Submit button: disabled while form is invalid or request is pending
   - On success: navigate to returnUrl (from queryParam) or /dashboard
   - On HTTP 401: display inline error "Invalid username or password" below the form
   - If already authenticated (currentUser$ has value): redirect to /dashboard immediately

5. app.routes.ts
   - { path: 'login', component: LoginComponent }
   - { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
   - { path: 'dashboard', component: DashboardComponent, canActivate: [authGuard] }
   - { path: '**', redirectTo: 'login' }

6. shared/layout/navbar/navbar.component.ts + .html
   - Standalone top navigation bar
   - Shows current username (from AuthService.currentUser$)
   - User dropdown menu with "Logout" option
   - On logout: calls AuthService.logout(), navigates to /login

FRONTEND UNIT TESTS TO GENERATE:

7. core/auth/auth.service.spec.ts
   - login(): success → updates currentUser$, returns UserDto
   - login(): failure → throws error, currentUser$ stays null
   - logout(): success → clears currentUser$
   - me(): success → returns UserDto
   - isAuthenticated(): true when currentUser$ has value, false otherwise

8. core/auth/auth.guard.spec.ts
   - authenticated user → returns true
   - unauthenticated (401) → redirects to /login with returnUrl

9. features/auth/login/login.component.spec.ts
   - renders form with username and password fields
   - submit button disabled when form is invalid
   - shows error message on 401 response
   - redirects to returnUrl on successful login
   - redirects to /dashboard if already authenticated

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EXPECTED FILE STRUCTURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

backend/src/main/java/com/promato/
  security/
    SecurityConfig.java
    AppUserDetailsService.java
  auth/
    AuthController.java
    LoginRequest.java
    UserDto.java
  user/
    AppUser.java
    AppUserRepository.java

backend/src/test/java/com/promato/
  security/
    AppUserDetailsServiceTest.java
  auth/
    AuthControllerTest.java

frontend/src/app/
  core/
    auth/
      auth.service.ts
      auth.service.spec.ts
      auth.guard.ts
      auth.guard.spec.ts
      auth.interceptor.ts
  features/
    auth/
      login/
        login.component.ts
        login.component.html
        login.component.scss
        login.component.spec.ts
  shared/
    layout/
      navbar/
        navbar.component.ts
        navbar.component.html
  app.routes.ts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONSTRAINTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- All code and comments in English
- No @NgModule anywhere — Angular standalone only
- environment.apiUrl = '/api/v1' — use it in AuthService instead of hardcoding the URL
- Spring Security Phase 2 hook must be a clearly visible comment block in SecurityConfig
- Do NOT use HttpSession directly in controllers — use Spring Security's SecurityContextHolder
  and SecurityContextLogoutHandler
- UserDto must never expose password_hash
- Error responses must be consistent JSON: { "message": "..." }

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
VERIFICATION COMMANDS (run after generation)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Backend — run tests
cd backend && mvn test

# Backend — start dev server (requires Docker DB running)
cd backend && mvn spring-boot:run

# Frontend — install and start
cd frontend && npm install --force && npm start

# Frontend — run tests
cd frontend && npm test
```
