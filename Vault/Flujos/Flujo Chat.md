---
tipo: flujo
tags:
  - tipo/flujo
---
# Flujo: Chat

**URL:** `/Chat` · **Estado:** solo visual.

- Ícono de mensajes del header → [[ChatController]].Index() → [[Vista Chat-Index]].
- La vista tiene una conversación de ejemplo escrita en el HTML (contacto "Juan Pérez", intercambio "Silla ⇄ Lámpara"). Los elementos tienen `data-template` / `data-campo` para que [[plantillas.js]] los pueda llenar cuando haya datos.
- Diseño pensado: una conversación por intercambio ([[Tabla Mensajes]].IdIntercambio → [[Tabla Intercambios]]). [[SP RegistrarMensaje]] existe pero no se usa.
- El form de enviar mensaje no hace nada todavía.
