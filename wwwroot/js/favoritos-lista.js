// =========================================================
// SWAPPIT - Página "Favoritos" (Views/Favoritos/Index.cshtml)
// Las cards llegan armadas desde el servidor (FavoritosController.Index lee la BD).
// Este archivo solo saca una card cuando le sacás el corazón (evento 'swappit:favorito' de favoritos.js)
// y actualiza el texto de arriba ("3 favoritos") y el cartel de lista vacía.
// =========================================================

(() => {
    const lista = document.getElementById('lista-favoritos');
    if (!lista) return;
    const estado = document.getElementById('favoritos-estado');
    const vacio = document.getElementById('favoritos-vacio');

    function actualizar() {
        const cantidad = lista.querySelectorAll('.card-objeto').length;
        estado.textContent = cantidad === 1 ? '1 favorito' : `${cantidad} favoritos`;
        estado.hidden = cantidad === 0;
        vacio.hidden = cantidad > 0;
    }

    // Si se desmarca, la card se va
    document.addEventListener('swappit:favorito', (e) => {
        if (e.detail.esFavorito) return;
        lista.querySelectorAll(`.card-objeto[data-id="${e.detail.id}"]`).forEach(card => {
            const col = card.closest('.col-objeto');
            if (!col) return;
            const teniaFoco = col.contains(document.activeElement);
            const vecina = col.nextElementSibling || col.previousElementSibling;
            col.remove();
            // Para que el foco del teclado no se pierda al sacar la card
            if (teniaFoco) (vecina?.querySelector('.card-objeto-fav') || vacio.querySelector('a'))?.focus();
        });
        actualizar();
    });
})();
