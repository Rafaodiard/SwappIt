---
tipo: metodo
estado: eliminado
tags:
  - tipo/metodo
  - estado/eliminado
---
# HomeController.PorResponder()

**Ya no existe** (17/11, todo el acceso a datos pasó a stored procedures y se sacó LINQ). El orden del inicio (primero los intercambios que hay que responder) y los contadores ahora salen de [[SP GetIntercambios]] (`@enCurso`) y [[SP ContarIntercambiosPorEstado]].
