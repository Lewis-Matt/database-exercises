# Model View Controller
MVC says that we should separate our applications into three distinct parts: Models, Views and Controllers.

    - Models are responsible for the representation of data in our application. We'll use Java beans (more on this in a coming section) to represent our data.
    - Views are the piece of the application that handle the presentation to the user. JSP files are the view layer in our AdLister application.
    - Controllers are where the logic happens, and where we respond to user actions. Servlets will serve this purpose in our application.

 	                Model 	    View 	    Controller
Responsible for: 	Data 	Presentation 	Logic
In our project: 	Beans 	JSPs 	        Servlets

![](../MVC-Servlets-DAO-Diagram.png)

