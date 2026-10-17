/*
=============================================================
Crear la base de datos y los esquemas
=============================================================
Propósito del script:
    Este script crea una base de datos nueva llamada 'DataWarehouse', después de comprobar si ya existe.
    Si la base de datos existe, se elimina y se vuelve a crear. Además, el script crea tres esquemas
    dentro de la base de datos: 'bronze', 'silver' y 'gold'.

ADVERTENCIA:
    Al ejecutar este script se elimina por completo la base de datos 'DataWarehouse' si existe.
    Todos los datos de la base de datos se borrarán de forma permanente. Procede con cuidado
    y asegúrate de tener respaldos antes de ejecutar este script.
*/

USE master;
GO

-- Eliminar y volver a crear la base de datos 'DataWarehouse'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Crear la base de datos 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Crear los esquemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
