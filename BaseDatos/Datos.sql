/****** 2 de 3: Datos insertados. Ejecutar después de Estructura.sql. ******/
/****** Orden: Categorias, EstadosArticulos, EstadosIntercambios, Provincias, TipoNotificaciones, Usuarios, Articulos, Imagenes (para respetar las claves foráneas) ******/
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
SET IDENTITY_INSERT [dbo].[EstadosArticulos] ON 

INSERT [dbo].[EstadosArticulos] ([IdEstadosArticulos], [Nombre]) VALUES (2, N'Muy buen estado')
INSERT [dbo].[EstadosArticulos] ([IdEstadosArticulos], [Nombre]) VALUES (3, N'Buen estado')
INSERT [dbo].[EstadosArticulos] ([IdEstadosArticulos], [Nombre]) VALUES (4, N'Usado')
SET IDENTITY_INSERT [dbo].[EstadosArticulos] OFF
GO
SET IDENTITY_INSERT [dbo].[EstadosIntercambios] ON 

INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (1, N'Pendiente')
INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (2, N'Aceptado')
INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (3, N'Rechazado')
INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (4, N'Realizado')
SET IDENTITY_INSERT [dbo].[EstadosIntercambios] OFF
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
SET IDENTITY_INSERT [dbo].[TipoNotificaciones] ON 

INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (1, N'Propuesta recibida')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (2, N'Propuesta aceptada')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (3, N'Propuesta rechazada')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (4, N'Mensaje nuevo')
SET IDENTITY_INSERT [dbo].[TipoNotificaciones] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (2, N'Rafael dasf', N'Odiard Wesler', N'rafaelodiard', N'rafaelodiard@gmail.com', 0, N'AQAAAAIAAYagAAAAECiEIkRdwaCH2m8I7EVXb7wY7NNakfcf73xLU1wvvOWUCSSQNxhmMZj4mvt1ffIK/w==', N'', CAST(N'2024-11-01' AS Date), 1, 25, NULL)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (3, N'Sofía', N'Martínez', N'sofia.martinez', N'sofia.martinez@example.com', 110000001, N'SwappitDemo01!', N'Almagro', CAST(N'2005-04-12' AS Date), 21, 1, N'Me mudé hace poco a Almagro y estoy armando la cocina. Busco cosas para el depto; coordinamos por el chat de Swappit.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (4, N'Mateo', N'Gómez', N'mateo.gomez', N'mateo.gomez@example.com', 110000002, N'SwappitDemo02!', N'Villa Crespo', CAST(N'2004-09-23' AS Date), 22, 1, N'Armando mi primer monoambiente en Villa Crespo. Me interesan muebles chicos y cosas de cocina. Puedo encontrarme cerca del subte B.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (5, N'Valentina', N'López', N'valentina.lopez', N'valentina.lopez@example.com', 110000003, N'SwappitDemo03!', N'Caballito', CAST(N'2006-01-30' AS Date), 20, 1, N'Me sobran cosas de la casa de mis viejos y prefiero cambiarlas antes que tirarlas. Busco plantas, libros o cosas para el balcón.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (6, N'Lucas', N'Pérez', N'lucas.perez', N'lucas.perez@example.com', 110000006, N'SwappitDemo06!', N'Villa Urquiza', CAST(N'2005-02-19' AS Date), 21, 1, N'Trabajo desde casa, así que me interesa todo lo que sirva para armar un buen escritorio. Respondo rápido por el chat.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (7, N'Martina', N'Díaz', N'martina.diaz', N'martina.diaz@example.com', 110000007, N'SwappitDemo07!', N'Belgrano', CAST(N'2006-06-02' AS Date), 20, 1, N'Me encanta cocinar y estoy aprendiendo. Cambio cosas de cocina y libros; si querés, coordinamos un fin de semana por Belgrano.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (8, N'Thiago', N'Acosta', N'thiago.acosta', N'thiago.acosta@example.com', 110000010, N'SwappitDemo10!', N'Palermo', CAST(N'2005-08-05' AS Date), 21, 1, N'Estoy ordenando el depto y quiero darles otra vida a las cosas que no uso. Busco algo para el living. Coordinamos por el chat.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (9, N'Tomás', N'Fernández', N'tomas.fernandez', N'tomas.fernandez@example.com', 110000004, N'SwappitDemo04!', N'Nueva Córdoba', CAST(N'2005-07-08' AS Date), 21, 6, N'Estudio en Córdoba y me muevo en bici. Me interesan cosas útiles para un depto de estudiante. Coordinamos por Nueva Córdoba.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (10, N'Benjamín', N'Torres', N'benjamin.torres', N'benjamin.torres@example.com', 110000008, N'SwappitDemo08!', N'General Paz', CAST(N'2005-12-27' AS Date), 20, 6, N'Me estoy independizando y necesito de todo un poco. Prefiero cambiar antes que comprar nuevo. Escribime y lo vemos.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (11, N'Camila', N'Rodríguez', N'camila.rodriguez', N'camila.rodriguez@example.com', 110000005, N'SwappitDemo05!', N'Centro', CAST(N'2004-11-16' AS Date), 21, 21, N'Me mudo seguido y viajo liviana. Cambio cosas para la casa por algo que entre en una mochila o sirva para cocinar.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (12, N'Julieta', N'Romero', N'julieta.romero', N'julieta.romero@example.com', 110000009, N'SwappitDemo09!', N'Rosario Centro', CAST(N'2004-03-14' AS Date), 22, 21, N'Recién llegada a Rosario Centro, armando el depto de a poco. Busco lámparas, plantas o cosas de deco. Respondo por el chat.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (13, N'MARTINA', N'DRUCAROFF', N'50416809', N'50416809@est.ort.edu.ar', 0, N'12345678', N'', CAST(N'2000-09-09' AS Date), 26, 1, NULL)
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET IDENTITY_INSERT [dbo].[Articulos] ON 

INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (1, N'Microondas 20 L', N'Funciona perfecto, poco uso', 2, 3, 1, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (2, N'Juego de sábanas 2 plazas', N'Algodón, lavadas y planchadas', 3, 3, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (3, N'Mesa de luz', N'Madera, con un cajón', 3, 4, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (4, N'Pava eléctrica', N'1,7 L, con corte automático', 2, 4, 1, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (5, N'Sillas de comedor x2', N'Madera maciza, firmes', 3, 5, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (6, N'Sartén antiadherente', N'28 cm, sin rayones', 2, 5, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (7, N'Escritorio plegable', N'Ideal para monoambiente', 2, 6, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (8, N'Router WiFi', N'Incluye fuente, funciona bien', 3, 6, 1, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (9, N'Juego de ollas', N'Tres ollas de acero con tapa', 3, 7, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (10, N'Libro de recetas fáciles', N'Recetas simples para el día a día', 2, 7, 2, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (11, N'Estantería de 4 estantes', N'Melamina blanca, fácil de armar', 3, 8, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (12, N'Aspiradora', N'Buena succión, con accesorios', 3, 8, 1, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (13, N'Cortinas blackout', N'Par de paños, color gris', 2, 9, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (14, N'Bicicleta urbana', N'Rodado 26, ideal para la ciudad', 3, 9, 5, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (15, N'Colchón de 1 plaza', N'Espuma, sin manchas', 3, 10, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (16, N'Tostadora', N'Dos ranuras, funciona bien', 2, 10, 1, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (17, N'Vajilla para 4 personas', N'Platos, vasos y cubiertos', 2, 11, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (18, N'Perchero de pie', N'Metal negro, estable', 3, 11, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (19, N'Espejo de pie', N'Marco de madera, sin rayones', 2, 12, 4, NULL, NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [ACambio]) VALUES (20, N'Ventilador de pie', N'Tres velocidades, silencioso', 3, 12, 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Articulos] OFF
GO
SET IDENTITY_INSERT [dbo].[Imagenes] ON 

INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (2, N'/img/perfiles/2_8df340421a76dd6.png', NULL, 2)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (3, N'/img/ArticulosPrueba/Fotos swappit objetos/microondas.jpg', 1, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (4, N'/img/ArticulosPrueba/Fotos swappit objetos/juegoDeSabanas.jpg', 2, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (5, N'/img/ArticulosPrueba/Fotos swappit objetos/mesaDeLuz.jpg', 3, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (6, N'/img/ArticulosPrueba/Fotos swappit objetos/pavaElectrica.jpg', 4, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (7, N'/img/ArticulosPrueba/Fotos swappit objetos/sillaDeComedor.jpg', 5, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (8, N'/img/ArticulosPrueba/Fotos swappit objetos/sarten.jpg', 6, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (9, N'/img/ArticulosPrueba/Fotos swappit objetos/escritorioPlegable.jpg', 7, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (10, N'/img/ArticulosPrueba/Fotos swappit objetos/routerWifi.jpg', 8, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (11, N'/img/ArticulosPrueba/Fotos swappit objetos/juegoDeOllas.jpg', 9, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (12, N'/img/ArticulosPrueba/Fotos swappit objetos/libroRecetas.jpg', 10, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (13, N'/img/ArticulosPrueba/Fotos swappit objetos/estanteria.jpg', 11, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (14, N'/img/ArticulosPrueba/Fotos swappit objetos/aspiradora.jpg', 12, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (15, N'/img/ArticulosPrueba/Fotos swappit objetos/cortinasBlackout.jpg', 13, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (16, N'/img/ArticulosPrueba/Fotos swappit objetos/bicicletaUrbana.jpg', 14, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (17, N'/img/ArticulosPrueba/Fotos swappit objetos/colchon1Plaza.jpg', 15, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (18, N'/img/ArticulosPrueba/Fotos swappit objetos/tostadora.jpg', 16, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (19, N'/img/ArticulosPrueba/Fotos swappit objetos/vajillas4Personas.webp', 17, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (20, N'/img/ArticulosPrueba/Fotos swappit objetos/percheroDePie.jpg', 18, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (21, N'/img/ArticulosPrueba/Fotos swappit objetos/espejoDePie.jpg', 19, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (22, N'/img/ArticulosPrueba/Fotos swappit objetos/ventiladorDePie.jpg', 20, NULL)
SET IDENTITY_INSERT [dbo].[Imagenes] OFF
GO
    