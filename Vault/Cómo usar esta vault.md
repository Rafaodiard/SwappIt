---
tipo: general
tags:
  - tipo/general
---
# Cómo usar esta vault

1. En Obsidian: **Abrir carpeta como bóveda** → `C:\Users\rafae\Proyectos\swappit\Vault`.
2. Empezá por [[Inicio]].
3. **Vista de grafo** (Ctrl+G): cada nota de código es un nodo del grafo de graphify y cada `[[link]]` de la sección "Conexiones en el grafo" es una arista. Los colores ya vienen configurados:
   - azul petróleo: controllers y acciones
   - bordó: vistas
   - beige: modelos, ViewModels y métodos de [[BD]]
   - celeste grisáceo: base de datos (tablas, SP, scripts)
   - verde: JS y CSS
   - gris: flujos y notas generales
   Para ver solo el código, filtrá con `-path:Grafo -path:Flujos`.

## Carpetas
- `Memoria/`: la **memoria secundaria** de Claude: reglas, decisiones, equipo, entorno y bitácora ([[Memoria del proyecto]]). Podés escribir ahí; Claude lo lee antes de trabajar.
- `Flujos/`: cómo funciona cada cosa de punta a punta (escritas a mano).
- `Controllers/` (y `Controllers/Acciones/`), `Modelos/`, `Vistas/`, `Frontend/`, `Base de datos/`, `Proyecto/`: una nota por archivo, clase, método, tabla o SP.
- `Grafo/`: las **comunidades** que detectó graphify, los tipos externos (Controller, IFormFile, Dapper…), el [[Reporte del grafo]] y `graph.html` (el grafo interactivo de graphify; abrilo con el navegador).

## Qué es de graphify y qué está escrito a mano
- Las secciones **"Conexiones en el grafo"** y las notas de `Grafo/` salen del grafo (`Grafo/graph.json`). Cada conexión dice su tipo (`calls`, `renders`, `reads_from`…) y su confianza: `EXTRACTED` (está escrito en el código) o `INFERRED` (deducido, por ejemplo por convención MVC o por nombre igual).
- El resto del texto está escrito a mano leyendo el código.
- Para que el grafo una cada vista con su controller, además del análisis de graphify se leyeron los `.cshtml` (links `asp-controller`/`asp-action`, `<partial>`, `<script src>`), los `return View(...)` de cada acción y el SQL de cada método de [[BD]]. graphify solo no ve esas uniones.
- Las propiedades de las clases (ej. `Usuarios.Apellido`) no tienen nota propia: están listadas dentro de la nota de su clase para que el grafo no se llene de puntitos.

## Volver a generar el grafo
Si el código cambia mucho, pedile a Claude "actualizá la vault y el grafo de Swappit". El grafo se generó con graphify 0.9.95 (con el complemento de SQL, `graphifyy[sql]`) sobre el código de `main` (sin `bin/`, `obj/`, `wwwroot/lib` ni imágenes). Última actualización: 30/10, sobre `f639baa` más el rediseño del inicio sin commit (492 nodos, 1119 conexiones, 31 comunidades).
