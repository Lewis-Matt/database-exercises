# RELATIONAL database management system (RDMS)
Using MySQL to manage relationships across multiple databases.

## Indexes (Indices)
<hr>
Indexes are used to find rows with specific column values quickly. Without an index, MySQL must begin with the first row and then read through the entire table to find the relevant rows. The larger the table, the more this costs. If the table has an index for the columns in question, MySQL can quickly determine the position to seek to in the middle of the data file without having to look at all the data. If a table has 1,000 rows, this is at least 100 times faster than reading sequentially. If you need to access most of the rows, it is faster to read sequentially, because this minimizes disk seeks.
        
    https://dev.mysql.com/doc/refman/8.0/en/mysql-indexes.html

### Primary Keys
Unique identifier for each row, much like a row number in a spreadsheet. This will give us the ability to easily reference the data in that row, and MySQL will make sure there are never duplicates.

Typically we add the PRIMARY KEY index on our id column, along with AUTO_INCREMENT.

        CREATE TABLE quotes (
        id INT NOT NULL AUTO_INCREMENT,
        author VARCHAR(50) NOT NULL,
        content VARCHAR(240) NOT NULL,
        PRIMARY KEY (id)
        );
This table will now have a column named id that will increase automatically, starting at 1. Because we set it as a primary key, the id column will never have a duplicate, and performing queries on the id will be very fast.

### Unique
UNIQUE indexes work very similar to primary keys; however, unique indexes are not limited to 1 per table. If we need to add a constraint on a column to make sure there are not duplicates, like email addresses in a user database, then the UNIQUE constraint can be added to the column.
#### ALTER
We can use the ALTER statement to update a table.

        ALTER TABLE quotes
        ADD UNIQUE (content);
### Foreign Keys
If a table has many columns, and you query different combinations of columns, it might be efficient to split the less-frequently used data into separate tables with a few columns each, and relate them back to the main table by duplicating the numeric ID column from the main table. That way, each small table can have a primary key for fast lookups of its data, and you can query just the set of columns that you need using a join operation.

    TL;DR: Use foreign keys to relate tables that will be used in joins
### Multiple-Column Indexes
MySQL can create composite indexes (that is, indexes on multiple columns). An index may consist of up to 16 columns.

    CREATE TABLE authors (
    id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (first_name, last_name)
    );
This creates a new table named authors, and the unique key constraint is on the combined values of first_name and last_name.

## Exercise
<hr>
1. USE your codeup_test_db database.
2. Add an index to make sure all album names combined with the artist are unique. Try to add duplicates to test the constraint.

    
    ALTER TABLE albums 
    ADD UNIQUE unique_album_and_artist (artist, name);
    DESCRIBE albums;
<hr>

## JOINS
<hr>

