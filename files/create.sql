CREATE TABLE USERS(
    id SERIAL PRIMARY KEY,
    username VARCHAR(25) NOT NULL UNIQUE,
    firstName VARCHAR(25) NOT NULL,
    lastName VARCHAR(25),
    phoneNumber VARCHAR(25) NOT NULL UNIQUE,
    birthDate DATE,
    dateJoined DATE DEFAULT CURRENT_DATE
);

CREATE TABLE CONTACT(
    userid INT NOT NULL,
    contactID INT NOT NULL,
    PRIMARY KEY(userid, contactID),
    FOREIGN KEY (userid) REFERENCES USERS (id),
    FOREIGN KEY (contactID) REFERENCES USERS (id)
);

CREATE TYPE chatType_t AS ENUM ('pv', 'gp');

CREATE TABLE CHAT (
    chatID SERIAL UNIQUE PRIMARY KEY,
    chatName VARCHAR(25),
    chatType chatType_t NOT NULL
);

CREATE TABLE CHATMEMBERS (
    userID INT NOT NULL,
    chatID INT NOT NULL,
    PRIMARY KEY (userID, chatID),
    FOREIGN KEY (userID) REFERENCES USERS(id),
    FOREIGN KEY (chatID) REFERENCES CHAT(chatID)
);
CREATE TABLE MESSAGES(
    messageID SERIAL PRIMARY KEY,
    chatID INT NOT NULL,
    senderID INT NOT NULL,
    context TEXT NOT NULL,
    ts TIMESTAMP NOT NULL,
    FOREIGN KEY (chatID) REFERENCES CHAT(chatID),
    FOREIGN KEY (senderID) REFERENCES USERS(id)
);

CREATE OR REPLACE FUNCTION check_chat_constraint()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM CHAT
        WHERE chatID = NEW.chatID AND chatType = 'pv'
    ) THEN
        IF (SELECT COUNT(*)
            FROM CHATMEMBERS
            WHERE chatID = NEW.chatID
        ) >= 2 THEN
            RAISE EXCEPTION 'A private chat cannot have more than 2 members';
        END IF;
    END IF;

    IF (NEW.chatId in (
            select c3.chatid from chatmembers as c3 join chat as ch2 on ch2.chatid = c3.chatid
            where ch2.chattype = 'pv' and c3.userid in 
                (select c2.userid from chatmembers c2 where c2.userId != NEW.userId and c2.chatid in 
                    (select c.chatid from chatmembers as c join chat as ch on ch.chatid = c.chatid where c.userId = NEW.userId and ch.chattype = 'pv'))
        )) THEN
            RAISE EXCEPTION 'There can only exist one private chat between 2 users';
        END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chat_constraint_trigger
BEFORE INSERT ON CHATMEMBERS
FOR EACH ROW
EXECUTE FUNCTION check_chat_constraint();
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('mcrocumbe0', 'Mariann', 'Crocumbe', '+86 543 182 8024', '1996-12-28 05:01:35');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('chaggard1', 'Corrine', 'Haggard', '+86 972 653 3154', '1994-05-14 10:59:58');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('csaintepaul2', 'Cecilius', 'Sainte Paul', '+62 718 903 6320', '1993-08-14 23:44:25');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('lworsam3', 'Leontine', 'Worsam', '+223 914 737 6339', '1997-09-20 20:46:46');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('cnightingale4', 'Calli', 'Nightingale', '+51 992 359 4658', '1999-03-18 23:25:48');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('tpessler5', 'Thaxter', 'Pessler', '+380 305 417 0644', '2003-09-07 06:13:21');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('hfairman6', 'Hilarius', 'Fairman', '+880 557 283 0644', '2001-07-20 23:09:00');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('qmadelin7', 'Quintus', 'Madelin', '+52 226 901 1204', '1991-10-30 09:12:56');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('ofranzoli8', 'Orren', 'Franzoli', '+389 914 472 7740', '2000-10-29 14:08:08');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('atixier9', 'Alaster', 'Tixier', '+234 159 984 5158', '1993-11-12 07:23:34');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('tvondrysa', 'Trevor', 'Vondrys', '+63 396 949 6921', '2002-08-22 03:23:01');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('bbettb', 'Buddy', 'Bett', '+62 909 833 9338', '2001-09-20 03:19:32');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('yhawardc', 'Yard', 'Haward', '+47 612 722 2069', '1992-08-22 00:32:23');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('gberrickd', 'Godiva', 'Berrick', '+86 714 765 6567', '2000-05-31 06:24:23');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('vguinnesse', 'Vida', 'Guinness', '+351 952 745 1559', '1991-12-06 02:32:04');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('ycalderonf', 'Yankee', 'Calderon', '+81 875 163 8939', '1993-12-09 13:55:43');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('ehartegang', 'Elwood', 'Hartegan', '+30 375 900 7601', '1994-01-11 07:58:15');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('lrentilllh', 'Ladonna', 'Rentilll', '+1 834 175 6116', '1998-08-25 12:26:37');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('lsheringtoni', 'Leelah', 'Sherington', '+33 389 889 4908', '1993-09-28 03:27:08');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('mlarventj', 'Merrill', 'Larvent', '+62 586 373 1042', '1998-12-22 20:11:31');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('haimablek', 'Hillard', 'Aimable', '+880 853 800 0702', '1995-07-06 15:19:01');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('itempletonl', 'Isa', 'Templeton', '+57 745 312 7472', '1999-01-21 23:57:03');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('bcastanagam', 'Britni', 'Castanaga', '+66 470 759 8738', '1992-10-08 14:36:41');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('mcockremn', 'Merrill', 'Cockrem', '+380 493 967 4857', '1991-09-01 21:40:17');
insert into USERS (username, firstName, lastName, phoneNumber, birthDate) values ('mstrattono', 'Madel', 'Stratton', '+386 798 752 9743', '1999-08-29 19:04:17');

insert INTO chat (chatname, chattype) VALUES ('chate jadid', 'gp');
insert INTO chat (chatname, chattype) VALUES ('my groupchat', 'gp');
insert INTO chat (chatname, chattype) VALUES ('university', 'gp');
insert INTO chat (chatname, chattype) VALUES (NULL, 'pv');
insert into chatmembers (userid, chatid) values (1,4);
insert into chatmembers (userid, chatid) values (3,4);

insert into chatmembers (userid, chatid) values (1,1);
insert into chatmembers (userid, chatid) values (3,1);
insert into chatmembers (userid, chatid) values (4,1);

insert into chatmembers (userid, chatid) values (4,2);
insert into chatmembers (userid, chatid) values (5,2);
insert into chatmembers (userid, chatid) values (6,2);

insert into contact (userid, contactid) values (1,3);
insert into contact (userid, contactid) values (1,4);
insert into contact (userid, contactid) values (1,5);
insert into contact (userid, contactid) values (1,6);

insert into contact (userid, contactid) values (8,9);
insert into contact (userid, contactid) values (8,10);
insert into contact (userid, contactid) values (8,11);
insert into contact (userid, contactid) values (8,7);
insert into messages (chatid, senderid, context, ts) values (1,16,'hello this is a message from user 16 to chat 30 as another message', '2024-06-02 12:34:56');
insert into messages (chatid, senderid, context, ts) values (1,1,'hello this is a message from user 1 to chat 1', '2024-06-02 12:34:56');
insert into messages (chatid, senderid, context, ts) values (1,3,'hello this is a message from user 3 to chat 1', '2024-06-02 12:35:56');
insert into messages (chatid, senderid, context, ts) values (2,4,'hello this is a message from user 4 to chat 1', '2024-06-02 12:36:56');
insert into messages (chatid, senderid, context, ts) values (2,4,'hello this is a message from user 4 to chat 2', '2024-06-02 12:37:56');
insert into messages (chatid, senderid, context, ts) values (2,5,'hello this is a message from user 5 to chat 2', '2024-06-02 12:38:56');
insert into messages (chatid, senderid, context, ts) values (1,4,'hello this is a message from user 4 to chat 1 as another message', '2024-06-02 12:34:56');

--Query that deletes users who are not in a group.
DELETE FROM USERS
WHERE id NOT IN (
    SELECT DISTINCT userID
    FROM CHATMEMBERS
    WHERE chatID IN (
        SELECT chatID
        FROM CHAT
        WHERE chatType = 'gp'
    )
);



--Query that checks What groups does each user (with complete information) belong to
SELECT 
    USERS.id AS userID,
    USERS.username,
    USERS.firstName,
    USERS.lastName,
    USERS.phoneNumber,
    CHAT.chatID,
    CHAT.chatName
FROM 
    USERS
JOIN 
    CHATMEMBERS ON USERS.id = CHATMEMBERS.userID
JOIN 
    CHAT ON CHATMEMBERS.chatID = CHAT.chatID
WHERE 
    CHAT.chatType = 'gp';


--Query that returns Users of a group (with complete information) in order of the number of messages sent in that group.
SELECT 
    USERS.id AS userID,
    USERS.username,
    USERS.firstName,
    USERS.lastName,
    USERS.phoneNumber,
    CHAT.chatID,
    CHAT.chatName,
    COUNT(MESSAGES.messageID) AS messageCount
FROM 
    USERS
JOIN 
    CHATMEMBERS ON USERS.id = CHATMEMBERS.userID
JOIN 
    CHAT ON CHATMEMBERS.chatID = CHAT.chatID
LEFT JOIN 
    MESSAGES ON USERS.id = MESSAGES.senderID AND CHAT.chatID = MESSAGES.chatID
WHERE 
    CHAT.chatID = 1 --Arbitrary chatID
GROUP BY 
    USERS.id, USERS.username, USERS.firstName, USERS.lastName, USERS.phoneNumber, CHAT.chatID, CHAT.chatName
ORDER BY 
    messageCount DESC;
    

--This query gives us the number of members in each group
SELECT 
    c.chatID,
    c.chatName,
    COUNT(cm.userID) AS numberOfUsers
FROM 
    CHAT c
JOIN 
    CHATMEMBERS cm ON c.chatID = cm.chatID
WHERE 
    c.chatType = 'gp'
GROUP BY 
    c.chatID, c.chatName;

--This query returns Each group (with complete information) has how many users who have private chats with each other
SELECT 
    u1.id AS user1_id, 
    u1.username AS user1_username, 
    u1.firstName AS user1_firstName, 
    u1.lastName AS user1_lastName, 
    u1.phoneNumber AS user1_phoneNumber, 
    u1.dateJoined AS user1_dateJoined,
    u2.id AS user2_id, 
    u2.username AS user2_username, 
    u2.firstName AS user2_firstName, 
    u2.lastName AS user2_lastName, 
    u2.phoneNumber AS user2_phoneNumber, 
    u2.dateJoined AS user2_dateJoined
FROM 
    USERS u1
JOIN 
    CONTACT c ON u1.id = c.userid
JOIN 
    USERS u2 ON c.contactID = u2.id
JOIN 
    CHATMEMBERS cm1 ON u1.id = cm1.userID
JOIN 
    CHATMEMBERS cm2 ON u2.id = cm2.userID AND cm1.chatID = cm2.chatID
JOIN 
    CHAT ch ON cm1.chatID = ch.chatID
WHERE 
    ch.chatType = 'pv';

--This query returns Users who have entered our messengers in one day and have sent more than one message in at least 2 groups
SELECT u.*
FROM USERS u
JOIN MESSAGES m ON u.id = m.senderID
JOIN CHAT c ON m.chatID = c.chatID
WHERE u.dateJoined = '2024-06-03' --Arbitrary date
AND c.chatType = 'gp'
GROUP BY u.id, u.username
HAVING COUNT(DISTINCT m.chatID) >= 2
AND COUNT(m.messageID) > 1;

--This query returns Users (with complete information) who share one or more groups with a specific user
SELECT DISTINCT u.*
FROM USERS u
JOIN CHATMEMBERS cm1 ON u.id = cm1.userID
JOIN CHAT c ON cm1.chatID = c.chatID
JOIN CHATMEMBERS cm2 ON c.chatID = cm2.chatID
WHERE cm2.userID = 1 --Arbitrary id
AND u.id != 1 --Arbitrary id
AND c.chatType = 'gp';
