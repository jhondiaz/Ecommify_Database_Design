-- 1. Tabla de Clientes
CREATE TABLE customers (
    customer_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_unique_id UUID NOT NULL,
    zip_code_prefix VARCHAR(10),
    city TEXT,
    state CHAR(2),
    geolocation geography(POINT) -- Requiere PostGIS
);

-- 2. Tabla de Productos (Uso de JSONB y ARRAYS)
CREATE TABLE products (
    product_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_name TEXT,
    name TEXT NOT NULL,
    specifications JSONB,       -- Características dinámicas (3FN flexible)
    photos TEXT[],             -- Array de URLs
    weight_g INT,
    promotion_period TSTZRANGE, -- Rango de tiempo para descuentos
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tabla de Órdenes (PARTICIONADA por fecha)
CREATE TABLE orders (
    order_id UUID NOT NULL,
    customer_id UUID REFERENCES customers(customer_id),
    status order_status DEFAULT 'created',
    purchase_timestamp TIMESTAMPTZ NOT NULL,
    approved_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (order_id, purchase_timestamp) -- La clave debe incluir la columna de partición
) PARTITION BY RANGE (purchase_timestamp);

-- Ejemplo de creación de particiones manuales (o automáticas mediante pg_partman)
CREATE TABLE orders_2023_q4 PARTITION OF orders
    FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');

CREATE TABLE orders_2024_q1 PARTITION OF orders
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

-- 4. Tabla de Ítems del Pedido
CREATE TABLE order_items (
    order_id UUID NOT NULL,
    order_item_id INT NOT NULL,
    product_id UUID REFERENCES products(product_id),
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2),
    shipping_limit_date TIMESTAMPTZ,
    PRIMARY KEY (order_id, order_item_id)
);

-- 5. Tabla de Pagos
CREATE TABLE payments (
    order_id UUID NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type TEXT,
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- Índices para optimización
CREATE INDEX idx_products_specs ON products USING GIN (specifications);
CREATE INDEX idx_products_trgm ON products USING gist (name gist_trgm_ops);