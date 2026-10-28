// =========================================================
// SWAPPIT - Imágenes que no cargan (se carga en todas las páginas desde _Layout)
// - Fotos de objetos (.sw-img): se vacía el src y queda el placeholder del contenedor.
// - Avatares ([data-iniciales]): la foto se reemplaza por las iniciales del usuario
//   (ej: el archivo de la foto no está en esta compu).
// El evento error de las imágenes no burbujea, por eso se escucha en fase de captura;
// así también cubre las imágenes que se agregan después (ej: perfil.js).
// =========================================================

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
        if (img.closest('.sw-img')) img.removeAttribute('src');
        mostrarIniciales(img);
    }, true);

    // Imágenes que ya fallaron antes de que cargara este script
    document.querySelectorAll('.sw-img img[src]').forEach((img) => {
        if (img.complete && img.naturalWidth === 0) img.removeAttribute('src');
    });
    document.querySelectorAll('[data-iniciales] img').forEach((img) => {
        if (img.complete && img.naturalWidth === 0) mostrarIniciales(img);
    });
})();
