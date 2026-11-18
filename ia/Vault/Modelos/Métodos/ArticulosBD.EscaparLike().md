---
tipo: metodo
estado: eliminado
tags:
  - tipo/metodo
  - estado/eliminado
---
# ArticulosBD.EscaparLike()

**Ya no existe** (17/11, todo el acceso a datos pasó a stored procedures y se sacó LINQ). El escape de `[`, `%` y `_` del texto buscado ahora lo hacen [[SP GetArticulosCatalogo]], [[SP GetFiltroCategorias]] y [[SP GetFiltroEstados]]. En C# solo queda [[ArticulosBD.TextoBusqueda()]], que saca los espacios.
