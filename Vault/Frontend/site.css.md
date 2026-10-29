---
tipo: css
tags:
  - tipo/css
---
# site.css

`wwwroot/css/site.css` (~1.100 líneas) · Estilos de todo el sitio, basados en el UI Kit de Figma. No es un nodo del grafo de graphify (no analiza CSS), pero lo cargan todas las páginas desde [[Vista _Layout]].

## Tokens (`:root`)
- Colores: `--sw-primario #0d596a` (azul petróleo), `--sw-secundario #6e2c3a` (bordó), `--sw-gris #a5babe`, `--sw-crema #ece6d8`, `--sw-fondo #f6f7f7`, `--sw-texto #1f2a2c`, `--sw-texto-suave #55666a` (contraste AA), hovers, bordes, sombras, anillo de foco, transición.
- Fuentes: `--sw-font-texto` (Century Gothic → Questrial → system-ui) y `--sw-font-titulo` (Forum).
- Sobrescribe variables de Bootstrap (`--bs-primary`, fuente, links).
- Segundo bloque `--sw-ui-*` para los formularios del UI Kit (mismos colores + grises y rojo de error `#ba0000`).

## Secciones
Foco y "saltar al contenido" · botones (`.btn-sw-primario` bordó, `.btn-sw-secundario`, `.btn-sw-outline`) · header y buscador (también mobile) · pop up de notificaciones · footer · tarjetas (`.sw-card`) y contenedor de imagen `.sw-img` · card de objeto (`.card-objeto`, título a 2 líneas, vista lista) · landing (hero, banda, secciones, pasos, CTA) · filtros del buscador (chips, rango) · perfil y avatares · chat · **UI Kit de formularios** (`.sw-campo`, `.sw-input`, `.sw-error`, `.sw-btn-solido`/`.sw-btn-contorno`, chips de estado) · auth (login/registro) · publicar (zona de carga, miniaturas) · responsive · detalle de artículo · página de error.

`Views/Shared/_Layout.cshtml.css` es el CSS de la plantilla original de Visual Studio y no se usa.
