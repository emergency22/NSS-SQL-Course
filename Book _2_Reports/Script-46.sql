-- Book 2, Chapter 13, Question #1
-- Create a view that lists all vehicle body types, 
-- makes and models.

CREATE VIEW veh_types AS
SELECT vt.body_type, vt.make, vt.model
FROM vehicletypes vt;
SELECT *
FROM veh_types;
