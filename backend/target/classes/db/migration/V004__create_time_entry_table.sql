-- V004: Time entries (consumption tracking)

CREATE TABLE time_entry (
    id             BIGSERIAL     PRIMARY KEY,
    pbs_node_id    BIGINT        NOT NULL REFERENCES pbs_node(id) ON DELETE CASCADE,
    user_id        BIGINT        NOT NULL REFERENCES app_user(id) ON DELETE CASCADE,
    entry_date     DATE          NOT NULL,
    duration_hours NUMERIC(5,2)  NOT NULL CHECK (duration_hours > 0),
    comment        TEXT,
    created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_time_entry_node ON time_entry(pbs_node_id);
CREATE INDEX idx_time_entry_user ON time_entry(user_id);
CREATE INDEX idx_time_entry_date ON time_entry(entry_date);

COMMENT ON TABLE time_entry IS 'Hours logged by users against PBS nodes';
