-- create three tables, populate those tables with relevant info

CREATE TABLE VehicleBodyType(
	vehicle_body_type_id SERIAL PRIMARY KEY,
	name VARCHAR(20)
);

CREATE TABLE VehicleModel(
	vehicle_model_id SERIAL PRIMARY KEY,
	name VARCHAR(20)
);

CREATE TABLE VehicleMake(
	vehicle_make_id SERIAL PRIMARY KEY,
	name VARCHAR(20)
);


INSERT INTO VehicleBodyType (name)
SELECT DISTINCT body_type
FROM vehicletypes;

INSERT INTO VehicleModel (name)
SELECT DISTINCT model
FROM vehicletypes;

INSERT INTO VehicleMake (name)
SELECT DISTINCT make
FROM vehicletypes;




UPDATE vehicletypes 
SET body_type = CASE WHEN body_type IN (SELECT name FROM vehiclebodytype) THEN (SELECT vehicle_body_type_id
FROM vehiclebodytype 
WHERE body_type = vehiclebodytype.name) 
END;

UPDATE vehicletypes 
SET make = CASE WHEN make IN (SELECT name FROM vehiclemake) THEN (SELECT vehicle_make_id
FROM vehiclemake
WHERE make = vehiclemake.name) 
END;

UPDATE vehicletypes 
SET model = CASE WHEN model IN (SELECT name FROM vehiclemodel) THEN (SELECT vehicle_model_id
FROM vehiclemodel
WHERE model = vehiclemodel.name) 
END;






ALTER TABLE vehicletypes
ADD vehicle_body_type_id INT;
UPDATE vehicletypes
SET vehicle_body_type_id = CAST(body_type AS INT);
ALTER TABLE vehicletypes 
ADD vehicle_make_id INT;
UPDATE vehicletypes 
SET vehicle_make_id = CAST(make AS INT);
ALTER TABLE vehicletypes 
ADD vehicle_model_id INT;
UPDATE vehicletypes 
SET vehicle_model_id = CAST(model AS INT);

ALTER TABLE vehicletypes
DROP COLUMN body_type;
ALTER TABLE vehicletypes
DROP COLUMN make;
ALTER TABLE vehicletypes
DROP COLUMN model;

ALTER TABLE vehiclemake
RENAME COLUMN name TO make;
ALTER TABLE vehiclemodel
RENAME COLUMN name TO model;
ALTER TABLE vehiclebodytype
RENAME COLUMN name TO body_type;

 
-- ALTER TABLE child_table 
--  ADD CONSTRAINT constraint_name 
--  FOREIGN KEY (fk_columns) 
--  REFERENCES parent_table (parent_key_columns);

ALTER TABLE vehicletypes
  ADD CONSTRAINT vehiclebodytype_body_type_id_fkey
  FOREIGN KEY (vehicle_body_type_id) --
  REFERENCES vehiclebodytype (vehicle_body_type_id);
 
 ALTER TABLE vehicletypes 
  ADD CONSTRAINT vehiclemake_vehicle_make_id_fkey 
  FOREIGN KEY (vehicle_make_id) 
  REFERENCES vehiclemake (vehicle_make_id);
 
 ALTER TABLE vehicletypes 
  ADD CONSTRAINT vehiclemodel_vehicle_model_id_fkey 
  FOREIGN KEY (vehicle_model_id) 
  REFERENCES vehiclemodel (vehicle_model_id);
