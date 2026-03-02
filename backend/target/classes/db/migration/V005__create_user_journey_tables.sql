-- V005: User Journeys and steps

CREATE TABLE user_journey (
    id            BIGSERIAL    PRIMARY KEY,
    project_id    BIGINT       NOT NULL REFERENCES project(id) ON DELETE CASCADE,
    title         VARCHAR(200) NOT NULL,
    description   TEXT,
    show_progress BOOLEAN      NOT NULL DEFAULT FALSE,
    created_by    BIGINT       NOT NULL REFERENCES app_user(id),
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE journey_step (
    id              BIGSERIAL PRIMARY KEY,
    journey_id      BIGINT    NOT NULL REFERENCES user_journey(id) ON DELETE CASCADE,
    step_number     INTEGER   NOT NULL,
    actor           VARCHAR(100) NOT NULL,
    action          TEXT      NOT NULL,
    system_response TEXT,
    expected_result TEXT,
    pbs_node_id     BIGINT    REFERENCES pbs_node(id) ON DELETE SET NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (journey_id, step_number)
);

CREATE INDEX idx_user_journey_project ON user_journey(project_id);
CREATE INDEX idx_journey_step_journey ON journey_step(journey_id);

COMMENT ON TABLE user_journey IS 'User journey scenarios linked to a project';
COMMENT ON TABLE journey_step IS 'Individual steps in a user journey';
