-- Book 2, Chapter 11, Question #2
-- How many finance managers work at each dealership?

-- Finance Manager = 2 in employeetypes table

WITH information AS (SELECT d.business_name, e.last_name, et.employee_type_name employee_type
FROM dealershipemployees de
JOIN dealerships d ON d.dealership_id = de.dealership_id 
JOIN employees e ON e.employee_id = de.employee_id
JOIN employeetypes et ON et.employee_type_id = e.employee_type_id 
WHERE et.employee_type_name = 'Finance Manager'
)
SELECT i.business_name, COUNT(i.employee_type)
FROM information i
GROUP BY i.business_name;

--Seems to be working
