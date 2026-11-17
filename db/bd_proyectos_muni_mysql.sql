/* ============================================================
   T1 - Lenguaje de Programacion I
   Base de datos : BD_ProyectosMuni
   Motor         : MySQL 8.x / MariaDB
   ============================================================ */

CREATE DATABASE IF NOT EXISTS BD_ProyectosMuni
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE BD_ProyectosMuni;

CREATE TABLE IF NOT EXISTS proyectos (
    id_proyecto INT            NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(60)    NOT NULL,
    descripcion VARCHAR(255)   NULL,
    fecha_inicio DATE          NOT NULL,
    fecha_fin    DATE          NOT NULL,
    asesor       VARCHAR(80)   NOT NULL,
    presupuesto  DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_proyecto),
    CONSTRAINT ck_proyectos_fechas CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT ck_proyectos_presupuesto CHECK (presupuesto > 0)
) ENGINE = InnoDB;

INSERT INTO proyectos (nombre, descripcion, fecha_inicio, fecha_fin, asesor, presupuesto)
SELECT * FROM (
    SELECT 'Sistema de Inventario',
           'Implementacion del sistema de control de almacen para la Gerencia de Abastecimiento.',
           '2025-01-15', '2025-03-20', 'Carlos Perez', 15000.00
    UNION ALL
    SELECT 'Plataforma E-Learning',
           'Plataforma virtual de capacitacion para el personal municipal.',
           '2025-02-01', '2025-06-30', 'Andrea Torres', 40000.00
    UNION ALL
    SELECT 'App de Gestion Medica',
           'Aplicacion movil para el registro de citas en los centros de salud municipal.',
           '2025-03-10', '2025-08-12', 'Luis Ramirez', 55000.00
) AS nuevos
WHERE NOT EXISTS (SELECT 1 FROM proyectos);

SELECT id_proyecto, nombre, fecha_inicio, fecha_fin, asesor, presupuesto FROM proyectos;
