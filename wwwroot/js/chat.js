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

        async function actualizar(despuesDeEnviar = false) {
            if (document.hidden && !despuesDeEnviar) return;
            try {
                const respuesta = await fetch(url, { cache: 'no-store' });
                if (!respuesta.ok) return;
                const html = await respuesta.text();
                if (ultimoHtml === null && !despuesDeEnviar) { ultimoHtml = html; return; }
                if (html !== ultimoHtml) {
                    ultimoHtml = html;
                    const estabaAbajo = mensajes.scrollHeight - mensajes.scrollTop - mensajes.clientHeight < 80;
                    mensajes.innerHTML = html;
                    if (estabaAbajo) bajarAlFinal();
                }
                if (despuesDeEnviar) bajarAlFinal();
            } catch {
            }
        }

        setInterval(actualizar, SEGUNDOS_ENTRE_PEDIDOS * 1000);
        actualizar();

        // ---------- Enviar sin recargar ----------
        const form = document.querySelector('form[data-chat-enviar]');
        const error = document.querySelector('[data-chat-error]');
        const errorTexto = document.querySelector('[data-chat-error-texto]');

        function mostrarError(mensaje) {
            errorTexto.textContent = mensaje;
            error.hidden = false;
        }

        if (form) {
            const boton = form.querySelector('button[type="submit"]');
            form.addEventListener('submit', async (e) => {
                e.preventDefault();
                error.hidden = true;
                boton.disabled = true;
                try {
                    const respuesta = await fetch(form.action, { method: 'POST', body: new FormData(form) });
                    if (respuesta.status === 401) {
                        location.href = document.body.dataset.urlLogin;
                        return;
                    }
                    if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`);
                    const resultado = await respuesta.json();
                    if (resultado.error) {
                        mostrarError(resultado.error);
                    } else {
                        texto.value = '';
                        await actualizar(true);
                    }
                } catch {
                    mostrarError('No pudimos mandar el mensaje. Probá de nuevo en un rato.');
                } finally {
                    boton.disabled = false;
                    texto.focus();
                }
            });
        }
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
