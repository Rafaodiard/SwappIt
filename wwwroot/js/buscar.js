(() => {
    document.querySelectorAll('#filtros input[name="categoria"], #filtros input[name="estado"]').forEach(c =>
        c.addEventListener('change', () => c.form.submit()));

    const ordenar = document.getElementById('ordenar');
    if (ordenar && ordenar.form) ordenar.addEventListener('change', () => ordenar.form.submit());

    const lista = document.getElementById('lista-objetos');
    document.querySelectorAll('input[name="vista"]').forEach(r => r.addEventListener('change', e => {
        if (lista) lista.classList.toggle('modo-lista', e.target.value === 'lista');
    }));
})();
