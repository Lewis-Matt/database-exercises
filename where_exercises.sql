USE employees;
# Find all employees with first names 'Irena', 'Vidya', or 'Maya' — 709 rows
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya');

# Find all employees whose last name starts with 'E' — 7,330 rows.
SELECT *
FROM employees
WHERE last_name LIKE 'E%';

# Find all employees with a 'q' in their last name — 1,873 rows.
SELECT *
FROM employees
WHERE last_name LIKE '%q%';

# Update your query for 'Irena', 'Vidya', or 'Maya' to use OR instead of IN — 709 rows
# Add a condition to find everybody with those names who is also male — 441 rows.
SELECT *
FROM employees
WHERE
      (first_name = 'Irena'
   OR first_name = 'Vidya'
   OR first_name = 'Maya')
    AND gender = 'M';

# Find all employees whose last name starts or ends with 'E' — 30,723 rows
SELECT *
FROM employees
WHERE last_name LIKE 'E%'
OR last_name Like '%E';

# Duplicate the previous query and update it to find all employees whose last name starts and ends with 'E' — 899 rows.
SELECT *
FROM employees
WHERE last_name LIKE 'E%'
   AND last_name Like '%E';

# Find all employees with a 'q' in their last name but not 'qu' — 547 rows.
SELECT *
FROM employees
WHERE last_name LIKE '%q%'
AND last_name NOT LIKE '%qu%';