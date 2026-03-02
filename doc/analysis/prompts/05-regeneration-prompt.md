# Promato — Regeneration Prompt

Use this prompt to regenerate the full application skeleton from scratch with an AI assistant.

---

## Context Prompt

```
You are helping me build "Promato", a web-based project management application.

**Stack:**
- Backend: Java 21, Spring Boot 3, Spring Security (session-based auth, BCrypt), Spring Data JPA, Flyway, PostgreSQL 17
- Frontend: Angular 19, Angular Material, standalone components, lazy-loaded feature modules
- Infrastructure: Docker Compose (dev + prod environments), Nginx reverse proxy, multi-stage Dockerfile

**Application purpose:**
Promato allows teams to manage projects by:
1. Decomposing project needs into a PBS (Product Breakdown Structure) — a recursive tree of unlimited depth
2. Tracking time consumption per PBS node per user
3. Creating User Journey scenarios (steps: actor / action / system response / result), with optional project progress overlay per step
4. Generating HLR (High Level Requirements) documents as a web view and PDF export

**Users & Roles (system-level):** ADMIN, PROJECT_MANAGER, MEMBER, READER
**Project-level roles:** PROJECT_MANAGER, MEMBER, READER

**Authentication:** Phase 1 = session-based DB auth. Phase 2 = OAuth2/Keycloak (security layer must be designed to accommodate this).

**Database schema (PostgreSQL, managed by Flyway):**
- V001: app_user (id, username, password_hash, email, role, active, created_at, updated_at)
- V002: project (id, code UNIQUE, name, description, status CHECK DRAFT/ACTIVE/ARCHIVED, start_date, planned_end_date, budget, created_by FK, timestamps), project_member (id, project_id FK, user_id FK, project_role CHECK PM/MEMBER/READER, joined_at, UNIQUE project+user)
- V003: pbs_node (id, project_id FK, parent_id FK self-ref nullable, code, title, description, node_type CHECK DELIVERABLE/TASK/MILESTONE, estimated_effort, status CHECK NOT_STARTED/IN_PROGRESS/DONE/BLOCKED, sort_order, timestamps), pbs_node_assignee (pbs_node_id, user_id, PK composite)
- V004: time_entry (id, pbs_node_id FK, user_id FK, entry_date, duration_hours CHECK >0, comment, timestamps)
- V005: user_journey (id, project_id FK, title, description, show_progress boolean, created_by FK, timestamps), journey_step (id, journey_id FK, step_number, actor, action, system_response, expected_result, pbs_node_id FK nullable, created_at, UNIQUE journey+step_number)
- V006: hlr (id, project_id FK UNIQUE, purpose, scope, generated_at, updated_at), hlr_requirement (id, hlr_id FK, req_type CHECK FUNCTIONAL/NON_FUNCTIONAL, code, title, description, source_pbs_node_id FK nullable, sort_order, timestamps)
- V007: default admin user (username=admin, password=Admin1234!)

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
