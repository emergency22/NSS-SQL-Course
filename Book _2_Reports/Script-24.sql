-- Get a list of all dealerships and which roles each of the employees hold.
SELECT
    d.business_name,
    et.employee_type_name
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON de.employee_id = e.employee_id
RIGHT JOIN employeetypes et ON e.employee_type_id = et.employee_type_id;