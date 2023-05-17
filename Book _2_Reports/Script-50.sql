-- Book 2, Chapter 13, Question #4
-- Create a view that shows the employee at each dealership 
-- with the most number of sales.

CREATE OR REPLACE VIEW topSalesPeople AS
	SELECT d.business_name, e.first_name || ' ' || e.last_name full_name, COUNT(sale_id) total_sales
	FROM sales s
	JOIN employees e USING (employee_id)
	JOIN dealerships d USING (dealership_id)
	WHERE s.sales_type_id = 1
	GROUP BY d.business_name, full_name
	ORDER BY total_sales DESC;
SELECT *
FROM topSalesPeople;