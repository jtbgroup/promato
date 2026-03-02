# UC-01 — Login

## Metadata
| Field | Value |
|-------|-------|
| ID | UC-01 |
| Name | Login |
| Actor | Any user |
| Precondition | User account exists in database and is active |
| Postcondition | Authenticated session created, user redirected to dashboard |
| Related user stories | US-001, US-002 |

---

## Main Flow

1. User navigates to `/login`
2. User enters username and password
3. System validates credentials against `app_user` table (BCrypt 12)
4. System creates an HTTP session (HttpOnly, SameSite=Strict, timeout 30min)
5. System returns authenticated user info (`GET /api/v1/auth/me`)
6. Frontend redirects user to the originally requested route (or dashboard by default)

---

## Alternate Flows

### A1 — Invalid credentials
- Step 3 fails → system returns HTTP 401
- Frontend displays error message, no session created
- No information leaked about whether username or password is wrong

### A2 — Inactive account
- Step 3 fails → system returns HTTP 401
- Same error message as A1 (no enumeration)

### A3 — Already authenticated
- User navigates to `/login` while session is active
- Frontend redirects directly to dashboard

---

## Logout (companion flow)

1. User clicks "Logout"
2. Frontend calls `POST /api/v1/auth/logout`
3. System invalidates the session server-side
4. Frontend clears local state, redirects to `/login`

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/v1/auth/login` | Authenticate with username + password |
| POST | `/api/v1/auth/logout` | Invalidate current session |
| GET | `/api/v1/auth/me` | Return current authenticated user info |

---

## Security Notes

- Passwords hashed with **BCrypt cost factor 12**
- Session cookie: `HttpOnly=true`, `SameSite=Strict`, `Secure=false` (dev) / `Secure=true` (prod)
- Session timeout: 30 minutes
- CSRF: disabled for REST API (stateless clients handle it via SameSite cookie policy)
- Spring Security config structured to support **OAuth2/Keycloak switch in Phase 2** without rewriting the filter chain
- HTTP 401 vs HTTP 403 distinction: 401 = not authenticated, 403 = authenticated but not authorized

---

## Frontend Routes

| Route | Component | Guard |
|-------|-----------|-------|
| `/login` | `LoginComponent` | Redirect to dashboard if already authenticated |
| `/*` | Any protected component | `AuthGuard` → redirect to `/login` if not authenticated |
