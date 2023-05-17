--Book 2, Chapter 9
-- Write a query that shows the total purchase sales income 
-- per dealership.

SELECT s.sales_type_id,
	s.price,
	s.dealership_id,
	d.business_name, 
	SUM(s.price) OVER(PARTITION BY s.dealership_id) Total_By_Dealership
FROM sales s 
JOIN dealerships d ON d.dealership_id = s.dealership_id 