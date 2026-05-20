-- Habilitar soporte para datos geoespaciales (Logística/Fletes)
CREATE EXTENSION IF NOT EXISTS postgis;

-- Habilitar búsqueda difusa (Buscador de productos)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Habilitar generación de UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";