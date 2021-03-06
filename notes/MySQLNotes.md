# MySQL Notes
<hr>
MySQL is a Relational Database Management System, or RDBMS. This means it stores data in tables and creates relationships between the data in the different tables. This is much like having multiple spreadsheets and having the data from one sheet use data from another. We use the Structured Query Language (SQL) to interact with MySQL. SQL is made up of statements and commands sent to the server individually, with results sent back to the client.

MySQL's commands are divided into several different categories:

       - Data Definition Language (DDL) refers to the CREATE, ALTER and DROP statements.
       - Data Manipulation Language (DML) refers to the INSERT, UPDATE and DELETE statements
       - Data Query Language (DQL) refers to the SELECT, SHOW and HELP statements (queries)
       - Data Control Language (DCL) refers to the GRANT and REVOKE statements
       - Data Transaction Language (DTL) refers to the START TRANSACTION, SAVEPOINT, COMMIT and ROLLBACK [TO SAVEPOINT] statements

<hr>
NOTE ON COMMENTS: MySQL supports:

    --
    /* */
    #
<hr>

## Starting Server
<hr>
In a production setup the database will be setup to run automatically, but for out purposes we'll need to start and stop MySQL ourselves.
Whenever you see an error that references communicating with the database, one of the first things you should do is make sure the MySQL server is running.
    
    mysql.server status
    mysql.server start
    mysql.server stop

MySQL stores information in a series of files, but we will virtually never look at or manipulate those files directly. Instead, we need some sort of interface for interacting with the data they contain.

There are actually two parts to MySQL we will be using. There is the underlying <strong>MySQL server</strong> that understands Structured Query Language (SQL) commands, stores and organizes the data on disk, and users that can connect and manipulate the data. 
    
To interact with the server, there is the <strong>MySQL client</strong> that connects to the server for us, sends our commands to the server, and displays the data on screen.

To connect to the sever, via the client:

    mysql -u USERNAME -p
    (currently setup as root (username) and codeup (password)


## Displaying Information
<hr>
Most of our output from MySQL will be formatted in a table. SQL commands are terminated with a ;. However, we can actually use a different combination of characters as a terminator: \G will display the rows individually.

    pager less -~SFX
This will tell MySQL to use a pager for output. Specifically, we will specify the pager program named less. A pager is a terminal program designed to handle multiple pages of output. You can use the arrow keys to move around the display, and the space bar to jump to the next page of results. In addition, you can use the following keys to navigate in less:

    d: go down a half page
    u: go up a half page
    j: scroll down one line
    k: scroll up one line
    /: search for a term

Regardless of how you navigate, press q to exit the pager. Remove the pager via:

    nopager;

## Managing Users
<hr>
MySQL server is a multi-user system. If we are already in the MySQL client, and want to determine the user we are currently connected as, we can run the command: 

    SELECT current_user;
All MySQL users are defined as a combination of their name and where they are connecting from. In this case, we are the root user and we are connecting from localhost (i.e. the same machine the server is running on).

The MySQL server stores the information for users and privileges in a table called user within the mysql database.

    SELECT user, host FROM mysql.user;
This table presents us with the usernames defined in our MySQL server and what hosts they are allowed to connect from.

### Creating a User
To create a new MySQL user we use the command CREATE USER. We must then specify a new username and hostname for that user to connect from. A username & hostname combination is defined like 'username'@'hostname'. Notice the single quotes (') around the username and hostname and the @ between them. Lastly, we specify the password by adding IDENTIFIED BY 'password' afterwards. If you omit IDENTIFIED BY from the CREATE USER command, people will be able to connect as a user without specifying a password, which would be a serious security hazard.

    CREATE USER 'sally'@'192.168.77.1' IDENTIFIED BY 'passwordForSally321';

#### Host Wildcards
Sometimes we want to create a user for multiple clients in different locations. To do that we can use the wildcard % in the host specification. For example, let's say we have an office where all the computers have IP addresses that start with 192.168.77. If we wanted to quickly and easily create a user those computers could all share (called office_user) we could use 'office_user'@'192.168.77.%', thus allowing any client in the IP range of 192.168.77.1 to 192.168.77.255 to connect. We could go one step further and use 'office_user'@'%', which would allow people to connect as that user from anywhere on the internet (assuming they know the user's password).

In general though, it is a good idea to make the user specifications as restrictive as possible, in order to limit the chances of a malicious person from gaining access to our databases.

** By default, the MySQL server is configured to disallow connections coming from outside of the server itself, meaning even if a user's host is set to %, it can still only connect from localhost. **

To create a user that can connect from multiple hosts, you will need separate CREATE USER commands. For each host you wish to allow access from, create a user with the same username, but a different hostname.

In addition, you will need to grant privileges separately to each user/host combination you create.

### User Privileges
https://dev.mysql.com/doc/refman/8.0/en/privileges-provided.html#idm139711220094800

    GRANT ALL ON *.* TO 'billy'@'localhost';

The first part of the command (GRANT ALL) specifies which permissions we want to give to a user. If we need to be more fine-grained, we can list individual privileges to allow the user. A common example might be creating a read_only user in our production database server. This would be an account other developers could use to look up and analyze data, without the risk of accidentally changing anything. To grant our read_only user these privileges, we need to do:
    
    GRANT SELECT ON *.* TO 'read_only'@'localhost';

The second portion (ON *.*) is how we control what databases and tables the privileges applies to. It is in the format of database_name.table_name, where * is a wildcard for each. Our prior examples granted privileges for all databases and all tables. Instead, if wanted our user sally to only be able to SELECT, INSERT, UPDATE, and DELETE from a single table called sallys_table inside sally_db we would do:

    GRANT SELECT, INSERT, UPDATE, DELETE ON sally_db.sallys_table TO 'sally'@'localhost';

Lastly, what about the permission to grant privileges themselves? To accomplish this, we add WITH GRANT OPTION to the end of our GRANT command. 

    GRANT ALL ON *.* TO 'billy'@'localhost' WITH GRANT OPTION;

If you want to find out the current privileges to a specific user you can run the following command:

    SHOW GRANTS for 'username'@'hostname';

### Dropping a User
The process of removing a user from the system is known as "dropping" it. For example, to remove sally from our server, we would run:

    DROP USER 'sally'@'localhost';

DROP USER does not automatically close any open user sessions. Rather, in the event that a user with an open session is dropped, the statement does not take effect until that user's session is closed. Once the session is closed, the user is dropped, and that user's next attempt to log in fails. 

#### Create a new database administrator
    
    mysql> GRANT ALL ON *.* TO 'misterlewis'@'localhost' WITH GRANT OPTION;
    mysql> SHOW GRANTS FOR 'misterlewis'@'localhost' \G

The username should be the same as the username on your mac. You can run the command whoami (from your shell, not from mysql)
If you are trying to log in to MySQL as a user that has the same username as the user you are logged in to your computer as, you will not need to specify the -u option.

    mysql -p;

# Databases
<hr>
The main organization structure of MySQL is a database. One MySQL server can have many databases. In fact, our MySQL server came with three system databases already defined, one of which we have already been working with (mysql). Databases are where MySQL stores virtually all of its data (the notable exception being users & their privileges).

### Creating

    CREATE DATABASE IF NOT EXISTS database_name;

Database names should be all lower case, with underscores used to separate words in their name. Often times we will end a database name with _db.

Sometimes we may be creating a database in an automated script. In this case, if we try to create a database that already exists, MySQL will give us an error. We can avoid this problem by adding the condition IF NOT EXISTS. That way, if the database has already been created, the CREATE query will be skipped.

### Listing

    SHOW DATABASES;

### Selecting
Since virtually all MySQL information is stored within a database, it can be convenient to switch to a particular database. Doing so ensures that your subsequent queries refer (by default) to tables and other objects within that database. 

    USE database_name;

At times it may be necessary to refer to a table or object in a separate database. Or, if you have just connected to a MySQL server, you may not have any database selected. To do this, you can use the syntax:

    database_name.table_name

Notice that most of our queries refer to the mysql database (e.g. mysql.user). That is because we had not selected any database at that point.

### Show Current db

    SELECT database();
You can actually find out the query used to create a database with:

    SHOW CREATE DATABASE database_name;
The query has given us the exact SQL command necessary to recreate the database. This could be useful if we were trying to export or duplicate our database on a different server. 

### Deleting

    DROP DATABASE IF EXISTS database_name;
Trying to delete a database that does not already exist can create errors. To avoid this problem when trying to drop a database in a script we use IF EXISTS.

#### Database vs Schema
You may notice the word "schema" being used in documentation in several places. Other RDBMSs use schemas as a second level of organization within databases and strictly separate databases from each other from the user's perspective. Within MySQL, "database" and "schema" mean the same thing and can be used interchangeably.

#### Application specific databases
When you begin developing an application backed by a database, you must decide how to organize that information within your database. Most web applications can be encapsulated in a single database. Because of this, we will usually pair our application's database with a dedicated user. This user would be granted full control of just that database. We do this also as a security measure: if our application's user is somehow compromised, attackers only have access to the data for that application, not to any other database on our server.

    Note: Most other RDBMSs take this practice one step further, treating users & schemas interchangeably, or declaring that a schema is "owned" by a particular user. MySQL is unique in that it completely separates the idea of "users" from "databases / schemas"

#### Quoting Identifiers
Although great care should be used to avoid using <a href="https://dev.mysql.com/doc/mysqld-version-reference/en/keywords-8-0.html">reserved words</a> in your database names, there is actually a way around it. In SQL, you can actually use any word for a database name, even space characters, so long as we enclose the database name in back ticks (``). In practice though, do not do this. Using a reserved word as a table name is almost never worth the trouble it takes to do so; the same goes double for names with spaces in them.

<hr>
TODO: Create a new database called codeup_test_db and user codeup_test_user. Give codeup_test_user all permissions only on codeup_test_db. Make sure to remember this new user's password.

    mysql> CREATE DATABASE IF NOT EXISTS codeup_test_db;
    mysql> CREATE USER 'codeup_test_user'@'localhost' IDENTIFIED BY 'codeup';
    mysql> GRANT ALL ON codeup_test_db.* TO 'codeup_test_user'@'localhost';
        // GRANT ALL ON databaseName.databaseTable //
<hr>

# Tables
<hr>
Data is organized into tables. Tables look a lot like a spreadsheet; they break our data down into columns and store individual records in rows. Unlike a spreadsheet however, a database table has a specific set of columns and it is up to us as developers to define what those columns are called and what kind of data they can contain.

## Data Types
<hr>
MySQL, and most database systems, are statically typed. This means that when we create our tables we must specify what data type each column will be.

### Numeric Types
- INT
- FLOAT - A number containing decimals (not specific or accurate)
- DOUBLE - A more accurate decimal number
- DECIMAL(length, precision) ??? A precise decimal number. Decimal columns must be defined with a length and a precision; length is the total number of digits that will be stored for a value, and precision is the number of digits after the decimal place. For example, a column defined as DECIMAL(4,2) would allow four digits total: two before the decimal point and two after. 

#### Unsigned
This allows us to potentially store larger numbers in a column but only positive values. For example, a normal INT column can store numbers from -2,147,483,648 to 2,147,483,647, whereas an INT UNSIGNED column can store 0 to 4,294,967,295.

#### Boolean
MySQL has no native support for boolean values. Instead, it uses a TINYINT data type that goes from -128 to 127 and treats 0 as false and 1 as true.

### String Types
- CHAR(length) ??? A string with a fixed number of characters, where length can be from 1 to 255. If a string shorter than length is stored in a CHAR column then the value is padded with empty space to take up the full size. If you try to store a string longer than length, then an error occurs. CHAR column types are ideal for values where you know the length and it is constant, like a state abbreviation CHAR(2), zip code CHAR(5), or phone number CHAR(10).
- VARCHAR(length) ??? For strings where the length could vary up to some maximum number. VARCHAR columns are probably the most common type of column you will use in your database tables.
  - TEXT ??? A large block of characters that can be any length. It may be tempting to just throw everything in TEXT columns and not worry about lengths, but this is a very bad idea! There are some major technical limitations to TEXT and they can cause serious performance issues if they are abused. Only use TEXT columns for very large blocks of text, like the full text of an article, or the pages of a book.
      

    Use single quotes (') to indicate string values

### Date Types
<a href="https://dev.mysql.com/doc/refman/8.0/en/date-and-time-type-syntax.html">Dates and times</a> are deceptively complex data types. 
- DATE ??? A date value without any time. Typically MySQL displays dates as YYYY-MM-DD.
- TIME ??? A time down to the seconds. MySQL uses 24-hour times.
- DATETIME ??? A combined date and time value. DATETIME does not store any timezone information and will typically display information in the format YYYY-MM-DD HH:MM:SS

### Null
The value NULL has special meaning in relational databases. In most languages null behaves like 0 (many times, it secretly is 0). In MySQL, NULL can be thought of as the absence of value. This has some interesting consequences. If we asked whether NULL != NULL the answer would be NULL. On the other hand, if we asked if NULL = NULL the answer would also be NULL! In essence, you can think of this question as "does some unknown value equal some other unknown value?" to which MySQL responds "How should I know?!"

    Since NULL values are complex, and because they can lead to inconsistent data, columns can specify that their values are NOT NULL. This will prevent NULL from being stored in a particular column and lead to more predictable results.

## Creating Tables
<hr>
Syntax:

    CREATE TABLE table_name (
        column1_name data_type,
        column2_name data_type,
        ...
    );
Example:

    CREATE TABLE quotes (
        id INT UNSIGNED NOT NULL AUTO_INCREMENT,
        author_first_name VARCHAR(50),
        author_last_name  VARCHAR(100) NOT NULL,
        content TEXT NOT NULL,
        PRIMARY KEY (id)
    );

Notice we allow for the author_first_name to be NULL, but that author_last_name and content are both mandatory.
Primary keys stop us from inserting multiple duplicate values; a primary key is a guaranteed way to uniquely identify a single row in a table. A primary key is a special type of column with the following rules:

    - Each value must be unique.
    - They cannot be NULL.
    - There can only be one primary key in a table.
Most of the time, it is perfectly reasonable to let the database server manage your primary key values for you.

    The Column 'id' is a column just like the other four, but we have added some additional constraints to it. We have specified that the id is an UNSIGNED integer. This is because MySQL will assign IDs starting with 1; it does not make sense to allow negative values in our column. The last part of our column definition is AUTO_INCREMENT. This is what instructs MySQL to generate new values for this column when we try to insert records into our table. Only one column per table may be AUTO_INCREMENT and it must be the primary key. Finally, at the end of our table definition, we specify that the PRIMARY KEY for the table is id.

### Default Values
For any given column we can specify a default value for it in our table definition. For example, if we wanted to specify that the default first name was 'NONE' we could do so in our table definition like so:

    author_first_name VARCHAR(50) DEFAULT 'NONE',

## Showing Tables
<hr>
If we need to see what tables are defined in a database:

    SHOW TABLES;

## Describing Tables
<hr>
The command to show the structure of a table:

    DESCRIBE quotes;
MySQL uses EXPLAIN and DESCRIBE interchangeably. By convention we use DESCRIBE when we want to inspect a table, and EXPLAIN when we want to analyze a query.

MySQL can also display the original command used to create a table by using:

    SHOW CREATE TABLE quotes\G;

## Dropping Tables
<hr>

    DROP TABLE IF EXISTS quotes;
The same is also true about the inverse:
    
    CREATE TABLE IF NOT EXISTS quotes (
        ...
    );

## SQL Scripts
<hr>
we can create our SQL commands in a script file and then instruct the MySQL command line client to run those commands. In order to do so, we create a file with the extension .sql. The script can contain as many SQL queries as needed, each ending with ; or \G. To run the script, use the following command:

    mysql -u USERNAME -p -t < filename.sql
The < filename.sql tells the MySQL command line client to read the specified file and execute all the SQL queries in it. The option -t makes MySQL output data in tables just like when we interact with it directly.

You can add comments in your SQL script with two dashes: --. Everything on a line after -- is a comment and will not be executed.

# Statements
<hr>
You have one set of commands to create and manage the structure of your database, and another set to manipulate the data in your database.

These queries are often called CRUD operations, meaning "Create, Read, Update, and Delete". CRUD is the basic building block for working with data in any system, whether it is a database, a web API, a cache server, etc. By and large, most of the SQL you write in the future will be CRUD commands.

## Insert
<hr>
The commands to add new rows to a table is INSERT. Its basic structure looks like the following:

    INSERT INTO table_name (field1, field2, ...)
    VALUES ('value1', 'value2', ...);
You do not have to specify every column in your table, but the set of values must match up exactly with the set of columns. In particular, you should almost never specify a column that has AUTO_INCREMENT like your primary key.

Example:

    INSERT INTO quotes (author_first_name, author_last_name, content)
    VALUES ('Douglas', 'Adams',    'Time is an illusion. Lunchtime doubly so.'),
    ('Mark',    'Twain',    'Clothes make the man. Naked people have little or no influence on society.'),
    ('Kurt',    'Vonnegut', 'The universe is a big place, perhaps the biggest.');
Notice that all our string values are enclosed in single quotes ('), this is the SQL standard. If you need to put a single quote in a string, you can escape it, (\') or you can use two single quotes in a row ('').

## Select
<hr>
We use SELECT to find and return rows from a table. SELECT is a deceptively powerful statement.
Syntax:

    SELECT column1, column2, ... FROM table_name;
Examples:
  
    SELECT author_last_name, content FROM quotes;
    SELECT * FROM quotes;

### Where Clause
If we want to change what data is being returned, we need to narrow down our selection. We can do this by using a WHERE clause. WHERE allows you to specify a condition that must be true for a given row to be displayed. The basic syntax looks like:

    SELECT column1, column2, ...
    FROM table_name
    WHERE column_name = 'value';
Notice that for comparison SQL uses just a single = and not the double == we have used before. For example, if we wanted all the quotes written by 'Adams' we could do:

    SELECT * FROM quotes WHERE author_last_name = 'Adams';
Also remember, the guaranteed fastest and most precise way to find a single record in a table is to use the table's primary key:

    SELECT * FROM quotes WHERE id = 5;

### Operators
<a href="https://dev.mysql.com/doc/refman/8.0/en/non-typed-operators.html">MySQL Operators</a> are similar to other languages, however there are a few new ones:

    = 	Equal
    != or <> 	Not equal
    < 	Less than
    > 	Greater than
    <= 	Less than or equal to
    >= 	Greater than or equal to
    BETWEEN value1 AND value2 	Greater than or equal to value1 and less than or equal to value2

## Aliases
<hr>
Aliases are commonly used to make temporary names for joins, or to change the output of a column's name.
We use the AS keyword to assign an alias to a column name or table.

    SELECT CONCAT(first_name, ' ', last_name) AS full_name
    FROM employees
    LIMIT 25;
A SELECT expression can be given an alias using AS alias_name. The alias is used as the expression's column name and can be used in GROUP BY, ORDER BY, or HAVING clauses.
We can still use the original column names alongside the aliases.

    SELECT CONCAT(first_name, ' ', last_name) AS full_name
    FROM employees
    GROUP BY full_name, last_name
    ORDER BY last_name
    LIMIT 25;
We can also alias the table name.

    SELECT CONCAT(first_name, ' ', last_name) AS full_name
    FROM employees AS emp
    GROUP BY full_name, last_name
    ORDER BY last_name
    LIMIT 25;

It is not permissible to refer to a column alias in a WHERE clause, because the column value might not yet be determined when the WHERE clause is executed.
Does not work with * (must be individual columns)

### Misc Output
Sometimes it may be useful to output arbitrary data from our SQL scripts. We can do this by selecting an arbitrary string and giving it a name like so:

    SELECT 'I am output!' AS 'Info';

## Update
<hr>
The command to modify existing data in a table is UPDATE. Unlike INSERT, update only works with existing records; it will <strong>not</strong> add new rows to any table.
The basic syntax for an UPDATE statement is:

    UPDATE table_name
    SET column1 = 'value1', column2 = 'value2', ...
    WHERE columnA = 'valueA';
It is generally safest to use your primary key column for updates, but you can have any condition in your WHERE clause, or omit it entirely.
** If you omit the WHERE clause in an UPDATE statement, the update will apply to all rows on that table.

## Delete
<hr>
To remove records from a table, we use the DELETE statement. The basic syntax for delete rows:

    DELETE FROM table_name WHERE column_name = 'value';
The ids in the table will not automatically reorder. This is actually by design and helps keep our data consistent and predictable. If the values for our primary key changed regularly, we would have no reliable way to find a particular row.


### CAUTION ON DELETE
<hr>
The DELETE query is exceptionally dangerous???there is no confirmation and there is no going back. It is up to you as a developer to make sure you are only deleting the records you want to. A good rule of thumb is to:

    Always write your WHERE condition first.
    Whenever possible, DELETE using the table's primary key.

The safest way to write a DELETE statement is to write a SELECT statement first. Use that query to narrow down your condition and make sure you know what is about to be removed. Once you have a good SELECT it is trivial to convert it into a DELETE:

    -- First:
    SELECT * FROM quotes WHERE id = 3;
    -- Convert to:
    DELETE FROM quotes WHERE id = 3;
<hr>

## Truncate
<hr>
Sometimes you do not want to just remove a handful of records, but all the records from a table. For that, SQL also has a TRUNCATE command:

    TRUNCATE table_name;
TRUNCATE has no WHERE clause, there is no way to limit what rows of the table will be removed; it deletes EVERYTHING. If you thought DELETE was scary, TRUNCATE is <strong><em>downright terrifying</em></strong>.

## Misc Notes
<hr>

Running sql script: If you are already in mysql client use: "source script_name.sql" to run a script
Otherwise: mysql -u user_name -p < script_name.sql

## Notes for test_db Exercises
<hr>

### WHERE, LIKE, DISTINCT, BETWEEN, IN
The WHERE clause, if given, indicates the condition or conditions that rows must satisfy to be selected. The WHERE condition is an expression that evaluates to true for each row to be selected.

We can use WHERE with the LIKE option to find similarities. The % are wildcards.
This query will select all first names with the letter combination 'sus':

    SELECT DISTINCT first_name
    FROM employees
    WHERE first_name LIKE '%sus%';
* Can add the DISTINCT keyword to our SELECT statement to avoid getting duplicate values.

BETWEEN to find specific ranges of values:

    WHERE emp_no BETWEEN 10026 AND 10082;
We can use WHERE with IN to query only very specific sets of values. The () are required when you use IN.

    WHERE last_name IN ('Herber', 'Dredge', 'Lipner', 'Baek');

We can also use comparison operators, IS NULL, IS NOT NULL.

We can chain using AND or OR:

    WHERE emp_no < 20000
        AND last_name IN ('Herber','Baek')
        OR first_name = 'Shridhar';

### ORDER BY, GROUP BY
Columns selected for output can be referred to in ORDER BY and GROUP BY clauses using column names, column aliases, or column positions. Column positions are integers and begin with 1. ASCending or DESCending.

    SELECT column FROM table ORDER BY column_name [ASC|DESC];
The ORDER BY clause also allows you to chain together column names, column aliases, or column positions.

    SELECT first_name, last_name
    FROM employees
    ORDER BY last_name DESC, first_name ASC;

### LIMIT
The LIMIT clause limits the number of results returned to a number or range you specify.

    SELECT columns FROM table LIMIT count [OFFSET count];
The simplest use of the LIMIT clause just specifies a number after the keyword.

    WHERE first_name LIKE 'M%'
    LIMIT 10;
Adding an OFFSET tells MySQL which row to start with.

    LIMIT 25 OFFSET 50;
LIMIT and OFFSET are commonly used for pagination, or creating pages of data.
Try to think of your results as batches, sets, or pages. The first five results are your first page. The five after that would be your second page, etc.

    ceiling(OFFSET/LIMIT) = Page

https://www.xarg.org/2016/10/derivation-of-pagination-calculation/

## Functions
<hr>

https://dev.mysql.com/doc/refman/8.0/en/functions.html

### String Functions
#### CONCAT
The CONCAT() function takes in any number of strings or column names and will concatenate them all together.

    SELECT CONCAT('Hello ', 'Codeup', '!');
#### LIKE / NOT LIKE
Use WHERE with the LIKE option to find similarities. The % are wildcards.

    WHERE first_name NOT LIKE '%a%';
### Date and Time
One of the most commonly used is NOW() or its synonymous alias CURRENT_TIMESTAMP().
#### DAY
DAY() is a synonym for DAYOFMONTH().

    SELECT DAYOFMONTH('1990-05-03');
    -- Will return 3
    
    SELECT DAY('2017-03-25');
    -- Will return 25
#### MONTH
Returns the month for date, in the range 1 to 12 for January to December, or 0 for dates such as '0000-00-00' or '2008-00-00' where the month has not been defined.

    SELECT MONTH('2008-02-03');
    -- Will return 2
#### YEAR
Returns the year for a date, in the range 1000 to 9999, or 0 for the zero date.

    SELECT YEAR('1987-01-01');
    -- Will return 1987

Example trying to find employees that were born on the U.S. Independence Day during the 1950's: 

    SELECT *
    FROM employees
    WHERE year(birth_date) BETWEEN 1950 AND 1959
    AND month(birth_date) = 7
    AND day(birth_date) = 4;
#### NOW
The NOW() function returns the current time in YYYY-MM-DD HH:MM:SS format.

    SELECT NOW();
#### CURDATE
The CURDATE() function returns just the current date with no time information in YYYY-MM-DD format.

    SELECT CURDATE();
#### CURTIME
The function CURTIME() returns the time formatted as HH:MM:SS.

    SELECT CURTIME();
#### UNIX_TIMESTAMP() & UNIX_TIMESTAMP(date)
The UNIX_TIMESTAMP() function is used to represent time as an integer. It will return the number of seconds since midnight January 1st, 1970. 
If you pass a date time value to UNIX_TIMESTAMP(), it will give you the number of seconds from the unix epoch to that date.

    The Unix epoch is 00:00:00 UTC on 1 January 1970 (an arbitrary date). Unix time is nonlinear with a leap second having the same Unix time as the second before it (or after it, implementation dependent), so that every day is treated as if it contains exactly 86400 seconds,[2] with no seconds added to or subtracted from the day as a result of positive or negative leap seconds. Due to this treatment of leap seconds, Unix time is not a true representation of UTC. 

    SELECT CONCAT(
    'Teaching people to code for ',
    UNIX_TIMESTAMP() - UNIX_TIMESTAMP('2014-02-04'),
    ' seconds'
    );

### Numeric Functions and Operators
https://dev.mysql.com/doc/refman/8.0/en/numeric-functions.html

## GROUP BY
<hr>
Grouping results based on data in columns allows us to remove duplicates, much like using DISTINCT. We can also use GROUP BY in combination with aggregate functions.

GROUP BY follows the same syntax as ORDER BY.
SELECT column FROM table GROUP BY column_name;
However, GROUP BY returns only the unique occurrences of the column specified.

    SELECT last_name, first_name
    FROM employees
    GROUP BY last_name, first_name;
The above query will show us all of the unique combinations of first and last names, grouped by their last name sorted alphabetically, and within each last name group, sorted by first name.

    Any column(s) that appear in the SELECT should also be in the GROUP BY clause.

### Aggregate Functions
The functions we have seen so far look at data in a single column or possibly across an entire row. An aggregate function works with data across all the rows in our result.
https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html

#### COUNT
The COUNT() function will return the number of non-null expression values in a result. You will commonly see it written as COUNT(*). For example, if we wanted to see how many rows were in our employees table total, we would run:

    SELECT COUNT(*) FROM employees;
If we were only concerned about the values in a given column, we can pass that to the COUNT() function:

    SELECT COUNT(first_name)
    FROM employees
    WHERE first_name NOT LIKE '%a%';
This query will return a count of all first names that do not have an a in them from the employees table.

#### GROUP With Aggregates
We can combine our use of aggregate functions with the GROUP BY clause to produce more meaningful results.

If we want to find out how many unique first names do not contain an 'a', we know we can use a GROUP BY, but we can also combine this with the aggregate COUNT function to find how many employees have each unique last name:

    SELECT first_name, COUNT(first_name)
    FROM employees
    WHERE first_name NOT LIKE '%a%'
    GROUP BY first_name;
This will show us the 10 most common hire dates for employees:

    SELECT hire_date, COUNT(*)
    FROM employees
    GROUP BY hire_date
    ORDER BY COUNT(*) DESC
    LIMIT 10;
The COUNT() function will be the one you used most frequently, but there are many others such as SUM(), AVG(), MIN() and MAX(). There are even functions that do statistical analysis like STDDEV() and VARIANCE(). Using aggregates can save a lot of tedious looping and arithmetic on your end.

## Sub-queries
<hr>
Subqueries, also called nested queries, refers to having more than one query expression in a query.
Subqueries are helpful when we want to find if a value is within a subset of acceptable values.

    SELECT column_a, column_b, column_c
    FROM table_a
    WHERE column_a IN (
      SELECT column_a
      FROM table_b
      WHERE column_b = true
    );

From our employees database, we can use this example query to find all the department managers names and birthdates:

    SELECT first_name, last_name, birth_date
    FROM employees
    WHERE emp_no IN (
      SELECT emp_no
      FROM dept_manager
      )
    LIMIT 10;
Subqueries can be also useful while you are building INSERT / UPDATE statements where you don't know exactly what ID needs to be inserted as a foreign key as the following example demonstrates:

    INSERT INTO users (name, email, role_id)
      VALUES('fer', 'fer@codeup.com',
        (SELECT id FROM roles WHERE name = 'commenter')
    );
The following example uses a subquery to get the primary key for the roles table by only knowing the name of the role and just modifies a specific user by their email. 

    UPDATE users
        SET role_id = (SELECT id FROM roles WHERE name = 'admin')
        WHERE email = 'fer@codeup.com';
<hr>
SQL beginners often use subqueries when the same results can be achieved with JOINs. While subqueries may be easier to understand and use for many SQL users, JOINs are often more efficient and faster. JOINs are also easier to read as the queries become more complex.
<hr>


## IntelliJ Setup


1. Open the database tool window 
   1. View -> Tool Windows -> Database
2. Add a new connection 
   1. Click on the '+' and choose Data Source -> MySQL
   2. Some versions of IntelliJ might require to specify the server version while you choose a driver, in your case could be something like: MySQL 8.x.x
3. Fill in the following:
   1. Host: localhost 
   2. Port: 3306 
   3. Database:
   4. User: root 
   5. Password: codeup (or your root password)


    No database selected
    Note that you should leave the "Database" field blank so you can see them all.

4. Under the Advanced tab, find the serverTimezone property and set it to UTC
5. Click Test Connection and save if successful 
6. You should be dropped into the db console 
7. If you cannot run 'Test Connection', look for a prompt to update your drivers or analyze any exceptions found.
