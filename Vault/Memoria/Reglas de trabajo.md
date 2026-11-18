---
tipo: general
tags:
  - tipo/general
---
# Reglas de trabajo

Reglas que pidió Rafael (con la fecha en que las pidió):

- **Código solo en la compu de Rafael** (25/10), para que él lo vea, lo toque y lo pruebe. El repo de GitHub es solo de consulta: Claude no hace commits, push ni PRs; Rafael commitea. Si hay varias compus, preguntar en cuál.
- **Base de datos** (28/10): nunca ejecutar cambios en su base. Solo editar los scripts SQL; Rafael los corre en SSMS.
- **Sin scripts chicos** (14/11): en `BaseDatos/` solo van `Estructura.sql`, `Datos.sql` y `StoredProcedures.sql`. Cuando cambia la base se actualizan los dos scripts principales ([[Script SQLSwappit.sql]] y [[Script SQLSwappit_CualquierCompu.sql]]) y esos tres con lo mismo. No se arman scripts de migración ni se le pasan scripts sueltos para su base: Rafael actualiza su base por su cuenta.
- **Sin LINQ** (17/11): nada de `Where`, `Any`, `Select`, `OrderBy`, `Count()`... ni en C# ni en las vistas. Filtrar en el SP o usar `foreach` ("no tenés que usar linq, hacelo normal").
- **Todo por stored procedures** (17/11, devolución docente): ninguna consulta escrita en C#, ningún SQL armado con texto y ningún cambio de estructura desde la app.
- **"Para copiar y pegar"** (25/10): si pide un script o código para copiar y pegar, va solo en el chat, sin tocar archivos.
- **ViewBag** (25/10): controller → vista siempre con `ViewBag`, sin `@model` ni `asp-for` (ver [[Convenciones y decisiones]]).
- **Controllers y vistas limpios** (17/11, entrega de INFO 360): nada de lógica de negocio en los controllers, va en `Models/Logica/`. En las vistas solo C# para leer `ViewBag`; se permiten `@foreach` e `@if` sobre esos valores ("práctica"). Todo el JS en `wwwroot/js`.
- **Models separados** (17/11): tablas en `Models/Tablas/`, lógica en `Models/Logica/`, acceso a datos en `Models/BD/`.
- **Scripts SQL completos** (27/10): todos los scripts de creación tienen que tener lo mismo (tablas, datos, SP).
- **Vault y grafo** (29/10): cada vez que Claude trabaje en `C:\Users\rafae\Proyectos\swappit` y Rafael le escriba, revisa todo el proyecto y actualiza el grafo de graphify y esta vault. Usa el grafo cuando le sirva.
- **Memoria secundaria** (29/10): esta vault es la memoria secundaria de Claude ([[Memoria del proyecto]]).
- Del proyecto: no inventar tablas, campos ni funcionalidades; no usar datos falsos como reales; señalar problemas de diseño o lógica; preguntar si falta información; explicar los cambios importantes.
