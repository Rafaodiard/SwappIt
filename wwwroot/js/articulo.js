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
