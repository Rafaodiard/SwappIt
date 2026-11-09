(() => {
    // ---------- 1. Clic y tiempo en el detalle ----------
    const formVista = document.querySelector('form[data-reco-vista]');
    if (formVista) {
        let idInteraccion = null;
        let segundosAntes = 0;
        let visibleDesde = document.visibilityState === 'visible' ? Date.now() : null;

        const segundosTotales = () =>
            Math.round(segundosAntes + (visibleDesde ? (Date.now() - visibleDesde) / 1000 : 0));

        function mandarTiempo() {
            if (idInteraccion === null) return;
            const datos = new FormData(formVista);
            datos.append('idInteraccion', idInteraccion);
            datos.append('segundos', segundosTotales());
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
