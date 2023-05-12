-- Use a self join to list all sales that will be picked up on the same day,
-- including the full name of customer picking up the vehicle. .
SELECT
    CONCAT  (c.first_name, ' ', c.last_name) AS full_name,
    s1.invoice_number,
    s1.pickup_date
FROM sales s1
INNER JOIN sales s2   -- what about the SELF JOIN?
    ON s1.sale_id <> s2.sale_id    -- what does this mean?
    AND s1.pickup_date = s2.pickup_date  -- does does this mean?
INNER JOIN customers c
   ON c.customer_id = s1.customer_id;