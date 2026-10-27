// =========================================================
// SWAPPIT - helpers de front
// Cada lista (objetos, historial, chats, mensajes) tiene en el HTML
// UN elemento de ejemplo marcado con data-template="nombre".
// Estas funciones lo usan como molde: lo clonan una vez por dato
// y rellenan cada hijo que tenga data-campo="propiedad".
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
// fetch('/Articulos/Listar').then(r => r.json())
//     .then(lista => swappit.renderObjetos('#lista-objetos', lista));
// Cada artículo: { id, nombre, estado, barrio, distancia, busca, imagen }

// Si una imagen no carga, se vacía para que se vea el placeholder del contenedor .sw-img
document.addEventListener('error', e => {
    if (e.target.tagName === 'IMG' && e.target.closest('.sw-img')) e.target.removeAttribute('src');
}, true);

// Botón de favorito (visual)
document.addEventListener('click', e => {
    const fav = e.target.closest('.card-objeto-fav');
    if (!fav) return;
    fav.classList.toggle('activo');
    const icono = fav.querySelector('i');
    icono.classList.toggle('bi-heart');
    icono.classList.toggle('bi-heart-fill');
});

// Avatares: si la foto de perfil no se puede cargar (ej: el archivo no está en esta compu),
// se reemplaza por las iniciales del contenedor (data-iniciales).
(() => {
    function mostrarIniciales(img) {
        const avatar = img.closest('[data-iniciales]');
        if (!avatar) return;
        const span = document.createElement('span');
        span.textContent = avatar.dataset.iniciales;
        img.replaceWith(span);
    }

    // Fase de captura: el evento error de las imágenes no burbujea. También cubre las que agrega perfil.js.
    document.addEventListener('error', (e) => {
        if (e.target instanceof HTMLImageElement) mostrarIniciales(e.target);
    }, true);

    // Las que ya fallaron antes de que cargara este script.
    document.querySelectorAll('[data-iniciales] img').forEach((img) => {
        if (img.complete && img.naturalWidth === 0) mostrarIniciales(img);
    });
})();
