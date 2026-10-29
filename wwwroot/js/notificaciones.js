// =========================================================
// SWAPPIT - Pop up de notificaciones del header (se carga en todas las páginas desde _Layout)
// - La campana (_Layout.cshtml) lo abre y lo cierra, y muestra cuántas hay sin leer (/Notificaciones/NoLeidas).
// - Al abrirlo se pide la lista a /Notificaciones/Lista (Views/Notificaciones/_Lista.cshtml).
// - "Marcar todas como leídas" va por fetch a /Notificaciones/MarcarTodasLeidas y vuelve a cargar todo.
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

    function abrir(abierto) {
        popup.classList.toggle('abierto', abierto);
        boton.setAttribute('aria-expanded', String(abierto));
        if (abierto) cargarLista();
    }

    // Contador de la campana. El número también va en el aria-label para los lectores de pantalla.
    function mostrarCantidad(cantidad) {
        contador.hidden = cantidad === 0;
        contador.textContent = cantidad > 9 ? '9+' : String(cantidad);
        boton.setAttribute('aria-label', cantidad === 0 ? 'Notificaciones' : `Notificaciones, ${cantidad} sin leer`);
        marcarTodas.hidden = cantidad === 0;
    }

    async function cargarCantidad() {
        try {
            const respuesta = await fetch('/Notificaciones/NoLeidas', { cache: 'no-store' });
            if (!respuesta.ok) return;
            const datos = await respuesta.json();
            mostrarCantidad(datos.cantidad);
        } catch {
            // Sin conexión: la campana queda sin contador.
        }
    }

    async function cargarLista() {
        contenido.setAttribute('aria-busy', 'true');
        try {
            const respuesta = await fetch('/Notificaciones/Lista', { cache: 'no-store' });
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
