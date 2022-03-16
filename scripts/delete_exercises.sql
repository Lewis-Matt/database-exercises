USE codeup_test_db;

#  Albums released after 1991
SELECT '1991' AS 'Albums after';
DELETE FROM albums WHERE release_date > 1991;

# Albums with the genre 'disco'
SELECT 'disco' AS 'Genre';
DELETE FROM albums WHERE genre = 'disco';

# Albums by 'Whitney Houston'
SELECT 'Whitney Houston' AS 'Albums by';
DELETE FROM albums WHERE artist = 'Whitney Houston';

SELECT * FROM albums;
