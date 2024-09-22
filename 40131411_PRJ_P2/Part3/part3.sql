CREATE VIEW message_user AS
SELECT 
    M.messageID,
    M.chatID,
    M.senderID,
    U.username AS senderUsername,
    U.firstName AS senderFirstName,
    U.lastName AS senderLastName,
    M.context AS messageContent,
    M.ts AS timestamp
FROM 
    MESSAGES M
JOIN 
    USERS U ON M.senderID = U.id;


CREATE VIEW contacts_user AS
SELECT 
    U1.id AS userID,
    U1.username AS userUsername,
    U1.firstName AS userFirstName,
    U1.lastName AS userLastName,
    U2.id AS contactID,
    U2.username AS contactUsername,
    U2.firstName AS contactFirstName,
    U2.lastName AS contactLastName
FROM 
    CONTACT C
JOIN 
    USERS U1 ON C.userid = U1.id
JOIN 
    USERS U2 ON C.contactID = U2.id;


CREATE VIEW group_message_user AS
SELECT 
    U.id AS userID,
    U.username AS userUsername,
    U.firstName AS userFirstName,
    U.lastName AS userLastName,
    CH.chatID,
    CH.chatName,
    M.messageID,
    M.context AS messageContent,
    M.ts AS timestamp
FROM 
    USERS U
JOIN 
    CHATMEMBERS CM ON U.id = CM.userID
JOIN 
    CHAT CH ON CM.chatID = CH.chatID
LEFT JOIN 
    MESSAGES M ON U.id = M.senderID AND CH.chatID = M.chatID
WHERE 
    CH.chatType = 'gp';
