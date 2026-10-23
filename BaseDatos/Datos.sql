/****** 2 de 3: Datos insertados. Ejecutar después de 1_estructura.sql. ******/
/****** Orden: Categorias, Provincias, Usuarios, Articulos, Imagenes (para respetar las claves foráneas) ******/
USE [Base_De_Datos_Swappit]
GO
SET IDENTITY_INSERT [dbo].[Categorias] ON 

INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (1, N'Tecnología')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (2, N'Libros')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (3, N'Ropa')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (4, N'Hogar')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (5, N'Deportes')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (6, N'Música')
SET IDENTITY_INSERT [dbo].[Categorias] OFF
GO
SET IDENTITY_INSERT [dbo].[Provincias] ON 

INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (1, N'Buenos Aires')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (2, N'Ciudad Autónoma de Buenos Aires')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (3, N'Catamarca')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (4, N'Chaco')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (5, N'Chubut')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (6, N'Córdoba')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (7, N'Corrientes')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (8, N'Entre Ríos')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (9, N'Formosa')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (10, N'Jujuy')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (11, N'La Pampa')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (12, N'La Rioja')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (13, N'Mendoza')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (14, N'Misiones')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (15, N'Neuquén')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (16, N'Río Negro')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (17, N'Salta')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (18, N'San Juan')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (19, N'San Luis')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (20, N'Santa Cruz')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (21, N'Santa Fe')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (22, N'Santiago del Estero')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (23, N'Tierra del Fuego')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (24, N'Tucumán')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (25, N'Buenos Aires')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (26, N'Ciudad Autónoma de Buenos Aires')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (27, N'Catamarca')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (28, N'Chaco')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (29, N'Chubut')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (30, N'Córdoba')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (31, N'Corrientes')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (32, N'Entre Ríos')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (33, N'Formosa')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (34, N'Jujuy')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (35, N'La Pampa')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (36, N'La Rioja')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (37, N'Mendoza')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (38, N'Misiones')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (39, N'Neuquén')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (40, N'Río Negro')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (41, N'Salta')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (42, N'San Juan')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (43, N'San Luis')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (44, N'Santa Cruz')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (45, N'Santa Fe')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (46, N'Santiago del Estero')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (47, N'Tierra del Fuego')
INSERT [dbo].[Provincias] ([IdProvincia], [Nombre]) VALUES (48, N'Tucumán')
SET IDENTITY_INSERT [dbo].[Provincias] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (2, N'Rafael dasf', N'Odiard Wesler', N'rafaelodiard', N'rafaelodiard@gmail.com', 0, N'12345678', N'', CAST(N'2024-11-01' AS Date), 1, 1)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (3, N'Sofía', N'Martínez', N'sofia.martinez', N'sofia.martinez@example.com', 110000001, N'SwappitDemo01!', N'Almagro', CAST(N'2005-04-12' AS Date), 21, 1)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (4, N'Mateo', N'Gómez', N'mateo.gomez', N'mateo.gomez@example.com', 110000002, N'SwappitDemo02!', N'Villa Crespo', CAST(N'2004-09-23' AS Date), 22, 1)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (5, N'Valentina', N'López', N'valentina.lopez', N'valentina.lopez@example.com', 110000003, N'SwappitDemo03!', N'Caballito', CAST(N'2006-01-30' AS Date), 20, 1)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (6, N'Lucas', N'Pérez', N'lucas.perez', N'lucas.perez@example.com', 110000006, N'SwappitDemo06!', N'Villa Urquiza', CAST(N'2005-02-19' AS Date), 21, 1)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (7, N'Martina', N'Díaz', N'martina.diaz', N'martina.diaz@example.com', 110000007, N'SwappitDemo07!', N'Belgrano', CAST(N'2006-06-02' AS Date), 20, 1)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (8, N'Thiago', N'Acosta', N'thiago.acosta', N'thiago.acosta@example.com', 110000010, N'SwappitDemo10!', N'Palermo', CAST(N'2005-08-05' AS Date), 21, 1)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (9, N'Tomás', N'Fernández', N'tomas.fernandez', N'tomas.fernandez@example.com', 110000004, N'SwappitDemo04!', N'Nueva Córdoba', CAST(N'2005-07-08' AS Date), 21, 6)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (10, N'Benjamín', N'Torres', N'benjamin.torres', N'benjamin.torres@example.com', 110000008, N'SwappitDemo08!', N'General Paz', CAST(N'2005-12-27' AS Date), 20, 6)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (11, N'Camila', N'Rodríguez', N'camila.rodriguez', N'camila.rodriguez@example.com', 110000005, N'SwappitDemo05!', N'Centro', CAST(N'2004-11-16' AS Date), 21, 21)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (12, N'Julieta', N'Romero', N'julieta.romero', N'julieta.romero@example.com', 110000009, N'SwappitDemo09!', N'Rosario Centro', CAST(N'2004-03-14' AS Date), 22, 21)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias]) VALUES (13, N'MARTINA', N'DRUCAROFF', N'50416809', N'50416809@est.ort.edu.ar', 0, N'12345678', N'', CAST(N'2000-09-09' AS Date), 26, 1)
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET IDENTITY_INSERT [dbo].[Articulos] ON 

INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (1, N'Auriculares Bluetooth', N'Funcionan perfectamente', N'Muy bueno', 3, 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (2, N'Novela de fantasía', N'Leída una sola vez', N'Bueno', 3, 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (3, N'Teclado mecánico', N'Switches en buen estado', N'Muy bueno', 4, 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (4, N'Buzo gris', N'Talle M, poco uso', N'Bueno', 4, 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (5, N'Mochila universitaria', N'Sin roturas, amplia', N'Muy bueno', 5, 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (6, N'Lámpara de escritorio', N'Luz cálida, funciona bien', N'Bueno', 5, 4)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (7, N'Remera negra', N'Talle L, buen estado', N'Bueno', 6, 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (8, N'Parlante portátil', N'Batería en buen estado', N'Muy bueno', 6, 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (9, N'Lámpara LED', N'Funciona correctamente', N'Muy bueno', 7, 4)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (10, N'Raqueta de tenis', N'Grip cuidado, sin roturas', N'Bueno', 7, 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (11, N'Organizador de escritorio', N'Madera, poco uso', N'Bueno', 8, 4)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (12, N'Webcam HD', N'Imagen nítida, funciona bien', N'Muy bueno', 8, 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (13, N'Mouse gamer', N'Sensor funcionando bien', N'Muy bueno', 9, 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (14, N'Pelota de básquet', N'Uso normal, buen pique', N'Bueno', 9, 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (15, N'Mancuernas 5 kg', N'Par completo, buen estado', N'Muy bueno', 10, 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (16, N'Guitarra criolla', N'Afinada y funcional', N'Bueno', 10, 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (17, N'Set de tazas', N'Seis tazas en buen estado', N'Muy bueno', 11, 4)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (18, N'Libro de programación', N'Con algunos subrayados', N'Bueno', 11, 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (19, N'Cuaderno de dibujo', N'Hojas sin usar', N'Muy bueno', 12, 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [Estado], [IdUsuarios], [IdCategorias]) VALUES (20, N'Campera de jean', N'Talle M, buen estado', N'Bueno', 12, 3)
SET IDENTITY_INSERT [dbo].[Articulos] OFF
GO
SET IDENTITY_INSERT [dbo].[Imagenes] ON 

INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (1, N'/img/perfiles/2_8df301965cc785d.png', NULL, 2)
SET IDENTITY_INSERT [dbo].[Imagenes] OFF
GO
    