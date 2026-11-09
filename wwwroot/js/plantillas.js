const swappit = (() => {
    const moldes = {};

    function obtenerMolde(contenedor, nombre) {
        if (!moldes[nombre]) {
            const ejemplo = contenedor.querySelector(`[data-template="${nombre}"]`);
            if (!ejemplo) throw new Error(`No hay data-template="${nombre}" en el contenedor`);
            moldes[nombre] = ejemplo.cloneNode(true);
        }
        return moldes[nombre];
    }

    function rellenarCampos(nodo, item) {
        nodo.querySelectorAll('[data-campo]').forEach(el => {
            const valor = item[el.dataset.campo];
            if (valor === undefined || valor === null) return;
            if (el.tagName === 'IMG') el.src = valor;
            else el.textContent = valor;
        });
    }

    function renderLista(selector, items, nombre, extra) {
        const contenedor = document.querySelector(selector);
        const molde = obtenerMolde(contenedor, nombre);
        contenedor.innerHTML = '';
        items.forEach(item => {
            const nodo = molde.cloneNode(true);
            rellenarCampos(nodo, item);
            if (extra) extra(nodo, item);
            contenedor.appendChild(nodo);
        });
    }

    function renderObjetos(selector, articulos) {
        renderLista(selector, articulos, 'card-objeto', (nodo, a) => {
            nodo.querySelector('.card-objeto').dataset.id = a.id;
            nodo.querySelector('[data-campo="nombre"]').href = `/Articulos/Detalle/${a.id}`;
            nodo.querySelector('img[data-campo="imagen"]').alt = a.nombre;
        });
        if (typeof swappitFavoritos !== 'undefined') swappitFavoritos.marcar(document.querySelector(selector));
        const vacio = document.getElementById('sin-resultados');
        if (vacio) vacio.classList.toggle('d-none', articulos.length > 0);
    }

    return { renderLista, renderObjetos };
})();
