# Servlets
<hr>
A servlet is a Java class that extends the HttpServlet class from the servlet library. A servlet's most basic functionality is to handle HTTP requests and responses. Servlets also allow us to create dynamic web pages with Java; that is, we can create HTML responses where the content changes based on variables, not just static HTML pages.

We can use Maven to add the Java servlet dependencies within our pom.xml:

    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>3.1.0</version>
    </dependency>

## Tomcat
<hr>
Apache Tomcat as our servlet container. Tomcat is the piece of software that handles the lower level networking details of accepting HTTP requests and forwarding them on to our code that can interact with the requests at a higher level.

Tomcat expects our application to be deployed as a WAR (Web ARchive). This is a JAR file with additional structure.

    It is important to keep in mind that the .war file that is created from our project will have a different structure from the project itself. While it's important to understand what a war file is and how it is structured, most of the time we won't be interacting with the war file directly, as it is an artifact, a byproduct of our source code, but not the source code itself.

This is what our project structure will look like, and this is an example of a typical Maven project structure, although you might encounter slightly different conventions elsewhere:

    ./               <-- project root
    pom.xml
    src/main/
        java/        <-- your classes, including servlets, go here
            webapp/      <-- web *facet* | static files / assets and jsps go in here
            css/
            js/
            img/
            WEB-INF/ <-- non-public files go here

## Using Servlets
<hr>
Broadly speaking, we'll need to do these three things when creating a servlet:

    - Create a class the extends HttpServlet
    - Annotate the class with the @WebServlet annotation to specify which URL it maps to
    - Implement a protected doGet and/or doPost method that accepts two parameters: HttpServletRequest, and HttpServletResponse

An alternative to configuration with annotations is with a configuration file named web.xml. You may see examples of this on Stack Overflow or when searching for servlet related questions. At Codeup, we'll stick to annotation based configuration, as it is less verbose, and a little more modern.

Example:

    import java.io.*;
    import javax.servlet.*;
    import javax.servlet.http.*;
    
    @WebServlet(name = "HelloWorldServlet", urlPatterns = "/hello-world")
    public class HelloWorldServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h1>Hello, World!</h1>");
        }
    }
WebServlet annotation: This allows us to specify what URL this servlet should handle. In this case, we specified /hello-world, meaning that this servlet will be invoked for any request for our base domain (this will be localhost:8080 by default locally) + /hello-world. The full URL would look like http://localhost:8080/hello-world. If we deployed our project to a live domain, it might look like: https://my-awesome-project.com/hello-world.

Below the annotation, we have our class definition. The class must extend HttpServlet. We can name this class whatever we like, but it should be a descriptive name. A common convention is to suffix the class name with Servlet.

Inside of our class we implement a doGet method. Notice that this method contains the Override annotation, meaning it is overriding the definition from a parent class. The methods we choose to implement in our servlet define what HTTP verbs the servlet will handle. 

    Most commonly, this will be either GET (doGet) or POST(doPost). Regardless of the HTTP verb, the method will define two parameters representing the incoming request (HttpServletRequest) and the response (HttpServletResponse).
In the body of the doGet method, we set the content type of the request, get a reference to a PrintWriter object, and use that object to send some HTML as a response. You can think of this PrintWriter object like System.out.println, but for printing to the response that we send to the browser, as opposed to the console.

    We'll map each servlet we create to a URL, meaning that each unique URL in our application will have a servlet associated with it, and to add a new URL, we would need to create a new servlet.

### Request Parameters
https://www.oreilly.com/library/view/java-servlet-programming/156592391X/ch04s04.html

Each access to a servlet can have any number of request parameters associated with it. These parameters are typically name/value pairs that tell the servlet any extra information it needs to handle the request. Please don’t confuse these request parameters with init parameters, which are associated with the servlet itself.

Fortunately, even though a servlet can receive parameters in a number of different ways, every servlet retrieves its parameters the same way, using getParameter() and getParameterValues() :
    
    public String ServletRequest.getParameter(String name)
    public String[] ServletRequest.getParameterValues(String name)
getParameter() returns the value of the named parameter as a String or null if the parameter was not specified.
If there’s any chance a parameter could have more than one value, you should use the getParameterValues() method instead. This method returns all the values of the named parameter as an array of String objects or null if the parameter was not specified. A single value is returned in an array of length 1.

    WARNING: if the parameter information came in as encoded POST data, it may not be available if the POST data has already been read manually using the getReader() or getInputStream() method of ServletRequest (because POST data can be read only once).

## Servlet Life Cycle
<hr>
Unlike our past Java projects, our application does not have a main method. Instead, Tomcat will be taking over control (initially) for us.

The process for a GET request looks like this:

    The Tomcat web server starts up
    A request for a specific URL comes to the web server (e.g. /hello-world)
    If the servlet that is mapped to that URL (e.g. our HelloWorldServlet) does not exist, it is created
    If the servlet has already been created, we'll use the existing one
    The doGet method is called and the response is sent

A similar process is followed for POST requests, but with the doPost method, instead of doGet.

The most important implication of this process is that the objects created from our servlet classes persist between requests. This means that we can create instance properties that can be used across multiple requests. In addition, we should be careful to clean up any resources we use on a single request (e.g. file handles).

## Working with Servlets
<hr>
After implementing the class and a doGet (or doPost) method, most of our work will be done with the request and response objects.

### Request
#### getParameter
    Get a parameter passed in the GET or POST request
    It allows us to extract a value for a parameter submitted along with a request.
For example, use this method to extract the values of 4 and "price" for the following GET request URL: /product-search?page=4&sort=price (assuming we have a servlet with a doGet method mapped to the URL).

    String sortBy = request.getParameter("sort");
    int currentPage = (int) request.getParameter("page");
Note that any values we obtain using this method will be strings; if the values are of a different type, we'll need to convert them ourselves in our application code.

This method is also used with POST requests to obtain the values a user would type into a form. For example, if an HTML form was created like this:

    <form method="POST" action="/register">
        <label for="email">Email:</label>
        <input id="email" name="email" placeholder="Enter your email address" />
    </form>
And we had created a servlet mapped to /register with the @WebServlet annotation, we could access the value the user types into the form inside of the doPost method like so:

    String email = request.getParameter("email");
    // Now we can do something with the email like save it in our database, or
    // use it to send a message to the user

#### getSession
Gives access to the session object.

#### setAttribute
Allows us to add a value to the request. We'll use this to pass data from our servlet to our view (MVC).

### Response
#### getWriter
Get an instance of java.io.PrintWriter that can be used to write to the HTTP response
This is like System.out.println, but for printing content to the response that will be delivered to the user's browser, instead of to the console.

    // inside of a doGet or doPost method
    System.out.println("You will see this in the console");
    response.getWriter().println("You should see this in the browser");

#### sendRedirect
Redirect to a different location
We might use this, for example, to redirect our users to the login page if they try to visit a page they must first be logged in to visit.

    response.sendRedirect("/login");

## Summary
In order to use servlets we'll need both of the following:

    The Java EE servlet libraries
    a web server with a web container configured to interact with our servlet classes

We will use Maven to add the servlet library dependencies in our pom.xml, IntelliJ to compile and package our application as a WAR, and Tomcat to serve our application.