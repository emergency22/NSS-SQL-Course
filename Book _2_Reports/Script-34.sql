-- Book 2, Chaper 10, Question #2 of Diverse Dealerships
-- Which dealerships are currently selling the highest 
-- number of vehicle models? This will let dealerships 
-- know which regions have either a high population, or 
-- less brand loyalty.

SELECT d.business_name,
	COUNT(s.sale_id)
FROM sales s
JOIN dealerships d  ON d.dealership_id = s.dealership_id 
GROUP BY d.business_name
ORDER BY COUNT(s.sale_id) DESC