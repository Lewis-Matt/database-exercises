# Java DataBase Connectivity (JDBC)
Standard Java API for database-independent connectivity between the Java programming language and a wide range of databases.

The JDBC library includes APIs for each of the tasks mentioned below that are commonly associated with database usage.

1. Making a connection to a database.
2. Creating SQL or MySQL statements.
3. Executing SQL or MySQL queries in the database.
4. Viewing & Modifying the resulting records.


A database driver is a program that translates between Java and the database server. Database drivers are specific to a DBMS, meaning you would need a different database driver to talk to MySQL than you would to talk to Microsoft SQL Server.

Maven Dependency for MySQL:
- Delete the 'target' directory after changing dependencies

    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.23</version>
    </dependency>

## General Steps
<hr>

1. Connect to the database; obtain a `Connection` object
2. Create a `Statement` object
3. Execute the statement with our SQL based on its type
4. Work with the results of the query; the `ResultSet` object

Most methods on the objects we will be working with can throw a `SQLException;` our code will need to handle these exceptions.

### Connecting to a Database
Use the static `getConnection` method of the `DriverManager` class to return a `Connection` object, which, as the name implies, is an object that represents a database connection.

The getConnection method requires a URL for the database, a username of the user to connect as, and the password for that user.

    import java.sql.DriverManager;
    import com.mysql.cj.jdbc.Driver;
    // ...
    DriverManager.registerDriver(new Driver());                         // Instantiate Driver class
    Connection connection = DriverManager.getConnection(                // Create a single, reusable connection
        "jdbc:mysql://localhost:3306/codeup_test_db?allowPublicKeyRetrieval=true&useSSL=false",
        "root",
        "codeup"
    );
Here we create a database connection and by first registering an instance of the Driver class. Notice that the Driver class we are instantiating comes from the com.mysql namespace (import). This is the implementation of the MySQL driver. There is also a Driver interface in the java.sql package, it is important not to confuse the two.

It is worth noting that we generally create a connection once, and then continue to re-use that same connection object, as opposed to creating many different database connections.

    In larger applications you might have multiple database connections open at any given time, but it is still preferred to re-use 
    existing connections as opposed to creating a new connection every time you need to talk to the database. 
    In connection pooling, after a connection is created, it is placed in the pool and it is used again so that a new connection 
    does not have to be established. If all the connections are being used, a new connection is made and is added to the pool. 

    https://en.wikipedia.org/wiki/Connection_pool

### Creating and Executing Statements
Statement objects represent an individual SQL statement. Use `createStatement` method on the Connection object:

    Statement statement = connection.createStatement();
Once we have a statement object, we can run SQL commands. The way we run the commands depends on what kind of statement we are running.
1. `execute` returns a boolean indicating success
   1. `statement.execute("DELETE FROM albums WHERE id = 4");`
2. `executeUpdate` returns the number of rows affected
   1. `statement.executeUpdate("INSERT INTO albums (artist, name, release_date, genre, sales) VALUES('Nelly Furtado', 'Loose', 2006, 'Dance-pop, hip hop, R&B', 12.5)");`
3. `executeQuery` returns a `ResultSet` object
   1. `statement.executeQuery("SELECT * FROM albums");`

### Handle ResultSets
We will get the results of our query back as an instance of the `ResultSet` class. We can think of the result set object as a kind of cursor that iterates over the rows in the results of our query.

We call the `.next()` method on the result set object to move the cursor through our results row by row. The object also has different methods that start with `get` to obtain the values for each column in the row.

The .next() will return true as long as there are rows left in our results. Because of this, a very common pattern is to see code that looks like this:

    ResultSet rs = statement.executeQuery("SELECT * FROM albums");
    // 'rs' is an instance of ResultSet
    while (rs.next()) {
        // do something with each row
    }

<hr>

### Examples of handling ResultSets
For these examples, we are working with a database named codeup_test_db that contains a table with information about albums. In these examples we will show code that is presumed to be inside a main method that throws SQLException for the sake of easier demonstration.

#### Example: Displaying the Results of a Query

    String selectQuery = "SELECT * FROM albums";
    
    DriverManager.registerDriver(new Driver());
    Connection connection = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/codeup_test_db?allowPublicKeyRetrieval=true&useSSL=false",
        "root",
        "codeup"
    );
    
    Statement stmt = connection.createStatement();
    ResultSet rs = stmt.executeQuery(selectQuery);
    
    while (rs.next()) {
        System.out.println("Here's an album:");
        System.out.println("  id: " + rs.getLong("id"));
        System.out.println("  artist: " + rs.getString("artist"));
        System.out.println("  name: " + rs.getString("name"));
    }

1. Here we start by defining a string variable, selectQuery, that contains the SQL we will eventually execute.
2. Next we obtain our database connection.
3. From the connection object, we create a statement object, then pass selectQuery to the executeQuery method and store the returned ResultSet in the variable rs.
4. We'll put rs.next() inside the condition of our while loop so that it is called once per loop iteration, and we can iterate through the results returned from the database. 
   1. Inside the loop body, for every result in the result set, we'll use the getLong and getString methods to obtain the id and the title of the current row and print them out to the console.

#### Example: get the id of a newly inserted record

    DriverManager.registerDriver(new Driver());
    Connection connection = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/codeup_test_db?allowPublicKeyRetrieval=true&useSSL=false",
        "root",
        "codeup"
    );

    String query = "INSERT INTO albums (artist, name, release_date, genre, sales) VALUES('Nelly Furtado', 'Loose', 2006, 'Pop, Urban, R&B', 12.5)";
    Statement stmt = connection.createStatement();
    stmt.executeUpdate(query, Statement.RETURN_GENERATED_KEYS);
    ResultSet rs = stmt.getGeneratedKeys();
    if (rs.next()) {
        System.out.println("Inserted a new record! New id: " + rs.getLong(1));
    }

1. Here we create the connection object like before, and a string variable, query, to hold an insert statement.
2. We create our statement object and call the executeUpdate. 
   1. In addition to passing the string variable that holds the SQL we want to execute, we also pass a class constant, Statement.RETURN_GENERATED_KEYS. This tells the statement object that we wish to have access to the ids that are autogenerated by the database when inserting a record.
   2. The return value of executeUpdate is the number of rows affected, which, in this case, we don't care about.
3. We call the getGeneratedKeys method, which will give us a result set object that holds any ids that were generated by the database. We'll again need to call the next method on this object in order to advance through our results.
4. We'll use getLong to retrieve the generated id, and pass 1 to indicate that we want the first result in the result set. 
   1. Values can be retrieved from result set objects either by column name or column number (starting at 1).

<hr>

## Protecting the Configuration
In the examples, we had hardcoded username and password, which is bad. We can create a configuration file that has our sensitive information in it and add it to  The simplest approach, and the one we will use, is to create a class that holds our config information and not track that class file with Git.

    class Config {
        public String getUrl() {
            return "jdbc:mysql://localhost:3306/codeup_test_db?allowPublicKeyRetrieval=true&useSSL=false";
        }
        public String getUser() {
            return "root";
        }
        public String getPassword() {
            return "codeup";
        }
    }
Replace any hardcoded usernames, passwords, or URLs with references to this config class:

    // ...
    Config config = new Config();
    Connection connection = DriverManager.getConnection(
        config.getUrl(),
        config.getUser(),
        config.getPassword()
    );
    // ...



