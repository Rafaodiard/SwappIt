---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Proponer intercambio

**Estado:** solo visual. **No se guarda nada.**

- En [[Vista Articulos-Detalle]], un usuario logueado que no es el dueño abre el pop up "Proponer intercambio" y elige uno de sus artículos (radio `IdArticuloOfrecido`, cargados con [[BD]].GetArticulosCatalogo(idUsuario)).
- Si no tiene artículos, se le ofrece publicar uno ([[Flujo Publicar artículo]]).
- El botón "Enviar propuesta" está deshabilitado y el form tiene `onsubmit="return false"`. La vista avisa: "El envío de propuestas todavía no está conectado".

**Lo que haría falta** (no está hecho): una acción POST que inserte en [[Tabla Intercambios]] con estado *Pendiente* ([[Tabla EstadosIntercambios]]), y pantallas para aceptar, rechazar y marcar como realizado. Existe [[SP RegistrarIntercambio]], pero tiene problemas (busca por nombre y exige fecha pasada, ver [[Pendientes y problemas]]).
