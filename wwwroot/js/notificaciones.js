// =========================================================
// SWAPPIT - Pop up de notificaciones del header (se carga en todas las páginas desde _Layout)
// - La campana (_Layout.cshtml) lo abre y lo cierra.
// - Se cierra con Esc (el foco vuelve a la campana), con clic afuera o al salir con Tab.
// El contenido está en Views/Shared/_PopupNotificaciones.cshtml (por ahora, estado vacío).
// =========================================================

(() => {
    const contenedor = document.querySelector('[data-notif]');
    if (!contenedor) return; // visitante: no hay campana
    const boton = contenedor.querySelector('[data-notif-boton]');
    const popup = contenedor.querySelector('.sw-notif-popup');

    function abrir(abierto) {
        popup.classList.toggle('abierto', abierto);
        boton.setAttribute('aria-expanded', String(abierto));
    }

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
})();
