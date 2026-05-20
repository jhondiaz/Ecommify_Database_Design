# Ecommify: Diseño de Base de Datos Relacional Avanzado y Arquitectura Híbrida

Este proyecto forma parte de la **Unidad 2: PostgreSQL - Diseño relacional avanzado**. Se enfoca en el desarrollo del módulo transaccional de una plataforma de E-commerce, utilizando el dataset de **Olist (Brazilian E-commerce)** como base de datos de referencia.

## 1. Resumen Técnico (Abstract)
Ecommify utiliza una arquitectura de base de datos políglota para equilibrar la integridad transaccional y la escalabilidad analítica. Se ha implementado **PostgreSQL** como motor principal para el núcleo de negocio (pedidos, pagos, inventario) cumpliendo con las propiedades **ACID**, e integrando **MongoDB** para el catálogo extendido y reseñas, siguiendo el modelo **BASE**. El diseño destaca por el uso de tipos de datos avanzados como `JSONB`, `Arrays` y extensiones geoespaciales (`PostGIS`).

## 2. Modelo Entidad-Relación (3FN)
El modelo ha sido normalizado a **Tercera Forma Normal (3FN)** para eliminar redundancias y asegurar la integridad referencial.

### Entidades Clave:
* **Customers:** Almacena perfiles de clientes con datos geolocalizados mediante PostGIS.
* **Orders:** Entidad central particionada por rangos de fecha para optimizar el rendimiento de consultas históricas.
* **Products:** Implementa un esquema flexible mediante `JSONB` para especificaciones técnicas y `ARRAY` para galerías multimedia.
* **Payments:** Gestiona el flujo financiero con soporte multi-método (tarjeta, boleto, etc.).



## 3. Justificación de Decisiones Arquitectónicas

### ¿Por qué PostgreSQL para el Core?
Se seleccionó PostgreSQL por su robustez transaccional y capacidad de extenderse mediante:
* **Extensiones:** `PostGIS` para calcular costos de envío por distancia y `pg_trgm` para búsquedas "fuzzy" en el buscador.
* **Tipos Avanzados:** Uso de `JSONB` para permitir que diferentes categorías de productos tengan atributos únicos sin alterar el esquema (Esquema-Flexible).
* **Escalabilidad:** Particionamiento de tablas para separar datos "calientes" (pedidos recientes) de datos "fríos" (historial).

### Matriz PostgreSQL vs MongoDB (Teorema CAP)
| Criterio | PostgreSQL | MongoDB |
| :--- | :--- | :--- |
| **Módulos** | Pedidos, Pagos, Inventario. | Reseñas, Logs, Catálogo. |
| **Teorema CAP** | Consistencia (C) - Disponibilidad (A) | Disponibilidad (A) - Partición (P) |
| **Justificación** | Necesidad de transacciones ACID. | Escalabilidad para datos masivos. |

## 4. Análisis Exploratorio de Datos (EDA)
El EDA realizado sobre el dataset de Olist permitió identificar:
1.  **Calidad:** Tratamiento de valores nulos en el flujo logístico.
2.  **Patrones Temporales:** Picos de venta estacionales que justifican el uso de **Vistas Materializadas** para reportes mensuales.
3.  **Outliers:** Detección de precios atípicos que requieren reglas de validación en la capa de base de datos.



## 5. Estructura del Repositorio
```text
├── docs/                            # Documentos de diseño y presentación
├── postgresql/                      # Scripts de base de datos relacional
│   ├── schema/                      # DDL (Tablas, Particiones, Extensiones)
│   ├── seed_data/                   # Datos de prueba para validación
│   └── queries/                     # Consultas avanzadas (JSONB, PostGIS)
├── mongodb/                         # Esquemas NoSQL para reseñas
└── notebooks/                       # Análisis Exploratorio (Google Colab)
