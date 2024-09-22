CREATE USER Arousha_Azad WITH PASSWORD 'azad2000Arousha';


--Revoked all default privileges from the user to ensure no unintended access.
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM Arousha_Azad;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM Arousha_Azad;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM Arousha_Azad;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM Arousha_Azad;
REVOKE ALL PRIVILEGES ON DATABASE "myuser" FROM Arousha_Azad;


--Granted SELECT privileges on all current and future tables and views to provide read-only access.
GRANT CONNECT ON DATABASE "myuser" TO Arousha_Azad;
GRANT USAGE ON SCHEMA public TO Arousha_Azad;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO Arousha_Azad;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO Arousha_Azad;

-- Ensure that future tables and views will also have read-only access granted to the user
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO Arousha_Azad;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON SEQUENCES TO Arousha_Azad;

