-- Book 2, Chapter 10, Question #1 of Diverse Dealerships
-- Which dealerships are currently selling the least number 
-- of vehicle models? This will let dealerships market 
-- vehicle models more effectively per region.

SELECT d.business_name, COUNT(sale_id) total_sales
FROM dealerships d
JOIN sales s ON s.dealership_id = d.dealership_id
WHERE s.sales_type_id = 2
GROUP BY d.business_name
ORDER BY total_sales ASC
LIMIT 10;