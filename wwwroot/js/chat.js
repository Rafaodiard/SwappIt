// =========================================================
// SWAPPIT - Chat (Views/Chat/Index.cshtml)
// - Baja hasta el último mensaje al abrir la conversación y, en compu, pone el cursor en el campo de texto.
// - Cada 4 segundos pide los mensajes a ChatController.Mensajes (partial _Mensajes) y, si cambiaron,
//   los reemplaza: así aparecen los mensajes nuevos de la otra persona y los "visto" sin recargar.
//   Mandar un mensaje es un form normal (recarga la página). La URL la genera la vista con @Url.Action
//   y la pasa en data-url-mensajes (un .js no puede usar Razor).
// - El buscador de la lista filtra las conversaciones por nombre, usuario o artículo.
// =========================================================

(() => {
    const SEGUNDOS_ENTRE_PEDIDOS = 4;

    // ---------- Mensajes ----------
    const mensajes = document.getElementById('mensajes');
    if (mensajes) {
        const url = mensajes.dataset.urlMensajes;
        let ultimoHtml = null;

        const bajarAlFinal = () => { mensajes.scrollTop = mensajes.scrollHeight; };
        bajarAlFinal();

        // En compu deja el cursor listo para escribir (también después de mandar, que recarga la página).
        // En celular no, para que no se abra el teclado apenas entra.
        const texto = document.querySelector('[data-chat-texto]');
        if (texto && window.matchMedia('(min-width: 768px)').matches) texto.focus();

        async function actualizar() {
            if (document.hidden) return; // pestaña en segundo plano: no pide nada
            try {
                const respuesta = await fetch(url, { cache: 'no-store' });
                if (!respuesta.ok) return;
                const html = await respuesta.text();
                if (ultimoHtml === null) { ultimoHtml = html; return; } // el primero es lo que ya se ve
                if (html === ultimoHtml) return;
                ultimoHtml = html;
                // Si estaba leyendo mensajes viejos, no lo mueve; si estaba abajo, sigue abajo.
                const estabaAbajo = mensajes.scrollHeight - mensajes.scrollTop - mensajes.clientHeight < 80;
                mensajes.innerHTML = html;
                if (estabaAbajo) bajarAlFinal();
            } catch {
                // Sin conexión: se vuelve a intentar en el próximo pedido.
            }
        }

        setInterval(actualizar, SEGUNDOS_ENTRE_PEDIDOS * 1000);
        actualizar();
    }

    // ---------- Buscador de conversaciones ----------
    const buscar = document.querySelector('[data-chat-buscar]');
    if (buscar) {
        const contactos = document.querySelectorAll('[data-chat-contacto]');
        const sinResultados = document.querySelector('[data-chat-sin-resultados]');
        const normalizar = (texto) => texto.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();

        buscar.addEventListener('input', () => {
            const busqueda = normalizar(buscar.value.trim());
            let visibles = 0;
            contactos.forEach((c) => {
                const coincide = normalizar(c.dataset.chatContacto).includes(busqueda);
                c.classList.toggle('d-none', !coincide);
                if (coincide) visibles++;
            });
            sinResultados.hidden = visibles > 0;
        });
    }
})();
