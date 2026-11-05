// =========================================================
// SWAPPIT - Buscar: panel de filtros y vista de resultados
// - Al marcar o desmarcar una categoría o un estado se recarga Buscar con los filtros nuevos
//   (el filtrado lo hace ArticulosController.Buscar).
// - "Ordenar por" (Para vos, Más populares, Más recientes, A - Z): también recarga Buscar, con ?orden=...
//   (el orden lo calcula RecomendacionesController.Ordenar).
// - Botones grilla / lista: cambian cómo se ven las cards.
// =========================================================

(() => {
    document.querySelectorAll('#filtros input[name="categoria"], #filtros input[name="estado"]').forEach(c =>
        c.addEventListener('change', () => c.form.submit()));

    // El select está fuera del form pero pertenece a él (form="filtros"), así viaja junto con los filtros y la búsqueda.
    const ordenar = document.getElementById('ordenar');
    if (ordenar && ordenar.form) ordenar.addEventListener('change', () => ordenar.form.submit());

    const lista = document.getElementById('lista-objetos');
    document.querySelectorAll('input[name="vista"]').forEach(r => r.addEventListener('change', e => {
        if (lista) lista.classList.toggle('vista-lista', e.target.value === 'lista');
    }));
})();
