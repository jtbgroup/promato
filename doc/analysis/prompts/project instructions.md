# Promato — Regeneration Prompt

Use this prompt to regenerate the full application skeleton from scratch with an AI assistant.

---

## Context Prompt

```
You are helping me build "Promato", a web-based project management application.

**Stack:**
- Backend: Java 21+, Spring Boot 3+, Spring Security (session-based auth, BCrypt 12), Spring Data JPA, Flyway, PostgreSQL 17+
- Frontend: Angular 19+, Angular Material, standalone components, lazy-loaded feature modules
- Infrastructure: Docker Compose with two separate environments:
    - docker-compose.dev.yml: development with hot reload (frontend on port 4300, backend on port 8080)
    - docker-compose.yml: production with multi-stage Dockerfile (app on port 8090)

**Application purpose:**
Promato allows teams to manage projects by:
1. Decomposing project needs into a PBS (Product Breakdown Structure) — a recursive tree of unlimited depth
2. Tracking time consumption per PBS node per user
3. Creating User Journey scenarios (steps: actor / action / system response / result), with optional project progress overlay per step
4. Generating HLR (High Level Requirements) documents as a web view and PDF export

**Users & Roles (system-level):** ADMIN, PROJECT_MANAGER, MEMBER, READER
**Project-level roles:** PROJECT_MANAGER, MEMBER, READER
**Roles are defined with their full access matrix in:** `doc/analysis/roles.md`

**Authentication:** Phase 1 = session-based DB auth. Phase 2 = OAuth2/Keycloak.
The Spring Security config MUST be structured so switching to OAuth2/Keycloak only requires
adding the resource server starter and swapping the SecurityFilterChain bean — no other changes.

**Database schema (PostgreSQL 17, managed by Flyway):**
- V001: app_user (id, username, password_hash, email, role, active, created_at, updated_at) — UC-01
- V002: project, project_member — UC-03
- V003: pbs_node (recursive self-ref tree, parent_id nullable), pbs_node_assignee — UC-04
- V004: time_entry — UC-05
- V005: user_journey, journey_step — UC-07
- V006: hlr, hlr_requirement — UC-08
- V007: default admin user (username=admin, password=Admin1234!, BCrypt 12) — UC-01

Each Flyway migration is traceable to a use case (SQL header comment: -- Use case: UC-XX).

**Documentation structure:**
- Each use case lives in its own file: `doc/analysis/use-cases/UC-XX-<slug>.md`
- Each user story lives in its own file: `doc/analysis/user-stories/US-XXX-<slug>.md`
- Roles and access matrix: `doc/analysis/roles.md`
- Data model: `doc/analysis/data-model.md`
- Each UC has a dedicated generation prompt: `doc/analysis/prompts/UC-XX-<slug>-prompt.md`

**What to generate:**
[Specify what you need — entities, repositories, services, controllers, Angular components, etc.]
```

---

## Key Decisions to Communicate

- PBS is a recursive self-referential tree (parent_id → pbs_node.id), unlimited depth
- Auth is session-based now, but Spring Security config must be structured so switching to OAuth2/Keycloak only requires adding the resource server starter and changing the SecurityFilterChain bean
- Angular uses standalone components and lazy-loaded routes (no NgModules)
- Angular services use `environment.apiUrl` (currently `/api/v1`) for all API calls
- PDF export is server-side (Spring Boot generates PDF from HLR/Journey data)
- All entities have `created_at` / `updated_at` with `@PreUpdate` hook
- Dev frontend accessible at **http://localhost:4300**
- All generated code and documentation must be in **English**
