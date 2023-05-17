SELECT d.business_name, 
	COUNT(CASE WHEN st.sales_type_name = 'Purchase' THEN st.sales_type_name END) AS purchases,
	COUNT(CASE WHEN st.sales_type_name = 'Lease' THEN st.sales_type_name END) AS leases
FROM dealerships d 
INNER JOIN sales s ON d.dealership_id = s.dealership_id 
INNER JOIN salestypes st ON s.sales_type_id = st.sales_type_id 
GROUP BY d.business_name 