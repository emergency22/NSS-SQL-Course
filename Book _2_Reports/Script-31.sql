--Book 2, Chapter 9
-- Write a query that shows the lease income 
-- per dealership for Jan of 2020.

SELECT d.business_name,
	SUM(s.price) total_sales_for_Jan_2020
FROM sales s 
JOIN dealerships d ON d.dealership_id = s.dealership_id 
WHERE s.purchase_date BETWEEN '2020-01-01' AND '2020-01-31'
AND s.sales_type_id = '2'
GROUP BY d.business_name;

--Solved.