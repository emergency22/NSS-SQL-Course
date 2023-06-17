-- Book 3, Chapter 1 (Update), Practice: Employees
/* Kristopher Blumfield an employee of Carnival has 
 * asked to be transferred to a different dealership 
 * location. She is currently at dealership 9. She 
 * would like to work at dealership 20. Update her 
 * record to reflect her transfer. */
SELECT e.first_name, e.last_name, de.dealership_id
FROM employees e
JOIN dealershipemployees de ON de.employee_id = e.employee_id
WHERE e.first_name = 'Kristopher' AND e.last_name = 'Blumfield'

UPDATE dealershipemployees
SET dealership_id = 9
FROM employees WHERE employees.employee_id = dealershipemployees.employee_id
AND employees.first_name = 'Kristopher' AND employees.last_name = 'Blumfield'

--Working :)

-- Book 3, Chapter 1 (Update), Practice: Sales 
/* A Sales associate needs to update a sales record 
 * because her customer want to pay with a Mastercard 
 * instead of JCB. Update Customer, Ernestus Abeau 
 * Sales record which has an invoice number of 
 * 9086714242. */
SELECT c.first_name, c.last_name, s.invoice_number, s.payment_method
FROM sales s
JOIN customers c ON c.customer_id = s.customer_id 
WHERE s.invoice_number = '9086714242';

UPDATE sales 
SET payment_method = 'Mastercard'
WHERE invoice_number = '9086714242';

--Working :)

-- Book 3, Chapter 2 (Delete), Practice - Employees, Question #1
/*  A sales employee at carnival creates a new sales record 
 * for a sale they are trying to close. The customer, last 
 * minute decided not to purchase the vehicle. Help delete 
 * the Sales record with an invoice number of '2436217483'. 
 * */
DELETE FROM sales s 
WHERE s.invoice_number = '2436217483';

-- Book 3, Chapter 2 (Delete), Practice - Employees, Question #2
/* An employee was recently fired so we must delete them from 
 * our database. Delete the employee with employee_id of 35. 
 * What problems might you run into when deleting? How would 
 * you recommend fixing it? */
SELECT *
FROM employees e 
WHERE e.employee_id = '35';

DELETE FROM employees e 
WHERE e.employee_id = '35';

ALTER TABLE dealershipemployees
DROP CONSTRAINT dealershipemployees_employee_id_fkey,
ADD CONSTRAINT dealershipemployees_employee_id_fkey
	FOREIGN KEY (employee_id)
	REFERENCES employees (employee_id)
	ON DELETE CASCADE;

ALTER TABLE sales
DROP CONSTRAINT sales_employee_id_fkey,
ADD CONSTRAINT sales_employee_id_fkey
	FOREIGN KEY (employee_id)
	REFERENCES employees (employee_id)
	ON DELETE CASCADE;

--All working :)

-- Book 3, Chapter 4- Selling a vehicle
/*
Carnival would like to create a stored procedure that 
handles the case of updating their vehicle inventory 
when a sale occurs. They plan to do this by flagging 
the vehicle as is_sold which is a field on the 
Vehicles table. When set to True this flag will 
indicate that the vehicle is no longer available 
in the inventory. Why not delete this vehicle? We 
don't want to delete it because it is attached to 
a sales record. */

CREATE OR REPLACE PROCEDURE updateInventory(vehicleId int)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE vehicles v 
	SET is_sold = TRUE
	WHERE vehicle_id = vehicleId;
END
$$;

CALL updateInventory(1);

SELECT *
FROM vehicles v
WHERE v.vehicle_id = 1;

-- Working!

-- Book 3, Chapter 4- Returning a vehicle
/* Carnival would also like to handle the case 
 * for when a car gets returned by a customer. When 
 * this occurs they must add the car back to the 
 * inventory and mark the original sales record 
 * as sale_returned = TRUE.

Carnival staff are required to do an oil change on 
the returned car before putting it back on the sales 
floor. In our stored procedure, we must also log 
the oil change within the OilChangeLogs table. */

CREATE OR REPLACE PROCEDURE returnVehicle(vehicleId int, timestamp_val timestamptz)
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE sales s
	SET sale_returned = TRUE 
	WHERE vehicle_id = vehicleId;
	INSERT INTO oilchangelogs (date_occured, vehicle_id)
	VALUES  (timestamp_val, vehicleId);
END
$$;

CALL returnVehicle(4, CURRENT_TIMESTAMP);

SELECT *
FROM oilchangelogs;

SELECT *
FROM sales s 
WHERE s.vehicle_id = 4;

--Working :) 


-- Book 3, Chapter 5, Question #1
-- Create a trigger for when a new Sales 
-- record is added, set the purchase date 
-- to 3 days from the current date.

SELECT * FROM sales
WHERE sales_type_id = 1 AND vehicle_id = 1 AND employee_id = 5;

INSERT INTO sales(sales_type_id, vehicle_id, employee_id, customer_id, dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method, sale_returned)
VALUES(1, 1, 5, 1, 1, 1, 1, CURRENT_DATE, CURRENT_DATE, 1, 'Mastercard', False);

CREATE OR REPLACE FUNCTION set_purchase_date()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
AS $$
BEGIN
    NEW.purchase_date := NEW.purchase_date + INTERVAL '3 days';
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER three_days
    BEFORE INSERT ON sales
    FOR EACH ROW
    EXECUTE PROCEDURE set_purchase_date();
   
-- This is working :)

-- Book 3, Chapter 5, Question #1           
/* Create a trigger for updates to the Sales 
 * table. If the pickup date is on or before 
 * the purchase date, set the pickup date to 
 * 7 days after the purchase date. If the 
 * pickup date is after the purchase date 
 * but less than 7 days out from the purchase 
 * date, add 4 additional days to the pickup 
 * date. */
   
SELECT * FROM sales
WHERE sales_type_id = 1 AND vehicle_id = 1 AND employee_id = 8;

INSERT INTO sales(sales_type_id, vehicle_id, employee_id, customer_id, dealership_id, price, deposit, purchase_date, pickup_date, invoice_number, payment_method, sale_returned)
VALUES(1, 1, 8, 1, 1, 1, 1, '2023-07-01', '2023-07-02', 1, 'Mastercard', False);

UPDATE sales 
SET pickup_date = '2023-07-01'
WHERE sales_type_id = 1 AND vehicle_id = 1 AND employee_id = 8;

CREATE OR REPLACE FUNCTION change_the_days()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.pickup_date < NEW.purchase_date OR NEW.pickup_date = NEW.purchase_date THEN
        NEW.pickup_date := NEW.purchase_date + INTERVAL '7 days';
    ELSIF NEW.pickup_date > NEW.purchase_date AND NEW.pickup_date < NEW.purchase_date + INTERVAL '7 days' THEN
        NEW.pickup_date := NEW.pickup_date + INTERVAL '4 days';
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER change_days
	BEFORE UPDATE 
	ON sales
	FOR EACH ROW 
	EXECUTE PROCEDURE change_the_days();

-- WORKING! :)

-- Book 3, Chapter 6, Task #1

SELECT *
FROM dealerships d 
WHERE d.business_name = 'test business';

INSERT INTO dealerships(business_name, phone, city, state, website, tax_id)
VALUES ('test business', '555-555-5555', 'Chattanooga', 'TN', 'http://www.testbiz.com', '12345');

CREATE OR REPLACE FUNCTION enforceWebsiteURL()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    NEW.website := 'http://www.carnivalcars.com/' || REPLACE(NEW.business_name, ' ', '_');
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER dealershipAddedOrEdited
    BEFORE INSERT OR UPDATE
    ON dealerships
    FOR EACH ROW
    EXECUTE PROCEDURE enforceWebsiteURL();
   
   
--IT WORKS!

-- Book 3, Chapter 6, Task #2

SELECT *
FROM dealerships d 
WHERE d.business_name = 'test for no phone';

INSERT INTO dealerships(business_name, phone, city, state, website, tax_id)
VALUES ('test for no phone', null, 'Chattanooga', 'TN', 'http://www.testbiztwo.com', '23456');
   
CREATE OR REPLACE FUNCTION maybeSetDefaultPhone()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.phone IS NULL THEN
        NEW.phone := '777-111-0305';
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER setPhoneNumber
    BEFORE INSERT
    ON dealerships
    FOR EACH ROW
    EXECUTE FUNCTION maybeSetDefaultPhone();

--Its working :)   
   
-- Book 3, Chapter 6, Task #3
   
SELECT *
FROM dealerships d 
WHERE d.business_name = 'test for taxId';

INSERT INTO dealerships(business_name, phone, city, state, website, tax_id)
VALUES ('test for taxId', '777-777-7777', 'Nashville', 'Tennessee', 'http://www.testbizthree.com', '234567');
   
CREATE OR REPLACE FUNCTION addStateToTaxID()
    RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
BEGIN
    NEW.tax_id := NEW.tax_id || '--' || NEW.state;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER setStateOnTaxID
    BEFORE INSERT
    ON dealerships
    FOR EACH ROW
    EXECUTE FUNCTION addStateToTaxID();
   
-- Its working :)
	
-- Book 3, Chapter 7, Task 1: 
-- Add a new role for employees called Automotive Mechanic
-- Add five new mechanics, their data is up to you
-- Each new mechanic will be working at all three of these dealerships: 
-- Meeler Autos of San Diego, Meadley Autos of California 
-- and Major Autos of Florida   [50, 36, 18]
CREATE OR REPLACE PROCEDURE addThoseEmployees()
LANGUAGE plpgsql
AS $$
DECLARE 
	EmployeeTypeId integer;
	EmployeeId integer;
BEGIN
INSERT INTO employeetypes(employee_type_name)
VALUES('Automotive Mechanic')
RETURNING employee_type_id INTO EmployeeTypeId;
COMMIT;
--Insert first employee
INSERT INTO employees(first_name, last_name, email_address, phone, employee_type_id)
VALUES('bob', 'johnson', 'bobj@aol.com', '555-555-5555', EmployeeTypeId)
RETURNING employee_id INTO EmployeeId;
COMMIT;
INSERT INTO dealershipemployees(dealership_id, employee_id)
VALUES('50', EmployeeId);
INSERT INTO dealershipemployees(dealership_id, employee_id)
VALUES('36', EmployeeId);
INSERT INTO dealershipemployees(dealership_id, employee_id)
VALUES('18', EmployeeId);
COMMIT;
--Insert second employee
INSERT INTO employees(first_name, last_name, email_address, phone, employee_type_id)
VALUES('bob', 'smith', 'bobs@aol.com', '555-555-5556', EmployeeTypeId)
RETURNING employee_id INTO EmployeeId;
COMMIT;
INSERT INTO dealershipemployees(dealership_id, employee_id)
VALUES('50', EmployeeId);
INSERT INTO dealershipemployees(dealership_id, employee_id)
VALUES('36', EmployeeId);
INSERT INTO dealershipemployees(dealership_id, employee_id)
VALUES('18', EmployeeId);
COMMIT;
--	('bob', 'grace', 'bobg@aol.com', '555-555-5557', EmployeeTypeId),
--	('bob', 'kilgore', 'bobk@aol.com', '555-555-5558', EmployeeTypeId),
--	('bob', 'newhart', 'bobn@aol.com', '555-555-5559', EmployeeTypeId);    
END;
$$;

--Proof of concept works :). I would now just add the other three employees.

CALL addThoseEmployees();

--testing stuff below
ROLLBACK;

SELECT *
FROM employees e
WHERE e.email_address = 'bobs@aol.com';

SELECT *
FROM dealershipemployees
WHERE employee_id = 1009;

DELETE FROM employees 
WHERE email_address = 'bobj@aol.com' 
	OR email_address = 'bobs@aol.com'
	OR email_address = 'bobg@aol.com'
	OR email_address = 'bobk@aol.com'
	OR email_address = 'bobn@aol.com';

DELETE FROM employeetypes 
WHERE employee_type_name = 'Automotive Mechanic';

DELETE FROM dealershipemployees 
WHERE employee_id = '1007';



-- Book 3, Chapter 7, Task 2:
-- Creating a new dealership in Washington, D.C. called 
-- Felphun Automotive.
-- Hire 3 new employees for the new dealership: Sales Manager, 
-- General Manager and Customer Service.
-- All employees that currently work at Nelsen Autos of 
-- Illinois will now start working at Cain Autos of Missouri instead.   [17, 3]
CREATE OR REPLACE PROCEDURE hireThreeEmployees()
LANGUAGE plpgsql
AS $$
BEGIN
INSERT INTO dealerships(business_name, phone, city, state, website, tax_id)
VALUES('Felphun Automotive', '555-567-7777', 'Columbia', 'TN', 'www.test.com', 'abc123');
COMMIT;
INSERT INTO employees(first_name, last_name, email_address, phone, employee_type_id)
VALUES('bob', 'apple', 'boba@aol.com', '555-444-5555', '3'), 
	('bob', 'orange', 'bobo@aol.com', '555-444-5556', '6'),
	('bob', 'lemon', 'bobl@aol.com', '555-444-5557', '4');
COMMIT;
UPDATE dealershipemployees
SET dealership_id = 3
WHERE dealership_id = 17;
COMMIT;
END;
$$;

CALL hireThreeEmployees();

-- Its working :)

--Testing stuff below
SELECT *
FROM employees
WHERE last_name = 'apple'
	OR last_name = 'orange'
	OR last_name = 'lemon';

SELECT *
FROM dealershipemployees
WHERE dealership_id = 17;

SELECT *
FROM dealerships
WHERE city = 'Columbia';

DELETE FROM employees 
WHERE last_name = 'apple'
	OR last_name = 'orange'
	OR last_name = 'lemon'; 

DELETE FROM dealerships 
WHERE city = 'Columbia';

--Book 3, Chapter 8, Question #1.
/* Adding 5 brand new 2021 Honda CR-Vs to the inventory. They have 
 I4 engines and are classified as a Crossover SUV or CUV. All of 
 them have beige interiors but the exterior colors are Lilac, Dark Red, 
 Lime, Navy and Sand. The floor price is $21,755 and the MSR price 
 is $18,999. */
BEGIN;
INSERT INTO 
COMMIT;


--Book 3, Chapter 8, Question #2.
/* For the CX-5s and CX-9s in the inventory that have not been sold, 
change the year of the car to 2021 since we will be updating our 
stock of Mazdas. For all other unsold Mazdas, update the year to 2020. 
The newer Mazdas all have red and black interiors. */
BEGIN;

COMMIT;

--Book 3,Chapter 8, Question #3.
/* The vehicle with VIN KNDPB3A20D7558809 is about to be returned. 
Carnival has a pretty cool program where it offers the returned 
vehicle to the most recently hired employee at 70% of the cost it 
previously sold for. The most recent employee accepts this offer 
and will purchase the vehicle once it is returned. The employee 
and dealership who sold the car originally will be on the new 
sales transaction.   */
BEGIN;

COMMIT;

------------------------------------------------------------------

create table accountsreceivable (
	accountsreceivable_id SERIAL primary key,
	credit_amount int,
	debit_amount int,
	date_received date,
	sale_id int references sales (sale_id)
)


CREATE or replace FUNCTION add_accountsreceivable()
 RETURNS TRIGGER
 LANGUAGE PlPGSQL
AS $$
BEGIN
 -- trigger function logic
 insert into accountsreceivable (credit_amount, date_received, sale_id)
 values (NEW.deposit, NEW.purchase_date, NEW.sale_id);
  RETURN NEW;
END;
$$

create or replace TRIGGER new_sale_made
 AFTER INSERT
 ON sales
 FOR EACH ROW
 EXECUTE PROCEDURE add_accountsreceivable();



CREATE or replace FUNCTION add_returned_accountsreceivable()
 RETURNS TRIGGER
 LANGUAGE PlPGSQL
AS $$
BEGIN
 -- trigger function logic
	if new.sale_returned = true then
	  insert into accountsreceivable (debit_amount, date_received, sale_id)
	  values (NEW.deposit, NOW(), NEW.sale_id);
 	end if;
 RETURN NEW;
END;
$$

create or replace TRIGGER new_return_made
 AFTER UPDATE
 ON sales
 FOR EACH ROW
 EXECUTE PROCEDURE add_returned_accountsreceivable();
 




CREATE OR REPLACE PROCEDURE hireNewEmployee(IN dealershipId1 INT, IN dealershipId2 INT)
LANGUAGE plpgsql
AS $$
DECLARE 
	EmployeeId integer;
BEGIN
	--Add a new record for the employee in the Employees table and 
INSERT INTO employees(first_name, last_name, email_address, phone, employee_type_id)
VALUES ('bob', 'tree', 'bobp@aol.com', '555-444-5555', '3')
RETURNING employee_id INTO EmployeeId;
COMMIT;
	--add a record to the Dealershipemployees table for the two dealerships the new employee will start at
INSERT INTO dealershipemployees (dealership_id, employee_id)
VALUES (dealershipId1, EmployeeId);
COMMIT;
INSERT INTO dealershipemployees (dealership_id, employee_id)
VALUES (dealershipId2, EmployeeId);
COMMIT;	
END;
$$;

CALL hireNewEmployee(1, 2);

SELECT *
FROM employees
WHERE last_name = 'tree';

SELECT * FROM
dealershipemployees
WHERE employee_id = '1020';






CREATE OR REPLACE PROCEDURE dismissedEmployee(IN dismissed_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
	ALTER TABLE dealershipemployees
	DROP CONSTRAINT dealershipemployees_employee_id_fkey,
	ADD CONSTRAINT dealershipemployees_employee_id_fkey
		FOREIGN KEY (employee_id)
		REFERENCES employees (employee_id)
		ON DELETE CASCADE;
	
	ALTER TABLE sales
	DROP CONSTRAINT sales_employee_id_fkey,
	ADD CONSTRAINT sales_employee_id_fkey
		FOREIGN KEY (employee_id)
		REFERENCES employees (employee_id)
		ON DELETE CASCADE;
	DELETE FROM employees
	WHERE employee_id = dismissed_id;
	
END;
$$;

CALL dismissedEmployee(3)





