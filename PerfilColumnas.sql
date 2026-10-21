USE [Base_De_Datos_Swappit]
GO
-- Columnas para "Editar perfil": descripción y foto de perfil (ruta dentro de wwwroot)
ALTER TABLE Usuarios ADD Descripcion varchar(500) NULL;
ALTER TABLE Usuarios ADD Foto varchar(200) NULL;
GO
