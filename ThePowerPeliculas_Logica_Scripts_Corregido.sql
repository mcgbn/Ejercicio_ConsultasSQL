--1. Crea el esquema de la BBDD. 
	--png disponible en github

--2. Muestra los nombres de todas las películas con una clasificación por
--edades de ‘R’.
SELECT "title", "rating"
FROM "film"
WHERE "rating" ='R';
--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30
--y 40.

SELECT concat("first_name", ' ' ,"last_name") AS "complete_actor_name"
FROM actor a
WHERE "actor_id" >30 AND "actor_id" <40;

-- query sin concat

SELECT "first_name","last_name"
FROM actor a
WHERE "actor_id" >30 AND "actor_id" <40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.
SELECT film_id, title, language_id, original_language_id 
FROM film
WHERE language_id = original_language_id;

--5. Ordena las películas por duración de forma ascendente.
SELECT "title", "length"
FROM film f 
ORDER BY "length" ASC;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su
--apellido.
SELECT "first_name", "last_name" 
FROM actor a
WHERE "last_name" = 'ALLEN';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla
--“film” y muestra la clasificación junto con el recuento.
SELECT count ("film_id"), "rating"
FROM film
GROUP BY "rating";


SELECT "title", "rating", "length"
FROM film
WHERE "rating" = 'PG-13'
OR "length" > 180;

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
--duración mayor a 3 horas en la tabla film.
SELECT "title", "rating", "length"
FROM film
WHERE "rating" = 'PG-13' OR "length" > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT VARIANCE(replacement_cost) AS variabilidad_replacement_cost
FROM film;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
--menor duracion
select "length"
from film f
order by "length" asc
limit 1;

-- mayor duracion
select "length"
from film f
order by "length" desc
limit 1;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT p.amount, r.rental_date
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
ORDER BY r.rental_date DESC
OFFSET 2
LIMIT 1;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-
--17’ ni ‘G’ en cuanto a su clasificación.
SELECT "title", "rating"
FROM film f
WHERE "rating" NOT IN ('NC-17', 'G')

--13. Encuentra el promedio de duración de las películas para cada
--clasificación de la tabla film y muestra la clasificación junto con el
--promedio de duración.
SELECT "rating", round(avg("length"),0) as duracion_media
FROM film f
GROUP BY "rating";

--14. Encuentra el título de todas las películas que tengan una duración mayor
--a 180 minutos.
SELECT "title", "length"
FROM film f 
WHERE "length">180;

--15. ¿Cuánto dinero ha generado en total la empresa?
SELECT SUM(amount) AS dinero_generado
FROM payment p;

--16. Muestra los 10 clientes con mayor valor de id.
SELECT *
FROM customer c
ORDER BY customer_id DESC
LIMIT 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la
--película con título ‘Egg Igby’.

SELECT f."title", a."first_name",a."last_name"
FROM "film_actor" AS "fa"
INNER JOIN "film" AS "f"
ON "fa"."film_id" = "f"."film_id"
INNER  JOIN "actor" AS a
ON fa."actor_id" = a."actor_id"
WHERE f.title='EGG IGBY';

--18. Selecciona todos los nombres de las películas únicos.
SELECT COUNT(distinct("title"))
FROM film f;


--19. Encuentra el título de las películas que son comedias y tienen una
--duración mayor a 180 minutos en la tabla “film”.
SELECT f."title",f."length", c."name" AS "film_category"
FROM "film" AS f
INNER JOIN film_category AS fc 
ON f."film_id"= fc."film_id"
INNER JOIN "category" c
ON fc."category_id"=c."category_id"
WHERE c.name = 'Comedy'
AND f.length > 180;

--20. Encuentra las categorías de películas que tienen un promedio de
--duración superior a 110 minutos y muestra el nombre de la categoría
--junto con el promedio de duración.
--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 
--110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name AS category_name, AVG(f.length) AS avg_duration
FROM film f
JOIN film_category AS fc
ON f.film_id = fc.film_id
JOIN category AS c
ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

--21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(return_date - rental_date) AS avg_rental_time
FROM rental

--22. Crea una columna con el nombre y apellidos de todos los actores y
--actrices.
SELECT DISTINCT CONCAT( first_name,' ', last_name) AS full_name
FROM actor
ORDER BY full_name ASC;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de
--forma descendente.
SELECT DATE(r.rental_date) AS fecha_alquiler, COUNT(*) AS total_alquileres
FROM rental r
GROUP BY DATE(r.rental_date)
ORDER BY total_alquileres DESC;

--24. Encuentra las películas con una duración superior al promedio.
SELECT title, length
FROM film
WHERE length>
(SELECT AVG(length)
FROM film)
ORDER BY length;

--25. Averigua el número de alquileres registrados por mes.
SELECT 
  TO_CHAR(r.rental_date, 'YYYY-MM') AS month,
  COUNT(*) AS total_rentals
FROM rental r
GROUP BY month
ORDER BY month;

--26. Encuentra el promedio, la desviación estándar y varianza del total
--pagado.
SELECT AVG (amount),STDDEV (amount), VARIANCE (amount)
FROM payment;

--27. ¿Qué películas se alquilan por encima del precio medio?
SELECT title, rental_rate
FROM film
WHERE rental_rate > (
  SELECT AVG(rental_rate)
  FROM film)

--28. Muestra el id de los actores que hayan participado en más de 40
--películas.
SELECT fa.actor_id 
FROM film AS f
INNER JOIN film_actor AS fa 
ON f.film_id=fa.film_id
GROUP BY fa.actor_id 
HAVING COUNT(fa.film_id)>40;

--29. Obtener todas las películas y, si están disponibles en el inventario,
--mostrar la cantidad disponible.

SELECT f.title , COUNT (f.title)
FROM film AS f 
LEFT JOIN inventory AS i 
ON f.film_id = i.film_id
LEFT JOIN rental AS r 
ON i.inventory_id = r.inventory_id 
WHERE r.return_date IS NULL
GROUP BY f.title ;

--30. Obtener los actores y el número de películas en las que ha actuado.
SELECT fa.actor_id, concat(a.first_name,' ', a.last_name) AS actor_full_name, count(f.film_id) AS n_peliculas
FROM film AS f
INNER JOIN film_actor AS fa 
ON f.film_id=fa.film_id
INNER JOIN actor AS a 
ON a.actor_id= fa.actor_id
WHERE fa.actor_id IS NOT NULL
GROUP BY fa.actor_id, a.first_name, a.last_name ;

--31. Obtener todas las películas y mostrar los actores que han actuado en
--ellas, incluso si algunas películas no tienen actores asociados.
SELECT f.film_id , f.title, fa.actor_id, concat(a.first_name,' ', a.last_name) 
FROM film AS f
LEFT JOIN film_actor AS fa 
ON f.film_id=fa.film_id
LEFT JOIN actor AS a 
ON a.actor_id= fa.actor_id
ORDER BY f.film_id, fa.actor_id, a.first_name, a.last_name;

--32. Obtener todos los actores y mostrar las películas en las que han
--actuado, incluso si algunos actores no han actuado en ninguna película.
SELECT  fa.actor_id, concat(a.first_name,' ', a.last_name) AS actor_full_name, f.film_id , f.title
FROM actor AS a
LEFT JOIN film_actor AS fa 
ON a.actor_id= fa.actor_id
LEFT JOIN film AS f 
ON fa.film_id = f.film_id
ORDER BY fa.actor_id;

---33. Obtener todas las películas que tenemos y todos los registros de
--alquiler.
SELECT f.title, r.*
FROM film AS f
LEFT JOIN inventory AS i
ON f.film_id= i.film_id
LEFT JOIN rental AS r
ON i.inventory_id=r.inventory_id; 

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT sum(p.amount) AS total_amount, CONCAT (c.first_name, ' ', c.last_name)
FROM customer AS c 
INNER JOIN rental AS r 
ON c.customer_id = r.customer_id 
INNER JOIN payment AS p 
ON 	r.rental_id=p.rental_id
GROUP BY c.first_name, c.last_name
ORDER BY total_amount DESC
LIMIT 5; 

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT *
FROM actor AS a 
WHERE a.first_name='JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como
--Apellido.
SELECT first_name AS Nombre, last_name AS Apellido
FROM actor AS a 
WHERE a.first_name='JOHNNY';

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT MIN (actor_id), MAX(actor_id) 
FROM actor AS a ;

--38. Cuenta cuántos actores hay en la tabla “actor”.
SELECT count(actor_id) 
FROM actor AS a ;

--39. Selecciona todos los actores y ordénalos por apellido en orden
--ascendente.
SELECT *
FROM actor AS a
ORDER BY last_name ASC;

--40. Selecciona las primeras 5 películas de la tabla “film”.
SELECT *
FROM film AS f 
LIMIT 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
--mismo nombre. ¿Cuál es el nombre más repetido?
SELECT COUNT(a.first_name) AS cantidad, a.first_name 
FROM actor AS a 
GROUP BY a.first_name
ORDER BY cantidad DESC;

--¿Cuál es el nombre más repetido?
SELECT COUNT(a.first_name) AS cantidad, a.first_name 
FROM actor AS a 
GROUP BY a.first_name
ORDER BY cantidad DESC
LIMIT 3;

--42. Encuentra todos los alquileres y los nombres de los clientes que los
--realizaron.

SELECT r.rental_id, c.first_name ,c.last_name
FROM customer AS c 
INNER JOIN rental AS r 
ON c.customer_id=r.customer_id;  

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo
--aquellos que no tienen alquileres.
SELECT c.first_name, c.last_name, r.rental_id,  c.active  
FROM customer AS c 
LEFT JOIN rental AS r 
ON c.customer_id=r.customer_id;  

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
--esta consulta? ¿Por qué? Deja después de la consulta la contestación.
SELECT *
FROM film AS f
CROSS JOIN category AS c;


--Esta consulta no aporta valor, ya que
--en la misma película da todas las categoríasdisponibles, 
--sin saber realmente a qué categoría pertenece

--45. Encuentra los actores que han participado en películas de la categoría
'Action'.
SELECT a.first_name, a.last_name, c.name AS Genero
FROM film_actor AS fa 
INNER JOIN film AS f 
ON fa.film_id=f.film_id
INNER JOIN actor AS a 
ON a.actor_id=fa.actor_id
INNER JOIN film_category AS fc
ON fc.film_id=f.film_id
INNER JOIN category AS c 
ON fc.category_id =c.category_id
WHERE c."name" = 'Action';

--46. Encuentra todos los actores que no han participado en películas.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

--47. Selecciona el nombre de los actores y la cantidad de películas en las
--que han participado.
SELECT a.first_name, a.last_name, count(fa.film_id) AS "Numero Peliculas"
FROM film_actor AS fa 
INNER JOIN film AS f 
ON fa.film_id=f.film_id
INNER JOIN actor AS a 
ON a.actor_id=fa.actor_id
GROUP BY a.first_name, a.last_name, fa.actor_id ;


--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
--de los actores y el número de películas en las que han participado.
CREATE VIEW actor_num_peliculas AS
SELECT a.first_name, a.last_name, count(fa.film_id) AS "Numero Peliculas"
FROM film_actor AS fa 
INNER JOIN film AS f 
ON fa.film_id=f.film_id
INNER JOIN actor AS a 
ON a.actor_id=fa.actor_id
GROUP BY a.actor_id;

--49. Calcula el número total de alquileres realizados por cada cliente.
SELECT c.customer_id, c.first_name, c.last_name, count (r.rental_id) AS "Cantidad Alquiler"
FROM customer AS c 
LEFT JOIN rental AS r 
ON c.customer_id =r.customer_id
GROUP BY c.customer_id
ORDER BY "Cantidad Alquiler" DESC;

--50. Calcula la duración total de las películas en la categoría 'Action'.
SELECT SUM(f.length), c.name AS Genero
FROM film AS f
INNER JOIN film_category AS fc
ON fc.film_id=f.film_id
INNER JOIN category AS c 
ON fc.category_id =c.category_id
WHERE c.name = 'Action'
GROUP BY c.name;

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
--almacenar el total de alquileres por cliente.
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT COUNT(r.rental_id) AS "Total Alquileres", concat(c.first_name,' ', c.last_name) AS client_full_name
FROM rental AS r 
LEFT JOIN customer AS c 
ON r.customer_id=c.customer_id
GROUP BY c.customer_id

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
--películas que han sido alquiladas al menos 10 veces.
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT COUNT(r.rental_id) AS películas_alquiladas, f.title
FROM rental AS r 
LEFT JOIN inventory AS i 
ON r.inventory_id=i.inventory_id
LEFT JOIN film AS f 
ON i.film_id=f.film_id
GROUP BY  f.title
HAVING COUNT(r.rental_id) >= 10;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente
--con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
--los resultados alfabéticamente por título de película.
SELECT f.title
FROM rental AS r 
INNER JOIN customer AS c 
ON r.customer_id=c.customer_id
INNER JOIN inventory AS i 
ON r.inventory_id=i.inventory_id
INNER JOIN film AS f 
ON i.film_id=f.film_id
WHERE 
	c.first_name = 'TAMMY'
	AND c.last_name ='SANDERS'
	AND r.return_date IS NULL
ORDER BY f.title ASC;


--54. Encuentra los nombres de los actores que han actuado en al menos una
---película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
--alfabéticamente por apellido.
SELECT DISTINCT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa 
ON a.actor_id=fa.actor_id 
INNER JOIN film AS f
ON fa.film_id=f.film_id
INNER JOIN film_category AS fc 
ON f.film_id=fc.film_id
INNER JOIN category AS c
ON fc.category_id=c.category_id 
WHERE c.name = 'Sci-Fi'
ORDER BY last_name ASC, first_name ASC;


--55. Encuentra el nombre y apellido de los actores que han actuado en
--películas que se alquilaron después de que la película ‘Spartacus
--Cheaper’ se alquilara por primera vez. Ordena los resultados
--alfabéticamente por apellido.
SELECT DISTINCT a.first_name ,a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa 
ON a.actor_id=fa.actor_id 
INNER JOIN film AS f
ON fa.film_id=f.film_id
INNER JOIN film_category AS fc 
ON f.film_id=fc.film_id
INNER JOIN inventory AS i 
ON f.film_id=i.film_id
INNER JOIN rental AS r 
ON i.inventory_id=r.inventory_id
WHERE r.rental_date > 
(SELECT MIN (r.rental_date)
FROM actor AS a
INNER JOIN film_actor AS fa 
ON a.actor_id=fa.actor_id 
INNER JOIN film AS f
ON fa.film_id=f.film_id
INNER JOIN film_category AS fc 
ON f.film_id=fc.film_id
INNER JOIN inventory AS i 
ON f.film_id=i.film_id
INNER JOIN rental AS r 
ON i.inventory_id=r.inventory_id
WHERE f.title ='SPARTACUS CHEAPER')
ORDER BY a.last_name ASC;

--56. Encuentra el nombre y apellido de los actores que no han actuado en
--ninguna película de la categoría ‘Music’.
SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f
    ON fa.film_id = f.film_id
    JOIN film_category fc
    ON f.film_id = fc.film_id
    JOIN category c
    ON fc.category_id = c.category_id
    WHERE fa.actor_id = a.actor_id
    AND c.name = 'Music'
)
ORDER BY a.last_name ASC, a.first_name ASC;

--57. Encuentra el título de todas las películas que fueron alquiladas por más
--de 8 días.
SELECT DISTINCT f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days';


--58. Encuentra el título de todas las películas que son de la misma categoría
--que ‘Animation’.
SELECT f.title 
FROM film AS f 
	LEFT JOIN film_category AS fc 
	ON f.film_id=fc.film_id 
	LEFT JOIN category AS c 
	ON fc.category_id=c.category_id 
	WHERE c.name= 'Animation'

--59. Encuentra los nombres de las películas que tienen la misma duración
--que la película con el título ‘Dancing Fever’. Ordena los resultados
--alfabéticamente por título de película.
SELECT f.title
FROM film AS f 
WHERE length=(
SELECT length
FROM film
WHERE title = 'DANCING FEVER')
ORDER BY title;
	
	
--60. Encuentra los nombres de los clientes que han alquilado al menos 7
--películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT c.first_name, c.last_name
FROM customer AS c 
LEFT JOIN rental AS r 
ON c.customer_id=r.customer_id 
LEFT JOIN inventory AS i 
ON r.inventory_id=i.inventory_id 
LEFT JOIN film AS f 
ON i.film_id=f.film_id 
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT f.film_id) >= 7

--61. Encuentra la cantidad total de películas alquiladas por categoría y
--muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT c.name, COUNT(r.rental_id) AS Recuento_Alquileres
FROM rental AS r 
LEFT JOIN inventory AS i 
ON r.inventory_id=i.inventory_id 
LEFT JOIN film AS f 
ON i.film_id=f.film_id 
LEFT JOIN film_category AS fc 
ON f.film_id =fc.film_id 
LEFT JOIN category AS c
ON c.category_id=fc.category_id 
GROUP BY c.name;

--62. Encuentra el número de películas por categoría estrenadas en 2006.
SELECT  c.name AS category, COUNT(f.film_id) AS film_number
FROM film AS f
LEFT JOIN film_category AS fc 
ON f.film_id =fc.film_id 
LEFT JOIN category AS c
ON c.category_id=fc.category_id 
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY film_number DESC;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
--que tenemos.
SELECT *
FROM staff AS s 
CROSS JOIN store AS s2

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y
--muestra el ID del cliente, su nombre y apellido junto con la cantidad de
--películas alquiladas.
SELECT COUNT(r.rental_id) AS cantidad_alquileres, c.customer_id ,c.first_name ,c.last_name 
FROM customer AS c
LEFT JOIN rental AS r 
ON C.customer_id=r.customer_id
GROUP BY c.customer_id ,c.first_name ,c.last_name
ORDER BY cantidad_alquileres DESC;