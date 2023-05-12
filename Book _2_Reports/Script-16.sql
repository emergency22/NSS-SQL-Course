-- What is the most popular vehicle make in terms of number of sales?

SELECT vt.make, vt.model, COUNT(v.vehicle_id) Sale_Count
FROM sales s
INNER JOIN vehicles v ON v.vehicle_id = s.vehicle_id 
INNER JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE s.sales_type_id = 1
GROUP BY vt.make, vt.model 
ORDER BY COUNT(v.vehicle_id) DESC 
LIMIT 1