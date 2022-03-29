# Java Server Pages (JSP)
JSP allows us to create HTML pages with dynamic content by letting us mix Java code into our HTML. 
Using JSPs is much easier than writing HTML inside of strings inside of servlets.
A JSP page is a text document that contains two types of text: static data, which can be expressed in any text-based format (such as HTML, SVG, WML, and XML), and JSP elements, which construct dynamic content.
<br>
The page can be composed of a top file that includes other files that contain either a complete JSP page or a fragment of a JSP page. The recommended extension for the source file of a fragment of a JSP page is jspf.
<br>

While our servlets reside in src/main/java, we'll create our JSPs inside of src/main/webapp, as they are not Java source code.
Example:

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%! int counter = 0; %>
    <% counter += 1; %>
    <html>
    <head>
        <title>Title</title>
    </head>
    <body>
    
    <h1>The current count is <%= counter %>.</h1>
    
    View the page source!
    
    <%-- this is a JSP comment, you will *not* see this in the html --%>
    
    <!-- this is an HTML comment, you *will* see this in the html -->
    
    </body>
    </html>
Notice that this code contains HTML and tag-like elements that start with <% and end with %>. These are used to define the dynamic parts of the page. When the JSP file is processed, everything inside of the <% %> tags are evaluated, and a pure HTML response is produced. The code sample above might produce a response that looks like this:

    <html>
    <head>
        <title>Title</title>
    </head>
    <body>
    
    <h1>The current count is 3.</h1>
    
    View the page source!
    
    <!-- this is an HTML comment, you *will* see this in the html -->
    
    </body>
    </html>

**** The JSP file is executed on the server, and what the user sees in their browser is the end result of that process. That is, the end result is just HTML; web browsers don't ever see the JSP as we see it. ****

### JSP Directives

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
Directives allow us to set conditions that apply to the entire JSP file. The example above is a page directive, and is used to specify the content type of this page. Most JSP files you create will include this directive.

    A taglib directive <%@taglib ... %> can be used to import custom tags. See notes on JSTL.
    Include directives can be used to include other files or JSPs. This is primarily used for templating. We'll take a look at this in more detail in the next section.
    The page import directive <%@page ... %> can be used to import classes and libraries, the same way we might use an import statement in our Java code.

### Defining and using instance variables
Code inside of <%! %> will be treated as an instance variable definition.

    <%! int counter = 0; %>
This line creates an instance variable for our JSP page. This is similar to defining a property on a servlet class, and, like a property defined on a servlet, variables defined in this manner will persist between page loads.

This means that in our example, the variable initialization only happens once. We will increment the value every time the page is loaded, allowing us to keep track of how many times the page has been loaded:

    <% counter += 1; %>
The <% %> tags allow us to evaluate arbitrary Java code, and can potentially even contain multiple statements.
Evaluate an expression and print the result:
 
    <%= %> 	

### Comments
Code inside of <%-- --%> is treated as a comment and will not be rendered.

## Partials
A partial is a page with a piece of HTML or other code that can be included into other pages. Best examples are header and footer files that are being included into all pages of the website. You may also have complicated logic that you would like to separate or some repetitive code.

JSP doesn’t offer partials as a part of the language, but you can use include tag or directive for this purpose.

There are two different includes available in JSP, static and dynamic.

https://studiofreya.com/2017/05/14/jsp-partials-how-to-include-files/
### Static
Static include uses a JSP directive include meaning they start with an alpha-sign “@”:

    <%@ include file="header.html" %>
Static include is resolved at compile time. If you want to pass parameters from another request they may not be available yet as they will be first known at execution time.

Static includes are faster as the code is inserted at translation time once and for all.
header.jsp

    <head>
        <title>My title</title>
    </head>

main.jsp

    <!DOCTYPE html>
    <html lang="en">
        <%@ include page="header.jsp" %>
        <body>
             ...
        </body>
    </html>

### Dynamic Partials
Dynamic includes are resolved at runtime and you can use them to pass parameters from other requests to your partial pages.

In order to make the partial JSP dynamic we will use the jsp:include tag and pass some parameters with jsp:param tag.
header.jsp

    <head>
        <title><%= request.getParameter("title") %></title>
    </head>
footer.html
    
    <footer>
        My footer
    </footer>
main.jsp

    <!DOCTYPE html>
    <html lang="en">
        <jsp:include page="header.jsp">
           <jsp:param name="title" value="Main title" />
        </jsp:include>
        <body>
             ...
        </body>
        <%@ include page="footer.html" %>
    </html>

## Implicit Objects
Objects/variables that have already been defined:

    - request (javax.servlet.http.HttpServletRequest): To get the values of attributes or parameters that are passed to a JSP page.
    - response (javax.servlet.http.HttpServletResponse): To send information to the client
    - out (javax.servlet.jsp.JspWriter): send content in response

https://docs.oracle.com/cd/E19575-01/819-3669/bnaij/index.html

Example of using the implicit request object (Notice that we don't ever define request, it is already in scope):

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!doctype html>
    <html>
    <head>
        <title>Implicit Object Example</title>
    </head>
    <body>
        <h1>Welcome To The Site!</h1>
        <p>Path: <%= request.getRequestURL() %></p>
        <p>Query String: <%= request.getQueryString() %></p>
        <p>"name" parameter: <%= request.getParameter("name") %></p>
        <p>"method" attribute: <%= request.getMethod() %></p>
        <p>User-Agent header: <%= request.getHeader("user-agent") %></p>
    </body>
    </html>

## Expression Language
<hr>
The EL makes it easy to access attributes from the request object, and gives us a convenient way of accessing properties on objects. Handling null values is easier as well, if a value is null or a reference is not defined, nothing will be output, as opposed to an exception being raised.
<br>
JSP expression language expressions (${ }) retrieve the value of object properties. The values are used to set custom tag attribute values and create dynamic content. All expressions using the ${} syntax are evaluated immediately. These expressions can appear as part of a template (static) text or as the value of a tag attribute that can accept runtime expressions. Expressions whose evaluation can be deferred use the #{} delimiters.
https://javaee.github.io/tutorial/jsf-el003.html
<br>
There are also more implicit objects available to us:

    - param: get request parameter
    - paramValues: get all the request parameters in an array
    - header: get a single header value.
    - headerValues : get request header information
    - cookie: get cookie value
    - sessionScope: get attribute value in a session
Example:

    <%-- This assumes we are visiting a page and have ?page_no=5 (or something
    similar) appended to the query string --%>
    <p>"page_no" parameter: ${param.page_no}</p>
    <p>User-Agent header: ${header["user-agent"]}</p>
When not referring to an implicit object, the expression language assumes you are referring to an attribute on the request object.

    <% request.setAttribute("message", "Hello, World!"); %>
    ...
    <h1>Here is the message: ${message}</h1>
We have to use request.setAttribute to make a value available to the EL. Cannot do <% String message = "Hello, World"; %>
https://javaee.github.io/tutorial/jsf-el001.html

## JSP Standard Tag Library (JSTL)
<hr>
Pre-defined tags that provides functionality for many common programming tasks. Also had the ability to create custom tags

1. Include the required dependency in our pom.xml file:


    <dependency>
        <groupId>jstl</groupId>
        <artifactId>jstl</artifactId>
        <version>1.2</version>
    </dependency>

2. Add a taglib directive on any page we are using the JSTL on

    
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

We have a variable named cart in scope and cart is an object that represents a user's shopping cart. It has a method named isEmpty that returns whether the cart is empty, and a private property (along with a getter and setter for) named items that is a list of objects that represent an item the user has added to the shopping cart. Each item object has several private properties and getters and setters for each property:

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <html>
    <head>
        <title>JSTL Example</title>
    </head>
    <body>
        <h1>Your Shopping Cart</h1>
    
        <c:choose>
    
            <c:when test="${cart.isEmpty()}">
                <h2>No items in your cart (yet).</h2>
            </c:when>
    
            <c:otherwise>
                <c:forEach var="item" items="${cart.items}">
                    <div class="item">
                        <h3>${item.name}</h3>
                        <p>${item.description}</p>
                        <p>${item.price}</p>
                        <c:if test="${item.isOnSale}">
                            <p>This item is on sale!</p>
                        </c:if>
                    </item>
                </c:forEach>
            </c:otherwise>
    
        </c:choose>
    
    </body>
    </html>
note that:

    - All of the JSTL tags are prefixed with c:
    - Each tag has zero or more attribute-value pairs
    - We are using the JSTL in combination with the Expression Language
    - We reference property names directly, (as opposed to through the getter or setter, as we would in our Java code)
    - We can nest tags within each other
    - For our conditional tags, only one branch will be rendered in the final HTML output.

### Choose
The c:choose tag is analogous to an if-else block in our Java code. The entire structure is encased in c:choose tags, and the children are either c:when (representing an if) or c:otherwise (representing the final else).
Syntax:

    <c:choose>
        <c:when test="${boolean_expression_1}">
            <p>boolean_expression_1 was true</p>
        </c:when>
        <c:when test="${boolean_expression_2}">
            <p>boolean_expression_1 was false, and boolean_expression_2 was true</p>
        </c:when>
        <c:otherwise>
            <p>none of the above tests were true</p>
        </c:otherwise>
    </c:choose>
Inside the c:when tags, the test attribute should be a boolean expression that determines whether the content inside the tag should be rendered. Like an if-else, if one expression evaluates to true, the content inside that tag will be rendered, and if none of the conditions are true, the content inside the c:otherwise tag will be rendered.

In the shopping cart example, we use this to either display a message that tells the user their shopping cart is empty, or display the contents of their cart.

### For Each
The c:forEach tag allows us to loop through most types of collections. The content inside the tag will be rendered for every item in the collection.
Syntax:

    <c:forEach items="${collection}" var="element"></c:forEach>
We use the items attribute to specify the variable that contains the collection we are iterating over. The var attribute's value defines a variable that we can use inside the tag to refer to each item in the collection. With MVC, this collection will be defined in the Controller (Servlet).
Example:

    <% request.setAttribute("numbers", new int[]{1, 2, 3, 4, 5, 6, 7}); %>
    <ul>
        <c:forEach items="${numbers}" var="n">
            <li>${n}</li>
        </c:forEach>
    </ul>
Generates ul with the numbers 1-7 in each list item
In the shopping cart example, we use the c:forEach tag to render a div with the class of item that contains information about one specific item for every item in the user's shopping cart.

### If
The c:if tag allows us to conditionally show a piece of HTML. There is no corresponding else tag, if you want that sort of functionality, you should use the c:choose tag.
Syntax:

    <c:if test="${boolean_expression}">
        ...
    </c:if>
c:if tag must provide a test attribute where the content evaluates to a boolean value that determines whether to render the tag contents.
In the shopping cart example, we use the c:if tag to display a special message if an item is on sale.

https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/c/tld-summary.html

### Misc tag notes
    - Custom tags can be used to set a variable (c:set), iterate over a collection of locale names (c:forEach), and conditionally insert HTML text into the response (c:if, c:choose, c:when, c:otherwise).
    
    - jsp:setProperty is another standard element that sets the value of an object property.

    - A function (f:equals) tests the equality of an attribute and the current item of a collection. (A built-in == operator is usually used to test equality.)

    - The variable, inside of ${variable} in the JSP, comes from the controller (Servlet) when we are using MVC  

