(() => {
    const lista = document.getElementById('lista-favoritos');
    if (!lista) return;

    const estado = document.getElementById('favoritos-estado');
    const vacio = document.getElementById('favoritos-vacio');
    const sinResultados = document.getElementById('favoritos-sin-resultados');
    const buscador = document.getElementById('buscador-favoritos');

    function normalizar(texto) {
        return texto
            .normalize('NFD')
            .replace(/[\u0300-\u036f]/g, '')
            .toLowerCase()
            .trim();
    }

    function tarjetas() {
        return Array.from(lista.querySelectorAll('.col-objeto'));
    }

    function actualizar() {
        const termino = normalizar(buscador?.value || '');
        let visibles = 0;

        for (const columna of tarjetas()) {
            const nombre = normalizar(columna.querySelector('[data-campo="nombre"]')?.textContent || '');
            const coincide = termino === '' || nombre.includes(termino);
            columna.hidden = !coincide;
            if (coincide) visibles++;
        }

        const total = tarjetas().length;

        if (total === 0) {
            estado.hidden = true;
            vacio.hidden = false;
            sinResultados.hidden = true;
            return;
        }

        if (termino === '') {
            estado.textContent = total === 1 ? '1 favorito' : `${total} favoritos`;
        } else {
            estado.textContent = visibles === 1
                ? '1 favorito encontrado'
                : `${visibles} favoritos encontrados`;
        }

        estado.hidden = false;
        vacio.hidden = true;
        sinResultados.hidden = visibles > 0;
    }

    buscador?.addEventListener('input', actualizar);

    document.addEventListener('swappit:favorito', (e) => {
        if (e.detail.esFavorito) return;
        lista.querySelectorAll(`.card-objeto[data-id="${e.detail.id}"]`).forEach(card => {
            const col = card.closest('.col-objeto');
            if (!col) return;

            const teniaFoco = col.contains(document.activeElement);
            const vecina = col.nextElementSibling || col.previousElementSibling;
            col.remove();

            if (teniaFoco) {
                (vecina?.querySelector('.card-objeto-fav') || buscador || vacio.querySelector('a'))?.focus();
            }
        });
        actualizar();
    });

    actualizar();
})();
