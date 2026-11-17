/* ============================================================
   T1 - Lenguaje de Programacion I
   Base de datos : BD_ProyectosMuni
   Motor         : Microsoft SQL Server
   ============================================================ */

IF DB_ID('BD_ProyectosMuni') IS NULL
BEGIN
    CREATE DATABASE BD_ProyectosMuni;
END
GO

USE BD_ProyectosMuni;
GO

IF OBJECT_ID('dbo.proyectos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.proyectos (
        id_proyecto  INT            IDENTITY(1,1) NOT NULL,
        nombre       VARCHAR(60)    NOT NULL,
        descripcion  VARCHAR(255)   NULL,
        fecha_inicio DATE           NOT NULL,
        fecha_fin    DATE           NOT NULL,
        asesor       VARCHAR(80)    NOT NULL,
        presupuesto  DECIMAL(12,2)  NOT NULL,
        CONSTRAINT PK_proyectos PRIMARY KEY (id_proyecto),
        CONSTRAINT CK_proyectos_fechas CHECK (fecha_fin >= fecha_inicio),
        CONSTRAINT CK_proyectos_presupuesto CHECK (presupuesto > 0)
    );
END
GO

/* Datos de ejemplo (solo si la tabla esta vacia) */
IF NOT EXISTS (SELECT 1 FROM dbo.proyectos)
BEGIN
    SET IDENTITY_INSERT dbo.proyectos ON;

    INSERT INTO dbo.proyectos (id_proyecto, nombre, descripcion, fecha_inicio, fecha_fin, asesor, presupuesto) VALUES
    (1, 'Sistema de Inventario',        'Implementacion del sistema de control de almacen para la Gerencia de Abastecimiento.', '2025-01-15', '2025-03-20', 'Carlos Perez',   15000.00),
    (2, 'Plataforma E-Learning',        'Plataforma virtual de capacitacion para el personal municipal.',                      '2025-02-01', '2025-06-30', 'Andrea Torres',  40000.00),
    (3, 'App de Gestion Medica',        'Aplicacion movil para el registro de citas en los centros de salud municipal.',       '2025-03-10', '2025-08-12', 'Luis Ramirez',   55000.00);

    SET IDENTITY_INSERT dbo.proyectos OFF;
END
GO

/* Usuario de la aplicacion web */
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'usr_proyectos')
BEGIN
    CREATE LOGIN usr_proyectos WITH PASSWORD = 'Proyectos2026*', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'usr_proyectos')
BEGIN
    CREATE USER usr_proyectos FOR LOGIN usr_proyectos;
END
GO

ALTER ROLE db_datareader ADD MEMBER usr_proyectos;
ALTER ROLE db_datawriter ADD MEMBER usr_proyectos;
GO

SELECT id_proyecto, nombre, fecha_inicio, fecha_fin, asesor, presupuesto FROM dbo.proyectos;
GO
