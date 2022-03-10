USE codeup_test_db;
-- Use INSERT to add records from: https://en.wikipedia.org/wiki/List_of_best-selling_albums
-- First write your queries as separate INSERT statements for each record and test. You should see no output.
-- Refactor your script to use a single INSERT statement for all the records and test it again. Again, this should not generate any output.

-- As No data sources are configured to run this SQL script, have to recreate the album from albums_migration.sql

CREATE TABLE IF NOT EXISTS albums
(
    id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
    artist       VARCHAR(50),
    name         VARCHAR(100),
    release_date INT,
    sales        FLOAT,
    genre        VARCHAR(50),
    PRIMARY KEY (id)
);

INSERT INTO albums (artist, name, release_date, sales, genre)
VALUES ('Michael Jackson', 'Thriller', 1982, 70000000, 'pop, post-disco, funk'),
       ('AC/DC', 'Back in Black', 1980, 50000000, 'hard rock'),
       ('Whitney Houston', 'The Bodyguard', 1992, 45000000, 'R&B, soul, pop'),
       ('Meat Loaf', 'Bat Out of Hell', 1977, 44000000, 'hard rock, glam rock'),
       ('Eagles', 'Their Greatest Hits', 1976, 44000000, 'country rock, soft rock'),
       ('Pink Floyd', 'The Dark Side of the Moon', 1973, 44000000, 'progressive rock'),
       ('Eagles', 'Hotel California', 1976, 42000000, 'soft rock'),
       ('Bee Gees', 'Saturday Night Fever', 1977, 40000000, 'disco'),
       ('Fleetwood Mac', 'Rumours', 1977, 40000000, 'soft rock'),
       ('Shania Twain', 'Come On Over', 1997, 40000000, 'country, pop'),
       ('Various Artists', 'Grease Soundtrack', 1978, 38000000, 'rock and roll'),
       ('Led Zeppelin', 'Led Zeppelin IV', 1971, 37000000, 'hard rock, heavy metal'),
       ('Michael Jackson', 'Bad', 1987, 35000000, 'pop, rhythm and blues'),
       ('Alanis Morissette', 'Jagged Little Pill', 1995, 33000000, 'alternative rock'),
       ('Michael Jackson', 'Dangerous', 1991, 32000000, 'new jack swing, pop'),
       ('Celine Dion', 'Falling into You', 1996, 32000000, 'pop, soft rock'),
       ('The Beatles', 'Sgt. Pepper''s Lonely Hearts Club Band', 1967, 32000000, 'rock'),
       ('Various Artists', 'Dirty Dancing', 1987, 32000000, 'pop, rock, R&B'),
       ('Adele', '21', 2011, 31000000, 'pop, soul'),
       ('Celine Dion', 'Let''s Talk About Love', 1997, 31000000, 'pop, soft rock');

-- mysql -u codeup_test_user -p < albums_seeder.sql
-- SELECT * FROM albums;