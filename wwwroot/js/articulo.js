(() => {
    const principal = document.getElementById('articulo-foto-principal');
    const miniaturas = document.querySelectorAll('.boton-miniatura');
    if (!principal || miniaturas.length === 0) return;

    miniaturas.forEach(boton => {
        boton.addEventListener('click', () => {
            principal.src = boton.dataset.foto;
            miniaturas.forEach(m => m.setAttribute('aria-current', m === boton ? 'true' : 'false'));
        });
    });
})();

document.querySelectorAll('form[data-proponer]').forEach(form => {
    const opciones = [...form.querySelectorAll('input[type="checkbox"]')];
    if (opciones.length === 0) return;
    const max = Number(form.dataset.maxOfrecidos) || 1;
    const enviar = form.querySelector('button[type="submit"]');
    const contador = form.querySelector('[data-proponer-contador]');
    const textoInicial = contador ? contador.textContent : '';

    const actualizar = () => {
        const elegidos = opciones.filter(o => o.checked).length;
        opciones.forEach(o => { o.disabled = !o.checked && elegidos >= max; });
        enviar.disabled = elegidos === 0;
        if (!contador) return;
        contador.textContent = elegidos === 0
            ? textoInicial
            : elegidos >= max
                ? (elegidos === 1 ? 'Elegiste 1 artículo, el máximo.' : `Elegiste ${elegidos} artículos, el máximo.`)
                : `Elegiste ${elegidos} de ${max} artículos.`;
    };

    opciones.forEach(o => o.addEventListener('change', actualizar));
    actualizar();
});
