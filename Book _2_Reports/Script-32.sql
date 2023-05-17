--Book 2, Chapter 9
-- Write a query that shows the lease income 
-- per dealership for all of 2019.

--SELECT d.business_name,
--	SUM(s.price) OVER(PARTITION BY d.business_name) total_2019_sales
--FROM sales s 
--JOIN dealerships d ON d.dealership_id = s.dealership_id 
--WHERE s.purchase_date BETWEEN '2019-01-01' AND '2019-12-31'
--AND s.sales_type_id = 2

--cant figure out how to group by

WITH information AS (SELECT s.sale_id, d.business_name, s.price price
FROM sales s
JOIN dealerships d ON d.dealership_id = s.dealership_id 
WHERE s.sales_type_id = 2 AND s.purchase_date BETWEEN '2019-01-01' AND '2019-12-31'
)
SELECT i.business_name, SUM(i.price) total_sales
FROM information i
GROUP BY i.business_name;

--Aha. No window function was needed here. SOLVED!