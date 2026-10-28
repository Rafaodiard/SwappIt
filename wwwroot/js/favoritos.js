// =========================================================
// SWAPPIT - Botón de favorito de las cards (se carga en todas las páginas desde _Layout)
// Por ahora es solo visual: cambia el corazón vacío/lleno, no se guarda en la base.
// La card está en Views/Shared/_CardObjeto.cshtml.
// =========================================================

document.addEventListener('click', (e) => {
    const fav = e.target.closest('.card-objeto-fav');
    if (!fav) return;
    fav.classList.toggle('activo');
    const icono = fav.querySelector('i');
    icono.classList.toggle('bi-heart');
    icono.classList.toggle('bi-heart-fill');
});
