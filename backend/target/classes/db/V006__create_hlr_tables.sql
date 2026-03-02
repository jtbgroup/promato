-- V006: HLR (High Level Requirements)

CREATE TABLE hlr (
    id           BIGSERIAL PRIMARY KEY,
    project_id   BIGINT    NOT NULL UNIQUE REFERENCES project(id) ON DELETE CASCADE,
    purpose      TEXT,
    scope        TEXT,
    generated_at TIMESTAMP,
    updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hlr_requirement (
    id                 BIGSERIAL    PRIMARY KEY,
    hlr_id             BIGINT       NOT NULL REFERENCES hlr(id) ON DELETE CASCADE,
    req_type           VARCHAR(20)  NOT NULL CHECK (req_type IN ('FUNCTIONAL','NON_FUNCTIONAL')),
    code               VARCHAR(20)  NOT NULL,
    title              VARCHAR(200) NOT NULL,
    description        TEXT,
    source_pbs_node_id BIGINT       REFERENCES pbs_node(id) ON DELETE SET NULL,
    sort_order         INTEGER      NOT NULL DEFAULT 0,
    created_at         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (hlr_id, code)
);

CREATE INDEX idx_hlr_requirement_hlr  ON hlr_requirement(hlr_id);
CREATE INDEX idx_hlr_requirement_type ON hlr_requirement(req_type);

COMMENT ON TABLE hlr             IS 'One HLR document per project';
COMMENT ON TABLE hlr_requirement IS 'Individual requirements in an HLR';
