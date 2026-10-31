---
tipo: general
tags:
  - tipo/general
---
# Entorno y herramientas

- **Compu principal:** `C:\Users\rafae\Proyectos\swappit` (clon de `github.com/rafaodiard/swappit`, rama `main`). Hubo trabajo también en otras compus del colegio (`C:\Users\49758734\Desktop\SwappIt`, `C:\Users\50416809\Downloads\SwappIt`).
- **Base:** SQL Server local, `Base_De_Datos_Swappit`, autenticación de Windows. La connection string está fija en [[BD]] (`localhost`; alternativa `.\SQLEXPRESS`). Rafael crea la base con [[Script SQLSwappit.sql]] o [[Script SQLSwappit_CualquierCompu.sql]] y a veces regenera el script con "Generate Scripts" de SSMS (revisar que no se pierdan columnas).
- **graphify** 0.9.95 está instalado en la compu de Rafael (con `uv`, desde el 30/10 con el complemento de SQL: `uv tool install --force "graphifyy[sql]==0.9.95"`; sin él, los .sql no aportan nodos). Claude lo corre sobre una copia del código (sin `bin/`, `obj/`, `wwwroot/lib`, imágenes ni la vault), le suma las conexiones de vistas, acciones y SQL que graphify no ve y trae el resultado a esta vault.
- **Claude en la nube:** puede compilar .NET 9 (instalando el SDK a mano) pero no tiene SQL Server; para capturas usa una copia con datos de prueba que nunca se copia a la compu de Rafael.
- **Archivos compartidos del proyecto** (en la nube): guía del código `guia-codigo/swappit-por-dentro.html`, copias de cambios anteriores y las fuentes de esta vault (`vault-obsidian/fuente`).
