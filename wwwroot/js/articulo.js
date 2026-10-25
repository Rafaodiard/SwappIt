// =========================================================
// SWAPPIT - Detalle de artículo: galería de fotos
// Al hacer clic en una miniatura se muestra esa foto como principal.
// Las miniaturas solo existen si el artículo tiene más de una foto.
// =========================================================

(() => {
    const principal = document.getElementById('articulo-foto-principal');
    const miniaturas = document.querySelectorAll('.sw-articulo-miniatura');
    if (!principal || miniaturas.length === 0) return;

    miniaturas.forEach(boton => {
        boton.addEventListener('click', () => {
            principal.src = boton.dataset.foto;
            miniaturas.forEach(m => m.setAttribute('aria-current', m === boton ? 'true' : 'false'));
        });
    });
})();
