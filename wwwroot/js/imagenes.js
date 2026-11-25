(() => {
    function mostrarIniciales(img) {
        const avatar = img.closest('[data-iniciales]');
        if (!avatar) return;
        const span = document.createElement('span');
        span.textContent = avatar.dataset.iniciales;
        img.replaceWith(span);
    }

    document.addEventListener('error', (e) => {
        const img = e.target;
        if (!(img instanceof HTMLImageElement)) return;
        if (img.closest('.marco-imagen')) img.removeAttribute('src');
        mostrarIniciales(img);
    }, true);

    document.querySelectorAll('.marco-imagen img[src]').forEach((img) => {
        if (img.complete && img.naturalWidth === 0) img.removeAttribute('src');
    });
    document.querySelectorAll('[data-iniciales] img').forEach((img) => {
        if (img.complete && img.naturalWidth === 0) mostrarIniciales(img);
    });
})();
