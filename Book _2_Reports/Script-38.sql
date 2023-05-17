-- Book 2, Chapter 12, problem #2
-- What are the top 5 US zipcodes with the most customers 
-- who have purchased a vehicle from a dealership 
-- participating in the Carnival platform?

WITH information AS (SELECT s.customer_id, s.sales_type_id, c.zipcode zipcodes
FROM sales s 
JOIN customers c ON c.customer_id = s.customer_id
)
SELECT i.zipcodes
FROM information i
GROUP BY i.zipcodes
ORDER BY COUNT(i.zipcodes) DESC
LIMIT 5;




