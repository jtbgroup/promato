# US-001 — Login

## Metadata
| Field | Value |
|-------|-------|
| ID | US-001 |
| Use case | UC-01 |
| Actor | Any user |
| Priority | Must Have |

---

## User Story

**As a** user,  
**I want to** log in with my username and password,  
**so that** I can access the application.

---

## Acceptance Criteria

- [ ] A `/login` page is accessible without authentication
- [ ] The form contains a username field and a password field
- [ ] Submitting valid credentials creates a session and redirects to the dashboard
- [ ] Submitting invalid credentials displays an error message without revealing which field is wrong
- [ ] The login form is disabled / shows a loading state while the request is in progress
- [ ] After login, the user is redirected to the originally requested URL (if any)
- [ ] The session cookie is HttpOnly and SameSite=Strict
- [ ] An inactive account receives the same error as invalid credentials

---

## UI Notes

- Angular Material form with `mat-form-field`, `mat-error`
- Password field has a show/hide toggle
- "Login" button disabled while form is invalid or request is pending
- Error message displayed inline below the form (not a modal)
