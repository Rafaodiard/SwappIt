// =========================================================
// SWAPPIT - Botón de favorito de las cards (se carga en todas las páginas desde _Layout)
// La card está en Views/Shared/_CardObjeto.cshtml.
//
// Solo con sesión iniciada: si no hay usuario (data-usuario vacío en el <body>
// de _Layout), el corazón lleva a iniciar sesión (data-url-login).
//
// Por ahora los favoritos se guardan SOLO en el navegador (localStorage),
// sin tocar la base de datos. La clave lleva el ID del usuario, así dos
// cuentas que usan la misma compu no comparten la lista.
//
// TODO backend: cuando exista la tabla de favoritos, reemplazar leer()/guardar()
// por llamadas al servidor (ver los TODO de abajo). El resto (marcar las cards,
// alternar el corazón, accesibilidad) puede quedar igual.
// La página de favoritos usa ids() y el evento 'swappit:favorito' (favoritos-lista.js).
// =========================================================

const swappitFavoritos = (() => {
    const usuario = document.body.dataset.usuario;
    const CLAVE = usuario ? `swappit:favoritos:${usuario}` : null;

    // Devuelve un Set con los IDs (números) de los artículos favoritos
    function leer() {
        if (!CLAVE) return new Set();
        // TODO backend: traer la lista del servidor
        // (ej: GET a una acción tipo Favoritos/Ids que devuelva [1, 5, 8]).
        try {
            const datos = JSON.parse(localStorage.getItem(CLAVE) || '[]');
            return new Set(Array.isArray(datos) ? datos.map(Number).filter(Number.isInteger) : []);
        } catch {
            // localStorage bloqueado (modo privado, etc.) o JSON roto: se arranca vacío
            return new Set();
        }
    }

    function guardar(ids) {
        try {
            localStorage.setItem(CLAVE, JSON.stringify([...ids]));
        } catch {
            // Sin localStorage el corazón igual cambia en pantalla, solo no se recuerda
        }
    }

    // Pinta un botón según esté o no en favoritos
    function pintar(boton, esFavorito) {
        const nombre = boton.closest('.card-objeto')?.querySelector('.card-objeto-titulo')?.textContent.trim() || 'este artículo';
        const icono = boton.querySelector('i');
        boton.classList.toggle('activo', esFavorito);
        if (usuario) {
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

    // Marca las cards que ya están en favoritos. Se llama al cargar la página,
    // desde swappit.renderObjetos (plantillas.js) y desde favoritos-lista.js.
    function marcar(contenedor = document) {
        const ids = leer();
        contenedor.querySelectorAll('.card-objeto[data-id]').forEach(card => {
            const boton = card.querySelector('.card-objeto-fav');
            if (boton) pintar(boton, ids.has(Number(card.dataset.id)));
        });
    }

    // IDs favoritos en el orden en que se marcaron
    function ids() {
        return [...leer()];
    }

    document.addEventListener('click', (e) => {
        const boton = e.target.closest('.card-objeto-fav');
        if (!boton) return;

        if (!usuario) {
            location.href = document.body.dataset.urlLogin;
            return;
        }

        const id = Number(boton.closest('.card-objeto')?.dataset.id);
        if (!Number.isInteger(id)) return;

        const favoritos = leer();
        const esFavorito = !favoritos.has(id);
        if (esFavorito) favoritos.add(id); else favoritos.delete(id);
        guardar(favoritos);
        // TODO backend: avisar al servidor (ej: POST Favoritos/Alternar con el id
        // y el token antiforgery). Si falla, volver a pintar con el estado anterior.

        // El mismo artículo puede aparecer más de una vez en la página
        document.querySelectorAll(`.card-objeto[data-id="${id}"] .card-objeto-fav`)
            .forEach(b => pintar(b, esFavorito));

        if (esFavorito) {
            boton.classList.add('latido');
            boton.addEventListener('animationend', () => boton.classList.remove('latido'), { once: true });
        }

        document.dispatchEvent(new CustomEvent('swappit:favorito', { detail: { id, esFavorito } }));
    });

    // Si se cambia un favorito en otra pestaña, esta se actualiza sola
    window.addEventListener('storage', (e) => {
        if (CLAVE && e.key === CLAVE) marcar();
    });

    marcar();

    return { marcar, ids };
})();
