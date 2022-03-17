USE employees;
# Write a query that shows each department along with the name of the current manager for that department.
SELECT d.dept_name AS department, CONCAT(e.first_name, ', ', e.last_name) AS full_name
FROM employees AS e
         JOIN dept_manager AS dm ON e.emp_no = dm.emp_no
         JOIN departments AS d ON d.dept_no = dm.dept_no
WHERE dm.to_date = '9999-01-01';

# Find the name of all departments currently managed by women.
SELECT d.dept_name AS department, CONCAT(e.first_name, ', ', e.last_name) AS full_name
FROM employees AS e
         JOIN dept_manager AS dm ON e.emp_no = dm.emp_no
         JOIN departments AS d ON d.dept_no = dm.dept_no
WHERE dm.to_date = '9999-01-01'
  AND e.gender = 'F';

# Find the current titles of employees currently working in the Customer Service department.
# count the number of titles in the title table
SELECT t.title AS title, COUNT(t.title) AS 'total'
FROM titles AS t
         # title table has FK of emp_no that is linked to employees PK of emp_no
         JOIN dept_emp AS de on t.emp_no = de.emp_no
    # departments PK dept_no links to dept_emp FK of dept_no
    # thus the tables titles and departments are JOINED through the relationship they share with dept_emp
         JOIN departments AS d ON de.dept_no = d.dept_no
# From departments
WHERE dept_name = 'Customer Service'
  # From dept_emp
  AND de.to_date = '9999-01-01'
  # From titles
  AND t.to_date = '9999-01-01'
GROUP BY t.title;

# Find the current salary of all current managers.
# Using without aliases, as I find it less confusing
-- Set the headings of the returned 'table'
SELECT departments.dept_name AS 'Department Name',
       CONCAT(employees.first_name, ' ', employees.last_name) AS "Manager",
       salaries.salary AS 'Salary'
FROM departments
            -- Joins departments and dept_manager
         JOIN dept_manager ON dept_manager.dept_no = departments.dept_no
            -- Joins dept_manager and employees
         JOIN employees ON employees.emp_no = dept_manager.emp_no
            -- Joins employees and salaries
         JOIN salaries ON employees.emp_no = salaries.emp_no
            -- 4 tables are now linked via shared relationships
WHERE dept_manager.to_date > CURDATE()
  AND salaries.to_date > CURDATE()
ORDER BY departments.dept_name;

# Find the names of all current employees, their department name, and their current manager's name .
SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Employee',
departments.dept_name AS 'Department',
       CONCAT(employees.first_name, ' ', employees.last_name) AS 'Manager'
# Had to make an alias here as employees table (from below JOIN) has the same name as the db referenced here, thus throwing an error as it doesn't know which 'employees' is being referred to
FROM employees AS e
        JOIN dept_emp ON e.emp_no = dept_emp.emp_no
        JOIN departments ON departments.dept_no = dept_emp.dept_no
        JOIN dept_manager ON dept_emp.dept_no = dept_manager.dept_no
        JOIN employees ON dept_manager.emp_no = employees.emp_no
WHERE dept_manager.to_date > CURDATE()
    AND dept_emp.to_date > CURDATE()
ORDER BY departments.dept_name, employees.emp_no;

