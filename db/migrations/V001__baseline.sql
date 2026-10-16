-- SPDX-License-Identifier: AGPL-3.0-only
-- Proposed baseline, not executed automatically; review before production use.
BEGIN;
CREATE TABLE accounts (
    id UUID PRIMARY KEY,
    handle VARCHAR(40) NOT NULL CHECK (handle ~ '^[A-Za-z0-9_-]{3,40}$'),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX accounts_handle_lower_idx ON accounts ((lower(handle)));
CREATE TABLE games (
    id UUID PRIMARY KEY,
    platform VARCHAR(16) NOT NULL CHECK (platform IN ('gb','gbc','gba')),
    title TEXT NOT NULL CHECK (length(trim(title)) > 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE game_hashes (
    sha256 CHAR(64) PRIMARY KEY CHECK (sha256 ~ '^[0-9a-f]{64}$'),
    game_id UUID NOT NULL REFERENCES games(id),
    revision_label TEXT
);
CREATE INDEX game_hashes_game_idx ON game_hashes(game_id);
CREATE TABLE achievements (
    id UUID PRIMARY KEY,
    game_id UUID NOT NULL REFERENCES games(id),
    slug VARCHAR(100) NOT NULL,
    title TEXT NOT NULL,
    points INTEGER NOT NULL CHECK (points BETWEEN 0 AND 1000),
    rules_version INTEGER NOT NULL DEFAULT 1,
    rules JSONB NOT NULL,
    status VARCHAR(12) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','review','published','retired')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(game_id, slug)
);
CREATE INDEX achievements_game_idx ON achievements(game_id);
CREATE TABLE game_sessions (
    id UUID PRIMARY KEY,
    account_id UUID NOT NULL REFERENCES accounts(id),
    game_id UUID NOT NULL REFERENCES games(id),
    mode VARCHAR(16) NOT NULL CHECK (mode IN ('casual','competitive')),
    started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    ended_at TIMESTAMPTZ,
    CHECK (ended_at IS NULL OR ended_at >= started_at)
);
CREATE INDEX game_sessions_account_idx ON game_sessions(account_id);
CREATE TABLE unlocks (
    id UUID PRIMARY KEY,
    account_id UUID NOT NULL REFERENCES accounts(id),
    achievement_id UUID NOT NULL REFERENCES achievements(id),
    session_id UUID NOT NULL REFERENCES game_sessions(id),
    mode VARCHAR(16) NOT NULL CHECK (mode IN ('casual','competitive')),
    unlocked_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(account_id, achievement_id, mode)
);
CREATE INDEX unlocks_account_time_idx ON unlocks(account_id, unlocked_at DESC);
COMMIT;
