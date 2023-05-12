-- Produce a report that determines 
-- the most popular vehicle model that is leased.

SELECT vt.make, vt.model, COUNT(v.vehicle_id) Lease_Count
FROM sales s
INNER JOIN vehicles v ON v.vehicle_id = s.vehicle_id 
INNER JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE s.sales_type_id = 2
GROUP BY vt.make, vt.model
ORDER BY COUNT(v.vehicle_id) DESC
LIMIT 1

-- Appears to be working?