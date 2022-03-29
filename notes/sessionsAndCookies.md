# Sessions and Cookies
Cookies are a way for web applications to track state. Cookies are the reason why you can log in to a website, and stay logged in even if you close and re-open your browser.

More specifically, a cookie is a name / value pair stored in a browser. When a browser requests a website from a server, the server can give the browser a unique value that the browser will then send to the server with every subsequent request. 

    This is done through HTTP headers, which, in short, are additional metadata that relate to HTTP requests and responses. 
    When the first request comes to the server, the server will send a Set-Cookie header, which will cause the browser to store 
    the sent value, and include a Cookie header with that value on any future requests to the same domain.

The server can then use this unique value to identify specific users and keep track of various pieces of information, such as whether the user has successfully logged in.

Sessions are the server-side complement to cookies. While it is possible to store information directly in a cookie, often times the cookie just serves as an identifier for session data on the server. You can think of a cookies and sessions as key-value pairs, the cookie serving as the key (used to find the session data), and the session as the value(s) (any information we want to track from our individual users).

## Session Tracking
<hr>
Java servlets automatically use cookies to track and store a session ID in each browser. By default, this session will be destroyed when the browser is closed. You can also create and send your own cookies, and use them to access user-specific data stored in memory, a file, or a database, but for this course, we will just be using the built-in functionality.

The servlet libraries define a class named `HttpSession`, instances of which represent a session. We have access to this session object through the request object's `getSession` method, and from there, we can define and retrieve attributes on the session with the `setAttribute` and `getAttribute` methods. The attributes that we set in the session are completely up to us, the only restriction is that we must use the same names to retrieve items as we use to set them.

### Session Methods

        Method 	                                    Description
        request.getSession()                      Obtain the current session object
        session.getAttribute("attributeName")     Retrieve a value from the session
        session.setAttribute("name", value)       Set/store a value in the session
        session.removeAttribute("name")           Remove an attribute from the session
        session.invalidate()                      Destroy and regenerate the entire session

#### Examples:
Inside a servlet

`HttpSession session = request.getSession();`

Track user's language preference for a site

`session.setAttribute("language", "en-us");`

    The first argument is a string that provides the name that we will use later to lookup the attribute in the session. 
    The second argument is the value we want to associate with that name. In the example above, it is another string, 
    but the second argument can be of any type.

Get the language to render the page content in

`String languagePreference = (String) session.getAttribute("language");`

    The first argument is a string that is the name of attribute we previously set. Notice here that we are doing 
    an explicit cast of the return value of getAttribute to a String in order to save it in a string variable. 
    This is because all values stored in the session have the type Object, the most generic type in Java. 
    When we want to work with a value, we'll need to cast it to the appropriate type.

Removing attributes

`request.getSession().removeAttribute("rememberMe");`

Destroy the entire session

`request.getSession().invalidate();`

<hr>

### Requests vs Sessions
Both the request object and the session object have getAttribute and setAttribute methods, and you will be using both. It is important not to confuse the two. In general, the request object (and any attributes you set on it) is only available for one HTTP request, but the session object persists for much longer (until the user closes the browser or the server is restarted).
<hr>

## Restricting Public Access to JSPs
<hr>
We can store information in our sessions and use that to restrict access to different parts of our application. For example, imagine we have a web application with an admin dashboard that should only be available to admin users. When a user logs in, we can store information about whether the user is an admin in the session.

Inside of LoginServlet.java:

    protected void doPost(HttpServletRequest request, HttpServletResponse repsonse) {
        // figure out if the login attempt was good...
        // ...
        if (isAdmin) {
            request.getSession().setAttribute("isAdmin", true);
        }
        // ...
    }
Later on, if the user tries to access the admin dashboard page, we can check against that value.

Inside ShowAdminDashboardServlet.java:

    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        // redirect if the user is not an admin
        // cast to a boolean data type to properly compare
        if ((boolean)request.getSession().getAttribute("isAdmin") == false) {
            response.sendRedirect("/login");
            return;
        }
        request.getRequestDispatcher("/secret-admin-page.jsp").forward(request, response);
    }
With the default configuration, Tomcat will serve any files in the webapp directory without restriction. This is good for static assets; for example, if a user visits /css/style.css, we want to serve the contents of our CSS stylesheet.

This is not ideal for JSP files, however. If a user visits /login.jsp, the JSP file will be served directly; this is bad for a couple of reasons:

1. When visiting the JSP file directly, no servlet methods are invoked. It is very commonly the case that our JSP file is set up to display some data that is defined in a servlet method, and if we access the JSP directly and not through the servlet, that data will not be defined.
2. There is no access control on who is able to see what pages. In our example above, we don't want just anyone to see the contents of secret-admin-page.jsp.

To protect against this, we can create a directory named `WEB-INF` inside webapp. Anything we put in the WEB-INF directory will not be accessible outside our application. This means that if we put our JSP files inside the WEB-INF directory, we can only allow access them through one of our servlets.

Note that you will need to update your getRequestDispatcher calls to include /WEB-INF/ when defining the path to your JSP file. In our example, we would need to modify ShowAdminDashboardServlet.java from:

    request.getRequestDispatcher("/secret-admin-page.jsp").forward(request, response);
    TO:
    request.getRequestDispatcher("/WEB-INF/secret-admin-page.jsp").forward(request, response);
