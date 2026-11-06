const swappitFavoritos = (() => {
    const form = document.querySelector('form[data-favoritos]');
    const usuario = document.body.dataset.usuario;
    const CLAVE_NAVEGADOR = usuario ? `swappit:favoritos:${usuario}` : null;
    let favoritos = new Set();
    const enCamino = new Set();

    function pintar(boton, esFavorito) {
        const nombre = boton.closest('.card-objeto')?.querySelector('.card-objeto-titulo')?.textContent.trim() || 'este artículo';
        const icono = boton.querySelector('i');
        boton.classList.toggle('activo', esFavorito);
        if (form) {
            boton.setAttribute('aria-pressed', esFavorito);
            boton.setAttribute('aria-label', esFavorito ? `Quitar ${nombre} de favoritos` : `Agregar ${nombre} a favoritos`);
        } else {
            boton.removeAttribute('aria-pressed');
            boton.setAttribute('aria-label', `Iniciá sesión para guardar ${nombre} en favoritos`);
        }
        icono.classList.toggle('bi-heart', !esFavorito);
        icono.classList.toggle('bi-heart-fill', esFavorito);
    }

    function marcar(contenedor = document) {
        contenedor.querySelectorAll('.card-objeto[data-id]').forEach(card => {
            const boton = card.querySelector('.card-objeto-fav');
            if (boton) pintar(boton, favoritos.has(Number(card.dataset.id)));
        });
    }

    function datos(campos) {
        const formData = new FormData(form);
        Object.entries(campos).forEach(([nombre, valor]) => [].concat(valor).forEach(v => formData.append(nombre, v)));
        return formData;
    }

    function leerDelNavegador() {
        try {
            const guardados = JSON.parse(localStorage.getItem(CLAVE_NAVEGADOR) || '[]');
            return Array.isArray(guardados) ? guardados.map(Number).filter(Number.isInteger) : [];
        } catch {
            return [];
        }
    }

    async function cargar() {
        if (!form) {
            marcar();
            return;
        }
        try {
            const delNavegador = leerDelNavegador();
            if (delNavegador.length > 0) {
                const importados = await fetch(form.dataset.urlImportar, { method: 'POST', body: datos({ ids: delNavegador }) });
                if (importados.ok) {
                    try { localStorage.removeItem(CLAVE_NAVEGADOR); } catch { }
                }
            }
            const respuesta = await fetch(form.dataset.urlIds, { cache: 'no-store' });
            if (respuesta.ok) favoritos = new Set((await respuesta.json()).map(Number));
        } catch {
        }
        marcar();
    }

    function aplicar(id, esFavorito) {
        if (esFavorito) favoritos.add(id); else favoritos.delete(id);
        document.querySelectorAll(`.card-objeto[data-id="${id}"] .card-objeto-fav`).forEach(b => pintar(b, esFavorito));
        document.dispatchEvent(new CustomEvent('swappit:favorito', { detail: { id, esFavorito } }));
    }

    document.addEventListener('click', async (e) => {
        const boton = e.target.closest('.card-objeto-fav');
        if (!boton) return;

        if (!form) {
            location.href = document.body.dataset.urlLogin;
            return;
        }

        const id = Number(boton.closest('.card-objeto')?.dataset.id);
        if (!Number.isInteger(id) || enCamino.has(id)) return;

        const antes = favoritos.has(id);
        aplicar(id, !antes);
        if (!antes) {
            boton.classList.add('latido');
            boton.addEventListener('animationend', () => boton.classList.remove('latido'), { once: true });
        }

        enCamino.add(id);
        try {
            const respuesta = await fetch(form.action, { method: 'POST', body: datos({ idArticulo: id }) });
            if (respuesta.status === 401) {
                location.href = document.body.dataset.urlLogin;
                return;
            }
            if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`);
            const resultado = await respuesta.json();
            if (resultado.esFavorito !== !antes) aplicar(id, resultado.esFavorito);
        } catch {
            aplicar(id, antes);
        } finally {
            enCamino.delete(id);
        }
    });

    cargar();

    return { marcar };
})();
