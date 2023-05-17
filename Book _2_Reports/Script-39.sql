-- Book 2, Chapter 12, problem #3
-- What are the top 5 dealerships with the most customers?

SELECT d.business_name, COUNT(s.sale_id) total_sales
FROM dealerships d
JOIN sales s ON S.dealership_id = d.dealership_id 
GROUP BY d.business_name 
ORDER BY COUNT(s.sale_id) DESC
LIMIT 5;