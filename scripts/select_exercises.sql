USE codeup_test_db;
# Write queries to find the following information. Before each item, output a caption explaining the results:
# The name of all albums by Pink Floyd.
SELECT 'Pink Floyd' AS 'Albums By';
SELECT * FROM albums WHERE artist = 'Pink Floyd';

# The year Sgt. Pepper's Lonely Hearts Club Band was released
SELECT 'Sgt. Pepper''s Lonely Hearts Club Band' AS 'Release Year For';
SELECT release_date FROM albums WHERE name = 'Sgt. Pepper''s Lonely Hearts Club Band';

# The genre for Nevermind
SELECT 'Nevermind' AS 'Genre of';
SELECT genre FROM albums WHERE name = 'Nevermind';

# Which albums were released in the 1990s
SELECT '1990s' AS 'Albums released in the';
SELECT name FROM albums WHERE release_date BETWEEN 1990 AND 1999;

# Which albums had less than 20 million certified sales
SELECT '30 million sales' AS 'Albums with less than';
SELECT * FROM albums WHERE sales > 30000000;

# All the albums with a genre of "Rock". Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?
# Use 'like' instead of genre = 'rock', otherwise you will get albums that only have 'rock' as a genre (exact match).
SELECT 'Rock' AS 'Albums with the genre of';
SELECT * FROM albums WHERE genre like '%rock%';

-- if already in mysql client use: "source albums_seeder.sql" to run script
