---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Publicar un artículo

**URL:** `/Publicar` · **Estado:** funciona. Hay que estar logueado.

1. Botón "Publicar" del header ([[Vista _Layout]]) → `GET /Publicar` → [[PublicarController]].Index():
   - sin sesión → login;
   - arma un [[PublicarArticuloViewModel]] con `Ubicacion` = barrio del perfil;
   - si ya tiene 5 artículos (`MaxPublicados`) que no se intercambiaron ([[BD]].ContarArticulosActivos: cuentan también los de intercambios pendientes o aceptados), muestra el aviso y deshabilita "Publicar objeto";
   - opciones de categoría ([[BD]].GetCategorias) y estado ([[BD]].GetEstadosArticulos).
2. [[Vista Publicar-Index]]: zona para arrastrar fotos, miniaturas, título, categoría, ubicación, estado (chips), descripción con contador, "¿Qué te gustaría recibir a cambio?". [[publicar.js]] maneja las fotos en el navegador (máx. 6, JPG/PNG, 10 MB) y, al apretar Publicar, revisa los campos obligatorios: si falta alguno muestra el error y no manda el form, así no se recarga la página y no se pierden las fotos (un `<input type="file">` no se puede volver a llenar desde el servidor).
3. `POST /Publicar` ([[PublicarController]].Index(modelo), con antiforgery y límite de pedido de 61 MB):
   - valida que la categoría y el estado existan en la lista, y las fotos (`ValidarFotos`);
   - si hay errores vuelve al form y pide elegir las fotos de nuevo (`AvisarFotosDeNuevo`); con la revisión de [[publicar.js]] esto queda para casos raros;
   - vuelve a revisar el límite de 5;
   - guarda las fotos en `wwwroot/img/articulos/` (`GuardarFotosArticulo`);
   - [[ArticulosBD.PublicarArticulo()]] llama a [[SP PublicarArticulo]], que inserta en [[Tabla Articulos]] y una fila por foto en [[Tabla Imagenes]], **en una transacción** (desde el 17/11; antes la transacción estaba en C#);
   - si falla la base o el disco, borra las fotos ya guardadas (`BorrarFotosArticulo`) y muestra "No pudimos publicar tu artículo".
4. Éxito → redirige a `/Articulos/Detalle/{id}` con el mensaje "¡Listo! Tu artículo ya está publicado." ([[Flujo Ver detalle de artículo]]).

**Pendiente:** editar y borrar artículos.
