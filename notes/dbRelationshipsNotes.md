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
MySQL allows us to JOIN tables, usually based on a foreign key relationship. The process of joining will allow us to obtain query results from more than one table in a single query. There are different types of joins, and those different types give us a lot of flexibility in the actual query results.
The syntax for joining tables is simply using JOIN to describe the table that will be joining the query, and ON to describe the relationship.

    SELECT columns
    FROM table_a as A
    JOIN table_b as B ON A.id = B.fk_id;
Notice that tables can be aliased by using table_name as alias. The records from table_a and table_b will be joined based on the relationship provided between the column id in table_a and the column fk_id in table_b.

It is also helpful to know that the first table mentioned, table_a in the above example, is referred to as the left table of the join. The joined/second table mentioned, table_b in the above example, is referred to as the right table of the join.

#### PERSON TABLE
PersonID 	LastName 	FirstName 	Age
1 	            Hansen 	    Ola 	30
2 	            Svendson 	Tove 	23
3 	            Pettersen 	Kari 	20

#### ORDER TABLE
OrderID 	OrderNumber 	PersonID
1 	            77895 	        3
2 	            44678 	        3
3 	            22456 	        2
4 	            24562 	        1

Notice that the "PersonID" column in the "Orders" table points to the "PersonID" column in the "Persons" table.

    The "PersonID" column in the "Persons" table is the PRIMARY KEY in the "Persons" table.
    The "PersonID" column in the "Orders" table is a FOREIGN KEY in the "Orders" table.

The FOREIGN KEY constraint prevents invalid data from being inserted into the foreign key column, because it has to be one of the values contained in the parent table.
The following SQL creates a FOREIGN KEY on the "PersonID" column when the "Orders" table is created:

    CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)
    ); 
<hr>

#### Example DB for JOINS
        CREATE TABLE roles (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        name VARCHAR(100) NOT NULL,
        PRIMARY KEY (id)
        );
        
        CREATE TABLE users (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        role_id INT UNSIGNED DEFAULT NULL,
        PRIMARY KEY (id),
        FOREIGN KEY (role_id) REFERENCES roles (id)
        );
        
        INSERT INTO roles (name) VALUES ('admin');
        INSERT INTO roles (name) VALUES ('author');
        INSERT INTO roles (name) VALUES ('reviewer');
        INSERT INTO roles (name) VALUES ('commenter');
        
        INSERT INTO users (name, email, role_id) VALUES
        ('bob', 'bob@example.com', 1),
        ('joe', 'joe@example.com', 2),
        ('sally', 'sally@example.com', 3),
        ('adam', 'adam@example.com', 3),
        ('jane', 'jane@example.com', null),
        ('mike', 'mike@example.com', null);
