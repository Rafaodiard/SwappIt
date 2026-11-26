function swappitDesplegable(contenedor, alAbrir) {
    const boton = contenedor.querySelector('[data-desplegable-boton]');
    const popup = contenedor.querySelector('.desplegable');

    function abrir(abierto) {
        if (popup.classList.contains('abierto') === abierto) return;
        popup.classList.toggle('abierto', abierto);
        boton.setAttribute('aria-expanded', String(abierto));
        if (abierto && alAbrir) alAbrir();
    }

    boton.addEventListener('click', () => abrir(boton.getAttribute('aria-expanded') !== 'true'));

    contenedor.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && popup.classList.contains('abierto')) {
            abrir(false);
            boton.focus();
        }
    });

    document.addEventListener('click', (e) => {
        if (!contenedor.contains(e.target)) abrir(false);
    });

    contenedor.addEventListener('focusout', (e) => {
        if (e.relatedTarget && !contenedor.contains(e.relatedTarget)) abrir(false);
    });

    return abrir;
}

document.querySelectorAll('[data-desplegable]').forEach(contenedor => swappitDesplegable(contenedor));
