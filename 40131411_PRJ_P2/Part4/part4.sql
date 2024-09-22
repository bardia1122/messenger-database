ALTER TABLE USERS
ADD CONSTRAINT unique_phone_number UNIQUE (phoneNumber);


ALTER TABLE CHAT
ADD COLUMN ownerID INT,
ADD CONSTRAINT fk_owner FOREIGN KEY (ownerID) REFERENCES USERS(id);


-- Step 2.1: Create the function that checks the number of owners per group
CREATE OR REPLACE FUNCTION check_single_owner() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM CHAT WHERE chatID = NEW.chatID AND ownerID IS NOT NULL) > 0 THEN
        RAISE EXCEPTION 'A group can only have one owner';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 2.2: Create the trigger that calls the function before insert or update
CREATE TRIGGER trg_single_owner
BEFORE INSERT OR UPDATE ON CHAT
FOR EACH ROW
EXECUTE FUNCTION check_single_owner();
