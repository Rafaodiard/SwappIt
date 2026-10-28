// =========================================================
// SWAPPIT - Perfil: pop up "Editar perfil"
// - Lo abren los botones con data-bs-toggle="modal" (Bootstrap)
// - Vista previa de la foto elegida y botón "Quitar foto"
// - Contador de caracteres de la descripción
// - Si el servidor devolvió un error, se vuelve a abrir solo
// La validación final y el guardado los hace PerfilController.Editar.
// =========================================================

(() => {
    const modalEl = document.getElementById('modal-editar-perfil');
    if (!modalEl) return;

    const form = modalEl.querySelector('form');
    const inputFoto = document.getElementById('Foto');
    const quitarFoto = document.getElementById('QuitarFoto');
    const btnQuitar = document.getElementById('quitar-foto');
    const vistaPrevia = document.getElementById('vista-previa-foto');
    const errorFoto = document.getElementById('error-foto');
    const descripcion = document.getElementById('Descripcion');
    const contador = document.getElementById('contador-descripcion');

    const MAX_MB = Number(inputFoto.dataset.maxMb) || 5;
    const TIPOS = ['image/jpeg', 'image/png'];
    const contenidoOriginal = vistaPrevia.innerHTML;
    const botonQuitarVisible = !btnQuitar.classList.contains('d-none');
    let urlTemporal = null;

    // --- Vista previa del avatar ---
    function mostrarImagen(src) {
        vistaPrevia.innerHTML = '';
        const img = document.createElement('img');
        img.src = src;
        img.alt = 'Vista previa de la foto';
        vistaPrevia.appendChild(img);
    }

    function mostrarIniciales() {
        vistaPrevia.innerHTML = '';
        const span = document.createElement('span');
        span.textContent = vistaPrevia.dataset.iniciales;
        vistaPrevia.appendChild(span);
    }

    function liberarUrl() {
        if (urlTemporal) URL.revokeObjectURL(urlTemporal);
        urlTemporal = null;
    }

    inputFoto.addEventListener('change', () => {
        errorFoto.textContent = '';
        const archivo = inputFoto.files[0];
        if (!archivo) return;

        if (!TIPOS.includes(archivo.type)) {
            errorFoto.textContent = 'La foto tiene que ser JPG o PNG.';
            inputFoto.value = '';
            return;
        }
        if (archivo.size > MAX_MB * 1024 * 1024) {
            errorFoto.textContent = `La foto puede pesar hasta ${MAX_MB} MB.`;
            inputFoto.value = '';
            return;
        }

        liberarUrl();
        urlTemporal = URL.createObjectURL(archivo);
        mostrarImagen(urlTemporal);
        quitarFoto.value = 'false';
        btnQuitar.classList.remove('d-none');
    });

    btnQuitar.addEventListener('click', () => {
        inputFoto.value = '';
        errorFoto.textContent = '';
        liberarUrl();
        mostrarIniciales();
        quitarFoto.value = 'true';
        btnQuitar.classList.add('d-none');
    });

    // --- Contador de la descripción ---
    const actualizarContador = () => { contador.textContent = `${descripcion.value.length}/${descripcion.maxLength}`; };
    descripcion.addEventListener('input', actualizarContador);
    actualizarContador();

    // --- Abrir / cerrar ---
    // El botón de la cámara abre directamente el selector de archivos
    document.querySelectorAll('[data-elegir-foto]').forEach(btn =>
        btn.addEventListener('click', () => inputFoto.click()));

    // Botones con data-enfocar="Campo" llevan el foco a ese campo al abrir
    modalEl.addEventListener('shown.bs.modal', e => {
        const campo = e.relatedTarget?.dataset.enfocar;
        const destino = campo ? document.getElementById(campo) : document.getElementById('Nombre');
        destino?.focus();
    });

    // Si se cancela, se descartan los cambios
    modalEl.addEventListener('hidden.bs.modal', () => {
        form.reset();
        liberarUrl();
        vistaPrevia.innerHTML = contenidoOriginal;
        quitarFoto.value = 'false';
        btnQuitar.classList.toggle('d-none', !botonQuitarVisible);
        errorFoto.textContent = '';
        actualizarContador();
    });

    // Error del servidor: se vuelve a abrir el pop up para mostrarlo
    if (modalEl.dataset.error) {
        bootstrap.Modal.getOrCreateInstance(modalEl).show();
    }
})();
