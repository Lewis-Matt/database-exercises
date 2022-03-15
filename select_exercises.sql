USE codeup_test_db;
# Write queries to find the following information. Before each item, output a caption explaining the results:
# The name of all albums by Pink Floyd.
SELECT '' AS 'Pink Floyd Albums';
SELECT * FROM albums WHERE artist = 'Pink Floyd';

# The year Sgt. Pepper's Lonely Hearts Club Band was released
SELECT '' AS 'Release year for Sgt. Pepper''s Lonely Hearts Club Band';
SELECT release_date FROM albums WHERE name = 'Sgt. Pepper''s Lonely Hearts Club Band';

# The genre for Nevermind
SELECT '' AS 'Genre of Nevermind';
SELECT genre FROM albums WHERE name = 'Nevermind';

# Which albums were released in the 1990s
SELECT '' AS 'Albums released in the 1990s';
SELECT name FROM albums WHERE release_date BETWEEN 1990 AND 1999;

# Which albums had less than 20 million certified sales
SELECT '' AS 'Albums with less than 30 million sales';
SELECT * FROM albums WHERE sales > 30000000;

# All the albums with a genre of "Rock". Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?
# Use 'like' instead of genre = 'rock', otherwise you will get albums that only have 'rock' as a genre (exact match).
SELECT '' AS 'Rock albums';
SELECT * FROM albums WHERE genre like '%rock%';

-- if already in mysql client use: "source albums_seeder.sql" to run script
