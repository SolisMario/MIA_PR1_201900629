SELECT sum(cantidad_copias) as cantidad_copias
FROM 
    (SELECT titulo,
         cantidad_copias
    FROM pelicula p
    INNER JOIN inventario i
        ON p.id_pelicula = i.PELICULA_id) sub
WHERE titulo = 'SUGAR WONKA';
--
SELECT  split_part(nombre,' ','1') AS nombre
       ,split_part(nombre,' ','2') AS apellido
       ,(cast(total_pago           AS float))
FROM
(
	SELECT  c.id_cliente
	       ,c.nombre
	       ,COUNT(*)          AS conteo
	       ,SUM(r.monto_pago) AS total_pago
	FROM cliente c
	INNER JOIN renta r
	ON c.id_cliente = r.CLIENTE_id
	GROUP BY  id_cliente
	         ,nombre
) sub
WHERE conteo >= 40;
--
SELECT a.nombre || ' ' || a.apellido AS nombre_actor
FROM actor a
WHERE a.apellido similar to '%(s|S)(o|O)(n|N)%'
ORDER BY  a.nombre asc;
--
SELECT a.nombre,
         a.apellido,
         p.ano_lanzamiento
FROM actor a
INNER JOIN reparto_pelicula r
    ON a.id_actor = r.ACTOR_id
INNER JOIN pelicula p
    ON p.id_pelicula = r.PELICULA_id
WHERE descripcion similar to '%(c|C)(r|R)(o|O)(c|C)(o|O)(d|D)(i|I)(l|L)(e|E)%'
        AND descripcion similar to '%(s|S)(h|H)(a|A)(r|R)(k|K)%'
ORDER BY  apellido asc;
--
SELECT split_part(nombre,
         ' ', '1') AS nombre, paisito AS pais, (conteo / conteo_pais) * 100 AS porcentaje
FROM 
    (SELECT cliente.nombre ,
         COUNT(id_pais) AS conteo_pais ,
         COUNT(id_renta) AS conteo ,
         pais.nombre AS paisito
    FROM cliente
    INNER JOIN renta
        ON cliente.id_cliente = renta.CLIENTE_id
    INNER JOIN ciudad
        ON cliente.CIUDAD_id = ciudad.id_ciudad
    INNER JOIN pais
        ON ciudad.PAIS_id = pais.id_pais
    GROUP BY  pais.nombre ,cliente.nombre )as a
WHERE conteo= 
    (SELECT MAX(conteo)
    FROM 
        (SELECT COUNT(*) AS conteo
        FROM cliente
        INNER JOIN renta
            ON cliente.id_cliente = renta.CLIENTE_id
        GROUP BY  nombre ) b);
--
SELECT nombre_pais,
         conteo_pais,
         nombre_ciudad,
         conteo_ciudad,
         (cast(conteo_ciudad AS float) * 100 / conteo_pais) AS porcentaje_pais
FROM 
    (SELECT pa.id_pais AS ident_pais ,
         COUNT(*) AS conteo_pais
    FROM cliente cli
    INNER JOIN ciudad ciu
        ON ciu.id_ciudad = cli.CIUDAD_id
    INNER JOIN pais pa
        ON pa.id_pais = ciu.PAIS_id
    GROUP BY  ident_pais ) a
INNER JOIN 
    (SELECT p.id_pais AS pais_ident ,
         p.nombre AS nombre_pais ,
         ci.nombre AS nombre_ciudad ,
         COUNT(cl.id_cliente) AS conteo_ciudad
    FROM cliente cl
    INNER JOIN ciudad ci
        ON ci.id_ciudad = cl.CIUDAD_id
    INNER JOIN pais p
        ON p.id_pais = ci.PAIS_id
    GROUP BY  p.id_pais ,p.nombre ,ci.nombre ) b
    ON pais_ident = ident_pais
ORDER BY  nombre_pais asc;
--
SELECT nombre_pais as pais,
         nombre_ciudad as ciudad,
         (cast(round(cast(rentas_ciudad AS decimal) / conteo_ciudades, 2)as float)) as promedio_renta
FROM 
    (SELECT p.nombre AS nombre_pais,
         ci.nombre AS nombre_ciudad,
         count(*) AS rentas_ciudad
    FROM cliente cl
    INNER JOIN renta r
        ON cl.id_cliente = r.CLIENTE_id
    INNER JOIN ciudad ci
        ON ci.id_ciudad = cl.CIUDAD_id
    INNER JOIN pais p
        ON p.id_pais = ci.PAIS_id
    GROUP BY  p.nombre, ci.nombre ) a
INNER JOIN 
    (SELECT p.nombre AS pais_nombre,
         count(*) AS conteo_ciudades
    FROM ciudad c
    INNER JOIN pais p
        ON c.PAIS_id = p.id_pais
    GROUP BY  p.nombre ) b
    ON nombre_pais = pais_nombre;
--
SELECT pais_nombre AS pais,
         (cast(trunc(cast(rentas_sports AS decimal) * 100 / rentas_pais, 2) AS FLOAT)) AS porcentaje_pais
FROM 
    (SELECT p.nombre AS pais_nombre,
         count(*) AS rentas_sports
    FROM cliente c
    INNER JOIN ciudad ci
        ON c.CIUDAD_id = ci.id_ciudad
    INNER JOIN pais p
        ON p.id_pais = ci.PAIS_id
    INNER JOIN renta r
        ON c.id_cliente = r.CLIENTE_id
    INNER JOIN pelicula pe
        ON r.PELICULA_id = pe.id_pelicula
    INNER JOIN categoria_pelicula cape
        ON cape.PELICULA_id = pe.id_pelicula
    INNER JOIN categoria ca
        ON ca.id_categoria = cape.CATEGORIA_id
    WHERE ca.nombre = 'Sports'
    GROUP BY  pais_nombre ) a
INNER JOIN 
    (SELECT p.nombre AS nombre_pais,
         count(*) AS rentas_pais
    FROM cliente c
    INNER JOIN ciudad ci
        ON c.CIUDAD_id = ci.id_ciudad
    INNER JOIN pais p
        ON p.id_pais = ci.PAIS_id
    INNER JOIN renta r
        ON c.id_cliente = r.CLIENTE_id
    GROUP BY  nombre_pais ) b
    ON pais_nombre = nombre_pais
ORDER BY  pais_nombre asc;
--
with ciudades AS 
    (SELECT ci.nombre AS nombre_ciudad,
         count(*) AS rentas_ciudad
    FROM cliente c
    INNER JOIN ciudad ci
        ON c.CIUDAD_id = ci.id_ciudad
    INNER JOIN pais p
        ON p.id_pais = ci.PAIS_id
    INNER JOIN renta r
        ON c.id_cliente = r.CLIENTE_id
    WHERE p.nombre = 'United States'
    GROUP BY  ci.nombre)
SELECT *
FROM ciudades
WHERE rentas_ciudad > 
    (SELECT rentas_ciudad
    FROM ciudades
    WHERE nombre_ciudad = 'Dayton');
--
with rentas_categoria AS 
    (SELECT p.nombre AS nombre_pais,
         ci.nombre AS nombre_ciudad,
         ca.nombre AS nombre_categoria,
         count(*) AS rentas_ciudad
    FROM cliente c
    INNER JOIN ciudad ci
        ON c.CIUDAD_id = ci.id_ciudad
    INNER JOIN pais p
        ON p.id_pais = ci.PAIS_id
    INNER JOIN renta r
        ON c.id_cliente = r.CLIENTE_id
    INNER JOIN pelicula pe
        ON r.PELICULA_id = pe.id_pelicula
    INNER JOIN categoria_pelicula cape
        ON cape.PELICULA_id = pe.id_pelicula
    INNER JOIN categoria ca
        ON ca.id_categoria = cape.CATEGORIA_id
    GROUP BY  nombre_pais, nombre_ciudad, nombre_categoria
    ORDER BY  nombre_pais asc)
SELECT rca.nombre_pais as pais,
         rca.nombre_ciudad as ciudad
FROM rentas_categoria rca
INNER JOIN 
    (SELECT rc.nombre_ciudad,
         MAX(rentas_ciudad) AS maximo
    FROM rentas_categoria rc
    GROUP BY  rc.nombre_ciudad ) AS b
    ON rca.nombre_ciudad = b.nombre_ciudad
WHERE rca.rentas_ciudad = b.maximo
        AND rca.nombre_categoria = 'Horror';