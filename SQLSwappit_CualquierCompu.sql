USE [master]
GO
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
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'alumno') AND DATABASE_PRINCIPAL_ID(N'alumno') IS NULL
	CREATE USER [alumno] FOR LOGIN [alumno] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Articulos]    Script Date: 29/10/2026 13:39:32 ******/
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
	[FechaPublicacion] [date] NOT NULL,
	[IdCategoriaACambio] [int] NULL,
 CONSTRAINT [PK_Articulos] PRIMARY KEY CLUSTERED 
(
	[IdArticulos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ArticulosIntercambios]    Script Date: 11/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticulosIntercambios](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[IdIntercambio] [int] NOT NULL,
 CONSTRAINT [PK_ArticulosIntercambios] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_ArticulosIntercambios] UNIQUE NONCLUSTERED
(
	[IdIntercambio] ASC,
	[IdArticulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CambiosIntercambios]    Script Date: 14/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CambiosIntercambios](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdIntercambio] [int] NOT NULL,
	[IdArticulo] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[IdTipoCambio] [int] NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[FechaRespuesta] [datetime] NULL,
 CONSTRAINT [PK_CambiosIntercambios] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_CambiosIntercambios_IdIntercambio]    Script Date: 14/11/2026 12:00:00 ******/
CREATE NONCLUSTERED INDEX [IX_CambiosIntercambios_IdIntercambio] ON [dbo].[CambiosIntercambios]
(
	[IdIntercambio] ASC,
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categorias]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  Table [dbo].[EstadosArticulos]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  Table [dbo].[EstadosIntercambios]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  Table [dbo].[Imagenes]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  Table [dbo].[Interacciones]    Script Date: 05/11/2026 10:02:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Interacciones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[IdTipoInteraccion] [int] NOT NULL,
	[IdArticulo] [int] NULL,
	[IdCategoria] [int] NULL,
	[Texto] [varchar](100) NULL,
	[Segundos] [int] NULL,
	[Fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_Interacciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Interacciones_Usuario_Fecha]    Script Date: 05/11/2026 10:02:21 ******/
CREATE NONCLUSTERED INDEX [IX_Interacciones_Usuario_Fecha] ON [dbo].[Interacciones]
(
	[IdUsuario] ASC,
	[Fecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Intercambios]    Script Date: 29/10/2026 13:39:32 ******/
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
	[Ubicacion] [varchar](50) NULL,
 CONSTRAINT [PK_Intercambios] PRIMARY KEY CLUSTERED 
(
	[IdIntercambios] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Mensajes]    Script Date: 29/10/2026 13:39:32 ******/
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
	[IdCambio] [int] NULL,
 CONSTRAINT [PK_Notificaciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Provincias]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  Table [dbo].[TipoCambios]    Script Date: 14/11/2026 12:00:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoCambios](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoCambios] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoInteracciones]    Script Date: 05/11/2026 10:02:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoInteracciones](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoInteracciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
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
/****** Object:  Table [dbo].[Usuarios]    Script Date: 29/10/2026 13:39:32 ******/
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
	[Telefono] [varchar](20) NOT NULL,
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
/****** Datos de prueba: los usuarios 3 a 12 y 14 a 45 (mails @example.com) con sus artículos, intercambios e interacciones. Los usuarios 44 (prueba.uno, contraseña SwappitPrueba1!) y 45 (prueba.dos, contraseña SwappitPrueba2!) tienen 4 artículos cada uno y ningún intercambio, para probar. Sus contraseñas están en texto plano y se re-hashean en el primer login. Las fechas son relativas a GETDATE() para que siempre sean recientes. Los usuarios 2 y 13 son cuentas reales. ******/
SET IDENTITY_INSERT [dbo].[Articulos] ON 

INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (1, N'Microondas 20 L', N'Funciona perfecto, poco uso', 2, 3, 10, NULL, CAST(DATEADD(DAY, -68, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (2, N'Juego de sábanas 2 plazas', N'Algodón, lavadas y planchadas', 3, 3, 4, NULL, CAST(DATEADD(DAY, -68, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (3, N'Mesa de luz', N'Madera, con un cajón', 3, 4, 8, NULL, CAST(DATEADD(DAY, -68, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (4, N'Pava eléctrica', N'1,7 L, con corte automático', 2, 4, 10, NULL, CAST(DATEADD(DAY, -68, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (5, N'Sillas de comedor x2', N'Madera maciza, firmes', 3, 5, 8, NULL, CAST(DATEADD(DAY, -67, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (6, N'Sartén antiadherente', N'28 cm, sin rayones', 2, 5, 7, NULL, CAST(DATEADD(DAY, -67, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (7, N'Escritorio plegable', N'Ideal para monoambiente', 2, 6, 8, NULL, CAST(DATEADD(DAY, -67, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (8, N'Router WiFi', N'Incluye fuente, funciona bien', 3, 6, 1, NULL, CAST(DATEADD(DAY, -67, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (9, N'Juego de ollas', N'Tres ollas de acero con tapa', 3, 7, 7, NULL, CAST(DATEADD(DAY, -66, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (10, N'Libro de recetas fáciles', N'Recetas simples para el día a día', 2, 7, 2, NULL, CAST(DATEADD(DAY, -66, GETDATE()) AS Date), 4)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (11, N'Estantería de 4 estantes', N'Melamina blanca, fácil de armar', 3, 8, 8, NULL, CAST(DATEADD(DAY, -66, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (12, N'Aspiradora', N'Buena succión, con accesorios', 3, 8, 10, NULL, CAST(DATEADD(DAY, -66, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (13, N'Cortinas blackout', N'Par de paños, color gris', 2, 9, 9, NULL, CAST(DATEADD(DAY, -65, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (14, N'Bicicleta urbana', N'Rodado 26, ideal para la ciudad', 3, 9, 5, NULL, CAST(DATEADD(DAY, -65, GETDATE()) AS Date), 8)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (15, N'Colchón de 1 plaza', N'Espuma, sin manchas', 3, 10, 4, NULL, CAST(DATEADD(DAY, -65, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (16, N'Tostadora', N'Dos ranuras, funciona bien', 2, 10, 10, NULL, CAST(DATEADD(DAY, -65, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (17, N'Vajilla para 4 personas', N'Platos, vasos y cubiertos', 2, 11, 7, NULL, CAST(DATEADD(DAY, -64, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (18, N'Perchero de pie', N'Metal negro, estable', 3, 11, 8, NULL, CAST(DATEADD(DAY, -64, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (19, N'Espejo de pie', N'Marco de madera, sin rayones', 2, 12, 9, NULL, CAST(DATEADD(DAY, -64, GETDATE()) AS Date), 9)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (20, N'Ventilador de pie', N'Tres velocidades, silencioso', 3, 12, 10, NULL, CAST(DATEADD(DAY, -64, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (21, N'Taza', N'cxz', 2, 2, 5, N'Almagro', CAST(DATEADD(DAY, -63, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (22, N'Raqueta de tenis', N'Con funda. El encordado está bien.', 3, 30, 5, NULL, CAST(DATEADD(DAY, -60, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (23, N'Mancuernas de 5 kg (par)', N'Recubiertas de goma, no rayan el piso.', 3, 23, 5, NULL, CAST(DATEADD(DAY, -58, GETDATE()) AS Date), 9)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (24, N'Cafetera italiana', N'De aluminio, para seis tazas. Con burlete nuevo.', 3, 32, 7, NULL, CAST(DATEADD(DAY, -58, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (25, N'Hábitos atómicos', N'Lo leí una vez, está impecable.', 2, 26, 2, NULL, CAST(DATEADD(DAY, -57, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (26, N'Licuadora', N'Vaso de vidrio de 1,5 L y tres velocidades. La usé muy poco.', 2, 18, 10, NULL, CAST(DATEADD(DAY, -56, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (27, N'Guantes de boxeo', N'12 oz, con vendas de regalo.', 3, 23, 5, NULL, CAST(DATEADD(DAY, -56, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (28, N'Mafalda, tomos 1 a 5', N'Los cinco tomos de las tiras. Algunas tapas están gastadas.', 3, 29, 2, NULL, CAST(DATEADD(DAY, -56, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (29, N'Violín 4/4', N'Con arco y estuche. Necesita cuerdas nuevas.', 4, 37, 6, NULL, CAST(DATEADD(DAY, -55, GETDATE()) AS Date), 8)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (30, N'Vinilos de rock nacional', N'Ocho discos de rock nacional de los 80 y 90, bien cuidados.', 3, 43, 6, NULL, CAST(DATEADD(DAY, -55, GETDATE()) AS Date), 8)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (31, N'Armónica en Do', N'Diatónica, con estuche. Casi sin uso.', 2, 15, 6, NULL, CAST(DATEADD(DAY, -54, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (32, N'Skate completo', N'Tabla de 8 pulgadas, ruedas nuevas. La lija está gastada.', 4, 27, 5, NULL, CAST(DATEADD(DAY, -54, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (33, N'Buzo con capucha talle L', N'Gris, de algodón frisado. Está lavado.', 4, 35, 3, NULL, CAST(DATEADD(DAY, -54, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (34, N'Afinador digital', N'De clip, sirve para guitarra, bajo y ukelele.', 2, 24, 6, NULL, CAST(DATEADD(DAY, -53, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (35, N'Bajo eléctrico', N'Cuatro cuerdas, con funda y cable.', 3, 40, 6, NULL, CAST(DATEADD(DAY, -53, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (36, N'Botas de cuero talle 38', N'Cuero marrón con cierre al costado. Tienen algunas marcas de uso en la punta.', 3, 14, 12, NULL, CAST(DATEADD(DAY, -52, GETDATE()) AS Date), 8)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (37, N'Conservadora portátil', N'20 L, mantiene el frío todo el día.', 3, 39, 5, NULL, CAST(DATEADD(DAY, -52, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (38, N'Teclado mecánico', N'Switches rojos y luz blanca. Lo cambio porque me pasé a uno más chico.', 2, 15, 1, NULL, CAST(DATEADD(DAY, -51, GETDATE()) AS Date), 11)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (39, N'Alfombra 1,5 x 2 m', N'Tonos beige, pelo corto. Está lavada.', 4, 20, 9, NULL, CAST(DATEADD(DAY, -51, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (40, N'Bufanda y gorro de lana', N'Tejidos a mano, color mostaza.', 2, 30, 12, NULL, CAST(DATEADD(DAY, -51, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (41, N'Libro de cocina vegetariana', N'Recetas simples y económicas. Sin manchas.', 2, 41, 2, NULL, CAST(DATEADD(DAY, -50, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (42, N'Pesa rusa 8 kg', N'De hierro con base plana. Tiene algo de pintura saltada.', 3, 19, 5, NULL, CAST(DATEADD(DAY, -49, GETDATE()) AS Date), 8)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (43, N'Lámpara de escritorio LED', N'Tres intensidades de luz y cuello flexible. Se carga por USB.', 2, 32, 9, NULL, CAST(DATEADD(DAY, -49, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (44, N'Webcam HD', N'1080p con micrófono incorporado. Ideal para videollamadas del trabajo.', 2, 19, 1, NULL, CAST(DATEADD(DAY, -48, GETDATE()) AS Date), 9)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (45, N'Disco externo 1 TB', N'USB 3.0, formateado y vacío. Con su cable.', 3, 19, 1, NULL, CAST(DATEADD(DAY, -48, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (46, N'Bolsa de dormir', N'Aguanta hasta 0 °C. Se lavó después del último uso.', 3, 31, 5, NULL, CAST(DATEADD(DAY, -48, GETDATE()) AS Date), 4)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (47, N'Mochila de trekking 40 L', N'Con cubre mochila para la lluvia. Tiene un cierre que se traba un poco.', 4, 31, 5, NULL, CAST(DATEADD(DAY, -48, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (48, N'Cajón peruano', N'Con bordona regulable y almohadón.', 2, 40, 6, NULL, CAST(DATEADD(DAY, -47, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (49, N'Saga de Harry Potter', N'Los siete libros. Los lomos están un poco gastados.', 3, 41, 2, NULL, CAST(DATEADD(DAY, -47, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (50, N'Parlante bluetooth', N'Resiste salpicaduras. Ideal para el balcón o la playa.', 3, 38, 11, NULL, CAST(DATEADD(DAY, -46, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (51, N'Piloto impermeable talle L', N'Con capucha. Aguanta lluvia fuerte.', 3, 31, 3, NULL, CAST(DATEADD(DAY, -45, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (52, N'Pollera de jean talle 36', N'Tiro alto, corte recto. Me quedó chica.', 3, 14, 3, NULL, CAST(DATEADD(DAY, -44, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (53, N'Mouse inalámbrico', N'Con receptor USB. Anda con una pila AA que dura meses.', 2, 19, 1, NULL, CAST(DATEADD(DAY, -43, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (54, N'Auriculares de estudio', N'Cerrados, cable de 3 m. Las almohadillas están cambiadas.', 3, 33, 11, NULL, CAST(DATEADD(DAY, -43, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (55, N'Ficciones de Borges', N'Edición de bolsillo con algunas páginas subrayadas en lápiz.', 4, 17, 2, NULL, CAST(DATEADD(DAY, -41, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (56, N'Monitor 22 pulgadas', N'Full HD, entradas HDMI y VGA. Incluye el cable de alimentación.', 3, 17, 1, NULL, CAST(DATEADD(DAY, -40, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (57, N'Auriculares bluetooth', N'La batería dura unas 15 horas. Con estuche y cable de carga.', 3, 35, 11, NULL, CAST(DATEADD(DAY, -40, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (58, N'Libro de yoga para principiantes', N'Con posturas explicadas paso a paso.', 2, 38, 2, NULL, CAST(DATEADD(DAY, -40, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (59, N'Secador de pelo', N'2000 W, dos temperaturas y difusor. Funciona perfecto.', 3, 16, 10, NULL, CAST(DATEADD(DAY, -39, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (60, N'Sillón de un cuerpo', N'Tapizado gris, muy cómodo. Hay que pasar a buscarlo.', 3, 20, 8, NULL, CAST(DATEADD(DAY, -39, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (61, N'Guitarra criolla', N'Con funda y cuerdas nuevas. Suena muy bien.', 3, 36, 6, NULL, CAST(DATEADD(DAY, -39, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (62, N'Bicicleta fija plegable', N'Con contador de tiempo y calorías. Ocupa poco lugar.', 3, 25, 5, NULL, CAST(DATEADD(DAY, -37, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (63, N'Micrófono USB', N'Cardioide, ideal para grabar voces o podcasts. Con trípode.', 2, 33, 6, NULL, CAST(DATEADD(DAY, -37, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (64, N'Casco de bici', N'Talle M, regulable, con luz trasera.', 2, 27, 5, NULL, CAST(DATEADD(DAY, -36, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (65, N'Rayuela de Cortázar', N'Edición de bolsillo, sin anotaciones.', 3, 29, 2, NULL, CAST(DATEADD(DAY, -35, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (66, N'Carpa para 2 personas', N'Se arma en cinco minutos. La usé en dos campamentos.', 3, 31, 5, NULL, CAST(DATEADD(DAY, -34, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (67, N'Zapatillas running talle 38', N'Usadas unos meses, la suela está en buen estado.', 3, 39, 12, NULL, CAST(DATEADD(DAY, -33, GETDATE()) AS Date), 9)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (68, N'Batería electrónica', N'Compacta, ideal para depto: con auriculares no molesta a nadie.', 3, 42, 6, NULL, CAST(DATEADD(DAY, -33, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (69, N'Teclado musical 61 teclas', N'Con fuente y atril. Tiene ritmos y salida para auriculares.', 3, 24, 6, NULL, CAST(DATEADD(DAY, -32, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (70, N'Diccionario inglés-español', N'De bolsillo. Tiene el nombre escrito en la primera hoja.', 4, 28, 2, NULL, CAST(DATEADD(DAY, -32, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (71, N'Organizador de placard', N'De tela con seis divisiones. Se cuelga de la barra.', 2, 25, 4, NULL, CAST(DATEADD(DAY, -31, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (72, N'Set de frascos de vidrio', N'Seis frascos con tapa hermética para la alacena.', 2, 26, 7, NULL, CAST(DATEADD(DAY, -31, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (73, N'Pie de micrófono', N'Tipo jirafa, regulable en altura.', 3, 33, 6, NULL, CAST(DATEADD(DAY, -31, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (74, N'Mesa ratona de madera', N'Pino macizo, 90 x 50 cm. Tiene algunas marcas de tazas.', 3, 34, 8, NULL, CAST(DATEADD(DAY, -31, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (75, N'Cafetera de filtro', N'Para 10 tazas, con jarra de vidrio y filtro permanente.', 3, 20, 10, NULL, CAST(DATEADD(DAY, -30, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (76, N'Planta potus con maceta', N'Grande y sana, con maceta de cerámica blanca.', 2, 34, 13, NULL, CAST(DATEADD(DAY, -29, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (77, N'Lámpara de pie', N'Metal negro con pantalla de tela. Le cambié el cable hace poco.', 3, 17, 9, NULL, CAST(DATEADD(DAY, -28, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (78, N'Mochila urbana', N'Con compartimento para notebook de 15 pulgadas.', 3, 29, 12, NULL, CAST(DATEADD(DAY, -28, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (79, N'Guía de plantas de interior', N'Explica riego, luz y trasplante. Ideal si arrancás con plantas.', 2, 34, 2, NULL, CAST(DATEADD(DAY, -28, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (80, N'Sweater de lana talle S', N'Color crema, muy abrigado. Sin pelotitas.', 3, 16, 3, NULL, CAST(DATEADD(DAY, -27, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (81, N'Cien años de soledad', N'Tapa blanda, bien cuidado.', 3, 28, 2, NULL, CAST(DATEADD(DAY, -25, GETDATE()) AS Date), 4)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (82, N'Campera de jean talle M', N'Clásica, con botones metálicos. Poco uso.', 3, 35, 3, NULL, CAST(DATEADD(DAY, -23, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (83, N'Pelota de fútbol N° 5', N'Cosida, aguanta bien. Le falta un poco de aire.', 4, 23, 5, NULL, CAST(DATEADD(DAY, -22, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (84, N'Smart TV 32 pulgadas', N'Funciona perfecto, con control remoto. La cambio porque me regalaron una más grande.', 3, 21, 11, NULL, CAST(DATEADD(DAY, -21, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (85, N'Campera inflable talle S', N'Negra, liviana y muy abrigada. Entra en su propia bolsita.', 2, 18, 3, NULL, CAST(DATEADD(DAY, -20, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (86, N'Camisa de lino talle M', N'Color arena, fresca para el verano.', 2, 22, 3, NULL, CAST(DATEADD(DAY, -20, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (87, N'Juego de toallas', N'Dos toallones y dos toallas de mano, lavados y suaves.', 3, 22, 4, NULL, CAST(DATEADD(DAY, -18, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (88, N'Riñonera', N'Negra, impermeable, con tres bolsillos.', 2, 28, 12, NULL, CAST(DATEADD(DAY, -18, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (89, N'Sapiens', N'Tapa blanda, como nuevo.', 2, 37, 2, NULL, CAST(DATEADD(DAY, -16, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (90, N'El Eternauta', N'Edición integral en un tomo.', 3, 36, 2, NULL, CAST(DATEADD(DAY, -15, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (91, N'Libros del CBC de Economía', N'Libros y resúmenes para el CBC. Algunas páginas tienen marcador.', 4, 42, 2, NULL, CAST(DATEADD(DAY, -13, GETDATE()) AS Date), 13)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (92, N'Saco de vestir talle 48', N'Azul marino. Lo usé en dos casamientos.', 2, 21, 3, NULL, CAST(DATEADD(DAY, -12, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (93, N'La sombra del viento', N'Tapa blanda. Una de mis novelas favoritas.', 3, 26, 2, NULL, CAST(DATEADD(DAY, -12, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (94, N'Atlas de Argentina', N'Mapas físicos y políticos por provincia. Tapa dura.', 3, 17, 2, NULL, CAST(DATEADD(DAY, -11, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (95, N'Mat de yoga', N'6 mm, antideslizante, con correa para llevarlo.', 3, 18, 5, NULL, CAST(DATEADD(DAY, -11, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (96, N'Paleta de pádel', N'Con funda. La goma está en buen estado.', 3, 21, 5, NULL, CAST(DATEADD(DAY, -11, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (97, N'Zapatos de vestir talle 42', N'Negros, de cuero. Los usé para algunas entrevistas.', 3, 27, 12, NULL, CAST(DATEADD(DAY, -11, GETDATE()) AS Date), 11)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (98, N'Ukelele soprano', N'Con funda acolchada y cuerdas nuevas. Ideal para arrancar.', 3, 15, 6, NULL, CAST(DATEADD(DAY, -10, GETDATE()) AS Date), 6)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (99, N'Vestido largo floreado talle M', N'Tela liviana, ideal para el verano. Lo usé dos veces.', 2, 14, 3, NULL, CAST(DATEADD(DAY, -9, GETDATE()) AS Date), 2)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (100, N'CDs de jazz', N'Doce discos originales, con sus cajas.', 3, 36, 6, NULL, CAST(DATEADD(DAY, -9, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (101, N'Pack de novelas policiales', N'Cinco novelas de Agatha Christie en edición de bolsillo.', 3, 28, 2, NULL, CAST(DATEADD(DAY, -8, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (102, N'El principito ilustrado', N'Edición de tapa dura con las ilustraciones originales.', 2, 16, 2, NULL, CAST(DATEADD(DAY, -7, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (103, N'Tocadiscos', N'Con parlantes incorporados y salida auxiliar.', 3, 37, 11, NULL, CAST(DATEADD(DAY, -7, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (104, N'Plancha a vapor', N'Calienta rápido y tiene suela antiadherente.', 3, 25, 10, NULL, CAST(DATEADD(DAY, -5, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (105, N'Rollers talle 39', N'Con protecciones para rodillas y codos.', 3, 43, 5, NULL, CAST(DATEADD(DAY, -5, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (106, N'Bandas elásticas de entrenamiento', N'Set de cinco intensidades con bolsita.', 2, 23, 5, NULL, CAST(DATEADD(DAY, -4, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (107, N'Pedal de distorsión', N'Analógico, con fuente de 9 V.', 2, 33, 6, NULL, CAST(DATEADD(DAY, -4, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (108, N'Amplificador de guitarra 15 W', N'Con entrada para auriculares. Ideal para practicar en casa.', 3, 40, 6, NULL, CAST(DATEADD(DAY, -4, GETDATE()) AS Date), NULL)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (109, N'Jean recto talle 40', N'Azul clásico. Lo cambio porque ya no me entra.', 3, 30, 3, NULL, CAST(DATEADD(DAY, -3, GETDATE()) AS Date), 8)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (110, N'Pack de remeras básicas talle M', N'Tres remeras lisas de algodón: blanca, negra y gris.', 2, 22, 3, NULL, CAST(DATEADD(DAY, -2, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (111, N'Notebook para estudiar', N'Core i3 y 8 GB de RAM. Anda bien para Office y navegar; la batería dura poco.', 4, 38, 1, NULL, CAST(DATEADD(DAY, -2, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (112, N'Lámpara de escritorio', N'Lámpara de prueba. Brazo articulado, luz cálida.', 2, 44, 4, NULL, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 1)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (113, N'Libro de cocina', N'Libro de prueba con recetas fáciles.', 3, 44, 2, NULL, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 7)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (114, N'Auriculares con cable', N'Auriculares de prueba. Andan bien.', 4, 44, 11, NULL, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (115, N'Maceta grande', N'Maceta de prueba, de cerámica.', 1, 44, 13, NULL, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 9)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (116, N'Mochila', N'Mochila de prueba, con varios bolsillos.', 2, 45, 12, NULL, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 5)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (117, N'Juego de tazas', N'Juego de prueba de 4 tazas.', 3, 45, 7, NULL, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 4)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (118, N'Pelota de fútbol', N'Pelota de prueba, número 5.', 4, 45, 5, NULL, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 3)
INSERT [dbo].[Articulos] ([IdArticulos], [Nombre], [Descripcion], [IdEstado], [IdUsuarios], [IdCategorias], [Ubicacion], [FechaPublicacion], [IdCategoriaACambio]) VALUES (119, N'Cuadro decorativo', N'Cuadro de prueba, 40 x 50 cm.', 2, 45, 9, NULL, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 8)
SET IDENTITY_INSERT [dbo].[Articulos] OFF
GO
SET IDENTITY_INSERT [dbo].[Categorias] ON 

INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (1, N'Tecnología')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (2, N'Libros')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (3, N'Ropa')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (4, N'Hogar')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (5, N'Deportes')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (6, N'Música')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (7, N'Cocina')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (8, N'Muebles')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (9, N'Decoración')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (10, N'Electrodomésticos')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (11, N'Audio y TV')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (12, N'Calzado y accesorios')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (13, N'Plantas y jardín')
INSERT [dbo].[Categorias] ([IdCategorias], [Nombre]) VALUES (14, N'Herramientas')
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
INSERT [dbo].[EstadosIntercambios] ([IdEstadosIntercambios], [Nombre]) VALUES (5, N'Cancelado')
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
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (23, N'/img/articulos/2_8df35a34bad2db2_1.png', 21, NULL)
INSERT [dbo].[Imagenes] ([IdImagenes], [Ruta], [IdArticulos], [IdUsuarios]) VALUES (24, N'/img/articulos/2_8df35a34bad2db2_2.png', 21, NULL)
SET IDENTITY_INSERT [dbo].[Imagenes] OFF
GO
SET IDENTITY_INSERT [dbo].[Interacciones] ON 

INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (1, 22, 3, NULL, 5, NULL, NULL, DATEADD(MINUTE, -880, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (2, 22, 1, 14, NULL, NULL, 99, DATEADD(MINUTE, -879, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (3, 22, 1, 16, NULL, NULL, 9, DATEADD(MINUTE, -877, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (4, 35, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -599, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (5, 35, 1, 10, NULL, NULL, 191, DATEADD(MINUTE, -598, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (6, 35, 4, 10, NULL, NULL, NULL, DATEADD(MINUTE, -595, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (7, 35, 1, 6, NULL, NULL, 41, DATEADD(MINUTE, -594, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (8, 24, 3, NULL, 3, NULL, NULL, DATEADD(MINUTE, -545, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (9, 24, 1, 2, NULL, NULL, 44, DATEADD(MINUTE, -544, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (10, 33, 1, 16, NULL, NULL, 190, DATEADD(MINUTE, -518, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (11, 14, 2, NULL, NULL, N'escritorio', NULL, DATEADD(MINUTE, -461, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (12, 14, 1, 7, NULL, NULL, 122, DATEADD(MINUTE, -459, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (13, 14, 4, 7, NULL, NULL, NULL, DATEADD(MINUTE, -456, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (14, 26, 2, NULL, NULL, N'cortinas', NULL, DATEADD(MINUTE, -121, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (15, 26, 1, 13, NULL, NULL, 29, DATEADD(MINUTE, -120, DATEADD(DAY, -60, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (16, 38, 2, NULL, NULL, N'estantería', NULL, DATEADD(MINUTE, -826, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (17, 38, 1, 11, NULL, NULL, 11, DATEADD(MINUTE, -825, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (18, 4, 3, NULL, 7, NULL, NULL, DATEADD(MINUTE, -371, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (19, 4, 1, 15, NULL, NULL, 23, DATEADD(MINUTE, -369, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (20, 4, 1, 9, NULL, NULL, 223, DATEADD(MINUTE, -367, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (21, 4, 4, 9, NULL, NULL, NULL, DATEADD(MINUTE, -365, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (22, 4, 1, 13, NULL, NULL, 97, DATEADD(MINUTE, -364, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (23, 4, 1, 17, NULL, NULL, 56, DATEADD(MINUTE, -362, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (24, 31, 2, NULL, NULL, N'ollas', NULL, DATEADD(MINUTE, -109, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (25, 31, 1, 9, NULL, NULL, 106, DATEADD(MINUTE, -108, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (26, 31, 4, 9, NULL, NULL, NULL, DATEADD(MINUTE, -105, DATEADD(DAY, -59, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (27, 36, 2, NULL, NULL, N'aspiradora', NULL, DATEADD(MINUTE, -824, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (28, 36, 1, 12, NULL, NULL, 207, DATEADD(MINUTE, -822, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (29, 42, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -777, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (30, 42, 1, 10, NULL, NULL, 106, DATEADD(MINUTE, -775, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (31, 42, 1, 8, NULL, NULL, 34, DATEADD(MINUTE, -772, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (32, 16, 2, NULL, NULL, N'estantería', NULL, DATEADD(MINUTE, -629, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (33, 16, 1, 11, NULL, NULL, 145, DATEADD(MINUTE, -628, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (34, 16, 4, 11, NULL, NULL, NULL, DATEADD(MINUTE, -624, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (35, 11, 1, 14, NULL, NULL, 59, DATEADD(MINUTE, -509, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (36, 18, 3, NULL, 6, NULL, NULL, DATEADD(MINUTE, -375, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (37, 18, 1, 10, NULL, NULL, 68, DATEADD(MINUTE, -373, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (38, 12, 2, NULL, NULL, N'colchón', NULL, DATEADD(MINUTE, -213, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (39, 12, 1, 15, NULL, NULL, 238, DATEADD(MINUTE, -211, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (40, 9, 3, NULL, 7, NULL, NULL, DATEADD(MINUTE, -191, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (41, 9, 1, 6, NULL, NULL, 227, DATEADD(MINUTE, -189, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (42, 9, 1, 15, NULL, NULL, 30, DATEADD(MINUTE, -186, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (43, 24, 3, NULL, 10, NULL, NULL, DATEADD(MINUTE, -145, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (44, 24, 1, 1, NULL, NULL, 13, DATEADD(MINUTE, -143, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (45, 24, 1, 12, NULL, NULL, 12, DATEADD(MINUTE, -140, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (46, 24, 1, 4, NULL, NULL, 18, DATEADD(MINUTE, -137, DATEADD(DAY, -58, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (47, 19, 2, NULL, NULL, N'cortinas', NULL, DATEADD(MINUTE, -1300, DATEADD(DAY, -57, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (48, 19, 1, 13, NULL, NULL, 111, DATEADD(MINUTE, -1298, DATEADD(DAY, -57, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (49, 19, 1, 11, NULL, NULL, 148, DATEADD(MINUTE, -1297, DATEADD(DAY, -57, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (50, 19, 4, 11, NULL, NULL, NULL, DATEADD(MINUTE, -1295, DATEADD(DAY, -57, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (51, 38, 2, NULL, NULL, N'vajilla', NULL, DATEADD(MINUTE, -397, DATEADD(DAY, -57, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (52, 38, 1, 17, NULL, NULL, 81, DATEADD(MINUTE, -395, DATEADD(DAY, -57, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (53, 7, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -1142, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (54, 7, 1, 25, NULL, NULL, 119, DATEADD(MINUTE, -1141, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (55, 7, 4, 25, NULL, NULL, NULL, DATEADD(MINUTE, -1137, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (56, 18, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -963, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (57, 18, 1, 10, NULL, NULL, 65, DATEADD(MINUTE, -962, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (58, 18, 1, 25, NULL, NULL, 6, DATEADD(MINUTE, -960, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (59, 16, 2, NULL, NULL, N'cortinas', NULL, DATEADD(MINUTE, -918, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (60, 16, 1, 13, NULL, NULL, 165, DATEADD(MINUTE, -917, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (61, 16, 1, 14, NULL, NULL, 231, DATEADD(MINUTE, -915, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (62, 16, 4, 14, NULL, NULL, NULL, DATEADD(MINUTE, -913, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (63, 20, 2, NULL, NULL, N'raqueta', NULL, DATEADD(MINUTE, -799, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (64, 20, 1, 22, NULL, NULL, 16, DATEADD(MINUTE, -798, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (65, 20, 1, 23, NULL, NULL, 147, DATEADD(MINUTE, -796, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (66, 41, 2, NULL, NULL, N'aspiradora', NULL, DATEADD(MINUTE, -716, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (67, 41, 1, 12, NULL, NULL, 52, DATEADD(MINUTE, -715, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (68, 41, 1, 16, NULL, NULL, 48, DATEADD(MINUTE, -713, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (69, 31, 1, 7, NULL, NULL, 63, DATEADD(MINUTE, -114, DATEADD(DAY, -56, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (70, 29, 2, NULL, NULL, N'microondas', NULL, DATEADD(MINUTE, -1294, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (71, 29, 1, 1, NULL, NULL, 5, DATEADD(MINUTE, -1293, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (72, 29, 1, 16, NULL, NULL, 54, DATEADD(MINUTE, -1290, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (73, 38, 1, 13, NULL, NULL, 127, DATEADD(MINUTE, -1193, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (74, 38, 4, 13, NULL, NULL, NULL, DATEADD(MINUTE, -1192, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (75, 19, 3, NULL, 10, NULL, NULL, DATEADD(MINUTE, -1109, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (76, 19, 1, 26, NULL, NULL, 59, DATEADD(MINUTE, -1108, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (77, 27, 1, 12, NULL, NULL, 26, DATEADD(MINUTE, -778, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (78, 42, 2, NULL, NULL, N'recetas', NULL, DATEADD(MINUTE, -602, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (79, 42, 1, 10, NULL, NULL, 153, DATEADD(MINUTE, -600, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (80, 42, 4, 10, NULL, NULL, NULL, DATEADD(MINUTE, -598, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (81, 42, 1, 28, NULL, NULL, 152, DATEADD(MINUTE, -597, DATEADD(DAY, -55, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (82, 8, 2, NULL, NULL, N'vajilla', NULL, DATEADD(MINUTE, -925, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (83, 8, 1, 17, NULL, NULL, 121, DATEADD(MINUTE, -924, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (84, 8, 4, 17, NULL, NULL, NULL, DATEADD(MINUTE, -923, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (85, 39, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -723, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (86, 39, 1, 25, NULL, NULL, 113, DATEADD(MINUTE, -722, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (87, 39, 4, 25, NULL, NULL, NULL, DATEADD(MINUTE, -721, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (88, 39, 1, 10, NULL, NULL, 141, DATEADD(MINUTE, -720, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (89, 9, 1, 3, NULL, NULL, 163, DATEADD(MINUTE, -608, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (90, 9, 4, 3, NULL, NULL, NULL, DATEADD(MINUTE, -606, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (91, 3, 3, NULL, 5, NULL, NULL, DATEADD(MINUTE, -234, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (92, 3, 1, 14, NULL, NULL, 42, DATEADD(MINUTE, -233, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (93, 3, 1, 6, NULL, NULL, 92, DATEADD(MINUTE, -230, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (94, 34, 3, NULL, 5, NULL, NULL, DATEADD(MINUTE, -75, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (95, 34, 1, 14, NULL, NULL, 17, DATEADD(MINUTE, -73, DATEADD(DAY, -54, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (96, 5, 2, NULL, NULL, N'recetas', NULL, DATEADD(MINUTE, -1183, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (97, 5, 1, 10, NULL, NULL, 161, DATEADD(MINUTE, -1182, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (98, 5, 4, 10, NULL, NULL, NULL, DATEADD(MINUTE, -1180, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (99, 5, 1, 11, NULL, NULL, 188, DATEADD(MINUTE, -1179, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (100, 5, 4, 11, NULL, NULL, NULL, DATEADD(MINUTE, -1178, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (101, 11, 3, NULL, 3, NULL, NULL, DATEADD(MINUTE, -1097, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (102, 11, 1, 33, NULL, NULL, 59, DATEADD(MINUTE, -1095, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (103, 11, 1, 13, NULL, NULL, 228, DATEADD(MINUTE, -1093, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (104, 11, 4, 13, NULL, NULL, NULL, DATEADD(MINUTE, -1090, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (105, 20, 2, NULL, NULL, N'bicicleta', NULL, DATEADD(MINUTE, -1050, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (106, 20, 1, 14, NULL, NULL, 30, DATEADD(MINUTE, -1049, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (107, 20, 1, 23, NULL, NULL, 60, DATEADD(MINUTE, -1048, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (108, 43, 1, 29, NULL, NULL, 12, DATEADD(MINUTE, -790, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (109, 14, 2, NULL, NULL, N'estantería', NULL, DATEADD(MINUTE, -439, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (110, 14, 1, 11, NULL, NULL, 30, DATEADD(MINUTE, -438, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (111, 14, 1, 7, NULL, NULL, 125, DATEADD(MINUTE, -436, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (112, 22, 1, 14, NULL, NULL, 161, DATEADD(MINUTE, -383, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (113, 22, 4, 14, NULL, NULL, NULL, DATEADD(MINUTE, -382, DATEADD(DAY, -53, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (114, 3, 2, NULL, NULL, N'escritorio', NULL, DATEADD(MINUTE, -661, DATEADD(DAY, -52, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (115, 3, 1, 7, NULL, NULL, 28, DATEADD(MINUTE, -659, DATEADD(DAY, -52, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (116, 3, 1, 19, NULL, NULL, 47, DATEADD(MINUTE, -658, DATEADD(DAY, -52, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (117, 28, 2, NULL, NULL, N'ollas', NULL, DATEADD(MINUTE, -438, DATEADD(DAY, -52, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (118, 28, 1, 9, NULL, NULL, 21, DATEADD(MINUTE, -436, DATEADD(DAY, -52, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (119, 28, 1, 6, NULL, NULL, 53, DATEADD(MINUTE, -434, DATEADD(DAY, -52, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (120, 30, 3, NULL, 7, NULL, NULL, DATEADD(MINUTE, -596, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (121, 30, 1, 6, NULL, NULL, 48, DATEADD(MINUTE, -595, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (122, 30, 1, 17, NULL, NULL, 139, DATEADD(MINUTE, -593, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (123, 30, 4, 17, NULL, NULL, NULL, DATEADD(MINUTE, -590, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (124, 30, 1, 13, NULL, NULL, 16, DATEADD(MINUTE, -589, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (125, 11, 1, 2, NULL, NULL, 116, DATEADD(MINUTE, -406, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (126, 15, 2, NULL, NULL, N'aspiradora', NULL, DATEADD(MINUTE, -258, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (127, 15, 1, 12, NULL, NULL, 202, DATEADD(MINUTE, -257, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (128, 15, 4, 12, NULL, NULL, NULL, DATEADD(MINUTE, -254, DATEADD(DAY, -51, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (129, 32, 2, NULL, NULL, N'violín', NULL, DATEADD(MINUTE, -1125, DATEADD(DAY, -50, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (130, 32, 1, 29, NULL, NULL, 198, DATEADD(MINUTE, -1123, DATEADD(DAY, -50, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (131, 32, 1, 2, NULL, NULL, 28, DATEADD(MINUTE, -1122, DATEADD(DAY, -50, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (132, 42, 1, 27, NULL, NULL, 49, DATEADD(MINUTE, -696, DATEADD(DAY, -50, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (133, 21, 3, NULL, 6, NULL, NULL, DATEADD(MINUTE, -1178, DATEADD(DAY, -49, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (134, 21, 1, 29, NULL, NULL, 56, DATEADD(MINUTE, -1177, DATEADD(DAY, -49, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (135, 21, 1, 35, NULL, NULL, 14, DATEADD(MINUTE, -1175, DATEADD(DAY, -49, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (136, 9, 1, 39, NULL, NULL, 84, DATEADD(MINUTE, -1113, DATEADD(DAY, -49, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (137, 14, 2, NULL, NULL, N'perchero', NULL, DATEADD(MINUTE, -308, DATEADD(DAY, -49, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (138, 14, 1, 18, NULL, NULL, 12, DATEADD(MINUTE, -306, DATEADD(DAY, -49, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (139, 41, 2, NULL, NULL, N'violín', NULL, DATEADD(MINUTE, -1201, DATEADD(DAY, -48, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (140, 41, 1, 29, NULL, NULL, 211, DATEADD(MINUTE, -1200, DATEADD(DAY, -48, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (141, 41, 4, 29, NULL, NULL, NULL, DATEADD(MINUTE, -1196, DATEADD(DAY, -48, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (142, 41, 1, 6, NULL, NULL, 58, DATEADD(MINUTE, -1195, DATEADD(DAY, -48, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (143, 27, 3, NULL, 5, NULL, NULL, DATEADD(MINUTE, -857, DATEADD(DAY, -48, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (144, 27, 1, 14, NULL, NULL, 26, DATEADD(MINUTE, -856, DATEADD(DAY, -48, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (145, 27, 1, 27, NULL, NULL, 37, DATEADD(MINUTE, -853, DATEADD(DAY, -48, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (146, 27, 1, 23, NULL, NULL, 31, DATEADD(MINUTE, -851, DATEADD(DAY, -48, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (147, 10, 3, NULL, 1, NULL, NULL, DATEADD(MINUTE, -1236, DATEADD(DAY, -47, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (148, 10, 1, 45, NULL, NULL, 20, DATEADD(MINUTE, -1235, DATEADD(DAY, -47, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (149, 43, 2, NULL, NULL, N'perchero', NULL, DATEADD(MINUTE, -832, DATEADD(DAY, -47, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (150, 43, 1, 18, NULL, NULL, 46, DATEADD(MINUTE, -831, DATEADD(DAY, -47, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (151, 43, 1, 39, NULL, NULL, 10, DATEADD(MINUTE, -827, DATEADD(DAY, -47, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (152, 3, 2, NULL, NULL, N'espejo', NULL, DATEADD(MINUTE, -1081, DATEADD(DAY, -46, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (153, 3, 1, 19, NULL, NULL, 130, DATEADD(MINUTE, -1079, DATEADD(DAY, -46, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (154, 3, 4, 19, NULL, NULL, NULL, DATEADD(MINUTE, -1075, DATEADD(DAY, -46, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (155, 39, 1, 39, NULL, NULL, 70, DATEADD(MINUTE, -471, DATEADD(DAY, -46, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (156, 10, 1, 18, NULL, NULL, 65, DATEADD(MINUTE, -158, DATEADD(DAY, -46, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (157, 40, 2, NULL, NULL, N'bolsa de dormir', NULL, DATEADD(MINUTE, -109, DATEADD(DAY, -46, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (158, 40, 1, 46, NULL, NULL, 6, DATEADD(MINUTE, -108, DATEADD(DAY, -46, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (159, 6, 1, 45, NULL, NULL, 185, DATEADD(MINUTE, -817, DATEADD(DAY, -45, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (160, 21, 1, 40, NULL, NULL, 52, DATEADD(MINUTE, -403, DATEADD(DAY, -45, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (161, 4, 2, NULL, NULL, N'tostadora', NULL, DATEADD(MINUTE, -299, DATEADD(DAY, -45, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (162, 4, 1, 16, NULL, NULL, 6, DATEADD(MINUTE, -298, DATEADD(DAY, -45, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (163, 4, 1, 36, NULL, NULL, 16, DATEADD(MINUTE, -296, DATEADD(DAY, -45, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (164, 10, 1, 36, NULL, NULL, 20, DATEADD(MINUTE, -1246, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (165, 34, 3, NULL, 1, NULL, NULL, DATEADD(MINUTE, -1158, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (166, 34, 1, 26, NULL, NULL, 11, DATEADD(MINUTE, -1157, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (167, 34, 1, 38, NULL, NULL, 57, DATEADD(MINUTE, -1153, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (168, 34, 1, 27, NULL, NULL, 116, DATEADD(MINUTE, -1151, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (169, 34, 4, 27, NULL, NULL, NULL, DATEADD(MINUTE, -1148, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (170, 23, 1, 24, NULL, NULL, 33, DATEADD(MINUTE, -1081, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (171, 17, 1, 31, NULL, NULL, 12, DATEADD(MINUTE, -1040, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (172, 33, 1, 51, NULL, NULL, 30, DATEADD(MINUTE, -684, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (173, 12, 2, NULL, NULL, N'guantes de boxeo', NULL, DATEADD(MINUTE, -405, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (174, 12, 1, 27, NULL, NULL, 12, DATEADD(MINUTE, -404, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (175, 14, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -180, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (176, 14, 1, 25, NULL, NULL, 135, DATEADD(MINUTE, -179, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (177, 14, 4, 25, NULL, NULL, NULL, DATEADD(MINUTE, -178, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (178, 14, 1, 41, NULL, NULL, 165, DATEADD(MINUTE, -177, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (179, 14, 4, 41, NULL, NULL, NULL, DATEADD(MINUTE, -174, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (180, 14, 1, 7, NULL, NULL, 191, DATEADD(MINUTE, -173, DATEADD(DAY, -44, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (181, 23, 2, NULL, NULL, N'estantería', NULL, DATEADD(MINUTE, -1126, DATEADD(DAY, -43, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (182, 23, 1, 11, NULL, NULL, 115, DATEADD(MINUTE, -1125, DATEADD(DAY, -43, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (183, 27, 2, NULL, NULL, N'afinador', NULL, DATEADD(MINUTE, -711, DATEADD(DAY, -43, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (184, 27, 1, 34, NULL, NULL, 159, DATEADD(MINUTE, -709, DATEADD(DAY, -43, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (185, 27, 1, 48, NULL, NULL, 49, DATEADD(MINUTE, -705, DATEADD(DAY, -43, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (186, 28, 3, NULL, 7, NULL, NULL, DATEADD(MINUTE, -1014, DATEADD(DAY, -42, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (187, 28, 1, 17, NULL, NULL, 123, DATEADD(MINUTE, -1013, DATEADD(DAY, -42, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (188, 28, 4, 17, NULL, NULL, NULL, DATEADD(MINUTE, -1009, DATEADD(DAY, -42, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (189, 39, 3, NULL, 10, NULL, NULL, DATEADD(MINUTE, -398, DATEADD(DAY, -42, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (190, 39, 1, 12, NULL, NULL, 48, DATEADD(MINUTE, -397, DATEADD(DAY, -42, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (191, 39, 1, 16, NULL, NULL, 30, DATEADD(MINUTE, -393, DATEADD(DAY, -42, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (192, 39, 1, 38, NULL, NULL, 5, DATEADD(MINUTE, -389, DATEADD(DAY, -42, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (193, 24, 2, NULL, NULL, N'pollera', NULL, DATEADD(MINUTE, -1244, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (194, 24, 1, 52, NULL, NULL, 47, DATEADD(MINUTE, -1242, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (195, 24, 1, 19, NULL, NULL, 6, DATEADD(MINUTE, -1240, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (196, 3, 2, NULL, NULL, N'bicicleta', NULL, DATEADD(MINUTE, -991, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (197, 3, 1, 14, NULL, NULL, 55, DATEADD(MINUTE, -989, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (198, 3, 1, 15, NULL, NULL, 174, DATEADD(MINUTE, -986, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (199, 36, 1, 12, NULL, NULL, 206, DATEADD(MINUTE, -976, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (200, 34, 2, NULL, NULL, N'mochila de trekking', NULL, DATEADD(MINUTE, -683, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (201, 34, 1, 47, NULL, NULL, 210, DATEADD(MINUTE, -682, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (202, 34, 4, 47, NULL, NULL, NULL, DATEADD(MINUTE, -680, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (203, 32, 2, NULL, NULL, N'escritorio', NULL, DATEADD(MINUTE, -62, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (204, 32, 1, 7, NULL, NULL, 15, DATEADD(MINUTE, -60, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (205, 32, 1, 25, NULL, NULL, 12, DATEADD(MINUTE, -58, DATEADD(DAY, -41, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (206, 31, 2, NULL, NULL, N'sábanas', NULL, DATEADD(MINUTE, -1090, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (207, 31, 1, 2, NULL, NULL, 55, DATEADD(MINUTE, -1089, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (208, 25, 2, NULL, NULL, N'pava', NULL, DATEADD(MINUTE, -821, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (209, 25, 1, 4, NULL, NULL, 108, DATEADD(MINUTE, -819, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (210, 25, 1, 23, NULL, NULL, 33, DATEADD(MINUTE, -816, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (211, 6, 2, NULL, NULL, N'tostadora', NULL, DATEADD(MINUTE, -272, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (212, 6, 1, 16, NULL, NULL, 74, DATEADD(MINUTE, -271, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (213, 6, 1, 27, NULL, NULL, 47, DATEADD(MINUTE, -267, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (214, 4, 2, NULL, NULL, N'cafetera italiana', NULL, DATEADD(MINUTE, -138, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (215, 4, 1, 24, NULL, NULL, 54, DATEADD(MINUTE, -137, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (216, 4, 1, 15, NULL, NULL, 43, DATEADD(MINUTE, -135, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (217, 20, 2, NULL, NULL, N'perchero', NULL, DATEADD(MINUTE, -120, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (218, 20, 1, 18, NULL, NULL, 34, DATEADD(MINUTE, -119, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (219, 7, 2, NULL, NULL, N'colchón', NULL, DATEADD(MINUTE, -71, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (220, 7, 1, 15, NULL, NULL, 193, DATEADD(MINUTE, -70, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (221, 7, 4, 15, NULL, NULL, NULL, DATEADD(MINUTE, -69, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (222, 7, 1, 39, NULL, NULL, 182, DATEADD(MINUTE, -68, DATEADD(DAY, -40, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (223, 30, 1, 5, NULL, NULL, 229, DATEADD(MINUTE, -1102, DATEADD(DAY, -38, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (224, 30, 4, 5, NULL, NULL, NULL, DATEADD(MINUTE, -1099, DATEADD(DAY, -38, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (225, 29, 2, NULL, NULL, N'secador', NULL, DATEADD(MINUTE, -562, DATEADD(DAY, -38, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (226, 29, 1, 59, NULL, NULL, 54, DATEADD(MINUTE, -561, DATEADD(DAY, -38, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (227, 29, 1, 51, NULL, NULL, 59, DATEADD(MINUTE, -557, DATEADD(DAY, -38, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (228, 6, 1, 57, NULL, NULL, 126, DATEADD(MINUTE, -694, DATEADD(DAY, -37, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (229, 6, 4, 57, NULL, NULL, NULL, DATEADD(MINUTE, -690, DATEADD(DAY, -37, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (230, 18, 1, 41, NULL, NULL, 155, DATEADD(MINUTE, -683, DATEADD(DAY, -37, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (231, 18, 4, 41, NULL, NULL, NULL, DATEADD(MINUTE, -681, DATEADD(DAY, -37, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (232, 24, 1, 10, NULL, NULL, 32, DATEADD(MINUTE, -312, DATEADD(DAY, -37, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (233, 26, 1, 52, NULL, NULL, 208, DATEADD(MINUTE, -670, DATEADD(DAY, -36, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (234, 26, 4, 52, NULL, NULL, NULL, DATEADD(MINUTE, -666, DATEADD(DAY, -36, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (235, 15, 2, NULL, NULL, N'afinador', NULL, DATEADD(MINUTE, -476, DATEADD(DAY, -36, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (236, 15, 1, 34, NULL, NULL, 133, DATEADD(MINUTE, -475, DATEADD(DAY, -36, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (237, 15, 4, 34, NULL, NULL, NULL, DATEADD(MINUTE, -474, DATEADD(DAY, -36, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (238, 28, 1, 9, NULL, NULL, 34, DATEADD(MINUTE, -419, DATEADD(DAY, -36, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (239, 20, 1, 47, NULL, NULL, 154, DATEADD(MINUTE, -116, DATEADD(DAY, -36, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (240, 20, 4, 47, NULL, NULL, NULL, DATEADD(MINUTE, -114, DATEADD(DAY, -36, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (241, 18, 1, 41, NULL, NULL, 211, DATEADD(MINUTE, -1114, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (242, 5, 1, 13, NULL, NULL, 97, DATEADD(MINUTE, -890, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (243, 33, 3, NULL, 3, NULL, NULL, DATEADD(MINUTE, -796, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (244, 33, 1, 51, NULL, NULL, 192, DATEADD(MINUTE, -794, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (245, 33, 4, 51, NULL, NULL, NULL, DATEADD(MINUTE, -790, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (246, 38, 3, NULL, 9, NULL, NULL, DATEADD(MINUTE, -642, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (247, 38, 1, 43, NULL, NULL, 214, DATEADD(MINUTE, -641, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (248, 38, 4, 43, NULL, NULL, NULL, DATEADD(MINUTE, -640, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (249, 38, 1, 24, NULL, NULL, 98, DATEADD(MINUTE, -639, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (250, 38, 1, 15, NULL, NULL, 181, DATEADD(MINUTE, -635, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (251, 38, 4, 15, NULL, NULL, NULL, DATEADD(MINUTE, -634, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (252, 38, 1, 23, NULL, NULL, 98, DATEADD(MINUTE, -633, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (253, 6, 1, 55, NULL, NULL, 25, DATEADD(MINUTE, -194, DATEADD(DAY, -35, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (254, 37, 2, NULL, NULL, N'cafetera italiana', NULL, DATEADD(MINUTE, -1009, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (255, 37, 1, 24, NULL, NULL, 60, DATEADD(MINUTE, -1008, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (256, 8, 3, NULL, 8, NULL, NULL, DATEADD(MINUTE, -751, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (257, 8, 1, 60, NULL, NULL, 164, DATEADD(MINUTE, -750, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (258, 8, 1, 5, NULL, NULL, 47, DATEADD(MINUTE, -747, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (259, 8, 1, 9, NULL, NULL, 69, DATEADD(MINUTE, -743, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (260, 26, 2, NULL, NULL, N'cajón peruano', NULL, DATEADD(MINUTE, -421, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (261, 26, 1, 48, NULL, NULL, 93, DATEADD(MINUTE, -419, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (262, 40, 1, 59, NULL, NULL, 92, DATEADD(MINUTE, -193, DATEADD(DAY, -34, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (263, 17, 2, NULL, NULL, N'guantes de boxeo', NULL, DATEADD(MINUTE, -1116, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (264, 17, 1, 27, NULL, NULL, 121, DATEADD(MINUTE, -1115, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (265, 17, 4, 27, NULL, NULL, NULL, DATEADD(MINUTE, -1112, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (266, 37, 2, NULL, NULL, N'mesa de luz', NULL, DATEADD(MINUTE, -885, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (267, 37, 1, 3, NULL, NULL, 19, DATEADD(MINUTE, -884, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (268, 19, 2, NULL, NULL, N'micrófono usb', NULL, DATEADD(MINUTE, -811, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (269, 19, 1, 63, NULL, NULL, 36, DATEADD(MINUTE, -809, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (270, 19, 1, 1, NULL, NULL, 40, DATEADD(MINUTE, -806, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (271, 21, 1, 30, NULL, NULL, 7, DATEADD(MINUTE, -765, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (272, 15, 3, NULL, 5, NULL, NULL, DATEADD(MINUTE, -113, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (273, 15, 1, 22, NULL, NULL, 10, DATEADD(MINUTE, -112, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (274, 15, 1, 64, NULL, NULL, 18, DATEADD(MINUTE, -111, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (275, 15, 1, 42, NULL, NULL, 34, DATEADD(MINUTE, -108, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (276, 15, 1, 63, NULL, NULL, 204, DATEADD(MINUTE, -105, DATEADD(DAY, -33, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (277, 8, 3, NULL, 6, NULL, NULL, DATEADD(MINUTE, -1189, DATEADD(DAY, -32, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (278, 8, 1, 34, NULL, NULL, 5, DATEADD(MINUTE, -1187, DATEADD(DAY, -32, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (279, 4, 1, 24, NULL, NULL, 170, DATEADD(MINUTE, -691, DATEADD(DAY, -32, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (280, 35, 2, NULL, NULL, N'micrófono usb', NULL, DATEADD(MINUTE, -925, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (281, 35, 1, 63, NULL, NULL, 96, DATEADD(MINUTE, -924, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (282, 24, 2, NULL, NULL, N'cocina vegetariana', NULL, DATEADD(MINUTE, -119, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (283, 24, 1, 41, NULL, NULL, 102, DATEADD(MINUTE, -117, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (284, 27, 2, NULL, NULL, N'pava', NULL, DATEADD(MINUTE, -85, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (285, 27, 1, 4, NULL, NULL, 157, DATEADD(MINUTE, -83, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (286, 27, 4, 4, NULL, NULL, NULL, DATEADD(MINUTE, -80, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (287, 27, 1, 29, NULL, NULL, 237, DATEADD(MINUTE, -79, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (288, 27, 4, 29, NULL, NULL, NULL, DATEADD(MINUTE, -77, DATEADD(DAY, -31, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (289, 27, 2, NULL, NULL, N'router', NULL, DATEADD(MINUTE, -1181, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (290, 27, 1, 8, NULL, NULL, 82, DATEADD(MINUTE, -1180, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (291, 24, 1, 74, NULL, NULL, 54, DATEADD(MINUTE, -826, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (292, 32, 2, NULL, NULL, N'rayuela', NULL, DATEADD(MINUTE, -684, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (293, 32, 1, 65, NULL, NULL, 192, DATEADD(MINUTE, -682, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (294, 32, 4, 65, NULL, NULL, NULL, DATEADD(MINUTE, -680, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (295, 32, 1, 73, NULL, NULL, 15, DATEADD(MINUTE, -679, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (296, 25, 2, NULL, NULL, N'frascos', NULL, DATEADD(MINUTE, -569, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (297, 25, 1, 72, NULL, NULL, 26, DATEADD(MINUTE, -567, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (298, 25, 1, 46, NULL, NULL, 125, DATEADD(MINUTE, -565, DATEADD(DAY, -30, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (299, 25, 3, NULL, 5, NULL, NULL, DATEADD(MINUTE, -1188, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (300, 25, 1, 42, NULL, NULL, 189, DATEADD(MINUTE, -1187, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (301, 25, 4, 42, NULL, NULL, NULL, DATEADD(MINUTE, -1185, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (302, 21, 2, NULL, NULL, N'batería', NULL, DATEADD(MINUTE, -1162, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (303, 21, 1, 68, NULL, NULL, 227, DATEADD(MINUTE, -1160, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (304, 21, 4, 68, NULL, NULL, NULL, DATEADD(MINUTE, -1159, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (305, 5, 2, NULL, NULL, N'mesa ratona', NULL, DATEADD(MINUTE, -994, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (306, 5, 1, 74, NULL, NULL, 114, DATEADD(MINUTE, -992, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (307, 36, 2, NULL, NULL, N'bicicleta', NULL, DATEADD(MINUTE, -873, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (308, 36, 1, 62, NULL, NULL, 49, DATEADD(MINUTE, -871, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (309, 9, 3, NULL, 5, NULL, NULL, DATEADD(MINUTE, -773, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (310, 9, 1, 66, NULL, NULL, 150, DATEADD(MINUTE, -772, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (311, 9, 4, 66, NULL, NULL, NULL, DATEADD(MINUTE, -771, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (312, 9, 1, 22, NULL, NULL, 53, DATEADD(MINUTE, -770, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (313, 9, 1, 64, NULL, NULL, 145, DATEADD(MINUTE, -767, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (314, 9, 4, 64, NULL, NULL, NULL, DATEADD(MINUTE, -764, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (315, 40, 3, NULL, 1, NULL, NULL, DATEADD(MINUTE, -492, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (316, 40, 1, 8, NULL, NULL, 118, DATEADD(MINUTE, -490, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (317, 40, 4, 8, NULL, NULL, NULL, DATEADD(MINUTE, -489, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (318, 40, 1, 26, NULL, NULL, 227, DATEADD(MINUTE, -488, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (319, 40, 4, 26, NULL, NULL, NULL, DATEADD(MINUTE, -486, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (320, 40, 1, 38, NULL, NULL, 32, DATEADD(MINUTE, -485, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (321, 15, 2, NULL, NULL, N'auriculares de estudio', NULL, DATEADD(MINUTE, -439, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (322, 15, 1, 54, NULL, NULL, 73, DATEADD(MINUTE, -437, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (323, 12, 2, NULL, NULL, N'lámpara de escritorio', NULL, DATEADD(MINUTE, -367, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (324, 12, 1, 43, NULL, NULL, 7, DATEADD(MINUTE, -366, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (325, 23, 2, NULL, NULL, N'cafetera italiana', NULL, DATEADD(MINUTE, -161, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (326, 23, 1, 24, NULL, NULL, 51, DATEADD(MINUTE, -159, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (327, 23, 1, 65, NULL, NULL, 28, DATEADD(MINUTE, -156, DATEADD(DAY, -29, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (328, 17, 2, NULL, NULL, N'pesa rusa', NULL, DATEADD(MINUTE, -1040, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (329, 17, 1, 42, NULL, NULL, 118, DATEADD(MINUTE, -1039, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (330, 17, 1, 2, NULL, NULL, 55, DATEADD(MINUTE, -1038, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (331, 33, 3, NULL, 10, NULL, NULL, DATEADD(MINUTE, -993, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (332, 33, 1, 1, NULL, NULL, 92, DATEADD(MINUTE, -992, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (333, 33, 1, 38, NULL, NULL, 137, DATEADD(MINUTE, -990, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (334, 33, 1, 59, NULL, NULL, 83, DATEADD(MINUTE, -987, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (335, 18, 1, 54, NULL, NULL, 193, DATEADD(MINUTE, -977, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (336, 7, 3, NULL, 8, NULL, NULL, DATEADD(MINUTE, -632, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (337, 7, 1, 60, NULL, NULL, 118, DATEADD(MINUTE, -630, DATEADD(DAY, -28, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (338, 23, 3, NULL, 9, NULL, NULL, DATEADD(MINUTE, -876, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (339, 23, 1, 19, NULL, NULL, 48, DATEADD(MINUTE, -875, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (340, 36, 2, NULL, NULL, N'mouse', NULL, DATEADD(MINUTE, -731, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (341, 36, 1, 53, NULL, NULL, 95, DATEADD(MINUTE, -730, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (342, 20, 2, NULL, NULL, N'conservadora', NULL, DATEADD(MINUTE, -633, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (343, 20, 1, 37, NULL, NULL, 148, DATEADD(MINUTE, -632, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (344, 20, 1, 33, NULL, NULL, 45, DATEADD(MINUTE, -628, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (345, 17, 2, NULL, NULL, N'bicicleta fija', NULL, DATEADD(MINUTE, -580, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (346, 17, 1, 62, NULL, NULL, 175, DATEADD(MINUTE, -578, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (347, 17, 4, 62, NULL, NULL, NULL, DATEADD(MINUTE, -574, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (348, 17, 1, 22, NULL, NULL, 222, DATEADD(MINUTE, -573, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (349, 17, 4, 22, NULL, NULL, NULL, DATEADD(MINUTE, -571, DATEADD(DAY, -27, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (350, 34, 2, NULL, NULL, N'casco', NULL, DATEADD(MINUTE, -1235, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (351, 34, 1, 64, NULL, NULL, 80, DATEADD(MINUTE, -1234, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (352, 34, 1, 59, NULL, NULL, 53, DATEADD(MINUTE, -1231, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (353, 14, 3, NULL, 8, NULL, NULL, DATEADD(MINUTE, -1132, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (354, 14, 1, 76, NULL, NULL, 165, DATEADD(MINUTE, -1131, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (355, 14, 1, 74, NULL, NULL, 58, DATEADD(MINUTE, -1128, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (356, 14, 1, 19, NULL, NULL, 96, DATEADD(MINUTE, -1127, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (357, 14, 1, 25, NULL, NULL, 68, DATEADD(MINUTE, -1126, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (358, 16, 3, NULL, 5, NULL, NULL, DATEADD(MINUTE, -1026, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (359, 16, 1, 37, NULL, NULL, 75, DATEADD(MINUTE, -1025, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (360, 16, 1, 27, NULL, NULL, 52, DATEADD(MINUTE, -1021, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (361, 16, 1, 77, NULL, NULL, 90, DATEADD(MINUTE, -1020, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (362, 25, 2, NULL, NULL, N'secador', NULL, DATEADD(MINUTE, -697, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (363, 25, 1, 59, NULL, NULL, 39, DATEADD(MINUTE, -695, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (364, 25, 1, 19, NULL, NULL, 53, DATEADD(MINUTE, -694, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (365, 4, 2, NULL, NULL, N'plantas', NULL, DATEADD(MINUTE, -692, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (366, 4, 1, 79, NULL, NULL, 41, DATEADD(MINUTE, -691, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (367, 7, 1, 19, NULL, NULL, 227, DATEADD(MINUTE, -434, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (368, 7, 4, 19, NULL, NULL, NULL, DATEADD(MINUTE, -433, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (369, 15, 2, NULL, NULL, N'licuadora', NULL, DATEADD(MINUTE, -422, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (370, 15, 1, 26, NULL, NULL, 214, DATEADD(MINUTE, -421, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (371, 15, 4, 26, NULL, NULL, NULL, DATEADD(MINUTE, -419, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (372, 28, 1, 73, NULL, NULL, 35, DATEADD(MINUTE, -226, DATEADD(DAY, -26, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (373, 15, 1, 54, NULL, NULL, 26, DATEADD(MINUTE, -1222, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (374, 32, 1, 54, NULL, NULL, 128, DATEADD(MINUTE, -1198, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (375, 32, 4, 54, NULL, NULL, NULL, DATEADD(MINUTE, -1194, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (376, 12, 1, 60, NULL, NULL, 198, DATEADD(MINUTE, -1154, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (377, 12, 4, 60, NULL, NULL, NULL, DATEADD(MINUTE, -1150, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (378, 43, 2, NULL, NULL, N'mochila urbana', NULL, DATEADD(MINUTE, -1117, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (379, 43, 1, 78, NULL, NULL, 208, DATEADD(MINUTE, -1116, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (380, 39, 3, NULL, 12, NULL, NULL, DATEADD(MINUTE, -572, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (381, 39, 1, 78, NULL, NULL, 15, DATEADD(MINUTE, -570, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (382, 34, 3, NULL, 3, NULL, NULL, DATEADD(MINUTE, -323, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (383, 34, 1, 51, NULL, NULL, 54, DATEADD(MINUTE, -322, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (384, 3, 3, NULL, 10, NULL, NULL, DATEADD(MINUTE, -93, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (385, 3, 1, 57, NULL, NULL, 210, DATEADD(MINUTE, -91, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (386, 3, 1, 12, NULL, NULL, 90, DATEADD(MINUTE, -89, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (387, 3, 1, 72, NULL, NULL, 145, DATEADD(MINUTE, -85, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (388, 3, 4, 72, NULL, NULL, NULL, DATEADD(MINUTE, -84, DATEADD(DAY, -25, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (389, 36, 1, 56, NULL, NULL, 214, DATEADD(MINUTE, -855, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (390, 36, 4, 56, NULL, NULL, NULL, DATEADD(MINUTE, -853, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (391, 11, 2, NULL, NULL, N'mesa ratona', NULL, DATEADD(MINUTE, -686, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (392, 11, 1, 74, NULL, NULL, 12, DATEADD(MINUTE, -685, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (393, 11, 1, 53, NULL, NULL, 23, DATEADD(MINUTE, -682, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (394, 40, 1, 62, NULL, NULL, 20, DATEADD(MINUTE, -536, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (395, 35, 2, NULL, NULL, N'cien años de soledad', NULL, DATEADD(MINUTE, -316, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (396, 35, 1, 81, NULL, NULL, 50, DATEADD(MINUTE, -314, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (397, 39, 1, 72, NULL, NULL, 154, DATEADD(MINUTE, -271, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (398, 39, 4, 72, NULL, NULL, NULL, DATEADD(MINUTE, -270, DATEADD(DAY, -24, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (399, 10, 1, 75, NULL, NULL, 206, DATEADD(MINUTE, -1118, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (400, 4, 2, NULL, NULL, N'espejo', NULL, DATEADD(MINUTE, -539, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (401, 4, 1, 19, NULL, NULL, 195, DATEADD(MINUTE, -538, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (402, 4, 4, 19, NULL, NULL, NULL, DATEADD(MINUTE, -537, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (403, 8, 2, NULL, NULL, N'lámpara de escritorio', NULL, DATEADD(MINUTE, -486, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (404, 8, 1, 43, NULL, NULL, 77, DATEADD(MINUTE, -484, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (405, 8, 1, 63, NULL, NULL, 231, DATEADD(MINUTE, -483, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (406, 8, 4, 63, NULL, NULL, NULL, DATEADD(MINUTE, -481, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (407, 29, 2, NULL, NULL, N'tostadora', NULL, DATEADD(MINUTE, -474, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (408, 29, 1, 16, NULL, NULL, 168, DATEADD(MINUTE, -472, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (409, 29, 1, 59, NULL, NULL, 194, DATEADD(MINUTE, -469, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (410, 11, 2, NULL, NULL, N'colchón', NULL, DATEADD(MINUTE, -452, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (411, 11, 1, 15, NULL, NULL, 26, DATEADD(MINUTE, -451, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (412, 11, 1, 79, NULL, NULL, 36, DATEADD(MINUTE, -449, DATEADD(DAY, -23, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (413, 40, 1, 46, NULL, NULL, 123, DATEADD(MINUTE, -764, DATEADD(DAY, -22, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (414, 22, 2, NULL, NULL, N'guantes de boxeo', NULL, DATEADD(MINUTE, -481, DATEADD(DAY, -22, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (415, 22, 1, 27, NULL, NULL, 84, DATEADD(MINUTE, -480, DATEADD(DAY, -22, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (416, 41, 2, NULL, NULL, N'cajón peruano', NULL, DATEADD(MINUTE, -1264, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (417, 41, 1, 48, NULL, NULL, 239, DATEADD(MINUTE, -1262, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (418, 41, 4, 48, NULL, NULL, NULL, DATEADD(MINUTE, -1258, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (419, 41, 1, 36, NULL, NULL, 208, DATEADD(MINUTE, -1257, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (420, 20, 3, NULL, 12, NULL, NULL, DATEADD(MINUTE, -1086, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (421, 20, 1, 40, NULL, NULL, 74, DATEADD(MINUTE, -1085, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (422, 22, 2, NULL, NULL, N'casco', NULL, DATEADD(MINUTE, -745, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (423, 22, 1, 64, NULL, NULL, 218, DATEADD(MINUTE, -743, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (424, 22, 4, 64, NULL, NULL, NULL, DATEADD(MINUTE, -741, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (425, 22, 1, 65, NULL, NULL, 38, DATEADD(MINUTE, -740, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (426, 42, 2, NULL, NULL, N'sartén', NULL, DATEADD(MINUTE, -651, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (427, 42, 1, 6, NULL, NULL, 138, DATEADD(MINUTE, -650, DATEADD(DAY, -21, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (428, 7, 1, 49, NULL, NULL, 195, DATEADD(MINUTE, -1225, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (429, 7, 4, 49, NULL, NULL, NULL, DATEADD(MINUTE, -1223, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (430, 23, 2, NULL, NULL, N'plantas', NULL, DATEADD(MINUTE, -723, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (431, 23, 1, 79, NULL, NULL, 201, DATEADD(MINUTE, -721, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (432, 23, 4, 79, NULL, NULL, NULL, DATEADD(MINUTE, -720, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (433, 23, 1, 13, NULL, NULL, 185, DATEADD(MINUTE, -719, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (434, 36, 2, NULL, NULL, N'webcam', NULL, DATEADD(MINUTE, -525, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (435, 36, 1, 44, NULL, NULL, 19, DATEADD(MINUTE, -524, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (436, 21, 2, NULL, NULL, N'plantas', NULL, DATEADD(MINUTE, -457, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (437, 21, 1, 79, NULL, NULL, 28, DATEADD(MINUTE, -455, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (438, 21, 1, 31, NULL, NULL, 142, DATEADD(MINUTE, -452, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (439, 27, 1, 67, NULL, NULL, 24, DATEADD(MINUTE, -72, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (440, 33, 1, 38, NULL, NULL, 161, DATEADD(MINUTE, -66, DATEADD(DAY, -20, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (441, 9, 1, 11, NULL, NULL, 64, DATEADD(MINUTE, -1231, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (442, 14, 2, NULL, NULL, N'mafalda', NULL, DATEADD(MINUTE, -796, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (443, 14, 1, 28, NULL, NULL, 128, DATEADD(MINUTE, -795, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (444, 31, 1, 82, NULL, NULL, 26, DATEADD(MINUTE, -753, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (445, 33, 2, NULL, NULL, N'pelota', NULL, DATEADD(MINUTE, -293, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (446, 33, 1, 83, NULL, NULL, 6, DATEADD(MINUTE, -292, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (447, 33, 1, 26, NULL, NULL, 20, DATEADD(MINUTE, -291, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (448, 29, 3, NULL, 6, NULL, NULL, DATEADD(MINUTE, -84, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (449, 29, 1, 73, NULL, NULL, 134, DATEADD(MINUTE, -82, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (450, 29, 4, 73, NULL, NULL, NULL, DATEADD(MINUTE, -79, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (451, 29, 1, 33, NULL, NULL, 34, DATEADD(MINUTE, -78, DATEADD(DAY, -19, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (452, 41, 1, 61, NULL, NULL, 95, DATEADD(MINUTE, -1143, DATEADD(DAY, -18, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (453, 35, 1, 13, NULL, NULL, 34, DATEADD(MINUTE, -1001, DATEADD(DAY, -18, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (454, 26, 2, NULL, NULL, N'piloto', NULL, DATEADD(MINUTE, -907, DATEADD(DAY, -18, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (455, 26, 1, 51, NULL, NULL, 54, DATEADD(MINUTE, -906, DATEADD(DAY, -18, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (456, 26, 1, 85, NULL, NULL, 8, DATEADD(MINUTE, -902, DATEADD(DAY, -18, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (457, 29, 2, NULL, NULL, N'batería', NULL, DATEADD(MINUTE, -556, DATEADD(DAY, -18, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (458, 29, 1, 68, NULL, NULL, 76, DATEADD(MINUTE, -554, DATEADD(DAY, -18, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (459, 29, 1, 1, NULL, NULL, 107, DATEADD(MINUTE, -551, DATEADD(DAY, -18, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (460, 3, 1, 16, NULL, NULL, 136, DATEADD(MINUTE, -1091, DATEADD(DAY, -17, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (461, 34, 1, 23, NULL, NULL, 183, DATEADD(MINUTE, -679, DATEADD(DAY, -17, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (462, 12, 1, 60, NULL, NULL, 52, DATEADD(MINUTE, -551, DATEADD(DAY, -17, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (463, 8, 1, 48, NULL, NULL, 108, DATEADD(MINUTE, -799, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (464, 8, 4, 48, NULL, NULL, NULL, DATEADD(MINUTE, -797, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (465, 30, 1, 2, NULL, NULL, 207, DATEADD(MINUTE, -485, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (466, 32, 3, NULL, 6, NULL, NULL, DATEADD(MINUTE, -392, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (467, 32, 1, 61, NULL, NULL, 218, DATEADD(MINUTE, -391, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (468, 32, 4, 61, NULL, NULL, NULL, DATEADD(MINUTE, -387, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (469, 32, 1, 69, NULL, NULL, 93, DATEADD(MINUTE, -386, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (470, 32, 1, 48, NULL, NULL, 208, DATEADD(MINUTE, -382, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (471, 32, 4, 48, NULL, NULL, NULL, DATEADD(MINUTE, -379, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (472, 3, 1, 47, NULL, NULL, 30, DATEADD(MINUTE, -249, DATEADD(DAY, -16, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (473, 25, 1, 56, NULL, NULL, 114, DATEADD(MINUTE, -938, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (474, 25, 4, 56, NULL, NULL, NULL, DATEADD(MINUTE, -935, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (475, 27, 2, NULL, NULL, N'parlante', NULL, DATEADD(MINUTE, -792, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (476, 27, 1, 50, NULL, NULL, 66, DATEADD(MINUTE, -790, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (477, 27, 1, 38, NULL, NULL, 117, DATEADD(MINUTE, -789, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (478, 5, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -555, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (479, 5, 1, 55, NULL, NULL, 66, DATEADD(MINUTE, -554, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (480, 5, 1, 65, NULL, NULL, 120, DATEADD(MINUTE, -552, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (481, 5, 4, 65, NULL, NULL, NULL, DATEADD(MINUTE, -550, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (482, 30, 2, NULL, NULL, N'secador', NULL, DATEADD(MINUTE, -245, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (483, 30, 1, 59, NULL, NULL, 14, DATEADD(MINUTE, -243, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (484, 30, 1, 74, NULL, NULL, 114, DATEADD(MINUTE, -241, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (485, 30, 4, 74, NULL, NULL, NULL, DATEADD(MINUTE, -240, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (486, 43, 1, 59, NULL, NULL, 36, DATEADD(MINUTE, -91, DATEADD(DAY, -15, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (487, 16, 1, 27, NULL, NULL, 28, DATEADD(MINUTE, -1208, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (488, 5, 1, 11, NULL, NULL, 98, DATEADD(MINUTE, -897, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (489, 7, 1, 3, NULL, NULL, 9, DATEADD(MINUTE, -742, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (490, 29, 1, 64, NULL, NULL, 30, DATEADD(MINUTE, -724, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (491, 10, 2, NULL, NULL, N'sillas', NULL, DATEADD(MINUTE, -390, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (492, 10, 1, 5, NULL, NULL, 43, DATEADD(MINUTE, -388, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (493, 10, 1, 41, NULL, NULL, 13, DATEADD(MINUTE, -387, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (494, 21, 2, NULL, NULL, N'violín', NULL, DATEADD(MINUTE, -117, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (495, 21, 1, 29, NULL, NULL, 28, DATEADD(MINUTE, -115, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (496, 21, 1, 5, NULL, NULL, 37, DATEADD(MINUTE, -112, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (497, 26, 2, NULL, NULL, N'violín', NULL, DATEADD(MINUTE, -108, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (498, 26, 1, 29, NULL, NULL, 132, DATEADD(MINUTE, -106, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (499, 26, 4, 29, NULL, NULL, NULL, DATEADD(MINUTE, -104, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (500, 26, 1, 63, NULL, NULL, 53, DATEADD(MINUTE, -103, DATEADD(DAY, -14, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (501, 10, 2, NULL, NULL, N'espejo', NULL, DATEADD(MINUTE, -1143, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (502, 10, 1, 19, NULL, NULL, 163, DATEADD(MINUTE, -1142, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (503, 18, 2, NULL, NULL, N'cajón peruano', NULL, DATEADD(MINUTE, -1140, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (504, 10, 1, 60, NULL, NULL, 59, DATEADD(MINUTE, -1139, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (505, 18, 1, 48, NULL, NULL, 104, DATEADD(MINUTE, -1139, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (506, 18, 4, 48, NULL, NULL, NULL, DATEADD(MINUTE, -1135, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (507, 30, 1, 33, NULL, NULL, 19, DATEADD(MINUTE, -728, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (508, 19, 1, 50, NULL, NULL, 15, DATEADD(MINUTE, -642, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (509, 9, 1, 63, NULL, NULL, 45, DATEADD(MINUTE, -468, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (510, 28, 1, 15, NULL, NULL, 234, DATEADD(MINUTE, -331, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (511, 28, 4, 15, NULL, NULL, NULL, DATEADD(MINUTE, -329, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (512, 37, 2, NULL, NULL, N'perchero', NULL, DATEADD(MINUTE, -307, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (513, 37, 1, 18, NULL, NULL, 136, DATEADD(MINUTE, -306, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (514, 37, 4, 18, NULL, NULL, NULL, DATEADD(MINUTE, -302, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (515, 32, 1, 79, NULL, NULL, 6, DATEADD(MINUTE, -150, DATEADD(DAY, -13, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (516, 38, 2, NULL, NULL, N'organizador', NULL, DATEADD(MINUTE, -774, DATEADD(DAY, -12, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (517, 38, 1, 71, NULL, NULL, 22, DATEADD(MINUTE, -773, DATEADD(DAY, -12, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (518, 38, 1, 39, NULL, NULL, 202, DATEADD(MINUTE, -770, DATEADD(DAY, -12, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (519, 35, 3, NULL, 7, NULL, NULL, DATEADD(MINUTE, -490, DATEADD(DAY, -12, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (520, 35, 1, 6, NULL, NULL, 42, DATEADD(MINUTE, -489, DATEADD(DAY, -12, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (521, 37, 1, 85, NULL, NULL, 39, DATEADD(MINUTE, -385, DATEADD(DAY, -12, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (522, 40, 1, 44, NULL, NULL, 28, DATEADD(MINUTE, -1140, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (523, 24, 2, NULL, NULL, N'riñonera', NULL, DATEADD(MINUTE, -697, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (524, 24, 1, 88, NULL, NULL, 231, DATEADD(MINUTE, -696, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (525, 24, 4, 88, NULL, NULL, NULL, DATEADD(MINUTE, -695, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (526, 24, 1, 81, NULL, NULL, 224, DATEADD(MINUTE, -694, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (527, 25, 2, NULL, NULL, N'guantes de boxeo', NULL, DATEADD(MINUTE, -595, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (528, 25, 1, 27, NULL, NULL, 71, DATEADD(MINUTE, -593, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (529, 19, 3, NULL, 8, NULL, NULL, DATEADD(MINUTE, -530, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (530, 19, 1, 11, NULL, NULL, 8, DATEADD(MINUTE, -529, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (531, 19, 1, 56, NULL, NULL, 170, DATEADD(MINUTE, -528, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (532, 19, 4, 56, NULL, NULL, NULL, DATEADD(MINUTE, -525, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (533, 15, 2, NULL, NULL, N'secador', NULL, DATEADD(MINUTE, -217, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (534, 15, 1, 59, NULL, NULL, 240, DATEADD(MINUTE, -215, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (535, 15, 4, 59, NULL, NULL, NULL, DATEADD(MINUTE, -214, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (536, 15, 1, 50, NULL, NULL, 125, DATEADD(MINUTE, -213, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (537, 15, 4, 50, NULL, NULL, NULL, DATEADD(MINUTE, -210, DATEADD(DAY, -11, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (538, 16, 1, 39, NULL, NULL, 41, DATEADD(MINUTE, -1169, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (539, 33, 1, 9, NULL, NULL, 47, DATEADD(MINUTE, -763, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (540, 4, 1, 72, NULL, NULL, 95, DATEADD(MINUTE, -487, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (541, 39, 3, NULL, 9, NULL, NULL, DATEADD(MINUTE, -365, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (542, 39, 1, 72, NULL, NULL, 81, DATEADD(MINUTE, -363, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (543, 39, 1, 39, NULL, NULL, 94, DATEADD(MINUTE, -360, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (544, 39, 1, 41, NULL, NULL, 79, DATEADD(MINUTE, -358, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (545, 37, 3, NULL, 1, NULL, NULL, DATEADD(MINUTE, -203, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (546, 37, 1, 38, NULL, NULL, 36, DATEADD(MINUTE, -201, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (547, 37, 1, 90, NULL, NULL, 46, DATEADD(MINUTE, -200, DATEADD(DAY, -10, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (548, 22, 1, 66, NULL, NULL, 45, DATEADD(MINUTE, -1228, DATEADD(DAY, -9, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (549, 42, 1, 76, NULL, NULL, 112, DATEADD(MINUTE, -1188, DATEADD(DAY, -9, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (550, 42, 4, 76, NULL, NULL, NULL, DATEADD(MINUTE, -1184, DATEADD(DAY, -9, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (551, 26, 2, NULL, NULL, N'auriculares bluetooth', NULL, DATEADD(MINUTE, -999, DATEADD(DAY, -9, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (552, 26, 1, 57, NULL, NULL, 13, DATEADD(MINUTE, -997, DATEADD(DAY, -9, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (553, 25, 1, 74, NULL, NULL, 24, DATEADD(MINUTE, -798, DATEADD(DAY, -9, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (554, 43, 1, 82, NULL, NULL, 87, DATEADD(MINUTE, -1019, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (555, 42, 2, NULL, NULL, N'potus', NULL, DATEADD(MINUTE, -859, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (556, 42, 1, 76, NULL, NULL, 90, DATEADD(MINUTE, -858, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (557, 42, 1, 79, NULL, NULL, 174, DATEADD(MINUTE, -854, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (558, 42, 4, 79, NULL, NULL, NULL, DATEADD(MINUTE, -853, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (559, 34, 2, NULL, NULL, N'campera inflable', NULL, DATEADD(MINUTE, -845, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (560, 34, 1, 85, NULL, NULL, 27, DATEADD(MINUTE, -844, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (561, 8, 1, 5, NULL, NULL, 21, DATEADD(MINUTE, -595, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (562, 36, 1, 56, NULL, NULL, 21, DATEADD(MINUTE, -475, DATEADD(DAY, -8, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (563, 29, 1, 12, NULL, NULL, 121, DATEADD(MINUTE, -868, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (564, 29, 4, 12, NULL, NULL, NULL, DATEADD(MINUTE, -864, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (565, 28, 2, NULL, NULL, N'organizador', NULL, DATEADD(MINUTE, -861, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (566, 28, 1, 71, NULL, NULL, 130, DATEADD(MINUTE, -859, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (567, 28, 4, 71, NULL, NULL, NULL, DATEADD(MINUTE, -856, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (568, 10, 2, NULL, NULL, N'webcam', NULL, DATEADD(MINUTE, -652, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (569, 10, 1, 44, NULL, NULL, 27, DATEADD(MINUTE, -651, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (570, 10, 1, 84, NULL, NULL, 52, DATEADD(MINUTE, -648, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (571, 9, 1, 6, NULL, NULL, 54, DATEADD(MINUTE, -557, DATEADD(DAY, -7, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (572, 11, 3, NULL, 8, NULL, NULL, DATEADD(MINUTE, -1211, DATEADD(DAY, -6, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (573, 11, 1, 5, NULL, NULL, 163, DATEADD(MINUTE, -1209, DATEADD(DAY, -6, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (574, 12, 1, 13, NULL, NULL, 9, DATEADD(MINUTE, -1201, DATEADD(DAY, -5, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (575, 37, 2, NULL, NULL, N'teclado musical', NULL, DATEADD(MINUTE, -958, DATEADD(DAY, -5, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (576, 37, 1, 69, NULL, NULL, 53, DATEADD(MINUTE, -956, DATEADD(DAY, -5, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (577, 37, 1, 32, NULL, NULL, 51, DATEADD(MINUTE, -953, DATEADD(DAY, -5, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (578, 17, 3, NULL, 4, NULL, NULL, DATEADD(MINUTE, -837, DATEADD(DAY, -5, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (579, 17, 1, 43, NULL, NULL, 38, DATEADD(MINUTE, -836, DATEADD(DAY, -5, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (580, 17, 1, 15, NULL, NULL, 18, DATEADD(MINUTE, -833, DATEADD(DAY, -5, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (581, 17, 1, 7, NULL, NULL, 29, DATEADD(MINUTE, -830, DATEADD(DAY, -5, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (582, 22, 2, NULL, NULL, N'bicicleta fija', NULL, DATEADD(MINUTE, -697, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (583, 22, 1, 62, NULL, NULL, 148, DATEADD(MINUTE, -695, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (584, 22, 1, 54, NULL, NULL, 22, DATEADD(MINUTE, -694, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (585, 39, 1, 28, NULL, NULL, 101, DATEADD(MINUTE, -672, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (586, 39, 4, 28, NULL, NULL, NULL, DATEADD(MINUTE, -669, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (587, 38, 2, NULL, NULL, N'plancha', NULL, DATEADD(MINUTE, -485, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (588, 38, 1, 104, NULL, NULL, 43, DATEADD(MINUTE, -484, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (589, 35, 2, NULL, NULL, N'rayuela', NULL, DATEADD(MINUTE, -412, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (590, 35, 1, 65, NULL, NULL, 69, DATEADD(MINUTE, -410, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (591, 31, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -383, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (592, 31, 1, 91, NULL, NULL, 94, DATEADD(MINUTE, -381, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (593, 31, 1, 70, NULL, NULL, 158, DATEADD(MINUTE, -380, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (594, 31, 4, 70, NULL, NULL, NULL, DATEADD(MINUTE, -378, DATEADD(DAY, -4, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (595, 11, 2, NULL, NULL, N'sábanas', NULL, DATEADD(MINUTE, -851, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (596, 11, 1, 2, NULL, NULL, 82, DATEADD(MINUTE, -850, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (597, 31, 2, NULL, NULL, N'escritorio', NULL, DATEADD(MINUTE, -805, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (598, 31, 1, 43, NULL, NULL, 24, DATEADD(MINUTE, -803, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (599, 41, 3, NULL, 6, NULL, NULL, DATEADD(MINUTE, -400, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (600, 41, 1, 29, NULL, NULL, 5, DATEADD(MINUTE, -399, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (601, 41, 1, 68, NULL, NULL, 131, DATEADD(MINUTE, -396, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (602, 41, 4, 68, NULL, NULL, NULL, DATEADD(MINUTE, -394, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (603, 41, 1, 107, NULL, NULL, 42, DATEADD(MINUTE, -393, DATEADD(DAY, -3, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (604, 18, 2, NULL, NULL, N'diccionario', NULL, DATEADD(MINUTE, -1109, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (605, 18, 1, 70, NULL, NULL, 236, DATEADD(MINUTE, -1107, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (606, 18, 4, 70, NULL, NULL, NULL, DATEADD(MINUTE, -1105, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (607, 17, 2, NULL, NULL, N'diccionario', NULL, DATEADD(MINUTE, -842, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (608, 17, 1, 70, NULL, NULL, 59, DATEADD(MINUTE, -841, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (609, 17, 1, 106, NULL, NULL, 198, DATEADD(MINUTE, -838, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (610, 17, 4, 106, NULL, NULL, NULL, DATEADD(MINUTE, -835, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (611, 12, 1, 7, NULL, NULL, 33, DATEADD(MINUTE, -683, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (612, 32, 1, 89, NULL, NULL, 135, DATEADD(MINUTE, -406, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (613, 32, 4, 89, NULL, NULL, NULL, DATEADD(MINUTE, -402, DATEADD(DAY, -2, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (614, 31, 2, NULL, NULL, N'plantas', NULL, DATEADD(MINUTE, -514, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (615, 31, 1, 79, NULL, NULL, 234, DATEADD(MINUTE, -513, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (616, 6, 3, NULL, 10, NULL, NULL, DATEADD(MINUTE, -230, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (617, 6, 1, 26, NULL, NULL, 221, DATEADD(MINUTE, -228, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (618, 6, 4, 26, NULL, NULL, NULL, DATEADD(MINUTE, -226, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (619, 5, 2, NULL, NULL, N'plantas', NULL, DATEADD(MINUTE, -111, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (620, 5, 1, 79, NULL, NULL, 184, DATEADD(MINUTE, -110, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (621, 5, 4, 79, NULL, NULL, NULL, DATEADD(MINUTE, -106, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (622, 5, 1, 86, NULL, NULL, 48, DATEADD(MINUTE, -105, DATEADD(DAY, -1, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (623, 23, 3, NULL, 2, NULL, NULL, DATEADD(MINUTE, -1198, DATEADD(DAY, -0, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (624, 23, 1, 58, NULL, NULL, 23, DATEADD(MINUTE, -1197, DATEADD(DAY, -0, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (625, 23, 1, 90, NULL, NULL, 199, DATEADD(MINUTE, -1194, DATEADD(DAY, -0, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (626, 23, 1, 17, NULL, NULL, 59, DATEADD(MINUTE, -1191, DATEADD(DAY, -0, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (627, 16, 2, NULL, NULL, N'alfombra', NULL, DATEADD(MINUTE, -648, DATEADD(DAY, -0, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (628, 16, 1, 39, NULL, NULL, 50, DATEADD(MINUTE, -646, DATEADD(DAY, -0, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (629, 40, 2, NULL, NULL, N'pelota', NULL, DATEADD(MINUTE, -106, DATEADD(DAY, -0, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (630, 40, 1, 83, NULL, NULL, 205, DATEADD(MINUTE, -104, DATEADD(DAY, -0, GETDATE())))
INSERT [dbo].[Interacciones] ([Id], [IdUsuario], [IdTipoInteraccion], [IdArticulo], [IdCategoria], [Texto], [Segundos], [Fecha]) VALUES (631, 40, 1, 7, NULL, NULL, 59, DATEADD(MINUTE, -101, DATEADD(DAY, -0, GETDATE())))
SET IDENTITY_INSERT [dbo].[Interacciones] OFF
GO
SET IDENTITY_INSERT [dbo].[Intercambios] ON 

INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (1, CAST(N'2026-10-29' AS Date), 2, 2, 12, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (2, CAST(DATEADD(DAY, -39, GETDATE()) AS Date), 1, 9, 4, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (3, CAST(DATEADD(DAY, -22, GETDATE()) AS Date), 3, 39, 26, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (4, CAST(DATEADD(DAY, -21, GETDATE()) AS Date), 3, 32, 29, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (5, CAST(DATEADD(DAY, -21, GETDATE()) AS Date), 3, 3, 12, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (6, CAST(DATEADD(DAY, -20, GETDATE()) AS Date), 1, 40, 18, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (7, CAST(DATEADD(DAY, -20, GETDATE()) AS Date), 1, 12, 20, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (8, CAST(DATEADD(DAY, -20, GETDATE()) AS Date), 3, 17, 25, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (9, CAST(DATEADD(DAY, -18, GETDATE()) AS Date), 1, 17, 30, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (10, CAST(DATEADD(DAY, -15, GETDATE()) AS Date), 1, 4, 12, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (11, CAST(DATEADD(DAY, -14, GETDATE()) AS Date), 3, 41, 40, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (12, CAST(DATEADD(DAY, -12, GETDATE()) AS Date), 1, 18, 40, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (13, CAST(DATEADD(DAY, -11, GETDATE()) AS Date), 1, 5, 8, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (14, CAST(DATEADD(DAY, -9, GETDATE()) AS Date), 1, 29, 33, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (15, CAST(DATEADD(DAY, -7, GETDATE()) AS Date), 1, 31, 7, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (16, CAST(DATEADD(DAY, -7, GETDATE()) AS Date), 1, 30, 5, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (17, CAST(DATEADD(DAY, -7, GETDATE()) AS Date), 1, 9, 31, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (18, CAST(DATEADD(DAY, -6, GETDATE()) AS Date), 1, 15, 24, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (19, CAST(DATEADD(DAY, -4, GETDATE()) AS Date), 3, 25, 19, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (20, CAST(DATEADD(DAY, -4, GETDATE()) AS Date), 1, 26, 37, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (21, CAST(DATEADD(DAY, -2, GETDATE()) AS Date), 1, 41, 42, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (22, CAST(DATEADD(DAY, -2, GETDATE()) AS Date), 3, 18, 28, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (23, CAST(DATEADD(DAY, -1, GETDATE()) AS Date), 1, 22, 27, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (24, CAST(DATEADD(DAY, -0, GETDATE()) AS Date), 1, 39, 29, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (25, CAST(DATEADD(DAY, -0, GETDATE()) AS Date), 1, 15, 16, NULL)
INSERT [dbo].[Intercambios] ([IdIntercambios], [Fecha], [IdEstado], [IdUsuarios1], [IdUsuarios2], [Ubicacion]) VALUES (26, CAST(DATEADD(DAY, -0, GETDATE()) AS Date), 3, 17, 23, NULL)
SET IDENTITY_INSERT [dbo].[Intercambios] OFF
GO
SET IDENTITY_INSERT [dbo].[ArticulosIntercambios] ON 

INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (1, 21, 1)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (2, 20, 1)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (3, 13, 2)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (4, 3, 2)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (5, 67, 3)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (6, 72, 3)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (7, 43, 4)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (8, 65, 4)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (9, 2, 5)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (10, 19, 5)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (11, 48, 6)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (12, 26, 6)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (13, 19, 7)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (14, 60, 7)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (15, 56, 8)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (16, 62, 8)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (17, 77, 9)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (18, 22, 9)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (19, 3, 10)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (20, 19, 10)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (21, 41, 11)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (22, 48, 11)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (23, 26, 12)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (24, 48, 12)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (25, 6, 13)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (26, 11, 13)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (27, 78, 14)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (28, 73, 14)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (29, 51, 15)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (30, 9, 15)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (31, 40, 16)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (32, 5, 16)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (33, 13, 17)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (34, 66, 17)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (35, 98, 18)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (36, 34, 18)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (37, 104, 19)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (38, 42, 19)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (39, 72, 20)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (40, 29, 20)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (41, 41, 21)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (42, 68, 21)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (43, 26, 22)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (44, 70, 22)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (45, 87, 23)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (46, 64, 23)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (47, 67, 24)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (48, 28, 24)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (49, 38, 25)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (50, 59, 25)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (51, 55, 26)
INSERT [dbo].[ArticulosIntercambios] ([Id], [IdArticulo], [IdIntercambio]) VALUES (52, 106, 26)
SET IDENTITY_INSERT [dbo].[ArticulosIntercambios] OFF
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
SET IDENTITY_INSERT [dbo].[Provincias] OFF
GO
SET IDENTITY_INSERT [dbo].[TipoCambios] ON 

INSERT [dbo].[TipoCambios] ([Id], [Nombre]) VALUES (1, N'Agregar')
INSERT [dbo].[TipoCambios] ([Id], [Nombre]) VALUES (2, N'Sacar')
INSERT [dbo].[TipoCambios] ([Id], [Nombre]) VALUES (3, N'Pedir')
SET IDENTITY_INSERT [dbo].[TipoCambios] OFF
GO
SET IDENTITY_INSERT [dbo].[TipoInteracciones] ON 

INSERT [dbo].[TipoInteracciones] ([Id], [Nombre]) VALUES (1, N'Vista')
INSERT [dbo].[TipoInteracciones] ([Id], [Nombre]) VALUES (2, N'Búsqueda')
INSERT [dbo].[TipoInteracciones] ([Id], [Nombre]) VALUES (3, N'Filtro por categoría')
INSERT [dbo].[TipoInteracciones] ([Id], [Nombre]) VALUES (4, N'Favorito')
SET IDENTITY_INSERT [dbo].[TipoInteracciones] OFF
GO
SET IDENTITY_INSERT [dbo].[TipoNotificaciones] ON 

INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (1, N'Propuesta recibida')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (2, N'Propuesta aceptada')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (3, N'Propuesta rechazada')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (4, N'Mensaje nuevo')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (5, N'Intercambio cancelado')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (6, N'Artículo agregado')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (7, N'Pedido de artículo')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (8, N'Pedido para sacar')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (9, N'Cambio aceptado')
INSERT [dbo].[TipoNotificaciones] ([Id], [Nombre]) VALUES (10, N'Cambio rechazado')
SET IDENTITY_INSERT [dbo].[TipoNotificaciones] OFF
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (2, N'Rafael dasf', N'Odiard Wesler', N'rafaelodiard', N'rafaelodiard@gmail.com', N'', N'AQAAAAIAAYagAAAAECiEIkRdwaCH2m8I7EVXb7wY7NNakfcf73xLU1wvvOWUCSSQNxhmMZj4mvt1ffIK/w==', N'', CAST(N'2024-11-01' AS Date), 1, 1, NULL)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (3, N'Sofía', N'Martínez', N'sofia.martinez', N'sofia.martinez@example.com', N'110000001', N'SwappitDemo01!', N'Almagro', CAST(N'2005-04-12' AS Date), 21, 1, N'Me mudé hace poco a Almagro y estoy armando la cocina. Busco cosas para el depto; coordinamos por el chat de Swappit.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (4, N'Mateo', N'Gómez', N'mateo.gomez', N'mateo.gomez@example.com', N'110000002', N'SwappitDemo02!', N'Villa Crespo', CAST(N'2004-09-23' AS Date), 22, 1, N'Armando mi primer monoambiente en Villa Crespo. Me interesan muebles chicos y cosas de cocina. Puedo encontrarme cerca del subte B.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (5, N'Valentina', N'López', N'valentina.lopez', N'valentina.lopez@example.com', N'110000003', N'SwappitDemo03!', N'Caballito', CAST(N'2006-01-30' AS Date), 20, 1, N'Me sobran cosas de la casa de mis viejos y prefiero cambiarlas antes que tirarlas. Busco plantas, libros o cosas para el balcón.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (6, N'Lucas', N'Pérez', N'lucas.perez', N'lucas.perez@example.com', N'110000006', N'SwappitDemo06!', N'Villa Urquiza', CAST(N'2005-02-19' AS Date), 21, 1, N'Trabajo desde casa, así que me interesa todo lo que sirva para armar un buen escritorio. Respondo rápido por el chat.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (7, N'Martina', N'Díaz', N'martina.diaz', N'martina.diaz@example.com', N'110000007', N'SwappitDemo07!', N'Belgrano', CAST(N'2006-06-02' AS Date), 20, 1, N'Me encanta cocinar y estoy aprendiendo. Cambio cosas de cocina y libros; si querés, coordinamos un fin de semana por Belgrano.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (8, N'Thiago', N'Acosta', N'thiago.acosta', N'thiago.acosta@example.com', N'110000010', N'SwappitDemo10!', N'Palermo', CAST(N'2005-08-05' AS Date), 21, 1, N'Estoy ordenando el depto y quiero darles otra vida a las cosas que no uso. Busco algo para el living. Coordinamos por el chat.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (9, N'Tomás', N'Fernández', N'tomas.fernandez', N'tomas.fernandez@example.com', N'110000004', N'SwappitDemo04!', N'Nueva Córdoba', CAST(N'2005-07-08' AS Date), 21, 6, N'Estudio en Córdoba y me muevo en bici. Me interesan cosas útiles para un depto de estudiante. Coordinamos por Nueva Córdoba.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (10, N'Benjamín', N'Torres', N'benjamin.torres', N'benjamin.torres@example.com', N'110000008', N'SwappitDemo08!', N'General Paz', CAST(N'2005-12-27' AS Date), 20, 6, N'Me estoy independizando y necesito de todo un poco. Prefiero cambiar antes que comprar nuevo. Escribime y lo vemos.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (11, N'Camila', N'Rodríguez', N'camila.rodriguez', N'camila.rodriguez@example.com', N'110000005', N'SwappitDemo05!', N'Centro', CAST(N'2004-11-16' AS Date), 21, 21, N'Me mudo seguido y viajo liviana. Cambio cosas para la casa por algo que entre en una mochila o sirva para cocinar.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (12, N'Julieta', N'Romero', N'julieta.romero', N'julieta.romero@example.com', N'110000009', N'AQAAAAIAAYagAAAAEGvD5HyASb2I0c6o3i61BVYAROs7rl5Q5m8OgNpr09vzP3zenKAkfx5dKhYoAs/mqQ==', N'Rosario Centro', CAST(N'2004-03-14' AS Date), 22, 21, N'Recién llegada a Rosario Centro, armando el depto de a poco. Busco lámparas, plantas o cosas de deco. Respondo por el chat.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (13, N'MARTINA', N'DRUCAROFF', N'50416809', N'50416809@est.ort.edu.ar', N'', N'12345678', N'', CAST(N'2000-09-09' AS Date), 26, 1, NULL)
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (14, N'Agustina', N'Herrera', N'agustina.herrera', N'agustina.herrera@example.com', N'110000011', N'SwappitDemo11!', N'San Telmo', CAST(N'2001-03-22' AS Date), 25, 2, N'Soy diseñadora gráfica y me mudé sola a San Telmo. Cambio ropa que ya no uso por libros o cosas lindas para el depto.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (15, N'Facundo', N'Molina', N'facundo.molina', N'facundo.molina@example.com', N'110000012', N'SwappitDemo12!', N'Boedo', CAST(N'1999-07-10' AS Date), 27, 2, N'Toco la guitarra y estoy armando un home studio en mi pieza. Cambio lo que no uso por equipos de música o tecnología.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (16, N'Micaela', N'Sosa', N'micaela.sosa', N'micaela.sosa@example.com', N'110000013', N'SwappitDemo13!', N'Quilmes', CAST(N'2003-11-02' AS Date), 23, 1, N'Estudio enfermería y comparto depto con una amiga en Quilmes. Busco cosas para la cocina y para entrenar en casa.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (17, N'Joaquín', N'Ruiz', N'joaquin.ruiz', N'joaquin.ruiz@example.com', N'110000014', N'SwappitDemo14!', N'La Plata', CAST(N'2000-05-18' AS Date), 26, 1, N'Estudio arquitectura en La Plata y me sobran cosas de la facu. Busco algo para hacer deporte y despejarme.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (18, N'Lucía', N'Benítez', N'lucia.benitez', N'lucia.benitez@example.com', N'110000015', N'SwappitDemo15!', N'Nueva Córdoba', CAST(N'2004-02-14' AS Date), 22, 6, N'Estudio psicología. Me encanta leer y escuchar vinilos; cambio lo que no uso por libros o música. Coordino por Nueva Córdoba.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (19, N'Santiago', N'Castro', N'santiago.castro', N'santiago.castro@example.com', N'110000016', N'SwappitDemo16!', N'Güemes', CAST(N'1998-09-30' AS Date), 28, 6, N'Trabajo en sistemas y me mudé hace poco a Güemes. Cambio periféricos que me sobran por cosas para la casa o tecnología.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (20, N'Florencia', N'Medina', N'florencia.medina', N'florencia.medina@example.com', N'110000017', N'SwappitDemo17!', N'Fisherton', CAST(N'2002-06-25' AS Date), 24, 21, N'Bailo y hago yoga. Me mudo a un depto más chico, así que cambio muebles que no entran por cosas para entrenar o ropa.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (21, N'Ignacio', N'Vega', N'ignacio.vega', N'ignacio.vega@example.com', N'110000018', N'SwappitDemo18!', N'Pichincha', CAST(N'2001-12-08' AS Date), 24, 21, N'Toco el bajo en una banda de Rosario y busco equipos para ensayar. Cambio cosas de la casa que no uso.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (22, N'Rocío', N'Giménez', N'rocio.gimenez', N'rocio.gimenez@example.com', N'110000019', N'SwappitDemo19!', N'Godoy Cruz', CAST(N'2000-01-19' AS Date), 26, 13, N'Me encanta la montaña y salir de camping. Cambio ropa y cosas de la casa por equipo para el trekking.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (23, N'Nicolás', N'Ramos', N'nicolas.ramos', N'nicolas.ramos@example.com', N'110000020', N'SwappitDemo20!', N'Santiago del Estero', CAST(N'1997-04-03' AS Date), 29, 22, N'Soy profe de educación física y tengo equipo que ya no uso. Me gustaría encontrar libros y alguna cosa para el depto.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (24, N'Milagros', N'Ortiz', N'milagros.ortiz', N'milagros.ortiz@example.com', N'110000021', N'SwappitDemo21!', N'Yerba Buena', CAST(N'2003-08-12' AS Date), 23, 24, N'Estudio medicina y ya casi no toco el teclado. Busco ropa abrigada y libros para despejarme entre parciales.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (25, N'Franco', N'Aguirre', N'franco.aguirre', N'franco.aguirre@example.com', N'110000022', N'SwappitDemo22!', N'Neuquén', CAST(N'1999-10-27' AS Date), 27, 15, N'Trabajo en turnos largos y paso poco tiempo en casa. Cambio cosas que no uso por equipo de camping o tecnología.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (26, N'Abril', N'Navarro', N'abril.navarro', N'abril.navarro@example.com', N'110000023', N'SwappitDemo23!', N'Palermo', CAST(N'2005-05-05' AS Date), 21, 2, N'Estudio diseño de indumentaria y me encanta la ropa vintage. Cambio libros y cosas de la casa por ropa o vinilos.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (27, N'Bruno', N'Silva', N'bruno.silva', N'bruno.silva@example.com', N'110000024', N'SwappitDemo24!', N'Caballito', CAST(N'2002-02-28' AS Date), 24, 2, N'Soy programador y trabajo desde casa. Dejé el skate y busco cosas para armar el escritorio o escuchar música.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (28, N'Carolina', N'Peralta', N'carolina.peralta', N'carolina.peralta@example.com', N'110000025', N'SwappitDemo25!', N'Tres Cerritos', CAST(N'1998-12-15' AS Date), 27, 17, N'Volví a Salta después de vivir en Buenos Aires y me sobraron cosas de la mudanza. Busco cosas para la casa.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (29, N'Emiliano', N'Domínguez', N'emiliano.dominguez', N'emiliano.dominguez@example.com', N'110000026', N'SwappitDemo26!', N'Paraná', CAST(N'2001-07-07' AS Date), 25, 8, N'Estudio ingeniería y toco el cajón con amigos. Me interesan los instrumentos y la tecnología.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (30, N'Paula', N'Suárez', N'paula.suarez', N'paula.suarez@example.com', N'110000027', N'SwappitDemo27!', N'Villa Ortúzar', CAST(N'2004-09-09' AS Date), 22, 2, N'Me independicé hace poco y estoy aprendiendo a cocinar. Busco cosas para la cocina y plantas para el balcón.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (31, N'Matías', N'Luna', N'matias.luna', N'matias.luna@example.com', N'110000028', N'SwappitDemo28!', N'Bariloche', CAST(N'1996-11-20' AS Date), 29, 16, N'Soy guía de montaña en Bariloche. Cambio equipo que tengo repetido por cosas para la casa o libros.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (32, N'Valeria', N'Ibáñez', N'valeria.ibanez', N'valeria.ibanez@example.com', N'110000029', N'SwappitDemo29!', N'Resistencia', CAST(N'2000-03-03' AS Date), 26, 4, N'Soy profe de inglés y leo mucho. Me gustaría encontrar novelas y algo de música para el depto.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (33, N'Gonzalo', N'Paz', N'gonzalo.paz', N'gonzalo.paz@example.com', N'110000030', N'SwappitDemo30!', N'Villa Sarita', CAST(N'1999-06-16' AS Date), 27, 14, N'Hago música electrónica y estoy renovando el equipo. Cambio lo que ya no uso por tecnología o ropa.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (34, N'Antonella', N'Ríos', N'antonella.rios', N'antonella.rios@example.com', N'110000031', N'SwappitDemo31!', N'La Perla', CAST(N'2003-01-26' AS Date), 23, 1, N'Vivo en Mar del Plata, cerca del mar, y me encanta la playa. Me mudo y cambio cosas de la casa por ropa o cosas de deporte.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (35, N'Lautaro', N'Cabrera', N'lautaro.cabrera', N'lautaro.cabrera@example.com', N'110000032', N'SwappitDemo32!', N'Barrio Norte', CAST(N'2005-10-01' AS Date), 21, 24, N'Estudio música en la universidad. Busco instrumentos y libros; tengo ropa que ya no uso.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (36, N'Julián', N'Correa', N'julian.correa', N'julian.correa@example.com', N'110000033', N'SwappitDemo33!', N'Santa Rosa', CAST(N'1998-02-11' AS Date), 28, 11, N'Trabajo en el campo y vengo poco a la ciudad. Cambio cosas que me quedaron de la mudanza por tecnología.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (37, N'Daniela', N'Acuña', N'daniela.acuna', N'daniela.acuna@example.com', N'110000034', N'SwappitDemo34!', N'San Salvador de Jujuy', CAST(N'2002-04-30' AS Date), 24, 10, N'Soy fotógrafa y me gustan las cosas de diseño para la casa. También busco ropa con onda.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (38, N'Federico', N'Ponce', N'federico.ponce', N'federico.ponce@example.com', N'110000035', N'SwappitDemo35!', N'Comodoro Rivadavia', CAST(N'1997-08-21' AS Date), 29, 5, N'Soy ingeniero, hago crossfit y me gusta cocinar. Busco cosas para entrenar en casa y para la cocina.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (39, N'Josefina', N'Quiroga', N'josefina.quiroga', N'josefina.quiroga@example.com', N'110000036', N'SwappitDemo36!', N'Rivadavia', CAST(N'2004-12-03' AS Date), 21, 18, N'Estudio letras. Busco libros de todo tipo y alguna lámpara para leer de noche.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (40, N'Ramiro', N'Godoy', N'ramiro.godoy', N'ramiro.godoy@example.com', N'110000037', N'SwappitDemo37!', N'San Luis', CAST(N'2000-10-14' AS Date), 26, 19, N'Trabajo en una bicicletería. Me quedaron instrumentos de cuando tocaba en una banda y busco tecnología o cosas de deporte.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (41, N'Brenda', N'Villalba', N'brenda.villalba', N'brenda.villalba@example.com', N'110000038', N'SwappitDemo38!', N'Corrientes', CAST(N'2003-05-20' AS Date), 23, 7, N'Estudio odontología en Corrientes. Me interesan la ropa y la música; cambio libros que ya leí.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (42, N'Maximiliano', N'Ledesma', N'maximiliano.ledesma', N'maximiliano.ledesma@example.com', N'110000039', N'SwappitDemo39!', N'Formosa', CAST(N'1999-01-09' AS Date), 27, 9, N'Trabajo en un estudio contable. Busco cosas para la casa y algún libro para leer en el colectivo.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (43, N'Celeste', N'Moreno', N'celeste.moreno', N'celeste.moreno@example.com', N'110000040', N'SwappitDemo40!', N'Ushuaia', CAST(N'2001-09-27' AS Date), 25, 23, N'En Ushuaia hace frío casi todo el año: busco ropa abrigada y cosas para la casa.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (44, N'Prueba', N'Uno', N'prueba.uno', N'prueba.uno@example.com', N'110000041', N'SwappitPrueba1!', N'Palermo', CAST(N'2000-05-10' AS Date), 26, 1, N'Usuario de prueba para probar intercambios.')
INSERT [dbo].[Usuarios] ([IdUsuarios], [Nombre], [Apellido], [Usuario], [Mail], [Telefono], [Contraseña], [Barrio], [Fecha nacimiento], [Edad], [IdProvincias], [Descripcion]) VALUES (45, N'Prueba', N'Dos', N'prueba.dos', N'prueba.dos@example.com', N'110000042', N'SwappitPrueba2!', N'Caballito', CAST(N'2001-08-22' AS Date), 25, 1, N'Usuario de prueba para probar intercambios.')
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_Categorias] FOREIGN KEY([IdCategorias])
REFERENCES [dbo].[Categorias] ([IdCategorias])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_Categorias]
GO
ALTER TABLE [dbo].[Articulos]  WITH CHECK ADD  CONSTRAINT [FK_Articulos_CategoriasACambio] FOREIGN KEY([IdCategoriaACambio])
REFERENCES [dbo].[Categorias] ([IdCategorias])
GO
ALTER TABLE [dbo].[Articulos] CHECK CONSTRAINT [FK_Articulos_CategoriasACambio]
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
ALTER TABLE [dbo].[ArticulosIntercambios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosIntercambios_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulos])
GO
ALTER TABLE [dbo].[ArticulosIntercambios] CHECK CONSTRAINT [FK_ArticulosIntercambios_Articulos]
GO
ALTER TABLE [dbo].[ArticulosIntercambios]  WITH CHECK ADD  CONSTRAINT [FK_ArticulosIntercambios_Intercambios] FOREIGN KEY([IdIntercambio])
REFERENCES [dbo].[Intercambios] ([IdIntercambios])
GO
ALTER TABLE [dbo].[ArticulosIntercambios] CHECK CONSTRAINT [FK_ArticulosIntercambios_Intercambios]
GO
ALTER TABLE [dbo].[CambiosIntercambios]  WITH CHECK ADD  CONSTRAINT [FK_CambiosIntercambios_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulos])
GO
ALTER TABLE [dbo].[CambiosIntercambios] CHECK CONSTRAINT [FK_CambiosIntercambios_Articulos]
GO
ALTER TABLE [dbo].[CambiosIntercambios]  WITH CHECK ADD  CONSTRAINT [FK_CambiosIntercambios_EstadosIntercambios] FOREIGN KEY([IdEstado])
REFERENCES [dbo].[EstadosIntercambios] ([IdEstadosIntercambios])
GO
ALTER TABLE [dbo].[CambiosIntercambios] CHECK CONSTRAINT [FK_CambiosIntercambios_EstadosIntercambios]
GO
ALTER TABLE [dbo].[CambiosIntercambios]  WITH CHECK ADD  CONSTRAINT [FK_CambiosIntercambios_Intercambios] FOREIGN KEY([IdIntercambio])
REFERENCES [dbo].[Intercambios] ([IdIntercambios])
GO
ALTER TABLE [dbo].[CambiosIntercambios] CHECK CONSTRAINT [FK_CambiosIntercambios_Intercambios]
GO
ALTER TABLE [dbo].[CambiosIntercambios]  WITH CHECK ADD  CONSTRAINT [FK_CambiosIntercambios_TipoCambios] FOREIGN KEY([IdTipoCambio])
REFERENCES [dbo].[TipoCambios] ([Id])
GO
ALTER TABLE [dbo].[CambiosIntercambios] CHECK CONSTRAINT [FK_CambiosIntercambios_TipoCambios]
GO
ALTER TABLE [dbo].[CambiosIntercambios]  WITH CHECK ADD  CONSTRAINT [FK_CambiosIntercambios_Usuarios] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
ALTER TABLE [dbo].[CambiosIntercambios] CHECK CONSTRAINT [FK_CambiosIntercambios_Usuarios]
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
ALTER TABLE [dbo].[Interacciones]  WITH CHECK ADD  CONSTRAINT [FK_Interacciones_Articulos] FOREIGN KEY([IdArticulo])
REFERENCES [dbo].[Articulos] ([IdArticulos])
GO
ALTER TABLE [dbo].[Interacciones] CHECK CONSTRAINT [FK_Interacciones_Articulos]
GO
ALTER TABLE [dbo].[Interacciones]  WITH CHECK ADD  CONSTRAINT [FK_Interacciones_Categorias] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[Categorias] ([IdCategorias])
GO
ALTER TABLE [dbo].[Interacciones] CHECK CONSTRAINT [FK_Interacciones_Categorias]
GO
ALTER TABLE [dbo].[Interacciones]  WITH CHECK ADD  CONSTRAINT [FK_Interacciones_TipoInteracciones] FOREIGN KEY([IdTipoInteraccion])
REFERENCES [dbo].[TipoInteracciones] ([Id])
GO
ALTER TABLE [dbo].[Interacciones] CHECK CONSTRAINT [FK_Interacciones_TipoInteracciones]
GO
ALTER TABLE [dbo].[Interacciones]  WITH CHECK ADD  CONSTRAINT [FK_Interacciones_Usuarios] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuarios] ([IdUsuarios])
GO
ALTER TABLE [dbo].[Interacciones] CHECK CONSTRAINT [FK_Interacciones_Usuarios]
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
ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD  CONSTRAINT [FK_Notificaciones_CambiosIntercambios] FOREIGN KEY([IdCambio])
REFERENCES [dbo].[CambiosIntercambios] ([Id])
GO
ALTER TABLE [dbo].[Notificaciones] CHECK CONSTRAINT [FK_Notificaciones_CambiosIntercambios]
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
/****** Object:  StoredProcedure [dbo].[ActualizarContrasena]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[BorrarFotoUsuario]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BorrarFotoUsuario]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM Imagenes WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL
END
GO
/****** Object:  StoredProcedure [dbo].[Complejos_Ejecucion]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Complejos_Ejecucion]

AS
BEGIN

EXEC Complejos_EstadisticasUsuario @IdUsuario = 3
EXEC Complejos_RankingCategoriasIntercambiadas @MinIntercambios = 1
EXEC Complejos_RecomendarUsuariosIntercambio @IdUsuarioConsultado = 4
EXEC Complejos_SeguimientoIntercambiosPendientes @AntiguedadMinimaDias = 0
EXEC Complejos_RendimientoPlataformaPorPeriodo @FechaDesde = '2025-01-01', @FechaHasta = '2026-12-31'
EXEC Complejos_Personalizado_GestionarPropuestaYNotificacion @IdIntercambio = 1

END
GO
/****** Object:  StoredProcedure [dbo].[Complejos_EstadisticasUsuario]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_EstadisticasUsuario]
    @IdUsuario INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.Usuarios WHERE IdUsuarios = @IdUsuario)
    BEGIN
        PRINT 'Error: El usuario no existe.';
        RETURN;
    END

    DECLARE @ArticulosPublicados INT;
    DECLARE @CategoriasDiferentes INT;
    DECLARE @IntercambiosParticipo INT;
    DECLARE @OperacionesConcretadas INT;
    DECLARE @PorcentajeConcrecion DECIMAL(5,2);
    DECLARE @Clasificacion VARCHAR(20);

    SELECT 
        @ArticulosPublicados = COUNT(IdArticulos),
        @CategoriasDiferentes = COUNT(DISTINCT IdCategorias)
    FROM dbo.Articulos
    WHERE IdUsuarios = @IdUsuario;

    SELECT 
        @IntercambiosParticipo = COUNT(*),
        @OperacionesConcretadas = ISNULL(SUM(CASE WHEN IdEstado = 4 THEN 1 ELSE 0 END), 0)
    FROM dbo.Intercambios
    WHERE IdUsuarios1 = @IdUsuario OR IdUsuarios2 = @IdUsuario;

    IF @IntercambiosParticipo = 0
    BEGIN
        SELECT 
            @ArticulosPublicados AS ArticulosPublicados,
            @CategoriasDiferentes AS CategoriasDiferentes,
            0 AS IntercambiosParticipo,
            0 AS OperacionesConcretadas,
            0.00 AS PorcentajeConcrecion,
            'Principiante' AS Clasificacion;
        RETURN;
    END

    SET @PorcentajeConcrecion = (CAST(@OperacionesConcretadas AS DECIMAL(10,2)) / @IntercambiosParticipo) * 100.0;

    IF @PorcentajeConcrecion >= 70.0
        SET @Clasificacion = 'Experto';
    ELSE IF @PorcentajeConcrecion >= 40.0
        SET @Clasificacion = 'Activo';
    ELSE
        SET @Clasificacion = 'Principiante';

    SELECT 
        @ArticulosPublicados AS ArticulosPublicados,
        @CategoriasDiferentes AS CategoriasDiferentes,
        @IntercambiosParticipo AS IntercambiosParticipo,
        @OperacionesConcretadas AS OperacionesConcretadas,
        @PorcentajeConcrecion AS PorcentajeConcrecion,
        @Clasificacion AS Clasificacion;
END;
GO
/****** Object:  StoredProcedure [dbo].[Complejos_Personalizado_GestionarPropuestaYNotificacion]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_Personalizado_GestionarPropuestaYNotificacion]
    @IdIntercambio INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @IdIntercambio IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.Intercambios WHERE IdIntercambios = @IdIntercambio)
    BEGIN
        PRINT 'Error: El código de intercambio especificado no existe.';
        RETURN;
    END

    DECLARE @IdUsuarioRecibe INT, @EstadoIntercambio INT;
    DECLARE @Prioridad VARCHAR(20) = 'Prioridad Normal';

    SELECT 
        @IdUsuarioRecibe = IdUsuarios2,
        @EstadoIntercambio = Intercambios.IdEstado
    FROM Intercambios 
    WHERE Intercambios.IdIntercambios = @IdIntercambio;

    IF @EstadoIntercambio <> 1
    BEGIN
        PRINT 'El intercambio no está en estado Pendiente.';
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM dbo.ArticulosIntercambios ai
        INNER JOIN dbo.Articulos ofrecido ON ofrecido.IdArticulos = ai.IdArticulo AND ofrecido.IdUsuarios <> @IdUsuarioRecibe
        INNER JOIN dbo.Articulos a ON a.IdUsuarios = @IdUsuarioRecibe AND a.IdCategorias = ofrecido.IdCategorias
        WHERE ai.IdIntercambio = @IdIntercambio
    )
    BEGIN
        SET @Prioridad = 'Alta Prioridad';
    END

    IF NOT EXISTS (
        SELECT 1 FROM dbo.Notificaciones 
        WHERE IdIntercambio = @IdIntercambio AND IdTipoNotificacion = 1
    )
    BEGIN
        INSERT INTO dbo.Notificaciones (IdUsuario, IdIntercambio, IdTipoNotificacion, Leida, Fecha)
        VALUES (@IdUsuarioRecibe, @IdIntercambio, 1, 0, GETDATE());
    END

    SELECT 
        Intercambios.IdIntercambios,
        u1.Usuario AS UsuarioEmisor,
        u2.Usuario AS UsuarioReceptor,
        @Prioridad AS PrioridadIntercambio,
        'Notificación procesada correctamente' AS EstadoProceso
    FROM dbo.Intercambios 
    INNER JOIN dbo.Usuarios u1 ON Intercambios.IdUsuarios1 = u1.IdUsuarios
    INNER JOIN dbo.Usuarios u2 ON Intercambios.IdUsuarios2 = u2.IdUsuarios
    WHERE Intercambios.IdIntercambios = @IdIntercambio;
END;
GO
/****** Object:  StoredProcedure [dbo].[Complejos_RecomendarUsuariosIntercambio]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_RecomendarUsuariosIntercambio]
    @IdUsuarioConsultado INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE IdUsuarios = @IdUsuarioConsultado)
    BEGIN
        PRINT 'El usuario consultado no existe';
        RETURN;
    END

    DECLARE @IdProvincia INT;
    SELECT @IdProvincia = IdProvincias FROM dbo.Usuarios WHERE IdUsuarios = @IdUsuarioConsultado;

    SELECT 
        Usuarios.IdUsuarios,
        Usuarios.Usuario,
        COUNT(DISTINCT a.IdArticulos) AS ArticulosDisponibles,
        COUNT(DISTINCT a.IdCategorias) AS VariedadCategorias
    FROM dbo.Usuarios 
    INNER JOIN dbo.Articulos a ON Usuarios.IdUsuarios = a.IdUsuarios
    WHERE Usuarios.IdProvincias = @IdProvincia
      AND Usuarios.IdUsuarios <> @IdUsuarioConsultado
      AND a.IdCategorias NOT IN (
          SELECT DISTINCT IdCategorias 
          FROM dbo.Articulos
          WHERE IdUsuarios = @IdUsuarioConsultado
      )
    GROUP BY Usuarios.IdUsuarios, Usuarios.Usuario
    ORDER BY VariedadCategorias DESC, ArticulosDisponibles DESC;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No se encontraron usuarios recomendados para intercambiar';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[Complejos_RendimientoPlataformaPorPeriodo]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_RendimientoPlataformaPorPeriodo]
    @FechaDesde DATE,
    @FechaHasta DATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @FechaDesde IS NULL OR @FechaHasta IS NULL OR @FechaDesde > @FechaHasta
    BEGIN
        PRINT 'Error: Rango de fechas inválido.';
        RETURN;
    END

    DECLARE @Totales INT, @Completados INT, @Pendientes INT;
    DECLARE @UsuariosUnicos INT;
    DECLARE @PromedioPorUsuario DECIMAL(10,2);
    DECLARE @ProvinciaMasActiva VARCHAR(50);
    DECLARE @PorcentajeCompletados DECIMAL(5,2);
    DECLARE @Clasificacion VARCHAR(20);

    SELECT 
        @Totales = COUNT(*),
        @Completados = ISNULL(SUM(CASE WHEN IdEstado = 4 THEN 1 ELSE 0 END), 0), -- 4: Realizado
        @Pendientes = ISNULL(SUM(CASE WHEN IdEstado = 1 THEN 1 ELSE 0 END), 0)   -- 1: Pendiente
    FROM dbo.Intercambios
    WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta;

    IF @Totales = 0 OR @Totales IS NULL
    BEGIN
        PRINT 'No se registraron datos en el período ingresado.';
        RETURN;
    END

    SELECT @UsuariosUnicos = COUNT(DISTINCT IdUsuario)
    FROM (
        SELECT IdUsuarios1 AS IdUsuario FROM dbo.Intercambios WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta
        UNION
        SELECT IdUsuarios2 AS IdUsuario FROM dbo.Intercambios WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta
    ) AS Participantes;

    SET @PromedioPorUsuario = CAST(@Totales AS DECIMAL(10,2)) / @UsuariosUnicos;

    SELECT TOP 1 @ProvinciaMasActiva = p.Nombre
    FROM dbo.Provincias p
    INNER JOIN dbo.Usuarios u ON p.IdProvincia = u.IdProvincias
    INNER JOIN (
        SELECT IdUsuarios1 AS IdUsuario FROM dbo.Intercambios WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta
        UNION
        SELECT IdUsuarios2 AS IdUsuario FROM dbo.Intercambios WHERE Fecha BETWEEN @FechaDesde AND @FechaHasta
    ) AS Part ON u.IdUsuarios = Part.IdUsuario
    GROUP BY p.IdProvincia, p.Nombre
    ORDER BY COUNT(DISTINCT u.IdUsuarios) DESC;

    SET @PorcentajeCompletados = (CAST(@Completados AS DECIMAL(10,2)) / @Totales) * 100.0;

    IF @PorcentajeCompletados >= 70.0
        SET @Clasificacion = 'Excelente';
    ELSE IF @PorcentajeCompletados >= 40.0
        SET @Clasificacion = 'Aceptable';
    ELSE
        SET @Clasificacion = 'Bajo';

    SELECT 
        @Totales AS IntercambiosTotales,
        @Completados AS IntercambiosCompletados,
        @Pendientes AS IntercambiosPendientes,
        @UsuariosUnicos AS UsuariosParticipantesDiferentes,
        @PromedioPorUsuario AS PromedioIntercambiosPorUsuario,
        ISNULL(@ProvinciaMasActiva, 'Sin datos') AS ProvinciaMasParticipantes,
        @PorcentajeCompletados AS PorcentajeCompletados,
        @Clasificacion AS ClasificacionRendimiento;
END;
GO
/****** Object:  StoredProcedure [dbo].[Complejos_SeguimientoIntercambiosPendientes]    Script Date: 6/11/2026 08:55:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Complejos_SeguimientoIntercambiosPendientes]
    @AntiguedadMinimaDias INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @AntiguedadMinimaDias IS NULL OR @AntiguedadMinimaDias < 0
    BEGIN
        PRINT 'Error: Ingrese una antigüedad válida en días.';
        RETURN;
    END

    SELECT 
        Intercambios.IdIntercambios,
        u1.Usuario AS Usuario1,
        u2.Usuario AS Usuario2,
        a1.Nombre AS Articulo1,
        a1.Cantidad AS CantidadOfrecidos,
        a2.Nombre AS Articulo2,
        DATEDIFF(DAY, Intercambios.Fecha, GETDATE()) AS DiasTranscurridos,
        COUNT(m.IdMensajes) AS MensajesTotales,
        ISNULL(SUM(CASE WHEN m.fueVisto = 0 THEN 1 ELSE 0 END), 0) AS MensajesNoVistos,
        CASE 
            WHEN COUNT(m.IdMensajes) = 0 THEN 'Sin comunicación'
            WHEN ISNULL(SUM(CASE WHEN m.fueVisto = 1 THEN 1 ELSE 0 END), 0) = 0 THEN 'Sin respuesta registrada'
            ELSE 'Con actividad'
        END AS Clasificacion
    FROM dbo.Intercambios 
    INNER JOIN Usuarios u1 ON Intercambios.IdUsuarios1 = u1.IdUsuarios
    INNER JOIN Usuarios u2 ON Intercambios.IdUsuarios2 = u2.IdUsuarios
    CROSS APPLY (SELECT TOP 1 a.Nombre, COUNT(*) OVER () AS Cantidad
        FROM ArticulosIntercambios ai
        INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
        WHERE ai.IdIntercambio = Intercambios.IdIntercambios AND a.IdUsuarios = Intercambios.IdUsuarios1
        ORDER BY ai.Id) a1
    CROSS APPLY (SELECT TOP 1 a.Nombre
        FROM ArticulosIntercambios ai
        INNER JOIN Articulos a ON a.IdArticulos = ai.IdArticulo
        WHERE ai.IdIntercambio = Intercambios.IdIntercambios AND a.IdUsuarios = Intercambios.IdUsuarios2
        ORDER BY ai.Id) a2
    LEFT JOIN Mensajes m ON Intercambios.IdIntercambios = m.IdIntercambio
    WHERE Intercambios.IdEstado = 1 -- Estado 1 = Pendiente
      AND DATEDIFF(DAY, Intercambios.Fecha, GETDATE()) >= @AntiguedadMinimaDias
    GROUP BY Intercambios.IdIntercambios, Intercambios.Fecha, u1.Usuario, u2.Usuario, a1.Nombre, a1.Cantidad, a2.Nombre
    ORDER BY DiasTranscurridos DESC;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'No hay intercambios pendientes que superen el límite de días ingresado.';
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[GetArticuloById]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetArticuloById]
	@id int
AS
BEGIN
	SET NOCOUNT ON;

		SELECT IdArticulos, Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, FechaPublicacion, IdCategoriaACambio
        FROM Articulos WHERE IdArticulos = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetArticulosCatalogo]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[GetCantidadNotificacionesNoLeidas]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCantidadNotificacionesNoLeidas]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT COUNT(*) FROM Notificaciones WHERE IdUsuario = @idUsuario AND Leida = 0
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategoriaById]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCategoriaById]
	@id int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IdCategorias, Nombre FROM Categorias WHERE IdCategorias = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetCategorias]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCategorias]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IdCategorias, Nombre FROM Categorias ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadoArticuloById]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEstadoArticuloById]
	@id int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos WHERE IdEstadosArticulos = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadosArticulos]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEstadosArticulos]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT IdEstadosArticulos, Nombre FROM EstadosArticulos ORDER BY IdEstadosArticulos
END
GO
/****** Object:  StoredProcedure [dbo].[GetEstadosIntercambios]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEstadosIntercambios]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT IdEstadosIntercambios, Nombre FROM EstadosIntercambios ORDER BY IdEstadosIntercambios
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiltroCategorias]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiltroCategorias]
	@busqueda varchar(150) = NULL,
	@excluirUsuario int = NULL,
	@comprometidos varchar(200) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CAST(c.IdCategorias AS varchar(10)) AS Valor, c.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
	FROM Categorias c
	LEFT JOIN Articulos a ON a.IdCategorias = c.IdCategorias
		AND (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
		AND (@excluirUsuario IS NULL OR a.IdUsuarios <> @excluirUsuario)
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ai
			INNER JOIN Intercambios ic ON ic.IdIntercambios = ai.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN (SELECT value FROM STRING_SPLIT(@comprometidos, ','))
				AND ai.IdArticulo = a.IdArticulos)
	GROUP BY c.IdCategorias, c.Nombre
	ORDER BY c.Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetFiltroEstados]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFiltroEstados]
	@busqueda varchar(150) = NULL,
	@excluirUsuario int = NULL,
	@comprometidos varchar(200) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT CAST(e.IdEstadosArticulos AS varchar(10)) AS Valor, e.Nombre AS Texto, COUNT(a.IdArticulos) AS Cantidad
	FROM EstadosArticulos e
	LEFT JOIN Articulos a ON a.IdEstado = e.IdEstadosArticulos
		AND (@busqueda IS NULL OR a.Nombre LIKE '%' + @busqueda + '%')
		AND (@excluirUsuario IS NULL OR a.IdUsuarios <> @excluirUsuario)
		AND NOT EXISTS (SELECT 1 FROM ArticulosIntercambios ai
			INNER JOIN Intercambios ic ON ic.IdIntercambios = ai.IdIntercambio
			INNER JOIN EstadosIntercambios eic ON eic.IdEstadosIntercambios = ic.IdEstado
			WHERE eic.Nombre IN (SELECT value FROM STRING_SPLIT(@comprometidos, ','))
				AND ai.IdArticulo = a.IdArticulos)
	GROUP BY e.IdEstadosArticulos, e.Nombre
	ORDER BY e.IdEstadosArticulos
END
GO
/****** Object:  StoredProcedure [dbo].[GetFotoUsuario]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFotoUsuario]
	@idUsuario int
	AS
BEGIN
	SELECT TOP 1 Ruta FROM Imagenes WHERE IdUsuarios = @idUsuario AND IdArticulos IS NULL ORDER BY IdImagenes DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetImagenesArticulo]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetImagenesArticulo]
	@idArticulo int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Ruta FROM Imagenes WHERE IdArticulos = @idArticulo ORDER BY IdImagenes
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvinciaById]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProvinciaById]
	@id int
AS
BEGIN
	SELECT IdProvincia, Nombre 
	FROM Provincias 
	WHERE IdProvincia = @id
END
GO
/****** Object:  StoredProcedure [dbo].[GetProvincias]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProvincias] 

AS
BEGIN
	SELECT IdProvincia, Nombre FROM Provincias ORDER BY Nombre
END
GO
/****** Object:  StoredProcedure [dbo].[GetUsuarioById]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[GetUsuarioByMail]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[GuardarFotoUsuario]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[MarcarNotificacionesLeidas]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcarNotificacionesLeidas]
	@idUsuario int
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE Notificaciones SET Leida = 1 WHERE IdUsuario = @idUsuario AND Leida = 0
END
GO
/****** Object:  StoredProcedure [dbo].[PublicarArticulo]    Script Date: 29/10/2026 13:39:32 ******/
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
	@idCategoriaACambio int = NULL,
	@rutasFotos varchar(max) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	DECLARE @idArticulo int, @ruta varchar(max), @pos int

	BEGIN TRANSACTION
	INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, Ubicacion, FechaPublicacion, IdCategoriaACambio)
	VALUES (@nombre, @descripcion, @idEstado, @idUsuario, @idCategoria, @ubicacion, CAST(GETDATE() AS date), @idCategoriaACambio)
	SET @idArticulo = SCOPE_IDENTITY()

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
/****** Object:  StoredProcedure [dbo].[RegistrarArticulo]    Script Date: 29/10/2026 13:39:32 ******/
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
                INSERT INTO Articulos (Nombre, Descripcion, IdEstado, IdUsuarios, IdCategorias, FechaPublicacion)
                VALUES(@nombre, @descripcion, (SELECT IdEstadosArticulos FROM EstadosArticulos WHERE Nombre = @estado), (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @usuario), (SELECT IdCategorias
                FROM Categorias WHERE Nombre = @categoria), CAST(GETDATE() AS date))
            END
        END
END

GO
/****** Object:  StoredProcedure [dbo].[RegistrarIntercambio]    Script Date: 29/10/2026 13:39:32 ******/
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
                        SET XACT_ABORT ON
                        BEGIN TRANSACTION
                        INSERT INTO Intercambios (Fecha, IdEstado, IdUsuarios1, IdUsuarios2)
                        VALUES
                            (@fecha, (SELECT IdEstadosIntercambios FROM EstadosIntercambios WHERE Nombre = @estado),
                             (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario1),
                             (SELECT IdUsuarios FROM Usuarios WHERE Usuario = @Usuario2))
                        DECLARE @idIntercambio int = SCOPE_IDENTITY()
                        INSERT INTO ArticulosIntercambios (IdArticulo, IdIntercambio)
                        VALUES
                            ((SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo1), @idIntercambio),
                            ((SELECT IdArticulos FROM Articulos WHERE Nombre = @Articulo2), @idIntercambio)
                        COMMIT TRANSACTION
                    END
                END
            END
        END
    END
END

GO
/****** Object:  StoredProcedure [dbo].[RegistrarMensaje]    Script Date: 29/10/2026 13:39:32 ******/
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
/****** Object:  StoredProcedure [dbo].[RegistrarUsuario]    Script Date: 29/10/2026 13:39:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegistrarUsuario]
	@nombre varchar(50),
	@apellido varchar(50),
	@usuario varchar(50),
	@mail varchar(50),
	@telefono varchar(20),
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
/****** Object:  StoredProcedure [dbo].[UpdateUsuario]    Script Date: 29/10/2026 13:39:32 ******/
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
	@telefono varchar(20),
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
/****** Object:  StoredProcedure [dbo].[UsuarioExiste]    Script Date: 29/10/2026 13:39:32 ******/
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
SET NOEXEC OFF
GO
