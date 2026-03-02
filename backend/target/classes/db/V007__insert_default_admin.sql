-- V007: Default admin user (password: Admin1234!)
-- BCrypt(12) hash of 'Admin1234!'
INSERT INTO app_user (username, password_hash, email, role, active)
VALUES (
    'admin',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj6ukx/LwCOi',
    'admin@promato.local',
    'ADMIN',
    true
)
ON CONFLICT (username) DO NOTHING;
