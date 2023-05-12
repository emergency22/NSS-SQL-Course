INSERT INTO public.vehicletypes
(body_type, make, model)
VALUES('Car', 'Tesla', 'Model S');

INSERT INTO public.vehicles
(vin, engine_type, vehicle_type_id, exterior_color, interior_color, floor_price, msr_price, miles_count, year_of_car, is_sold, is_new, dealership_location_id)
VALUES('12VIN1484VIN', '32', '1', '', '', 0, 0, 0, 0, false, false, 0);
