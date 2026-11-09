/****** Para una base que ya existe: deja una sola fila por provincia. Los scripts de creación ya vienen sin repetidas. ******/
USE [Base_De_Datos_Swappit]
GO
BEGIN TRANSACTION

UPDATE u SET u.IdProvincias = primera.IdProvincia
FROM dbo.Usuarios u
INNER JOIN dbo.Provincias p ON p.IdProvincia = u.IdProvincias
INNER JOIN (SELECT Nombre, MIN(IdProvincia) AS IdProvincia FROM dbo.Provincias GROUP BY Nombre) primera ON primera.Nombre = p.Nombre
WHERE u.IdProvincias <> primera.IdProvincia

DELETE p FROM dbo.Provincias p
WHERE p.IdProvincia > (SELECT MIN(p2.IdProvincia) FROM dbo.Provincias p2 WHERE p2.Nombre = p.Nombre)

COMMIT TRANSACTION
GO
SELECT COUNT(*) AS Provincias FROM dbo.Provincias
GO
