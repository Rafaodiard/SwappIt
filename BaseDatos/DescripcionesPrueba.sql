/****** Descripciones de los usuarios de prueba (IdUsuarios 3 a 12), para bases ya creadas.
   Correr después de DescripcionPerfil.sql (la columna Usuarios.Descripcion tiene que existir).
   Los usuarios 2 y 13 quedan sin descripción a propósito, para probar "Agregá una descripción".
   Se puede volver a ejecutar sin problema. ******/
USE [Base_De_Datos_Swappit]
GO
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Me mudé hace poco a Almagro y estoy armando la cocina. Busco cosas para el depto; coordinamos por el chat de Swappit.' WHERE [IdUsuarios] = 3
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Armando mi primer monoambiente en Villa Crespo. Me interesan muebles chicos y cosas de cocina. Puedo encontrarme cerca del subte B.' WHERE [IdUsuarios] = 4
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Me sobran cosas de la casa de mis viejos y prefiero cambiarlas antes que tirarlas. Busco plantas, libros o cosas para el balcón.' WHERE [IdUsuarios] = 5
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Trabajo desde casa, así que me interesa todo lo que sirva para armar un buen escritorio. Respondo rápido por el chat.' WHERE [IdUsuarios] = 6
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Me encanta cocinar y estoy aprendiendo. Cambio cosas de cocina y libros; si querés, coordinamos un fin de semana por Belgrano.' WHERE [IdUsuarios] = 7
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Estoy ordenando el depto y quiero darles otra vida a las cosas que no uso. Busco algo para el living. Coordinamos por el chat.' WHERE [IdUsuarios] = 8
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Estudio en Córdoba y me muevo en bici. Me interesan cosas útiles para un depto de estudiante. Coordinamos por Nueva Córdoba.' WHERE [IdUsuarios] = 9
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Me estoy independizando y necesito de todo un poco. Prefiero cambiar antes que comprar nuevo. Escribime y lo vemos.' WHERE [IdUsuarios] = 10
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Me mudo seguido y viajo liviana. Cambio cosas para la casa por algo que entre en una mochila o sirva para cocinar.' WHERE [IdUsuarios] = 11
UPDATE [dbo].[Usuarios] SET [Descripcion] = N'Recién llegada a Rosario Centro, armando el depto de a poco. Busco lámparas, plantas o cosas de deco. Respondo por el chat.' WHERE [IdUsuarios] = 12
GO
