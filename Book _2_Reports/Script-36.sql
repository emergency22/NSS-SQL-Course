--Book 2, Chapter 11, #3
-- Get the names of the top 3 employees who work shifts 
-- at the most dealerships?

WITH subset AS (SELECT (e.first_name || ' ' || 
	e.last_name) AS name,
	de.dealership_id,
	d.business_name
FROM employees e 
JOIN dealershipemployees de ON de.employee_id = e.employee_id 
JOIN dealerships d ON d.dealership_id = de.dealership_id
)
SELECT s.name,
	COUNT(s.dealership_id) OVER(PARTITION BY s.business_name) shifts_worked,
	s.business_name
FROM subset s

--Look back over this
