-- V003: PBS (Product Breakdown Structure) — recursive tree

CREATE TABLE pbs_node (
    id               BIGSERIAL    PRIMARY KEY,
    project_id       BIGINT       NOT NULL REFERENCES project(id) ON DELETE CASCADE,
    parent_id        BIGINT       REFERENCES pbs_node(id) ON DELETE CASCADE,
    code             VARCHAR(50)  NOT NULL,
    title            VARCHAR(200) NOT NULL,
    description      TEXT,
    node_type        VARCHAR(20)  NOT NULL DEFAULT 'TASK'
                         CHECK (node_type IN ('DELIVERABLE','TASK','MILESTONE')),
    estimated_effort NUMERIC(8,2),
    status           VARCHAR(20)  NOT NULL DEFAULT 'NOT_STARTED'
                         CHECK (status IN ('NOT_STARTED','IN_PROGRESS','DONE','BLOCKED')),
    sort_order       INTEGER      NOT NULL DEFAULT 0,
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (project_id, code)
);

CREATE TABLE pbs_node_assignee (
    pbs_node_id BIGINT NOT NULL REFERENCES pbs_node(id) ON DELETE CASCADE,
    user_id     BIGINT NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    PRIMARY KEY (pbs_node_id, user_id)
);

CREATE INDEX idx_pbs_node_project ON pbs_node(project_id);
CREATE INDEX idx_pbs_node_parent  ON pbs_node(parent_id);
CREATE INDEX idx_pbs_assignee_user ON pbs_node_assignee(user_id);

COMMENT ON TABLE pbs_node          IS 'Recursive PBS tree nodes — parent_id NULL means root';
COMMENT ON TABLE pbs_node_assignee IS 'Users assigned to a PBS node';
