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
├── docs/                             # Documentos de diseño y presentación
├── postgresql/                       # Scripts de base de datos relacional
│   ├── schema/                       # DDL (Tablas, Particiones, Extensiones)
│   ├── seed_data/                    # Datos de prueba para validación
│   └── queries/                      # Consultas avanzadas (JSONB, PostGIS)
├── mongodb/                          # Esquemas NoSQL para reseñas y catálogo
│   └── schema/                       # Definiciones de catálogo de productos
├── notebooks/                        # Análisis Exploratorio (Google Colab)
├── informe_arquitectura_final_U6.md  # [NUEVO] Informe técnico, benchmarking y CAP (U6)
└── plan_escalamiento_produccion_U6.md # [NUEVO] Plan de escalamiento 10x, migración y CI/CD (U6)
```

## 6. Unidad 6: Arquitectura, Benchmarking y Selección de Tecnologías
Como parte del cierre del diseño e infraestructura de Ecommify, se han consolidado las especificaciones del sistema híbrido relacional/NoSQL en dos artefactos clave:

1.  **[Informe Técnico de Arquitectura y Evaluación Comparativa](file:///E:/MAESTRIA/Base%20de%20datos/Ecommify_Database_Design/informe_arquitectura_final_U6.md):**
    *   **Benchmarking (Simulado):** Evaluación de rendimiento bajo alta concurrencia de tipo *Black Friday* mediante la **Ley de Little** (\(L = \lambda \times W\)). Contrasta PostgreSQL (Supabase) y MongoDB (Atlas) en throughput, latencia y tasa de errores con cargas de 10k, 50k y 100k+ VUs.
    *   **Identificación de Bottlenecks:** Telemetría de agotamiento de conexiones físicas, saturación de WAL y bloqueos en caliente en PostgreSQL; desalojo de páginas por WiredTiger Cache y contención en documentos en MongoDB.
    *   **Matriz de Selección:** Evaluación funcional para el Core transaccional (PostgreSQL), Catálogo polimórfico (MongoDB), Analítica masiva (MongoDB) y Logística geoespacial (PostgreSQL + PostGIS).
    *   **Teorema CAP:** Justificación del modelo transaccional CP y del catálogo AP con simulación lógica de fallas distribuidas (caída de red inter-AZ con quórum de elecciones y mitigación del desfase de réplicas asíncronas).

2.  **[Recomendaciones Estratégicas y Plan de Escalamiento 10x](file:///E:/MAESTRIA/Base%20de%20datos/Ecommify_Database_Design/plan_escalamiento_produccion_U6.md):**
    *   **Estrategia de Escalamiento:** Escalamiento vertical (instancias dedicadas con IOPS provisionados en AWS) y horizontal (PgBouncer en modo Transaction Pooling, 3 réplicas de lectura y particionado para PostgreSQL; fragmentación horizontal por *Hashed Shard Key* de `product_id` en MongoDB).
    *   **Plan de Migración Económico y Técnico:** Hoja de ruta para migrar de entornos compartidos gratuitos a entornos empresariales dedicados (estimación mensual de ~$800 USD) y estrategia de **migración con cero tiempo de inactividad** mediante replicación lógica WAL (AWS DMS / pglogical) y Atlas Live Migration.
    *   **CI/CD de Esquemas de Datos:** Integración continua en GitHub Actions usando **Prisma Migrations** o **Liquibase** aplicando el patrón de cambios seguros *Expand-and-Contract*.
    *   **Componentes de Soporte:** Arquitectura integrada con **Redis** para almacenamiento en caché, **Meilisearch** para búsquedas tolerantes a errores ortográficos, y **Datadog / Prometheus + Grafana** para observabilidad de hardware y métricas de consultas de bases de datos.
