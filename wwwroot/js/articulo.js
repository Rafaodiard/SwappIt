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

(() => {
    const form = document.querySelector('[data-proponer]');
    if (!form) return;
    const opciones = [...form.querySelectorAll('input[name="idsArticulosOfrecidos"]')];
    if (opciones.length === 0) return;
    const max = Number(form.dataset.maxOfrecidos) || 1;
    const enviar = form.querySelector('button[type="submit"]');
    const contador = form.querySelector('[data-proponer-contador]');

    const actualizar = () => {
        const elegidos = opciones.filter(o => o.checked).length;
        opciones.forEach(o => { o.disabled = !o.checked && elegidos >= max; });
        enviar.disabled = elegidos === 0;
        if (!contador) return;
        contador.textContent = elegidos === 0
            ? `Podés ofrecer hasta ${max} artículos juntos.`
            : elegidos >= max
                ? `Elegiste ${elegidos} artículos, el máximo.`
                : `Elegiste ${elegidos} de ${max} artículos.`;
    };

    opciones.forEach(o => o.addEventListener('change', actualizar));
    actualizar();
})();
