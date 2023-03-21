CREATE OR REPLACE FUNCTION retrievecustomers(l int, r int)
RETURNS TABLE (customer_id int) AS $$
DECLARE
BEGIN
	IF l >= 0 OR l <= 600 OR r >= 0 OR r <= 600 THEN
		return QUERY SELECT customer.customer_id FROM customer ORDER BY address_id LIMIT (r-l) OFFSET l;
	ELSE	
		RAISE '% %', l, r;
	END IF;
END;
$$ LANGUAGE plpgsql;
