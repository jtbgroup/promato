# Prompt — UC-01 Login (Backend + Frontend)

Use this prompt to generate all code related to UC-01 (Login / Logout / Current user).

---

## Context

```
You are helping me build "Promato", a web-based project management tool.

Stack:
- Backend: Java 21, Spring Boot 3, Spring Security (session-based, BCrypt 12), Spring Data JPA, PostgreSQL 17
- Frontend: Angular 19, Angular Material, standalone components, lazy-loaded routes
- Auth: Session-based (Phase 1). The Spring Security config MUST be structured so switching to OAuth2/Keycloak in Phase 2 only requires adding the resource server starter and swapping the SecurityFilterChain bean — no other changes.

Database (already exists via Flyway V001 + V007):
- Table: app_user (id, username, password_hash, email, role VARCHAR, active BOOLEAN, created_at, updated_at)
- Default user: admin / Admin1234! (BCrypt 12)

Session config (from application.properties):
- Timeout: 30 minutes
- Cookie: HttpOnly=true, SameSite=Strict, Secure=false (dev)
```

---

## Backend — What to generate

### 1. Security configuration
- `SecurityConfig.java` — `SecurityFilterChain` bean
  - Session-based auth (`SessionCreationPolicy.IF_REQUIRED`)
  - BCrypt `PasswordEncoder` bean (strength = 12)
  - Permit `/api/v1/auth/login`, `/actuator/health` without auth
  - All other `/api/**` routes require authentication
  - Return HTTP 401 (not redirect) on unauthenticated access → custom `AuthenticationEntryPoint`
  - CSRF disabled (REST API, SameSite cookie policy handles it)
  - Comment clearly where to add OAuth2 resource server config in Phase 2

### 2. UserDetailsService
- `AppUserDetailsService.java` implementing `UserDetailsService`
  - Load user by username from `app_user` table
  - Check `active = true`, throw `DisabledException` if inactive
  - Map `role` column to `GrantedAuthority`

### 3. Auth endpoints — `AuthController.java`
- `POST /api/v1/auth/login`
  - Accept `{ username, password }` JSON body
  - Authenticate via `AuthenticationManager`
  - On success: return `UserDto` (id, username, email, role) with HTTP 200
  - On failure: return HTTP 401 with `{ message: "Invalid credentials" }` — same message for bad password AND inactive account
- `POST /api/v1/auth/logout`
  - Invalidate `HttpSession`
  - Return HTTP 200
- `GET /api/v1/auth/me`
  - Return current authenticated user as `UserDto`
  - Return HTTP 401 if not authenticated

### 4. DTOs
- `LoginRequest.java` — `{ username, password }`
- `UserDto.java` — `{ id, username, email, role }`

### 5. Entity
- `AppUser.java` — JPA entity mapping `app_user` table (no `@Column(name)` needed if field names match)

---

## Frontend — What to generate

### 1. AuthService (`auth.service.ts`)
- `login(username, password): Observable<UserDto>` → POST `/api/v1/auth/login`
- `logout(): Observable<void>` → POST `/api/v1/auth/logout`
- `me(): Observable<UserDto>` → GET `/api/v1/auth/me`
- `currentUser$: BehaviorSubject<UserDto | null>` — shared state across app
- `isAuthenticated(): boolean`

### 2. AuthGuard (`auth.guard.ts`)
- Functional guard (`CanActivateFn`)
- Calls `AuthService.me()` to verify session server-side
- Redirects to `/login` if not authenticated
- Preserves the attempted URL for post-login redirect (`returnUrl`)

### 3. LoginComponent (`login/login.component.ts`)
- Standalone component, route: `/login`
- Angular Material form: `mat-form-field` for username and password
- Password field: show/hide toggle (`mat-icon-button` + `matSuffix`)
- Submit button disabled while form invalid or request pending
- On success: redirect to `returnUrl` or `/dashboard`
- On error: display inline error message below the form
- If already authenticated: redirect to `/dashboard` immediately

### 4. AppRoutes (`app.routes.ts`)
- `/login` → `LoginComponent` (no guard)
- `/` → redirect to `/dashboard`
- All other routes → protected with `AuthGuard`

### 5. HTTP interceptor (`auth.interceptor.ts`)
- `withCredentials: true` on all requests (sends session cookie)
- On HTTP 401 response: redirect to `/login`, clear `currentUser$`

### 6. Logout button
- In the main navigation component (top bar)
- User avatar/name dropdown with "Logout" option
- Calls `AuthService.logout()`, then navigates to `/login`

---

## File structure expected

```
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

frontend/src/app/
  core/
    auth/
      auth.service.ts
      auth.guard.ts
      auth.interceptor.ts
  features/
    auth/
      login/
        login.component.ts
        login.component.html
        login.component.scss
  app.routes.ts
```

---

## Constraints

- All classes in English
- No `@NgModule` — use Angular standalone components only
- `AuthService` uses `HttpClient` with `{ withCredentials: true }`
- Spring Security config must have a comment block: `// Phase 2: replace this bean with OAuth2ResourceServerConfigurer`
- Do not use `HttpSession` directly in controllers — use Spring Security's `SecurityContextHolder`
