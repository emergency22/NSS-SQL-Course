-- Book 2, Chapter 11, #4
-- Get a report on the top two employees who has 
-- made the most sales through leasing vehicles.

-- sales type id = 1
-- I'm going to attempt a subquery here in the FROM. Wish me luck.

SELECT i.full_name, COUNT(i.sale_id) total_leases
FROM (SELECT s.sale_id sale_id, e.employee_id, e.first_name || ' ' || e.last_name full_name, s.sales_type_id sales_type_id
	FROM sales s
	JOIN employees e ON e.employee_id = s.employee_id
) i
WHERE i.sales_type_id = 1
GROUP BY i.full_name
ORDER BY total_leases DESC
LIMIT 2;

-- Appears to be working. :)
