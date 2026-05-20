-- ==========================================================
-- 1. CONSULTAS SOBRE JSONB (Especificaciones de Productos)
-- ==========================================================

-- Buscar productos por una característica interna del JSONB (Ej: RAM de 8GB)
-- Utiliza el operador ->> para obtener el texto
SELECT name, specifications->'specs'->>'ram' AS ram_size
FROM products
WHERE specifications->'specs'->>'ram' = '8GB';

-- Buscar productos que tengan una marca específica dentro del JSON
-- Utiliza el operador @> (contiene) que es altamente eficiente con índices GIN
SELECT name, specifications
FROM products
WHERE specifications @> '{"brand": "Samsung"}';

-- Listar todas las opciones de color disponibles (extrayendo un array de un JSONB)
SELECT name, jsonb_array_elements_text(specifications->'color_options') AS colors
FROM products
WHERE specifications ? 'color_options';


-- ==========================================================
-- 2. CONSULTAS SOBRE ARRAYS (Galería de Fotos)
-- ==========================================================

-- Obtener productos que tengan más de una foto
SELECT name, cardinality(photos) AS total_photos
FROM products
WHERE cardinality(photos) > 1;

-- Buscar productos que contengan una URL de imagen específica
SELECT name
FROM products
WHERE 'https://cdn.ecommify.com/lamp1.jpg' = ANY(photos);


-- ==========================================================
-- 3. CONSULTAS SOBRE RANGOS (TSTZRANGE - Promociones)
-- ==========================================================

-- Verificar qué productos tienen una promoción activa en este momento
SELECT name, promotion_period
FROM products
WHERE promotion_period @> NOW();


-- ==========================================================
-- 4. CONSULTAS GEOESPACIALES (PostGIS - Logística)
-- ==========================================================

-- Calcular la distancia en kilómetros entre dos clientes
-- Utiliza ST_Distance para calcular la distancia mínima sobre la esfera
SELECT 
    c1.city AS origen, 
    c2.city AS destino,
    ST_Distance(c1.geolocation, c2.geolocation) / 1000 AS distancia_km
FROM customers c1, customers c2
WHERE c1.customer_id != c2.customer_id 
  AND c1.city = 'São Paulo' LIMIT 1;


-- ==========================================================
-- 5. BÚSQUEDA DIFUSA (pg_trgm - Buscador)
-- ==========================================================

-- Buscar productos por nombre ignorando errores tipográficos leves (Ej: "Smrtphone")
-- El operador % utiliza el índice GIST creado anteriormente
SELECT name, similarity(name, 'Smrtphone') AS score
FROM products
WHERE name % 'Smrtphone'
ORDER BY score DESC;


-- ==========================================================
-- 6. OPTIMIZACIÓN DE CARGAS HÍBRIDAS (Particionamiento)
-- ==========================================================

-- Consultar pedidos de un periodo específico
-- Gracias al "Partition Pruning", PostgreSQL solo escaneará la partición orders_2023_q4
EXPLAIN ANALYZE
SELECT * FROM orders 
WHERE purchase_timestamp BETWEEN '2023-10-01' AND '2023-12-31';