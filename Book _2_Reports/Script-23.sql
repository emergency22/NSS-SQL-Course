-- Get employees and customers who have interacted through a sale.
-- Include employees who may not have made a sale yet.
-- Include customers who may not have completed a purchase.

SELECT
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name
FROM employees e
FULL OUTER JOIN sales s ON e.employee_id = s.employee_id
FULL OUTER JOIN customers c ON s.customer_id = c.customer_id;


-- could this have been possible going through the sales table first?