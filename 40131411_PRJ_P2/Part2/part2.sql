-- Active: 1714737980320@@127.0.0.1@5432@postgres
CREATE INDEX idx_username ON USERS(username);
CREATE INDEX idx_chatid_ts ON MESSAGES(chatID, ts);

