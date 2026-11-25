(() => {
    const contenedor = document.querySelector('[data-notif]');
    if (!contenedor) return;
    const boton = contenedor.querySelector('[data-notif-boton]');
    const popup = contenedor.querySelector('.desplegable');
    const contenido = popup.querySelector('[data-notif-contenido]');
    const contador = boton.querySelector('[data-notif-contador]');
    const marcarTodas = popup.querySelector('[data-notif-marcar-todas]');
    const urlNoLeidas = contenedor.dataset.urlNoLeidas;
    const urlLista = contenedor.dataset.urlLista;

    function abrir(abierto) {
        popup.classList.toggle('abierto', abierto);
        boton.setAttribute('aria-expanded', String(abierto));
        if (abierto) cargarLista();
    }

    function mostrarCantidad(cantidad) {
        contador.hidden = cantidad === 0;
        contador.textContent = cantidad > 9 ? '9+' : String(cantidad);
        boton.setAttribute('aria-label', cantidad === 0 ? 'Notificaciones' : `Notificaciones, ${cantidad} sin leer`);
        marcarTodas.hidden = cantidad === 0;
    }

    async function cargarCantidad() {
        try {
            const respuesta = await fetch(urlNoLeidas, { cache: 'no-store' });
            if (!respuesta.ok) return;
            const datos = await respuesta.json();
            mostrarCantidad(datos.cantidad);
        } catch {
        }
    }

    async function cargarLista() {
        contenido.setAttribute('aria-busy', 'true');
        try {
            const respuesta = await fetch(urlLista, { cache: 'no-store' });
            if (!respuesta.ok) throw new Error(respuesta.status);
            contenido.innerHTML = await respuesta.text();
        } catch {
            contenido.innerHTML = '<p class="desplegable-aviso">No pudimos cargar tus notificaciones. Probá de nuevo en un rato.</p>';
        }
        contenido.setAttribute('aria-busy', 'false');
        cargarCantidad();
    }

    marcarTodas.addEventListener('submit', async (e) => {
        e.preventDefault();
        try {
            const respuesta = await fetch(marcarTodas.action, { method: 'POST', body: new FormData(marcarTodas) });
            if (respuesta.ok) mostrarCantidad(0);
        } catch {
        }
        cargarLista();
        boton.focus();
    });

    boton.addEventListener('click', () => abrir(boton.getAttribute('aria-expanded') !== 'true'));

    contenedor.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && popup.classList.contains('abierto')) {
            abrir(false);
            boton.focus();
        }
    });

    document.addEventListener('click', (e) => {
        if (!contenedor.contains(e.target)) abrir(false);
    });

    contenedor.addEventListener('focusout', (e) => {
        if (e.relatedTarget && !contenedor.contains(e.relatedTarget)) abrir(false);
    });

    cargarCantidad();
})();
