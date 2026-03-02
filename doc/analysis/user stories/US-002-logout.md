# US-002 — Logout

## Metadata
| Field | Value |
|-------|-------|
| ID | US-002 |
| Use case | UC-01 |
| Actor | Any authenticated user |
| Priority | Must Have |

---

## User Story

**As a** user,  
**I want to** log out,  
**so that** my session is closed securely.

---

## Acceptance Criteria

- [ ] A logout action is accessible from the main navigation (e.g. user menu)
- [ ] Clicking logout calls `POST /api/v1/auth/logout`
- [ ] The server invalidates the session immediately
- [ ] The frontend clears all local user state after logout
- [ ] The user is redirected to `/login` after logout
- [ ] After logout, navigating back (browser back button) does not restore access to protected routes
- [ ] A new login is required to access the application again

---

## UI Notes

- Logout option in the top navigation user menu (avatar / username dropdown)
- No confirmation dialog required (logout is non-destructive)
