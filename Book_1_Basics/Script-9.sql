SELECT
	c.last_name, c.first_name
FROM
	customers c
WHERE
	LENGTH(c.last_name) > 5 AND LENGTH(c.first_name) <= 7;