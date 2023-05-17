-- Book 2, Chapter 12, Question #3
-- What are the top 5 dealerships with the most customers?

SELECT d.business_name, COUNT(s.customer_id) customer_count
FROM sales s
JOIN dealerships d USING (dealership_id)
GROUP BY d.business_name 
ORDER BY customer_count DESC
LIMIT 5;