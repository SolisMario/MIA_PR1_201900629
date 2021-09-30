--llenado tabla clasificacion_pelicula 
INSERT INTO clasificacion_pelicula (nombre)
SELECT DISTINCT CLASIFICACION
FROM temporal
WHERE CLASIFICACION IS NOT NULL;

--llenado tabla pelicula 
INSERT INTO pelicula (titulo, descripcion, ano_lanzamiento, duracion, costo_renta, dias_renta, recargo_dano, CLASIFICACION_id)
SELECT DISTINCT NOMBRE_PELICULA,
         DESCRIPCION_PELICULA,
         ANO_LANZAMIENTO,
         DURACION,
         COSTO_RENTA,
         DIAS_RENTA,
         COSTO_POR_DANO,
         id_clasificacion
FROM temporal
INNER JOIN clasificacion_pelicula
    ON CLASIFICACION = nombre
WHERE NOMBRE_PELICULA IS NOT NULL;

--llenado tabla actor 
INSERT INTO actor (nombre, apellido)
SELECT DISTINCT SPLIT_PART(ACTOR_PELICULA,
        ' ','1'), SPLIT_PART(ACTOR_PELICULA,' ','2')
FROM temporal
WHERE ACTOR_PELICULA IS NOT NULL;

--llenado tabla reparto_pelicula 
INSERT INTO reparto_pelicula (PELICULA_id, ACTOR_id)
SELECT DISTINCT id_pelicula,
         id_actor
FROM temporal
INNER JOIN actor a
    ON ACTOR_PELICULA = a.nombre || ' ' || a.apellido
INNER JOIN pelicula p
    ON NOMBRE_PELICULA = p.titulo
WHERE NOMBRE_PELICULA IS NOT NULL
        AND ACTOR_PELICULA IS NOT NULL;

--llenado tabla idioma 
INSERT INTO idioma (nombre)
SELECT DISTINCT LENGUAJE_PELICULA
FROM temporal
WHERE LENGUAJE_PELICULA IS NOT NULL;

--llenado tabla doblaje_pelicula 
INSERT INTO doblaje_pelicula (PELICULA_id, IDIOMA_id)
SELECT DISTINCT id_pelicula,
        id_idioma
FROM temporal
INNER JOIN pelicula p
    ON NOMBRE_PELICULA = p.titulo
INNER JOIN idioma i
    ON LENGUAJE_PELICULA = i.nombre
WHERE NOMBRE_PELICULA IS NOT NULL
        AND LENGUAJE_PELICULA IS NOT NULL;

--lenado tabla categoria
INSERT INTO categoria (nombre)
SELECT DISTINCT CATEGORIA_PELICULA
FROM temporal
WHERE CATEGORIA_PELICULA IS NOT NULL;

--llenado tabla categoria_pelicula 
INSERT INTO categoria_pelicula (PELICULA_id, CATEGORIA_id)
SELECT DISTINCT id_pelicula,
        id_categoria
FROM temporal
INNER JOIN pelicula p
    ON NOMBRE_PELICULA = p.titulo
INNER JOIN categoria c
    ON CATEGORIA_PELICULA = c.nombre
WHERE NOMBRE_PELICULA IS NOT NULL
        AND CATEGORIA_PELICULA IS NOT NULL;

--llenado tabla pais 
INSERT INTO pais (nombre)
SELECT DISTINCT NOMBRE
FROM 
    (SELECT DISTINCT PAIS_CLIENTE AS NOMBRE
    FROM temporal
    UNION
    SELECT DISTINCT PAIS_EMPLEADO AS NOMBRE
    FROM temporal
    UNION
    SELECT DISTINCT PAIS_TIENDA AS NOMBRE
    FROM temporal ) sub
WHERE NOMBRE IS NOT NULL;

--llenado tabla ciudad
INSERT INTO ciudad (nombre, PAIS_id)
SELECT DISTINCT NOMBRE,
        id_pais
FROM 
    (SELECT DISTINCT CIUDAD_CLIENTE AS NOMBRE,
        id_pais
    FROM temporal
    INNER JOIN pais
        ON PAIS_CLIENTE = nombre
    UNION
    SELECT DISTINCT CIUDAD_EMPLEADO AS NOMBRE,
        id_pais
    FROM temporal
    INNER JOIN pais
        ON PAIS_EMPLEADO = nombre
    UNION
    SELECT DISTINCT CIUDAD_TIENDA AS NOMBRE,
        id_pais
    FROM temporal
    INNER JOIN pais
        ON PAIS_TIENDA = nombre ) AS sub
WHERE NOMBRE IS NOT NULL;

--llenado de tabla tienda 
INSERT INTO tienda (nombre, direccion, CIUDAD_id)
SELECT DISTINCT NOMBRE_TIENDA,
        DIRECCION_TIENDA,
        id_ciudad
FROM temporal
INNER JOIN ciudad
    ON CIUDAD_TIENDA = nombre
WHERE NOMBRE_TIENDA IS NOT NULL;

--llenado tabla inventario 
INSERT INTO inventario (TIENDA_id, PELICULA_id, cantidad_copias)
SELECT DISTINCT id_tienda,
        id_pelicula,
        COUNT(*)
FROM temporal
INNER JOIN tienda
    ON TIENDA_PELICULA = tienda.nombre
INNER JOIN pelicula
    ON NOMBRE_PELICULA = pelicula.titulo
GROUP BY  id_tienda, id_pelicula;

-- llenado tabla cliente 
INSERT INTO CLIENTE (nombre, direccion, correo, fecha_registro, cliente_activo, codigo_postal, CIUDAD_id, TIENDA_id)
SELECT DISTINCT NOMBRE_CLIENTE,
        DIRECCION_CLIENTE,
        CORREO_CLIENTE,
        FECHA_CREACION,
        CLIENTE_ACTIVO,
        CODIGO_POSTAL_CLIENTE,
        id_ciudad,
        id_tienda
FROM temporal
INNER JOIN ciudad
    ON CIUDAD_CLIENTE = ciudad.nombre
INNER JOIN tienda
    ON TIENDA_PREFERIDA = tienda.nombre
INNER JOIN pais
    ON pais.nombre = PAIS_CLIENTE
        AND ciudad.PAIS_id = id_pais
WHERE FECHA_CREACION IS NOT NULL
        AND NOMBRE_CLIENTE IS NOT NULL
ORDER BY  NOMBRE_CLIENTE ASC;

--llenado tabla empleado 
INSERT INTO empleado (nombre, correo, empleado_activo, TIENDA_id, usuario, contrasena, direccion)
SELECT DISTINCT NOMBRE_EMPLEADO,
        CORREO_EMPLEADO,
        EMPLEADO_ACTIVO,
        id_tienda,
        USUARIO_EMPLEADO,
        CONTRASENA_EMPLEADO,
        DIRECCION_EMPLEADO
FROM temporal
INNER JOIN tienda t
    ON TIENDA_EMPLEADO = t.nombre
WHERE NOMBRE_EMPLEADO IS NOT NULL
        AND CORREO_EMPLEADO IS NOT NULL
        AND EMPLEADO_ACTIVO IS NOT NULL
        AND USUARIO_EMPLEADO IS NOT NULL
        AND CONTRASENA_EMPLEADO IS NOT NULL
        AND DIRECCION_EMPLEADO IS NOT NULL;

--llenado de tabla renta
INSERT INTO renta (fecha_renta, fecha_retorno, monto_pago, fecha_pago, CLIENTE_id, EMPLEADO_id, PELICULA_id)
SELECT DISTINCT FECHA_RENTA,
        FECHA_RETORNO,
        MONTO_A_PAGAR,
        FECHA_PAGO,
        id_cliente,
        id_empleado,
        id_pelicula
FROM temporal
INNER JOIN cliente c
    ON NOMBRE_CLIENTE = c.nombre
INNER JOIN empleado e
    ON NOMBRE_EMPLEADO = e.nombre
INNER JOIN pelicula p
    ON NOMBRE_PELICULA = p.titulo
WHERE FECHA_RENTA IS NOT NULL;