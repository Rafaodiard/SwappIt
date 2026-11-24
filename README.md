# Swappit

> **Intercambiá. Conectá. Reutilizá.**

Swappit es una plataforma para intercambiar objetos sin usar dinero. Está pensada para jóvenes de 20 a 30 años que se están independizando: publicás lo que ya no usás y lo cambiás por algo que te sirva. La idea es darle una segunda vida a cada objeto, fomentar la reutilización y armar una comunidad basada en la confianza.

## Cómo levantarlo

### Requisitos

- [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- SQL Server y SQL Server Management Studio (SSMS)

### Pasos

1. **Clonar el repositorio**

   ```bash
   git clone https://github.com/Rafaodiard/SwappIt.git
   cd SwappIt
   ```

2. **Crear la base de datos.** Abrí `SQLSwappit.sql` (en la raíz del proyecto) en SSMS y ejecutalo. Crea la base `Base_De_Datos_Swappit` con sus tablas, datos y stored procedures.

   > El script guarda la base en la carpeta de la instancia predeterminada (`MSSQL14.MSSQLSERVER`). Si usás otra, por ejemplo SQL Express, cambiá las rutas `FILENAME` del `CREATE DATABASE` al principio del script.

3. **Configurar la conexión.** La cadena de conexión está en `Models/BD/ConexionBD.cs` y por defecto apunta a la instancia local predeterminada:

   ```csharp
   @"Server=localhost;Database=Base_De_Datos_Swappit;Integrated Security=True;TrustServerCertificate=True;"
   ```

   Si usás SQL Express, cambiá `Server=localhost` por `Server=.\SQLEXPRESS`.

4. **Ejecutar**

   ```bash
   dotnet run
   ```

   Abrí http://localhost:5015.

Para probar podés entrar con `prueba.uno@example.com` / `SwappitPrueba1!` o `prueba.dos@example.com` / `SwappitPrueba2!`.

## Funcionalidades

- Registro e inicio de sesión de usuarios.
- Publicación, edición y eliminación de artículos.
- Carga de fotos, categorías, estados y preferencias de intercambio.
- Búsqueda y filtrado de artículos por texto, categoría, estado y orden.
- Recomendaciones personalizadas según favoritos, búsquedas, vistas y intereses de los usuarios.
- Perfil público y privado con datos personales, artículos publicados e intercambios.
- Gestión de favoritos para marcar y consultar artículos de interés.
- Creación y seguimiento de propuestas e intercambios.
- Chat asociado a cada intercambio.
- Notificaciones sobre propuestas, cambios de estado y mensajes.
- Gestión de planes y suscripciones.
- Interfaz adaptable para dispositivos móviles y escritorio.

## Equipo

- Rafael Odiard Wesler
- Martina Drucaroff
- Sol Fuks
- Juan Manuel Malagrino
