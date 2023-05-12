-- For the top 5 dealerships, which employees made the most sales

-- I want the top 5 dealerships
-- I want the employees who made the most sales from those top 5
-- dealerships

WITH top_five AS(
SELECT d.dealership_id, d.business_name, COUNT(s.sale_id) numSales
FROM sales s
INNER JOIN dealerships d ON d.dealership_id = s.dealership_id 
GROUP BY d.dealership_id 
ORDER BY COUNT(s.sale_id) DESC
LIMIT 5
),
maxSales AS(
SELECT s.dealership_id, MAX(s.numSales) maxSales
FROM (SELECT d.dealership_id, COUNT(s.sale_id) numSales FROM sales s
	JOIN dealerships d ON d.dealership_id = s.dealership_id
	GROUP BY d.dealership_id
) s
WHERE s.dealership_id IN (SELECT dealership_id FROM top_five)
GROUP BY s.dealership_id
)
SELECT tf.business_name, e.first_name, e.last_name, COUNT(s.sale_id) numSales
FROM top_five tf
INNER JOIN maxSales ms ON ms.dealership_id = tf.dealership_id
INNER JOIN sales s ON s.dealership_id = tf.dealership_id --AND s.employee_id = employees.employee_id 
INNER JOIN employees e ON e.employee_id = s.employee_id
WHERE numSales = ms.maxSales  
GROUP BY tf.business_name, e.first_name, e.last_name, tf.dealership_id  
ORDER BY COUNT(s.sale_id) DESC
LIMIT 5
