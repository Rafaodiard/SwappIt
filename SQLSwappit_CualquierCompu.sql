USE [master]
GO
/****** Crea la base en la carpeta de datos por defecto de la instancia, así sirve en cualquier compu y versión de SQL Server. ******/
/****** Si la base ya existe, el script se detiene sin tocar nada. Para recrearla desde cero, descomentá el bloque DROP de abajo (borra todos sus datos). ******/
/*
IF DB_ID(N'Base_De_Datos_Swappit') IS NOT NULL
BEGIN
	ALTER DATABASE [Base_De_Datos_Swappit] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [Base_De_Datos_Swappit]
END
*/
IF DB_ID(N'Base_De_Datos_Swappit') IS NOT NULL
BEGIN
	RAISERROR(N'La base Base_De_Datos_Swappit ya existe. No se ejecutó nada. Para recrearla, descomentá el bloque DROP al principio del script.', 16, 1)
	SET NOEXEC ON
END
GO
CREATE DATABASE [Base_De_Datos_Swappit]
GO
IF DB_ID(N'Base_De_Datos_Swappit') IS NULL
BEGIN
	RAISERROR(N'No se pudo crear Base_De_Datos_Swappit. Se corta el script para no crear tablas en master.', 16, 1)
	SET NOEXEC ON
END
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Base_De_Datos_Swappit].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET ARITHABORT OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET RECOVERY FULL 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET  MULTI_USER 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'Base_De_Datos_Swappit', N'ON'
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET QUERY_STORE = OFF
GO
USE [Base_De_Datos_Swappit]
GO
IF DB_NAME() <> N'Base_De_Datos_Swappit'
BEGIN
	RAISERROR(N'No se está usando Base_De_Datos_Swappit (¿existe la base?). Se corta el script para no crear objetos en master.', 16, 1)
	SET NOEXEC ON
END
GO
/****** Usuario [alumno]: solo se crea si ese login existe en la instancia. La app se conecta con Integrated Security y no lo necesita. ******/
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'alumno') AND DATABASE_PRINCIPAL_ID(N'alumno') IS NULL
	CREATE USER [alumno] FOR LOGIN [alumno] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Articulos]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articulos](
	[IdArticulos] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
	[Estado] [varchar](50) NOT NULL,
	[IdUsuarios] [int] NOT NULL,
	[IdCategorias] [int] NOT NULL,
 CONSTRAINT [PK_Articulos] PRIMARY KEY CLUSTERED 
(
	[IdArticulos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categorias]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categorias](
	[IdCategorias] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Categorias] PRIMARY KEY CLUSTERED 
(
	[IdCategorias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Imagenes]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Imagenes](
	[IdImagenes] [int] IDENTITY(1,1) NOT NULL,
	[Ruta] [varchar](50) NOT NULL,
	[IdArticulos] [int] NULL,
	[IdUsuarios] [int] NULL,
 CONSTRAINT [PK_Imagenes] PRIMARY KEY CLUSTERED 
(
	[IdImagenes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Intercambios]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intercambios](
	[IdIntercambios] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Estado] [varchar](50) NOT NULL,
	[IdUsuarios1] [int] NOT NULL,
	[IdUsuarios2] [int] NOT NULL,
	[IdArticulos1] [int] NOT NULL,
	[IdArticulos2] [int] NOT NULL,
	[Ubicacion] [varchar](50) NULL,
 CONSTRAINT [PK_Intercambios] PRIMARY KEY CLUSTERED 
(
	[IdIntercambios] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mensajes]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mensajes](
	[IdMensajes] [int] IDENTITY(1,1) NOT NULL,
	[Texto] [varchar](50) NOT NULL,
	[fueVisto] [bit] NOT NULL,
	[FechaEnviado] [date] NOT NULL,
	[FechaRecibido] [date] NULL,
	[IdUsuariosManda] [int] NOT NULL,
	[IdIntercambio] [int] NOT NULL,
 CONSTRAINT [PK_Mensajes] PRIMARY KEY CLUSTERED 
(
	[IdMensajes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Provincias]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Provincias](
	[IdProvincia] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Provincias] PRIMARY KEY CLUSTERED 
(
	[IdProvincia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[IdUsuarios] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Apellido] [varchar](50) NOT NULL,
	[Usuario] [varchar](50) NOT NULL,
	[Mail] [varchar](50) NOT NULL,
	[Telefono] [int] NOT NULL,
	[Contraseña] [varchar](50) NOT NULL,
	[Barrio] [varchar](50) NOT NULL,
	[Fecha nacimiento] [date] NOT NULL,
	[Edad] [int] NOT NULL,
	[IdProvincias] [int] NOT NULL,
 CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED 
(
	[IdUsuarios] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
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
SET IDENTITY_INSERT [dbo].[Categorias] ON 

INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (1, N'Tecnología')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (2, N'Libros')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (3, N'Ropa')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (4, N'Hogar')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (5, N'Deportes')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (6, N'Música')
SET IDENTITY_INSERT [dbo].[Categorias] OFF
GO
SET IDENTITY_INSERT [dbo].[Imagenes] ON 

INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (1, N'/img/perfiles/2_8df301965cc785d.png', NULL, 2)
SET IDENTITY_INSERT [dbo].[Imagenes] OFF
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
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Categorias] FOREIGN KEY([IdCategorias])
REFERENCES [dbo].[Categorias] ([IdCategorias])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Categorias]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Usuarios] FOREIGN KEY([IdUsuarios])
REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Usuarios]
GO
ALTER TABLE [dbo].[Imagenes]  WITH CHECK ADD  CONSTRAINT [FK_Imagenes_Articulos] FOREIGN KEY([IdArticulos])
REFERENCES [dbo].[Articulos] ([IdArticulos])
GO
ALTER TABLE [dbo].[Imagenes] CHECK CONSTRAINT [FK_Imagenes_Articulos]
GO
ALTER TABLE [dbo].[Imagenes]  WITH CHECK ADD  CONSTRAINT [FK_Imagenes_Usuarios] FOREIGN KEY([IdUsuarios])
REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
ALTER TABLE [dbo].[Imagenes] CHECK CONSTRAINT [FK_Imagenes_Usuarios]
GO
ALTER TABLE [dbo].[Intercambios]  WITH CHECK ADD  CONSTRAINT [FK_Intercambios_Articulos] FOREIGN KEY([IdArticulos1])
REFERENCES [dbo].[Articulos] ([IdArticulos])
GO
ALTER TABLE [dbo].[Intercambios] CHECK CONSTRAINT [FK_Intercambios_Articulos]
GO
ALTER TABLE [dbo].[Intercambios]  WITH CHECK ADD  CONSTRAINT [FK_Intercambios_Articulos1] FOREIGN KEY([IdArticulos2])
REFERENCES [dbo].[Articulos] ([IdArticulos])
GO
ALTER TABLE [dbo].[Intercambios] CHECK CONSTRAINT [FK_Intercambios_Articulos1]
GO
ALTER TABLE [dbo].[Intercambios]  WITH CHECK ADD  CONSTRAINT [FK_Intercambios_Usuarios] FOREIGN KEY([IdUsuarios1])
REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
ALTER TABLE [dbo].[Intercambios] CHECK CONSTRAINT [FK_Intercambios_Usuarios]
GO
ALTER TABLE [dbo].[Intercambios]  WITH CHECK ADD  CONSTRAINT [FK_Intercambios_Usuarios1] FOREIGN KEY([IdUsuarios2])
REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
ALTER TABLE [dbo].[Intercambios] CHECK CONSTRAINT [FK_Intercambios_Usuarios1]
GO
ALTER TABLE [dbo].[Mensajes]  WITH CHECK ADD  CONSTRAINT [FK_Mensajes_Intercambios] FOREIGN KEY([IdIntercambio])
REFERENCES [dbo].[Intercambios] ([IdIntercambios])
GO
ALTER TABLE [dbo].[Mensajes] CHECK CONSTRAINT [FK_Mensajes_Intercambios]
GO
ALTER TABLE [dbo].[Mensajes]  WITH CHECK ADD  CONSTRAINT [FK_Mensajes_Usuarios2] FOREIGN KEY([IdUsuariosManda])
REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
ALTER TABLE [dbo].[Mensajes] CHECK CONSTRAINT [FK_Mensajes_Usuarios2]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Provincias] FOREIGN KEY([IdProvincias])
REFERENCES [dbo].[Provincias] ([IdProvincia])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_Provincias]
GO
/****** Object:  StoredProcedure [dbo].[RegistrarArticulo]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarArticulo]
	@nombre varchar(50),
	@descripcion varchar(50),
	@estado varchar(50),
    @usuario VARCHAR(50),
    @categoria VARCHAR(50)
AS
BEGIN
	    IF EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuario)
        BEGIN
            IF EXISTS (SELECT Nombre FROM Categorias WHERE Nombre = @categoria)
            BEGIN
                INSERT INTO Articulos (Nombre, Descripcion, Estado, IdUsuarios, IdCategorias)
                VALUES(@nombre, @descripcion, @estado, (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuario), (SELECT IdCategorias
                FROM Categorias WHERE Nombre = @categoria))
            END
        END
END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarIntercambio]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarIntercambio]
    @fecha DATE,
    @estado VARCHAR(50),
    @Usuario1 VARCHAR(50),
    @Usuario2 VARCHAR(50),
    @Articulo1 VARCHAR(50),
    @Articulo2 VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario1)
    BEGIN
        IF EXISTS (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario2)
        BEGIN
            IF EXISTS (SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo1)
            BEGIN
                IF EXISTS (SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo2)
                BEGIN
                    IF @fecha < GETDATE()
                    BEGIN
                        INSERT INTO Intercambios (Fecha, Estado, IdUsuarios1, IdUsuarios2, IdArticulos1, IdArticulos2)
                        VALUES
                            (@fecha, @estado,
                             (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario1),
                             (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario2),
                             (SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo1),
                             (SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo2))
                    END
                END
            END
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarMensaje]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarMensaje]
	@texto varchar(50),
	@fueVisto bit,
	@fechaEnviado date,
	@usuariomanda varchar(50),
	@usuariorecibe varchar(50),
	@idIntercambio int

AS
BEGIN
    IF EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuariomanda)
    BEGIN
        IF EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuariorecibe)
        BEGIN
            IF EXISTS (SELECT IdIntercambios FROM Intercambios WHERE IdIntercambios = @idIntercambio)
            BEGIN
                INSERT INTO Mensajes (Texto, fueVisto, FechaEnviado, FechaRecibido, IdUsuariosManda, IdIntercambio)
                VALUES (@texto, @fueVisto, @fechaEnviado, @fechaEnviado,
                     (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuariomanda), @idIntercambio)
            END
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarUsuario]    Script Date: 23/10/2026 09:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarUsuario]
	@nombre varchar(50),
	@apellido varchar(50),
	@usuario varchar(50),
	@mail varchar(50),
	@telefono int,
	@contraseña varchar(50),
	@barrio varchar(50),
	@fechaNacimiento date,
	@idProvincia int
AS
BEGIN
	IF NOT EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuario)
	BEGIN
		IF NOT EXISTS (SELECT Telefono FROM Usuarios WHERE Telefono = @telefono)
		BEGIN
			IF NOT EXISTS (SELECT Contraseña FROM Usuarios WHERE Contraseña = @contraseña)
			BEGIN
				INSERT INTO Usuarios (Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio, [Fecha nacimiento], IdProvincias)
				VALUES(@nombre, @apellido, @usuario, @mail, @telefono, @contraseña, @barrio, @fechaNacimiento, @idProvincia)
			END
		END
	END
END
GO
USE [master]
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET  READ_WRITE 
GO
/****** Vuelve a dejar la sesión ejecutando normalmente (por si algún control de arriba cortó el script). ******/
SET NOEXEC OFF
GO
