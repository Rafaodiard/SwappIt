// =========================================================
// SWAPPIT - Algoritmo de recomendaciones: la parte del navegador
// Junta lo que hace el usuario y se lo manda a RecomendacionesController, que lo guarda en la tabla Interacciones.
// Las recomendaciones las calcula el servidor (RecomendacionesController, Pasos 1 a 3).
//
// Solo hace algo con sesión iniciada: los forms ocultos que usa solo se dibujan en ese caso,
// y traen la URL (con @Url.Action) y el token antiforgery para los POST.
//
// 1. Detalle de un artículo (form [data-reco-vista] en Views/Articulos/Detalle.cshtml):
//    - al abrirlo manda la vista (= el clic) a Recomendaciones/Vista y recibe el id de esa vista;
//    - cuenta los segundos que la página está a la vista (si cambiás de pestaña o minimizás, el reloj se pausa)
//      y los manda a Recomendaciones/Tiempo cada vez que la página se esconde (cambiar de pestaña, irse, cerrar).
// 2. Explorar (form [data-reco-busqueda] en Views/Articulos/Buscar.cshtml):
//    - manda el texto buscado y las categorías marcadas a Recomendaciones/Busqueda.
// Si algo falla no se le muestra nada al usuario: solo se pierde ese dato.
// =========================================================

(() => {
    // ---------- 1. Clic y tiempo en el detalle ----------
    const formVista = document.querySelector('form[data-reco-vista]');
    if (formVista) {
        let idInteraccion = null;
        let segundosAntes = 0;    // tiempo de los tramos en que la página ya estuvo a la vista
        let visibleDesde = document.visibilityState === 'visible' ? Date.now() : null;

        const segundosTotales = () =>
            Math.round(segundosAntes + (visibleDesde ? (Date.now() - visibleDesde) / 1000 : 0));

        function mandarTiempo() {
            if (idInteraccion === null) return;
            const datos = new FormData(formVista); // token antiforgery
            datos.append('idInteraccion', idInteraccion);
            datos.append('segundos', segundosTotales());
            // sendBeacon: el navegador lo manda aunque la página se esté cerrando
            navigator.sendBeacon(formVista.dataset.urlTiempo, datos);
        }

        document.addEventListener('visibilitychange', () => {
            if (document.visibilityState === 'hidden') {
                segundosAntes = segundosTotales();
                visibleDesde = null;
                mandarTiempo();
            } else {
                visibleDesde = Date.now();
            }
        });

        // El servidor responde { idInteraccion } (o nada si el artículo es tuyo)
        fetch(formVista.action, { method: 'POST', body: new FormData(formVista) })
            .then(respuesta => (respuesta.ok && respuesta.status !== 204 ? respuesta.json() : null))
            .then(datos => { if (datos) idInteraccion = datos.idInteraccion; })
            .catch(() => { });
    }

    // ---------- 2. Búsquedas y filtros en Explorar ----------
    const formBusqueda = document.querySelector('form[data-reco-busqueda]');
    if (formBusqueda) {
        fetch(formBusqueda.action, { method: 'POST', body: new FormData(formBusqueda) }).catch(() => { });
    }
})();
