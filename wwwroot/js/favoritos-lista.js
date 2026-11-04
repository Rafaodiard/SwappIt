// =========================================================
// SWAPPIT - Página "Favoritos" (Views/Favoritos/Index.cshtml)
// Lee los IDs guardados (swappitFavoritos, en favoritos.js), pide las cards
// a FavoritosController.Tarjetas y las muestra. Si se saca el corazón de una
// card, la card se va de la lista.
// TODO backend: cuando los favoritos estén en la BD, la página puede llegar
// armada desde el servidor y este archivo queda solo para sacar las cards.
// =========================================================

(() => {
    const lista = document.getElementById('lista-favoritos');
    if (!lista) return;
    const estado = document.getElementById('favoritos-estado');
    const vacio = document.getElementById('favoritos-vacio');
    const error = document.getElementById('favoritos-error');

    function cantidadCards() {
        return lista.querySelectorAll('.card-objeto').length;
    }

    // Texto de arriba ("3 favoritos") y cartel de lista vacía
    function actualizar() {
        const cantidad = cantidadCards();
        estado.textContent = cantidad === 1 ? '1 favorito' : `${cantidad} favoritos`;
        estado.hidden = cantidad === 0;
        vacio.hidden = cantidad > 0;
    }

    async function cargar() {
        // Más nuevos primero (localStorage los guarda en el orden en que se marcaron)
        const ids = swappitFavoritos.ids().reverse();
        if (ids.length === 0) {
            actualizar();
            return;
        }

        const url = new URL(lista.dataset.urlTarjetas, location.origin);
        ids.forEach(id => url.searchParams.append('ids', id));

        try {
            const respuesta = await fetch(url, { cache: 'no-store' });
            if (respuesta.status === 401) {
                // Se venció la sesión: a iniciar sesión
                location.href = document.body.dataset.urlLogin;
                return;
            }
            if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`);
            lista.innerHTML = await respuesta.text();
            swappitFavoritos.marcar(lista);
            actualizar();
        } catch {
            estado.hidden = true;
            error.hidden = false;
        }
    }

    // favoritos.js avisa cada cambio: si se desmarca, la card se va
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

    cargar();
})();
