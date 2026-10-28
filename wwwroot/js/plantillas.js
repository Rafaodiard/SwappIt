// =========================================================
// SWAPPIT - Plantillas de listas (se carga en todas las páginas desde _Layout)
// Cada lista que se va a llenar por JS (objetos, historial, chats, mensajes)
// tiene en el HTML UN elemento de ejemplo marcado con data-template="nombre".
// Estas funciones lo usan como molde: lo clonan una vez por dato
// y rellenan cada hijo que tenga data-campo="propiedad".
// Hoy las páginas se arman desde el servidor; esto queda para cuando
// alguna lista se cargue con fetch (ver comentarios en Perfil.cshtml y Chat.cshtml).
// =========================================================

const swappit = (() => {
    const moldes = {};

    // Guarda el elemento de ejemplo la primera vez para poder re-renderizar
    function obtenerMolde(contenedor, nombre) {
        if (!moldes[nombre]) {
            const ejemplo = contenedor.querySelector(`[data-template="${nombre}"]`);
            if (!ejemplo) throw new Error(`No hay data-template="${nombre}" en el contenedor`);
            moldes[nombre] = ejemplo.cloneNode(true);
        }
        return moldes[nombre];
    }

    // Pone item[campo] en cada [data-campo="campo"]: como src si es <img>, si no como texto
    function rellenarCampos(nodo, item) {
        nodo.querySelectorAll('[data-campo]').forEach(el => {
            const valor = item[el.dataset.campo];
            if (valor === undefined || valor === null) return;
            if (el.tagName === 'IMG') el.src = valor;
            else el.textContent = valor;
        });
    }

    /**
     * Renderiza una lista a partir del elemento de ejemplo.
     * @param {string} selector  contenedor, ej: '#lista-objetos'
     * @param {Array}  items     datos que vienen del backend
     * @param {string} nombre    valor de data-template
     * @param {Function} [extra] (nodo, item) => {} para lo que no sea texto
     */
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

    // Caso particular para las cards de objetos (Views/Shared/_CardObjeto.cshtml)
    function renderObjetos(selector, articulos) {
        renderLista(selector, articulos, 'card-objeto', (nodo, a) => {
            nodo.querySelector('.card-objeto').dataset.id = a.id;
            nodo.querySelector('[data-campo="nombre"]').href = `/Articulos/Detalle/${a.id}`;
            nodo.querySelector('img[data-campo="imagen"]').alt = a.nombre;
        });
        const vacio = document.getElementById('sin-resultados');
        if (vacio) vacio.classList.toggle('d-none', articulos.length > 0);
    }

    return { renderLista, renderObjetos };
})();

// Ejemplo de uso (cuando esté el backend):
// fetch('/ruta/que/devuelva/json').then(r => r.json())
//     .then(lista => swappit.renderObjetos('#lista-objetos', lista));
// Cada artículo: { id, nombre, estado, barrio, imagen }
