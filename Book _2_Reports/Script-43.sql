-- Book 2, Chapter 10, Question #2 of Available Models
-- Which model of vehicle has the highest current 
-- inventory? This will help dealerships know 
-- which models are, perhaps, not selling.

SELECT vt.make, vt.model, v.is_sold, v.is_new, vt.vehicle_type_id, COUNT(vt.vehicle_type_id) count_in_inventory 
FROM vehicles v 
JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold = FALSE AND v.is_new = TRUE 
GROUP BY vt.vehicle_type_id, v.is_sold, v.is_new
ORDER BY count_in_inventory DESC
LIMIT 1;

--Seems to be working.