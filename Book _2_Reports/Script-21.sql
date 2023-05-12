-- Get all the departments in the database,
-- all the employees in the database and the floor price of 
-- any vehicle they have sold.
SELECT
    d.business_name,
    e.first_name,
    e.last_name,
    v.floor_price
FROM dealerships d
LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
INNER JOIN employees e ON e.employee_id = de.employee_id
INNER JOIN sales s ON s.employee_id = e.employee_id
INNER JOIN vehicles v ON s.vehicle_id = v.vehicle_id;