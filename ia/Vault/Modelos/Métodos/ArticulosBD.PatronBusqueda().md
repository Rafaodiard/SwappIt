---
tipo: metodo
estado: eliminado
tags:
  - tipo/metodo
  - estado/eliminado
---
# ArticulosBD.PatronBusqueda()

**Ya no existe** (17/11, todo el acceso a datos pasó a stored procedures y se sacó LINQ). El patrón de búsqueda (`%texto%` escapado) ahora lo arman [[SP GetArticulosCatalogo]], [[SP GetFiltroCategorias]] y [[SP GetFiltroEstados]]. En C# solo queda [[ArticulosBD.TextoBusqueda()]].
