-- Specifies the db we are using, so we don't have to input it in the cli.
USE codeup_test_db;
-- Write some SQL to drop a table named albums if it exists.
DROP TABLE IF EXISTS albums;

-- Create an albums table with the following columns:
--     id — auto-incrementing unsigned integer primary key
--     artist — string for storing the recording artist name
--     name — string for storing a record name
--     release_date — integer representing year record was released
--     sales — floating point value for number of records sold (in millions)
--     genre — string for storing the record's genre(s)
CREATE TABLE albums
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    artist       VARCHAR(50),
    name         VARCHAR(100),
    release_date INT,
    sales        FLOAT,
    genre        VARCHAR(50),
    PRIMARY KEY (id)
);
-- Open a terminal, and run the script as codeup_test_user with the following command:
--     mysql -u codeup_test_user -p < albums_migration.sql
-- if already in mysql client use: "source albums_seeder.sql" to run script
-- After running the script, connect to the MySQL server as you have done previously.
-- USE the codeup_test_db and use DESCRIBE and SHOW CREATE to verify that your albums table has been successfully created.
