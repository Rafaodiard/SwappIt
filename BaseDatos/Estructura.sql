USE [master]
GO
/****** Object:  Database [Base_De_Datos_Swappit]    Script Date: 23/10/2026 09:04:02 ******/
/****** 1 de 3: Estructura (base, usuario, tablas y claves foráneas). Ejecutar primero. ******/
CREATE DATABASE [Base_De_Datos_Swappit]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Base_De_Datos_Swappit', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Base_De_Datos_Swappit.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Base_De_Datos_Swappit_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Base_De_Datos_Swappit_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
/****** Object:  User [alumno]    Script Date: 23/10/2026 09:04:02 ******/
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
USE [master]
GO
ALTER DATABASE [Base_De_Datos_Swappit] SET  READ_WRITE 
GO
