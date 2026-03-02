# Promato — Functional Analysis

## 1. Application Overview

**Promato** is a web-based project management tool designed to:
- Decompose project needs into a **PBS (Product Breakdown Structure)** with a recursive tree
- Track **time consumption** spent on project tasks
- Generate **User Journeys** with or without project progress overlay
- Generate **HLR (High Level Requirements)** documents (web view + PDF export)

**Stack:** Angular 19 / Spring Boot 3 / PostgreSQL 17 / Docker

---

## 2. Users & Roles

| Role | Description | Permissions |
|------|-------------|-------------|
| `ADMIN` | System administrator | Full access, user management |
| `PROJECT_MANAGER` | Project owner/manager | Create/edit projects, manage members, view all data |
| `MEMBER` | Team contributor | Log time, update task progress |
| `READER` | Read-only stakeholder | View projects, PBS, reports |

Authentication is **session-based with DB credentials** (Phase 1).  
OAuth2 / Keycloak integration is planned for Phase 2 — the security layer must be designed to accommodate it.

---

## 3. Functional Domains

### 3.1 Authentication & User Management
- Login / Logout
- User profile management
- User CRUD (ADMIN only)
- Role assignment
- Password change

### 3.2 Project Management
- Create / Edit / Archive projects
- Define project metadata: name, code, description, start date, planned end date, budget
- Assign users to projects with roles
- Project dashboard: summary of PBS, time logged, budget consumed

### 3.3 PBS — Product Breakdown Structure
- Recursive tree structure (unlimited depth)
- Each node: code, title, description, type (deliverable/task/milestone), estimated effort (days), status, assigned members
- CRUD on nodes with drag-and-drop reordering
- Inherit/override status from children
- Visual tree view + flat list view

### 3.4 Time Tracking (Consumption)
- Log time entries: user, PBS node, date, duration (hours), comment
- Weekly timesheet view
- Summary by node / by user / by period
- Planned vs actual effort per node
- EVM and cost tracking: deferred to future phase

### 3.5 User Journey
- Create user journey scenarios linked to a project
- Steps: actor, action, system response, result
- Optional: overlay project progress (% complete per step)
- Export to PDF

### 3.6 HLR — High Level Requirements
- Auto-generated from PBS and User Journey data
- Sections: Purpose, Scope, Stakeholders, Functional Requirements (from PBS nodes), Non-Functional Requirements (manual)
- Web view with editing capability
- PDF export

---

## 4. Non-Functional Requirements

- **Security:** Spring Security, BCrypt password hashing, CSRF protection, session timeout
- **Keycloak-ready:** Security config must be easily switchable to OAuth2 resource server
- **Responsive:** Angular Material UI, mobile-friendly layout
- **Performance:** Lazy loading of Angular modules, paginated API responses
- **Audit:** created_at / updated_at on all entities
