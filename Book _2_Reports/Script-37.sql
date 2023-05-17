-- Book 2, Chapter 12, problem #1
-- What are the top 5 US states with the most customers who have 
-- purchased a vehicle from a dealership participating 
-- in the Carnival platform?

SELECT c.state
FROM sales s 
JOIN customers c ON c.customer_id = s.customer_id 
WHERE sales_type_id = 1
GROUP BY c.state
ORDER BY COUNT(c.state) DESC
LIMIT 5;