-- query
SELECT film.title FROM film INNER JOIN film_category ON film.film_id=film_category.film_id INNER JOIN category ON film_category.category_id=category.category_id WHERE (film.rating='R' OR film.rating='PG-13') AND (category.name='Horror' OR category.name='Sci-Fi') AND film.film_id NOT IN (SELECT DISTINCT film.film_id FROM film INNER JOIN inventory ON film.film_id=inventory.film_id INNER JOIN rental ON inventory.inventory_id=rental.inventory_id);

-- explain analyze
EXPLAIN ANALYZE SELECT film.title FROM film INNER JOIN film_category ON film.film_id=film_category.film_id INNER JOIN category ON film_category.category_id=category.category_id WHERE (film.rating='R' OR film.rating='PG-13') AND (category.name='Horror' OR category.name='Sci-Fi') AND film.film_id NOT IN (SELECT DISTINCT film.film_id FROM film INNER JOIN inventory ON film.film_id=inventory.film_id INNER JOIN rental ON inventory.inventory_id=rental.inventory_id);
--EXPLAIN ANALYZE SELECT film.film_id FROM film INNER JOIN film_category ON film.film_id=film_category.film_id INNER JOIN category ON film_category.category_id=category.category_id INNER JOIN inventory ON film.film_id=inventory.film_id WHERE (film.rating='R' OR film.rating='PG-13') AND (category.name='Horror' OR category.name='Sci-Fi') AND NOT EXISTS (SELECT rental.inventory_id FROM rental WHERE rental.inventory_id=inventory.inventory_id);

SELECT store.store_id FROM store
INNER JOIN
(
	SELECT store.store_id, SUM(payment.amount) AS total FROM store
	INNER JOIN inventory ON inventory.store_id=store.store_id
	INNER JOIN rental ON rental.inventory_id=inventory.inventory_id
	INNER JOIN payment ON payment.rental_id=rental.rental_id
	GROUP BY store.store_id
) subq2 ON subq2.store_id=store.store_id
INNER JOIN address ON address.address_id=store.address_id
INNER JOIN city ON city.city_id=address.city_id WHERE (subq2.total, city.city_id) IN
(
	SELECT MAX(subq.total), city.city_id FROM (
		SELECT store.store_id, SUM(payment.amount) AS total FROM store
		INNER JOIN inventory ON inventory.store_id=store.store_id
		INNER JOIN rental ON rental.inventory_id=inventory.inventory_id
		INNER JOIN payment ON payment.rental_id=rental.rental_id
		GROUP BY store.store_id
	) AS subq
	INNER JOIN store ON store.store_id=subq.store_id
	INNER JOIN address ON address.address_id=store.address_id
	INNER JOIN city ON city.city_id=address.city_id GROUP BY city.city_id
);

EXPLAIN ANALYZE SELECT store.store_id FROM store
INNER JOIN
(
	SELECT store.store_id, SUM(payment.amount) AS total FROM store
	INNER JOIN inventory ON inventory.store_id=store.store_id
	INNER JOIN rental ON rental.inventory_id=inventory.inventory_id
	INNER JOIN payment ON payment.rental_id=rental.rental_id
	GROUP BY store.store_id
) subq2 ON subq2.store_id=store.store_id
INNER JOIN address ON address.address_id=store.address_id
INNER JOIN city ON city.city_id=address.city_id WHERE (subq2.total, city.city_id) IN
(
	SELECT MAX(subq.total), city.city_id FROM (
		SELECT store.store_id, SUM(payment.amount) AS total FROM store
		INNER JOIN inventory ON inventory.store_id=store.store_id
		INNER JOIN rental ON rental.inventory_id=inventory.inventory_id
		INNER JOIN payment ON payment.rental_id=rental.rental_id
		GROUP BY store.store_id
	) AS subq
	INNER JOIN store ON store.store_id=subq.store_id
	INNER JOIN address ON address.address_id=store.address_id
	INNER JOIN city ON city.city_id=address.city_id GROUP BY city.city_id
);
