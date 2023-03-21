CREATE TYPE addr as (address VARCHAR(255), city_id int);
CREATE OR REPLACE FUNCTION get_address_and_city_for_ex1()
RETURNS TABLE (addr text) AS $$
DECLARE
BEGIN
	return QUERY SELECT CONCAT(address, ', ', CAST(city_id as VARCHAR)) from address where address like '%11%' and city_id >= 400 and city_id <= 600;
END;
$$ LANGUAGE plpgsql;


