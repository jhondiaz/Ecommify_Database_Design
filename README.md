# Ecommify_Database_Design

Ecommify: Diseño de Base de Datos Relacional Avanzado
1. Descripción del Proyecto
Este repositorio contiene el diseño conceptual, lógico e implementación preliminar del módulo transaccional de Ecommify. El objetivo principal es desarrollar una arquitectura de software compleja que integre innovación y sostenibilidad utilizando PostgreSQL como motor principal y MongoDB para cargas de datos específicas.

2. Estructura del Repositorio
Siguiendo los lineamientos de la guía de actividades, el proyecto se organiza de la siguiente manera:

Ecommify_Database_Design/
├── README.md                        # Descripción y guía del proyecto [cite: 114]
├── docs/                            # Documentación técnica obligatoria [cite: 115]
│   ├── Documento_Tecnico_Diseno.pdf  # Diseño conceptual y lógico [cite: 116]
│   └── Presentacion_Ejecutiva.pdf    # Resumen para sustentación [cite: 117]
├── postgresql/                      # Módulo relacional PostgreSQL [cite: 118]
│   ├── schema/                      # Scripts DDL (Tablas, Particiones) [cite: 119]
│   ├── seed_data/                   # Datos de prueba [cite: 120]
│   └── queries/                     # Consultas avanzadas (JSONB, Arrays) [cite: 121]
├── mongodb/                         # Módulo NoSQL MongoDB [cite: 122]
│   └── schema/                      # Esquema de documentos [cite: 123]
└── notebooks/                       # Análisis de datos [cite: 124]
    └── Data_Exploration_Analysis.ipynb # EDA del dataset Olist [cite: 125]


3. Decisiones Técnicas Destacadas
Implementación en PostgreSQL
Se han seleccionado tipos de datos avanzados para optimizar el rendimiento y la flexibilidad del esquema:

JSONB: Para almacenar especificaciones de productos (product_specifications).  


ARRAY TEXT[]: Para la gestión de múltiples fotos de productos (product_photos).  


TSTZRANGE: Para definir periodos de promociones (promotion_period).  


PostGIS: Extensión utilizada para el cálculo de costos de envío basados en geolocalización.  


pg_trgm: Extensión para búsqueda de productos con tolerancia a errores tipográficos.

Arquitectura Híbrida y Cargas OLTP/OLAP

Particionamiento: La tabla de órdenes (Orders) se ha diseñado con particiones por fecha para manejar datos históricos ("hot/cold partitions").  


Vistas Materializadas: Implementación de mv_sales_by_category_monthly para dashboards analíticos sin afectar el rendimiento transaccional.  


Sincronización: Se definen triggers para el mantenimiento automático de auditoría (updated_at).


4. Requisitos de Evaluación (Rúbrica)Este repositorio cumple con los siguientes criterios de excelencia:  Modelo ER Normalizado: Diseño en 3FN con entidades y relaciones claras.  Justificación Técnica: Análisis detallado de ACID vs BASE y uso de extensiones.  EDA: Análisis completo del dataset Brazilian E-commerce en Google Colab.  Matriz de Decisiones: Justificación del uso de PostgreSQL vs MongoDB bajo el Teorema CAP.  5. ReferenciasPostgreSQL 16 Documentation: Data Types.  PostgreSQL 16 Documentation: Extending SQL


