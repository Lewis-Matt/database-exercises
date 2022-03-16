USE employees;

# In your script, use DISTINCT to find the unique titles in the titles table.
SELECT DISTINCT title FROM titles;

# Find your query for employees whose last names start and end with 'E'. Update the query to find just the unique last names that start and end with 'E' using GROUP BY.
SELECT last_name
FROM employees
WHERE last_name LIKE 'E%'
AND last_name LIKE '%e'
GROUP BY last_name;

# TODO: This doesn't make sense - there are only 5 unique last_names that meet the criteria, how could I get 846 rows...
# Update your previous query to now find unique combinations of first and last name where the last name starts and ends with 'E'. You should get 846 rows.
# SELECT last_name
# FROM employees
# WHERE last_name LIKE 'E%'
#   AND last_name LIKE '%e'
# GROUP BY last_name;

# Find the unique last names with a 'q' but not 'qu'.
# Add a COUNT() to your results and use ORDER BY to make it easier to find employees whose unusual name is shared with others.
SELECT COUNT(*) AS 'Number of names', last_name AS 'Last Name'
FROM employees
WHERE last_name LIKE '%q%'
  AND last_name NOT LIKE '%qu%'
GROUP BY last_name
ORDER BY COUNT(*) DESC;

# Update your query for 'Irena', 'Vidya', or 'Maya'. Use count(*) and GROUP BY to find the number of employees for each gender with those names.
SELECT COUNT(*) AS 'Number of employees', gender AS 'First Name'
FROM employees
WHERE
    (first_name = 'Irena'
        OR first_name = 'Vidya'
        OR first_name = 'Maya')
GROUP BY gender
ORDER BY COUNT(*) DESC;
