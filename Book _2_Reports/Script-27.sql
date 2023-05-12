Which employee type sold the most of that make?

SELECT vt.make, vt.model, COUNT(v.vehicle_id) Sale_Count, et.employee_type_name 
FROM sales s
INNER JOIN vehicles v ON v.vehicle_id = s.vehicle_id 
INNER JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id
INNER JOIN employees e ON e.employee_id = s.employee_id
INNER JOIN employeetypes et ON et.employee_type_id = e.employee_type_id 
WHERE s.sales_type_id = 1
GROUP BY vt.make, vt.model, et.employee_type_name 
ORDER BY COUNT(et.employee_type_name) DESC 
LIMIT 1


