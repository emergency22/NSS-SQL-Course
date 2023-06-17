-- Book 2, Chapter 13, Question #3
--  Create a view that lists all customers without 
-- exposing their emails, phone numbers and street address.

CREATE VIEW customerList AS
	SELECT c.first_name, c.last_name, c.state
	FROM customers c;
SELECT *
FROM customerList;

-- Book 2, Chapter 13, Question #4
-- Create a view named sales2018 that shows the total 
-- number of sales for each sales type for the year 2018.

CREATE OR REPLACE VIEW sales2018 AS
	SELECT st.sales_type_name sale_type, s.sale_id sale_id
	FROM sales s
	JOIN salestypes st USING (sales_type_id)
	WHERE s.purchase_date BETWEEN '2018-01-01' AND '2018-12-31';
SELECT sl.sale_type, COUNT(sl.sale_id)
FROM sales2018 sl
GROUP BY sl.sale_type

-- Book 2, Chapter 13, Question #4
-- Create a view that shows the employee at each dealership 
-- with the most number of sales.

CREATE OR REPLACE VIEW topSalesPeople AS
	SELECT d.business_name, e.first_name || ' ' || e.last_name full_name, COUNT(sale_id) total_sales
	FROM sales s
	JOIN employees e USING (employee_id)
	JOIN dealerships d USING (dealership_id)
	WHERE s.sales_type_id = 1
	GROUP BY d.business_name, full_name
	ORDER BY total_sales DESC;
SELECT *
FROM topSalesPeople;




----------------
--Group Project
----------------

-- #1 Who are the top 5 employees for 
--generating sales income?
SELECT e.first_name, e.last_name, SUM(s.price) totalSalesIncome
FROM sales s
JOIN employees e ON e.employee_id = s.employee_id 
GROUP BY e.first_name, e.last_name 
ORDER BY totalSalesIncome DESC
LIMIT 5;


-- Question #2: 
-- Who are the top 5 dealership for generating sales income?
SELECT d.business_name, SUM(s.price) totalSalesIncome
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY d.business_name 
ORDER BY totalSalesIncome DESC
LIMIT 5;

-- #3 Which vehicle model generated the most sales income?
SELECT vt.make, vt.model, COUNT(s.sale_id) totalSales, SUM(s.price) totalSalesIncome
FROM vehicles v
JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
JOIN sales s ON s.vehicle_id = v.vehicle_id
GROUP BY vt.make, vt.model
ORDER BY totalSalesIncome DESC
LIMIT 1;

-- Top Performance - Question #1
-- Which employees generate the most income per dealership?
WITH employee_salespeople AS
	(
		SELECT
			e.first_name,
			e.last_name,
			de.dealership_id,
			sum(s.price) AS Total_Sales,
      		ROW_NUMBER() OVER(PARTITION BY de.dealership_Id ORDER BY sum(s.price) DESC) as TopEmployee
      	FROM dealershipemployees de
		JOIN employees e ON e.employee_id = de.employee_id
		JOIN sales s ON s.employee_id = de.employee_id
		GROUP BY de.dealership_id, e.first_name, e.last_name
		ORDER BY Total_Sales DESC
	)
	SELECT
		td.business_name,
	    SUM(s.price) AS Money_Made,
	    es.first_name,
	    es.last_name,
	    es.Total_Sales
	FROM dealerships td
	JOIN sales s ON s.dealership_id = td.dealership_id
	INNER JOIN employee_salespeople AS es ON td.dealership_id = es.dealership_id AND TopEmployee = 1
	GROUP BY td.business_name, es.first_name, es.last_name, es.Total_sales, td.dealership_id
	ORDER BY   td.dealership_id, es.Total_Sales DESC

	
	
-- Vehicle Reports - Inventory - Question #1
-- In our Vehicle inventory, show the count of each Model that 
-- is in stock.
	SELECT
	vt.make,
	vt.model,
	count(vt.model) models_in_stock
FROM vehicles v
JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id
	WHERE v.is_sold IS FALSE
GROUP BY vt.make , vt.model
ORDER BY models_in_stock DESC
	
	
-- Vehicle Reports - Inventory - Question #2
-- In our Vehicle inventory, show the count of each Make that 
-- is in stock.
	SELECT 
vt.make, 
COUNT(vt.make) totalInStock
FROM vehicles v
JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold IS FALSE
GROUP BY vt.make;
ORDER BY totalInStock DESC;
	

-- Vehicle Reports - Inventory - Question #3
-- In our Vehicle inventory, show the count of each BodyType 
-- that is in stock.

SELECT vt.body_type, COUNT(vt.body_type) totalOfBodyType
FROM vehicles v
JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id 
WHERE v.is_sold = FALSE 
GROUP BY vt.body_type 
ORDER BY totalOfBodyType DESC;

-- Purchasing Power - Question #1
-- Which US state's customers have the highest average 
-- purchase price for a vehicle?
SELECT
		c.state ,
	round( avg(s.price), 2) avg_vehicle_price
FROM sales s
JOIN customers c ON s.customer_id =c.customer_id
GROUP BY c.state
ORDER BY avg_vehicle_price DESC

-- Purchasing Power - Question #2
-- Now using the data determined above, which 5 states 
-- have the customers with the highest average purchase 
-- price for a vehicle?
SELECT
	c.state ,
		round( avg(s.price), 2) avg_vehicle_price
FROM sales s
JOIN customers c ON s.customer_id =c.customer_id
GROUP BY c.state
ORDER BY avg_vehicle_price DESC
LIMIT 5

