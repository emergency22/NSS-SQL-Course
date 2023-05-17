-- Book 2, Chapter 13, Question #4
-- Create a view named sales2018 that shows the total 
-- number of sales for each sales type for the year 2018.

CREATE OR REPLACE VIEW sales2018 AS
	SELECT st.sales_type_name sale_type, s.sale_id sale_id
	FROM sales s
	JOIN salestypes st USING (sales_type_id)
	WHERE s.purchase_date BETWEEN '2018-01-01' AND '2018-12-31';
SELECT sl.sale_type, COUNT(sl.sale_id)
FROM sales2018 sl
GROUP BY sl.sale_type