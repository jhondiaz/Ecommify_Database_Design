-- 1. Inserción de Clientes (Validación de PostGIS)
INSERT INTO customers (customer_id, customer_unique_id, zip_code_prefix, city, state, geolocation)
VALUES 
(
    '550e8400-e29b-41d4-a716-446655440000', 
    '7c309002-8611-4475-87d2-3165b4c19451', 
    '01001', 'São Paulo', 'SP', 
    ST_GeogFromText('SRID=4326;POINT(-46.6333 -23.5505)') -- Coordenadas de SP
),
(
    '661f9511-f30c-52e5-b827-557766551111', 
    '9d410113-9722-5586-98e3-4276c5d20562', 
    '20001', 'Rio de Janeiro', 'RJ', 
    ST_GeogFromText('SRID=4326;POINT(-43.1729 -22.9068)') -- Coordenadas de RJ
);

-- 2. Inserción de Productos (Validación de JSONB, Arrays y Ranges)
INSERT INTO products (product_id, category_name, name, specifications, photos, weight_g, promotion_period)
VALUES 
(
    'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d',
    'Electronics',
    'Smartphone Galaxy Ecommify X',
    '{
        "brand": "Samsung",
        "model": "X-2024",
        "specs": {
            "ram": "8GB",
            "storage": "256GB",
            "processor": "Snapdragon 8 Gen 2"
        },
        "color_options": ["Midnight Black", "Arctic White", "Ocean Blue"]
    }'::jsonb,
    ARRAY['https://cdn.ecommify.com/p1_front.jpg', 'https://cdn.ecommify.com/p1_back.jpg'],
    185,
    '[2024-01-01 00:00:00, 2024-02-01 23:59:59]' -- Promoción válida todo enero
),
(
    'b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e',
    'Home Decor',
    'Lámpara Inteligente Ambient',
    '{
        "brand": "EcoLight",
        "connectivity": ["WiFi", "Bluetooth"],
        "power": "10W",
        "lumens": 800
    }'::jsonb,
    ARRAY['https://cdn.ecommify.com/lamp1.jpg'],
    450,
    NULL -- Sin promoción activa
);

-- 3. Inserción de Órdenes (Validación de Particionamiento y Enums)
-- Nota: Asegúrate de que las particiones orders_2023_q4 y orders_2024_q1 existan
INSERT INTO orders (order_id, customer_id, status, purchase_timestamp)
VALUES 
(
    'd1e2f3a4-b5c6-7d8e-9f0a-1b2c3d4e5f6a',
    '550e8400-e29b-41d4-a716-446655440000',
    'delivered',
    '2023-11-15 14:30:00-03' -- Se insertará en la partición 2023_q4
),
(
    'e2f3a4b5-c6d7-8e9f-0a1b-2c3d4e5f6a7b',
    '661f9511-f30c-52e5-b827-557766551111',
    'paid',
    '2024-01-10 09:15:00-03' -- Se insertará en la partición 2024_q1
);

-- 4. Inserción de Ítems de Pedido
INSERT INTO order_items (order_id, order_item_id, product_id, price, freight_value)
VALUES 
('d1e2f3a4-b5c6-7d8e-9f0a-1b2c3d4e5f6a', 1, 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d', 850.00, 25.50),
('e2f3a4b5-c6d7-8e9f-0a1b-2c3d4e5f6a7b', 1, 'b2c3d4e5-f6a7-5b6c-9d0e-1f2a3b4c5d6e', 45.00, 10.00);

-- 5. Inserción de Pagos
INSERT INTO payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
VALUES 
('d1e2f3a4-b5c6-7d8e-9f0a-1b2c3d4e5f6a', 1, 'credit_card', 1, 875.50),
('e2f3a4b5-c6d7-8e9f-0a1b-2c3d4e5f6a7b', 1, 'boleto', 1, 55.00);