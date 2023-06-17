-- Book 2, Chapter 13, Question #1
-- Create a view that lists all vehicle body types, 
-- makes and models.

CREATE OR REPLACE VIEW veh_types AS
SELECT v.body_type, vmake.make, vmodel.model
FROM vehicletypes vt
JOIN vehiclebodytype v ON vt.vehicle_body_type_id = v.vehicle_body_type_id
JOIN vehiclemake vmake ON vt.vehicle_make_id = vmake.vehicle_make_id
JOIN vehiclemodel vmodel ON vt.vehicle_model_id = vmodel.vehicle_model_id;
SELECT *
FROM veh_types;

-- This had to be updated following the last project. Fixed :)