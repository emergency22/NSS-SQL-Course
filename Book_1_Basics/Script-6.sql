SELECT
	c.last_name, c.first_name, c.city, c.state
FROM
	customers c
WHERE
	c.state = 'TX' OR c.state = 'TN';