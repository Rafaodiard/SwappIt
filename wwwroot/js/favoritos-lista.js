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

    document.addEventListener('swappit:favorito', (e) => {
        if (e.detail.esFavorito) return;
        lista.querySelectorAll(`.card-objeto[data-id="${e.detail.id}"]`).forEach(card => {
            const col = card.closest('.col-objeto');
            if (!col) return;
            const teniaFoco = col.contains(document.activeElement);
            const vecina = col.nextElementSibling || col.previousElementSibling;
            col.remove();
            if (teniaFoco) (vecina?.querySelector('.card-objeto-fav') || vacio.querySelector('a'))?.focus();
        });
        actualizar();
    });
})();
