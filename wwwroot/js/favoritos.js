// =========================================================
// SWAPPIT - Botón de favorito de las cards (se carga en todas las páginas desde _Layout)
// La card está en Views/Shared/_CardObjeto.cshtml.
//
// Los favoritos se guardan en la base de datos (tabla Interacciones, tipo "Favorito") con FavoritosController:
// - al cargar la página se piden los IDs (GET Favoritos/Ids) y se pintan los corazones;
// - al tocar un corazón se manda POST Favoritos/Alternar. Se pinta enseguida y, si no se pudo guardar,
//   vuelve como estaba.
// Las URLs y el token antiforgery salen del form oculto [data-favoritos] de _Layout (un .js no puede usar Razor).
// Ese form solo existe con sesión iniciada: sin sesión, el corazón lleva a iniciar sesión (data-url-login del <body>).
//
// Antes los favoritos vivían solo en el navegador (localStorage). Si quedó algo guardado ahí,
// se pasa una vez a la BD (POST Favoritos/Importar) y se borra del navegador.
//
// La página de favoritos escucha el evento 'swappit:favorito' (favoritos-lista.js).
// Los favoritos también los usa el algoritmo de recomendaciones (RecomendacionesController).
// =========================================================

const swappitFavoritos = (() => {
    const form = document.querySelector('form[data-favoritos]');
    const usuario = document.body.dataset.usuario;
    const CLAVE_NAVEGADOR = usuario ? `swappit:favoritos:${usuario}` : null;
    let favoritos = new Set();
    // Artículos con un cambio en camino al servidor (para no mandar dos a la vez)
    const enCamino = new Set();

    // Pinta un botón según esté o no en favoritos
    function pintar(boton, esFavorito) {
        const nombre = boton.closest('.card-objeto')?.querySelector('.card-objeto-titulo')?.textContent.trim() || 'este artículo';
        const icono = boton.querySelector('i');
        boton.classList.toggle('activo', esFavorito);
        if (form) {
            boton.setAttribute('aria-pressed', esFavorito);
            boton.setAttribute('aria-label', esFavorito ? `Quitar ${nombre} de favoritos` : `Agregar ${nombre} a favoritos`);
        } else {
            // Para un visitante no es un interruptor: es un link a iniciar sesión
            boton.removeAttribute('aria-pressed');
            boton.setAttribute('aria-label', `Iniciá sesión para guardar ${nombre} en favoritos`);
        }
        icono.classList.toggle('bi-heart', !esFavorito);
        icono.classList.toggle('bi-heart-fill', esFavorito);
    }

    // Marca las cards que ya están en favoritos. Se llama al cargar la página
    // y desde swappit.renderObjetos (plantillas.js).
    function marcar(contenedor = document) {
        contenedor.querySelectorAll('.card-objeto[data-id]').forEach(card => {
            const boton = card.querySelector('.card-objeto-fav');
            if (boton) pintar(boton, favoritos.has(Number(card.dataset.id)));
        });
    }

    // FormData con el token antiforgery del form + los datos que se pasen (un valor o una lista)
    function datos(campos) {
        const formData = new FormData(form);
        Object.entries(campos).forEach(([nombre, valor]) => [].concat(valor).forEach(v => formData.append(nombre, v)));
        return formData;
    }

    // Favoritos que quedaron en el navegador de antes de usar la BD
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
            // Sin conexión con el servidor los corazones quedan vacíos
        }
        marcar();
    }

    // Cambia el estado en pantalla (en todas las cards de ese artículo) y avisa a la página de favoritos
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
                // Se venció la sesión: a iniciar sesión
                location.href = document.body.dataset.urlLogin;
                return;
            }
            if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`);
            const resultado = await respuesta.json();
            if (resultado.esFavorito !== !antes) aplicar(id, resultado.esFavorito);
        } catch {
            // No se guardó: el corazón vuelve como estaba
            aplicar(id, antes);
        } finally {
            enCamino.delete(id);
        }
    });

    cargar();

    return { marcar };
})();
