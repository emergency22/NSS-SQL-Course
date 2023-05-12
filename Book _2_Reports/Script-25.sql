-- Produce a report that lists every dealership, 
-- the number of purchases done by each, 
-- and the number of leases done by each.

SELECT d.business_name , COUNT(s.sales_type_id) AS purchases, COUNT(s.sales_type_id) AS leases
FROM dealerships d 
INNER JOIN sales s ON s.dealership_id = d.dealership_id
INNER JOIN salestypes st ON st.sales_type_id = s.sales_type_id
GROUP BY d.business_name 

-- Close. Hmm.