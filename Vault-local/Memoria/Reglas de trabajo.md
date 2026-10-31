---
tipo: general
tags:
  - tipo/general
---
# Reglas de trabajo

Reglas que pidió Rafael (con la fecha en que las pidió):

- **Código solo en la compu de Rafael** (25/10), para que él lo vea, lo toque y lo pruebe. El repo de GitHub es solo de consulta: Claude no hace commits, push ni PRs; Rafael commitea. Si hay varias compus, preguntar en cuál.
- **Base de datos** (28/10): nunca ejecutar cambios en su base. Solo editar los scripts SQL; Rafael los corre en SSMS.
- **"Para copiar y pegar"** (25/10): si pide un script o código para copiar y pegar, va solo en el chat, sin tocar archivos.
- **ViewBag** (25/10): controller → vista siempre con `ViewBag`, sin `@model` ni `asp-for` (ver [[Convenciones y decisiones]]).
- **Scripts SQL completos** (27/10): todos los scripts de creación tienen que tener lo mismo (tablas, datos, SP).
- **Vault y grafo** (29/10): cada vez que Claude trabaje en `C:\Users\rafae\Proyectos\swappit` y Rafael le escriba, revisa todo el proyecto y actualiza el grafo de graphify y esta vault. Usa el grafo cuando le sirva.
- **Memoria secundaria** (29/10): esta vault es la memoria secundaria de Claude ([[Memoria del proyecto]]).
- Del proyecto: no inventar tablas, campos ni funcionalidades; no usar datos falsos como reales; señalar problemas de diseño o lógica; preguntar si falta información; explicar los cambios importantes.
