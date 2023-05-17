-- Book 2, Chapter 13, Question #3
--  Create a view that lists all customers without 
-- exposing their emails, phone numbers and street address.

CREATE VIEW customerList AS
	SELECT c.first_name, c.last_name, c.state
	FROM customers c;
SELECT *
FROM customerList;