CREATE OR REPLACE FUNCTION count_messages_between_users(user1_id INT, user2_id INT)
RETURNS INT AS $$
DECLARE
    message_count INT;
BEGIN
    SELECT COUNT(*)
    INTO message_count
    FROM MESSAGES
    WHERE (senderID = user1_id AND chatID IN (SELECT chatID FROM CHATMEMBERS WHERE userID = user2_id))
       OR (senderID = user2_id AND chatID IN (SELECT chatID FROM CHATMEMBERS WHERE userID = user1_id));
    RETURN message_count;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_recent_active_users()
RETURNS TABLE(userID INT, username VARCHAR, firstName VARCHAR, lastName VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT U.id, U.username, U.firstName, U.lastName
    FROM USERS U
    JOIN MESSAGES M ON U.id = M.senderID
    WHERE M.ts >= NOW() - INTERVAL '24 HOURS';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_conversation_history(user1_id INT, user2_id INT, limitt INT)
RETURNS TABLE(messageID INT, senderID INT, receiverID INT, context TEXT, ts TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT M.messageID, M.senderID, CASE WHEN M.senderID = user1_id THEN user2_id ELSE user1_id END AS receiverID, M.context, M.ts
    FROM MESSAGES M
    WHERE M.chatID IN (
        SELECT chatID FROM CHATMEMBERS WHERE userID = user1_id
        INTERSECT
        SELECT chatID FROM CHATMEMBERS WHERE userID = user2_id
    )
    ORDER BY M.ts DESC
    LIMIT limitt;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION search_messages(keyword TEXT)
RETURNS TABLE(messageID INT, chatID INT, senderID INT, context TEXT, ts TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT M.messageID, M.chatID, M.senderID, M.context, M.ts
    FROM MESSAGES M
    WHERE M.context ILIKE '%' || keyword || '%'
    ORDER BY M.ts DESC;
END;
$$ LANGUAGE plpgsql;

