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
	[Descripcion] [varchar](500) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[IdUsuarios] [int] NOT NULL,
	[IdCategorias] [int] NOT NULL,
	[Ubicacion] [varchar](100) NULL,
	[ACambio] [varchar](100) NULL,
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
/****** Object:  Table [dbo].[EstadosArticulos]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosArticulos](
	[IdEstadosArticulos] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EstadosArticulos] PRIMARY KEY CLUSTERED 
(
	[IdEstadosArticulos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadosIntercambios]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadosIntercambios](
	[IdEstadosIntercambios] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EstadosIntercambios] PRIMARY KEY CLUSTERED 
(
	[IdEstadosIntercambios] ASC
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
	[Ruta] [varchar](100) NOT NULL,
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
	[IdEstado] [int] NOT NULL,
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
	[Texto] [varchar](500) NOT NULL,
	[fueVisto] [bit] NOT NULL,
	[FechaEnviado] [datetime] NOT NULL,
	[FechaRecibido] [datetime] NULL,
	[IdUsuariosManda] [int] NOT NULL,
	[IdIntercambio] [int] NOT NULL,
 CONSTRAINT [PK_Mensajes] PRIMARY KEY CLUSTERED 
(
	[IdMensajes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notificaciones]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notificaciones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[IdIntercambio] [int] NOT NULL,
	[IdTipoNotificacion] [int] NOT NULL,
	[Leida] [bit] NOT NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_Notificaciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
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
/****** Object:  Table [dbo].[TipoNotificaciones]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoNotificaciones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoNotificaciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
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
	[Contraseña] [varchar](100) NOT NULL,
	[Barrio] [varchar](50) NOT NULL,
	[Fecha nacimiento] [date] NOT NULL,
	[Edad] [int] NOT NULL,
	[IdProvincias] [int] NOT NULL,
	[Descripcion] [varchar](500) NULL,
 CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED 
(
	[IdUsuarios] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
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
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Categorias] FOREIGN KEY([IdCategorias])
REFERENCES [dbo].[Categorias] ([IdCategorias])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Categorias]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_EstadosArticulos] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosArticulos] ([IdEstadosArticulos])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_EstadosArticulos]
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
ALTER TABLE [dbo].[Intercambios]  WITH CHECK ADD  CONSTRAINT [FK_Intercambios_EstadosIntercambios] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosIntercambios] ([IdEstadosIntercambios])
GO
ALTER TABLE [dbo].[Intercambios] CHECK CONSTRAINT [FK_Intercambios_EstadosIntercambios]
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
ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD  CONSTRAINT [FK_Notificaciones_Intercambios] FOREIGN KEY([IdIntercambio])
REFERENCES [dbo].[Intercambios] ([IdIntercambios])
GO
ALTER TABLE [dbo].[Notificaciones] CHECK CONSTRAINT [FK_Notificaciones_Intercambios]
GO
ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD  CONSTRAINT [FK_Notificaciones_TipoNotificaciones] FOREIGN KEY([IdTipoNotificacion])
REFERENCES [dbo].[TipoNotificaciones] ([Id])
GO
ALTER TABLE [dbo].[Notificaciones] CHECK CONSTRAINT [FK_Notificaciones_TipoNotificaciones]
GO
ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD  CONSTRAINT [FK_Notificaciones_Usuarios] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
ALTER TABLE [dbo].[Notificaciones] CHECK CONSTRAINT [FK_Notificaciones_Usuarios]
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Provincias] FOREIGN KEY([IdProvincias])
REFERENCES [dbo].[Provincias] ([IdProvincia])
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [FK_Usuarios_Provincias]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarContrasena]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarContrasena]
	@idUsuario int,
	@contrasenaHash varchar(100)
AS
BEGIN
	UPDATE Usuarios SET Contraseña = @contrasenaHash 
	WHERE IdUsuarios = @idUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[BorrarFotoUsuario]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[BorrarFotoUsuario]
	@idUsuario int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DELETE FROM Imagenes WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticuloById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetArticuloById]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT IdArticulos, Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, ACambio
        FROM Articulos WHERE IdArticulos = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticulosCatalogo]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetArticulosCatalogo]
	@busqueda varchar(150) = NULL,
	@cantidad int = NULL,
	@categorias varchar(max) = NULL,
	@estados varchar(max) = NULL,
	@idUsuario int = NULL
AS
BEGIN
	-- @busqueda llega ya escapada para LIKE (BD.PatronBusqueda), por eso entra hasta el triple de Articulos.Nombre.
	-- @categorias y @estados: Ids separados por coma ('1,4'); NULL o vacío no filtra.
	-- Barrio: la ubicación que cargó el dueño al publicar; si no tiene, el barrio de su perfil.
	SET NOCOUNT ON;
	SELECT TOP (ISNULL(@cantidad, 2147483647)) a.IdArticulos, a.Nombre, e.Nombre AS Estado, COALESCE(NULLIF(a.Ubicacion, ''), u.Barrio) AS Barrio,
		(SELECT TOP 1 i.Ruta FROM Imagenes i WHERE i.IdArticulos = a.IdArticulos ORDER BY i.IdImagenes) AS Imagen
	FROM Articulos a
	INNER JOIN Usuarios u ON u.IdUsuarios = a.IdUsuarios
	INNER JOIN EstadosArticulos e ON e.IdEstadosArticulos = a.IdEstado
	WHERE (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
		AND (NULLIF(@categorias, '') IS NULL OR a.IdCategorias IN (SELECT CAST(value AS int) FROM STRING_SPLIT(@categorias, ',')))
		AND (NULLIF(@estados, '') IS NULL OR a.IdEstado IN (SELECT CAST(value AS int) FROM STRING_SPLIT(@estados, ',')))
		AND (@idUsuario IS NULL OR a.IdUsuarios = @idUsuario)
	ORDER BY a.IdArticulos DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategoriaById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCategoriaById]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT IdCategorias, Nombre FROM Categorias WHERE IdCategorias = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategorias]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCategorias]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT IdCategorias, Nombre FROM Categorias ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadoArticuloById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEstadoArticuloById]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos WHERE IdEstadosArticulos = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadosArticulos]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEstadosArticulos]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos ORDER BY IdEstadosArticulos
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiltroCategorias]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiltroCategorias]
	@busqueda varchar(150) = NULL
AS
BEGIN
	-- @busqueda llega ya escapada para LIKE (BD.PatronBusqueda).
	SET NOCOUNT ON;
	SELECT CAST(c.IdCategorias AS varchar(10)) AS Valor, c.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
	FROM Categorias c
	LEFT JOIN Articulos a ON a.IdCategorias = c.IdCategorias
		AND (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
	GROUP BY c.IdCategorias, c.Nombre
	ORDER BY c.Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiltroEstados]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiltroEstados]
	@busqueda varchar(150) = NULL
AS
BEGIN
	-- @busqueda llega ya escapada para LIKE (BD.PatronBusqueda). Estados de mejor a peor.
	SET NOCOUNT ON;
	SELECT CAST(e.IdEstadosArticulos AS varchar(10)) AS Valor, e.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
	FROM EstadosArticulos e
	LEFT JOIN Articulos a ON a.IdEstado = e.IdEstadosArticulos
		AND (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
	GROUP BY e.IdEstadosArticulos, e.Nombre
	ORDER BY e.IdEstadosArticulos
END
GO
/****** Object:  StoredProcedure [dbo].[GetFotoUsuario]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFotoUsuario]
	-- Add the parameters for the stored procedure here
	@idUsuario int
	AS
BEGIN
	SELECT TOP 1 Ruta FROM Imagenes WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL ORDER BY IdImagenes DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetImagenesArticulo]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetImagenesArticulo]
	-- Add the parameters for the stored procedure here
	@idArticulo int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Ruta FROM Imagenes WHERE IdArticulos = @idArticulo ORDER BY IdImagenes
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvinciaById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProvinciaById]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	SELECT IdProvincia, Nombre 
	FROM Provincias 
	WHERE IdProvincia = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvincias]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetProvincias] 

AS
BEGIN
	SELECT IdProvincia, Nombre FROM Provincias ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetUsuarioById]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[GetUsuarioById]
	@id int
AS
BEGIN
	SELECT IdUsuarios, Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio,
        [Fecha nacimiento] AS FechaNacimiento, Edad, IdProvincias, Descripcion 
		FROM Usuarios
		 WHERE IdUsuarios = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetUsuarioByMail]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUsuarioByMail]
	@Mail varchar(50)
AS
BEGIN
 SELECT IdUsuarios, Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio,
        [Fecha nacimiento] AS FechaNacimiento, Edad, IdProvincias, Descripcion FROM Usuarios
		WHERE Mail = @Mail
END
GO
/****** Object:  StoredProcedure [dbo].[GuardarFotoUsuario]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GuardarFotoUsuario]
	@idUsuario int,
	@ruta varchar(100)
	
	AS
BEGIN
	DELETE FROM Imagenes 
	WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL;
    INSERT INTO Imagenes (Ruta, IdUsuarios) VALUES (@ruta, @idUsuario)
END
GO
/****** Object:  StoredProcedure [dbo].[PublicarArticulo]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PublicarArticulo]
	@nombre varchar(50),
	@descripcion varchar(500),
	@idEstado int,
	@idUsuario int,
	@idCategoria int,
	@ubicacion varchar(100),
	@aCambio varchar(100) = NULL,
	@rutasFotos varchar(max) = NULL
AS
BEGIN
	-- Guarda el artículo y sus fotos en una transacción: si falla algo, no queda un artículo a medias.
	-- @rutasFotos: rutas separadas por '|' (no puede aparecer en un nombre de archivo); la primera es la portada.
	-- Devuelve el IdArticulos nuevo.
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	DECLARE @idArticulo int, @ruta varchar(max), @pos int

	BEGIN TRANSACTION
	INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, ACambio)
	VALUES (@nombre, @descripcion, @idEstado, @idUsuario, @idCategoria, @ubicacion, @aCambio)
	SET @idArticulo = SCOPE_IDENTITY()

	-- Se recorren en orden (STRING_SPLIT no lo garantiza): la portada es la foto de menor IdImagenes.
	WHILE LEN(@rutasFotos) > 0
	BEGIN
		SET @pos = CHARINDEX('|', @rutasFotos)
		IF @pos = 0 SET @pos = LEN(@rutasFotos) + 1
		SET @ruta = LEFT(@rutasFotos, @pos - 1)
		SET @rutasFotos = SUBSTRING(@rutasFotos, @pos + 1, LEN(@rutasFotos))
		IF @ruta <> '' INSERT INTO Imagenes (Ruta, IdArticulos) VALUES (@ruta, @idArticulo)
	END
	COMMIT TRANSACTION

	SELECT @idArticulo AS IdArticulos
END
GO
/****** Object:  StoredProcedure [dbo].[RegistrarArticulo]    Script Date: 28/10/2026 12:02:01 ******/
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
            IF EXISTS (SELECT Nombre FROM Categorias WHERE Nombre = @categoria) AND EXISTS (SELECT Nombre FROM EstadosArticulos WHERE Nombre = @estado)
            BEGIN
                INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias)
                VALUES(@nombre, @descripcion, (SELECT IdEstadosArticulos FROM EstadosArticulos WHERE Nombre = @estado), (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuario), (SELECT IdCategorias
                FROM Categorias WHERE Nombre = @categoria))
            END
        END
END

GO
/****** Object:  StoredProcedure [dbo].[RegistrarIntercambio]    Script Date: 28/10/2026 12:02:01 ******/
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
                    IF @fecha < GETDATE() AND EXISTS (SELECT Nombre FROM EstadosIntercambios WHERE Nombre = @estado)
                    BEGIN
                        INSERT INTO Intercambios (Fecha, IdEstado, IdUsuarios1, IdUsuarios2, IdArticulos1, IdArticulos2)
                        VALUES
                            (@fecha, (SELECT IdEstadosIntercambios FROM EstadosIntercambios WHERE Nombre = @estado),
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
/****** Object:  StoredProcedure [dbo].[RegistrarMensaje]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarMensaje]
	@texto varchar(500),
	@fueVisto bit,
	@fechaEnviado datetime,
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
/****** Object:  StoredProcedure [dbo].[RegistrarUsuario]    Script Date: 28/10/2026 12:02:01 ******/
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
	@contraseña varchar(100),
	@barrio varchar(50),
	@fechaNacimiento date,
	@idProvincia int
AS
BEGIN
	IF NOT EXISTS (SELECT Usuario FROM Usuarios WHERE Usuario = @usuario)
	BEGIN
		IF NOT EXISTS (SELECT Telefono FROM Usuarios WHERE Telefono = @telefono)
		BEGIN
			INSERT INTO Usuarios (Nombre, Apellido, Usuario, Mail, Telefono, Contraseña, Barrio, [Fecha nacimiento], IdProvincias)
			VALUES(@nombre, @apellido, @usuario, @mail, @telefono, @contraseña, @barrio, @fechaNacimiento, @idProvincia)
		END
	END
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateUsuario]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUsuario]
	@idUsuario int,
	@nombre varchar(50),
	@apellido varchar(50),
	@usuario varchar(50),
	@mail varchar(50),
	@telefono int,
	@contraseña varchar(100),
	@barrio varchar(50),
	@fechaNacimiento date,
	@edad int,
	@idProvincia int,
	@descripcion varchar(500)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Usuarios SET Nombre = @nombre, Apellido = @apellido, Usuario = @usuario, Mail = @mail,
		Telefono = @telefono, Contraseña = @contraseña, Barrio = @barrio, [Fecha nacimiento] = @fechaNacimiento,
		Edad = @edad, IdProvincias = @idProvincia, Descripcion = @descripcion
	WHERE IdUsuarios = @idUsuario
END
GO
/****** Object:  StoredProcedure [dbo].[UsuarioExiste]    Script Date: 28/10/2026 12:02:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UsuarioExiste]
	@mail varchar(50)
AS
BEGIN
	SELECT COUNT(*) FROM Usuarios WHERE Mail = @mail
END
GO
USE [master]
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET  READ_WRITE 
GO
/****** Vuelve a dejar la sesión ejecutando normalmente (por si algún control de arriba cortó el script). ******/
SET NOEXEC OFF
GO
