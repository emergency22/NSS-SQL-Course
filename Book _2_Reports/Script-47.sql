-- Book 2, Chapter 13, Question #2
-- Create a view that shows the total 
-- number of employees for each employee type.

CREATE VIEW empTypeCount AS
	SELECT et.employee_type_name, COUNT(employee_id)
	FROM employeetypes et
	JOIN employees e USING (employee_type_id )
	GROUP BY et.employee_type_name;
SELECT *
FROM empTypeCount;