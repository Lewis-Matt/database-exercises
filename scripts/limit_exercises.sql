USE employees;
# List the first 10 distinct last name sorted in descending order.
SELECT DISTINCT last_name
FROM employees
ORDER BY last_name DESC
LIMIT 10;

# Create a query to get the top 5 salaries and display just the employees number from the salaries table.
SELECT emp_no
FROM salaries
ORDER BY salary DESC
LIMIT 5;

# find the tenth page of results.
SELECT emp_no
FROM salaries
ORDER BY salary DESC
# OFFSET (number of results to skip), LIMIT (number of results per page), and the page number. (OFFSET/LIMIT) + LIMIT = Page
# 0-5 = pg 1, 6-10 = pg 2, ...40-45 = pg 9, 46-50 = pg 10...     ceiling(OFFSET/LIMIT) = Page
LIMIT 5 OFFSET 46;

