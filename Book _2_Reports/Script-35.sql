--Book 2, Chapter 11, question #1
-- How many emloyees are there for each role?

SELECT et.employee_type_name,
	COUNT(e.employee_type_id)
FROM employees e 
JOIN employeetypes et ON et.employee_type_id = e.employee_type_id 
GROUP BY et.employee_type_id