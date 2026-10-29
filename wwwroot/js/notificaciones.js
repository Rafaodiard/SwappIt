// =========================================================
// SWAPPIT - Pop up de notificaciones del header (se carga en todas las páginas desde _Layout)
// - La campana (_Layout.cshtml) lo abre y lo cierra, y muestra cuántas hay sin leer (NotificacionesController.NoLeidas).
// - Al abrirlo se pide la lista a NotificacionesController.Lista (Views/Notificaciones/_Lista.cshtml).
// - "Marcar todas como leídas" va por fetch a NotificacionesController.MarcarTodasLeidas y vuelve a cargar todo.
// - Las URLs no se escriben acá: _Layout las genera con @Url.Action y las pasa en data-url-no-leidas / data-url-lista
//   (la de "Marcar todas" es el action del form). Un .js no puede usar Razor.
// - Se cierra con Esc (el foco vuelve a la campana), con clic afuera o al salir con Tab.
// =========================================================

(() => {
    const contenedor = document.querySelector('[data-notif]');
    if (!contenedor) return; // visitante: no hay campana
    const boton = contenedor.querySelector('[data-notif-boton]');
    const popup = contenedor.querySelector('.sw-notif-popup');
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
            contenido.innerHTML = '<p class="sw-notif-cargando">No pudimos cargar tus notificaciones. Probá de nuevo en un rato.</p>';
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
            // Si falla, la lista que se vuelve a cargar sigue mostrando las sin leer.
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
