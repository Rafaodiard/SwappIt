(() => {
    const SEGUNDOS_ENTRE_PEDIDOS = 4;

    // ---------- Mensajes ----------
    const mensajes = document.getElementById('mensajes');
    if (mensajes) {
        const url = mensajes.dataset.urlMensajes;
        let ultimoHtml = null;

        const bajarAlFinal = () => { mensajes.scrollTop = mensajes.scrollHeight; };
        bajarAlFinal();

        const texto = document.querySelector('[data-chat-texto]');
        if (texto && window.matchMedia('(min-width: 768px)').matches) texto.focus();

        async function actualizar() {
            if (document.hidden) return;
            try {
                const respuesta = await fetch(url, { cache: 'no-store' });
                if (!respuesta.ok) return;
                const html = await respuesta.text();
                if (ultimoHtml === null) { ultimoHtml = html; return; }
                if (html === ultimoHtml) return;
                ultimoHtml = html;
                const estabaAbajo = mensajes.scrollHeight - mensajes.scrollTop - mensajes.clientHeight < 80;
                mensajes.innerHTML = html;
                if (estabaAbajo) bajarAlFinal();
            } catch {
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
