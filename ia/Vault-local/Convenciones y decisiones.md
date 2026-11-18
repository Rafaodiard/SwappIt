---
tipo: general
tags:
  - tipo/general
---
# Convenciones y decisiones

Decisiones del equipo que no se ven a simple vista en el código:

- **Datos controller → vista con `ViewBag`**, en todo el proyecto (no se pasa un `@model` a las vistas). Los ViewModels se usan solo para *recibir* formularios. Por eso las vistas empiezan con `Tipo x = ViewBag.algo;`.
- **Controllers separados por tema** con URLs nuevas (commit `dd9cbd1`, Martina, 28/10): Articulos, Publicar, Chat, Account, Perfil, Home. Antes casi todo estaba en Home y Account.
- **Estados como tablas** (28/10): [[Tabla EstadosArticulos]] (Como nuevo, Muy buen estado, Buen estado, Usado) y [[Tabla EstadosIntercambios]] (Pendiente, Aceptado, Rechazado, Realizado). [[Tabla Articulos]] e [[Tabla Intercambios]] guardan `IdEstado` con clave foránea. En Figma el estado intermedio se llama "En curso"; se eligió **Aceptado**.
- **Contraseñas hasheadas** con `PasswordHasher` (sin paquetes extra). Las de los datos de prueba están en texto plano y se re-hashean en el primer login ([[Contrasenas]]).
- **Scripts SQL**: las tablas, datos y SP tienen que estar iguales en [[Script SQLSwappit.sql]], [[Script SQLSwappit_CualquierCompu.sql]] y los tres de `BaseDatos/` ([[Script Estructura.sql]], [[Script Datos.sql]], [[Script StoredProcedures.sql]]). Hoy no lo están (ver [[Pendientes y problemas]]). Rafael ejecuta los scripts él mismo en SSMS.
- **Paleta oficial** en `:root` de [[site.css]]: azul petróleo `#0d596a`, bordó `#6e2c3a`, celeste grisáceo `#a5babe`, beige `#ece6d8`.
- **Tipografías**: Century Gothic (texto) y Forum (títulos), aunque Figma use Jost en algunos lugares. Como Century Gothic no está en Google Fonts, [[Vista _Layout]] carga Questrial como reemplazo.
- **Botones**: `.btn-sw-primario` (bordó) es el CTA del catálogo/landing/detalle; `.sw-btn-solido` (azul) es el de formularios.
- **Accesibilidad**: link "Saltar al contenido", `aria-*` en pop ups, foco visible, textos alternativos, contraste AA del gris de texto (`--sw-texto-suave`).
- **Textos en español rioplatense** ("Publicá", "Elegí", "Probá de nuevo").
