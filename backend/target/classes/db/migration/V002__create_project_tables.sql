-- V002: Projects and project membership

ALTER TABLE app_user ADD COLUMN IF NOT EXISTS active BOOLEAN NOT NULL DEFAULT TRUE;

CREATE TABLE project (
    id               BIGSERIAL    PRIMARY KEY,
    code             VARCHAR(20)  NOT NULL UNIQUE,
    name             VARCHAR(100) NOT NULL,
    description      TEXT,
    status           VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE'
                         CHECK (status IN ('DRAFT','ACTIVE','ARCHIVED')),
    start_date       DATE,
    planned_end_date DATE,
    budget           NUMERIC(15,2),
    created_by       BIGINT       NOT NULL REFERENCES app_user(id),
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE project_member (
    id           BIGSERIAL   PRIMARY KEY,
    project_id   BIGINT      NOT NULL REFERENCES project(id) ON DELETE CASCADE,
    user_id      BIGINT      NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    project_role VARCHAR(20) NOT NULL CHECK (project_role IN ('PROJECT_MANAGER','MEMBER','READER')),
    joined_at    TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (project_id, user_id)
);

CREATE INDEX idx_project_status      ON project(status);
CREATE INDEX idx_project_member_user ON project_member(user_id);
CREATE INDEX idx_project_member_proj ON project_member(project_id);

COMMENT ON TABLE project        IS 'Projects managed in Promato';
COMMENT ON TABLE project_member IS 'Users assigned to a project with a specific role';
