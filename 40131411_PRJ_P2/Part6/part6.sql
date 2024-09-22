-- 1. Design and create a new table to store audit logs
CREATE TABLE AUDIT_LOG (
    logID SERIAL PRIMARY KEY,
    operation VARCHAR(10) NOT NULL,
    tableName VARCHAR(50) NOT NULL,
    userID INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    oldData JSONB,
    newData JSONB
);

-- 2. Write a trigger to log insert, update, and delete changes into the audit log table
CREATE OR REPLACE FUNCTION log_user_changes() RETURNS TRIGGER AS $$
DECLARE
    current_user_id INT;
BEGIN
    -- Retrieve the current user ID; Replace with your own method of obtaining the user ID
    current_user_id := current_setting('application.current_user', true)::INT;

    IF (TG_OP = 'INSERT') THEN
        INSERT INTO AUDIT_LOG (operation, tableName, userID, newData)
        VALUES ('INSERT', TG_TABLE_NAME, current_user_id, row_to_json(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO AUDIT_LOG (operation, tableName, userID, oldData, newData)
        VALUES ('UPDATE', TG_TABLE_NAME, current_user_id, row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO AUDIT_LOG (operation, tableName, userID, oldData)
        VALUES ('DELETE', TG_TABLE_NAME, current_user_id, row_to_json(OLD));
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger to execute the log_user_changes function after INSERT, UPDATE, DELETE on USERS table
CREATE TRIGGER trg_log_user_changes
AFTER INSERT OR UPDATE OR DELETE ON USERS
FOR EACH ROW EXECUTE FUNCTION log_user_changes();
