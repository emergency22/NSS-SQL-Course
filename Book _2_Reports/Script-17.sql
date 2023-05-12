SELECT v.vin, c.first_name, c.last_name, e.first_name, e.last_name, d.business_name, d.city, d.state
FROM sales s
JOIN vehicles v
JOIN customers c
JOIN employees e
JOIN dealerships d
ON s.vehicle_id = v.vehicle_id AND s.customer_id = c.customer_id AND s.employee_id = e.employee_id AND s.dealership_id = d.dealership_id;