SELECT t.body_type, t.make, t.model
FROM vehicletypes t
JOIN vehicles v
ON v.vehicle_type_id = t.vehicle_type_id;