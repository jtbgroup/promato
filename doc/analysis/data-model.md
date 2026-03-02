# Promato — Data Model

## Entity Relationship Overview

```
app_user ──< project_member >── project
                                    │
                                pbs_node (self-referential tree)
                                    │
                              time_entry >── app_user
                                    
project ──< user_journey
                │
         journey_step >── pbs_node (optional)

project ──< hlr
                │
         hlr_requirement (functional + non-functional)
```

---

## Tables

### app_user (existing V001)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| username | VARCHAR(50) UNIQUE | login |
| password_hash | VARCHAR(255) | BCrypt(12) |
| email | VARCHAR(100) UNIQUE | |
| role | VARCHAR(20) | system role: ADMIN, PROJECT_MANAGER, MEMBER, READER |
| active | BOOLEAN | default true |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### project (V002)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| code | VARCHAR(20) UNIQUE | short code e.g. PROJ-01 |
| name | VARCHAR(100) | |
| description | TEXT | |
| status | VARCHAR(20) | ACTIVE, ARCHIVED, DRAFT |
| start_date | DATE | |
| planned_end_date | DATE | |
| budget | NUMERIC(15,2) | optional |
| created_by | BIGINT FK app_user | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### project_member (V002)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| project_id | BIGINT FK project | |
| user_id | BIGINT FK app_user | |
| project_role | VARCHAR(20) | PROJECT_MANAGER, MEMBER, READER |
| joined_at | TIMESTAMP | |
| UNIQUE(project_id, user_id) | | |

### pbs_node (V003)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| project_id | BIGINT FK project | |
| parent_id | BIGINT FK pbs_node NULL | NULL = root node |
| code | VARCHAR(50) | e.g. "1.2.3" |
| title | VARCHAR(200) | |
| description | TEXT | |
| node_type | VARCHAR(20) | DELIVERABLE, TASK, MILESTONE |
| estimated_effort | NUMERIC(8,2) | in hours |
| status | VARCHAR(20) | NOT_STARTED, IN_PROGRESS, DONE, BLOCKED |
| sort_order | INTEGER | for ordering siblings |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### pbs_node_assignee (V003)
| Column | Type | Notes |
|--------|------|-------|
| pbs_node_id | BIGINT FK pbs_node | |
| user_id | BIGINT FK app_user | |
| PRIMARY KEY(pbs_node_id, user_id) | | |

### time_entry (V004)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| pbs_node_id | BIGINT FK pbs_node | |
| user_id | BIGINT FK app_user | |
| entry_date | DATE | |
| duration_hours | NUMERIC(5,2) | |
| comment | TEXT | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### user_journey (V005)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| project_id | BIGINT FK project | |
| title | VARCHAR(200) | |
| description | TEXT | |
| show_progress | BOOLEAN | default false |
| created_by | BIGINT FK app_user | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### journey_step (V005)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| journey_id | BIGINT FK user_journey | |
| step_number | INTEGER | ordering |
| actor | VARCHAR(100) | who performs the action |
| action | TEXT | what the actor does |
| system_response | TEXT | how the system reacts |
| expected_result | TEXT | |
| pbs_node_id | BIGINT FK pbs_node NULL | optional link for progress |
| created_at | TIMESTAMP | |

### hlr (V006)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| project_id | BIGINT FK project UNIQUE | one HLR per project |
| purpose | TEXT | |
| scope | TEXT | |
| generated_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### hlr_requirement (V006)
| Column | Type | Notes |
|--------|------|-------|
| id | BIGSERIAL PK | |
| hlr_id | BIGINT FK hlr | |
| req_type | VARCHAR(20) | FUNCTIONAL, NON_FUNCTIONAL |
| code | VARCHAR(20) | e.g. FR-001 |
| title | VARCHAR(200) | |
| description | TEXT | |
| source_pbs_node_id | BIGINT FK pbs_node NULL | traceability |
| sort_order | INTEGER | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |
