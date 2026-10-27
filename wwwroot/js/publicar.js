// =========================================================
// SWAPPIT - Publicar objeto (solo comportamiento de interfaz)
// - Zona de carga: clic o arrastrar para elegir fotos
// - Miniaturas con vista previa y botón para quitar
// - Contador de caracteres de la descripción
// Descarta fotos que no son JPG/PNG o pesan de más para no mandarlas,
// pero la validación que vale es la del servidor
// (ver PublicarArticuloViewModel y HomeController.Publicar).
// =========================================================

(() => {
    const zona = document.getElementById('zona-carga');
    const inputFotos = document.getElementById('Fotos');
    const miniaturas = document.getElementById('miniaturas');
    if (!zona || !inputFotos || !miniaturas) return;

    // Límites que pone la vista desde PublicarArticuloViewModel (MaxFotos / MaxFotoMB)
    const MAX_FOTOS = Number(inputFotos.dataset.maxFotos) || 6;
    const MAX_MB = Number(inputFotos.dataset.maxMb) || 10;
    const TIPOS = ['image/jpeg', 'image/png'];
    const ESPACIOS_MIN = 4;  // espacios vacíos que muestra el diseño
    const aviso = document.getElementById('aviso-fotos');
    let archivos = [];

    // --- Zona de carga ---
    const abrirSelector = () => inputFotos.click();

    zona.addEventListener('click', abrirSelector);
    zona.addEventListener('keydown', e => {
        if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); abrirSelector(); }
    });

    ['dragenter', 'dragover'].forEach(tipo => zona.addEventListener(tipo, e => {
        e.preventDefault();
        zona.classList.add('sw-zona-carga--activa');
    }));
    ['dragleave', 'drop'].forEach(tipo => zona.addEventListener(tipo, e => {
        e.preventDefault();
        zona.classList.remove('sw-zona-carga--activa');
    }));
    zona.addEventListener('drop', e => agregar(e.dataTransfer.files));

    inputFotos.addEventListener('change', () => agregar(inputFotos.files));

    // --- Fotos ---
    function agregar(lista) {
        const elegidas = Array.from(lista);
        const validas = elegidas.filter(f => TIPOS.includes(f.type) && f.size <= MAX_MB * 1024 * 1024);
        const lugar = Math.max(MAX_FOTOS - archivos.length, 0);

        const avisos = [];
        if (validas.length < elegidas.length) avisos.push(`Solo se aceptan fotos JPG o PNG de hasta ${MAX_MB} MB.`);
        if (validas.length > lugar) avisos.push(`Podés subir hasta ${MAX_FOTOS} fotos.`);
        mostrarAviso(avisos.join(' '));

        archivos = archivos.concat(validas.slice(0, lugar));
        actualizar();
    }

    function quitar(indice) {
        archivos.splice(indice, 1);
        mostrarAviso('');
        actualizar();
    }

    function mostrarAviso(texto) {
        if (aviso) aviso.textContent = texto;
    }

    // Mantiene el <input type="file"> sincronizado para que el formulario envíe las fotos elegidas
    function actualizar() {
        const dt = new DataTransfer();
        archivos.forEach(f => dt.items.add(f));
        inputFotos.files = dt.files;
        dibujarMiniaturas();
    }

    function dibujarMiniaturas() {
        miniaturas.querySelectorAll('img').forEach(img => URL.revokeObjectURL(img.src));
        miniaturas.innerHTML = '';

        archivos.forEach((archivo, i) => {
            const celda = document.createElement('div');
            celda.className = 'sw-miniatura sw-miniatura--llena';

            const img = document.createElement('img');
            img.src = URL.createObjectURL(archivo);
            img.alt = i === 0 ? 'Foto de portada' : `Foto ${i + 1}`;

            const quitarBtn = document.createElement('button');
            quitarBtn.type = 'button';
            quitarBtn.className = 'sw-miniatura-quitar';
            quitarBtn.setAttribute('aria-label', `Quitar foto ${i + 1}`);
            quitarBtn.innerHTML = '<i class="bi bi-x-lg" aria-hidden="true"></i>';
            quitarBtn.addEventListener('click', () => quitar(i));

            celda.append(img, quitarBtn);
            miniaturas.appendChild(celda);
        });

        const vacios = Math.max(ESPACIOS_MIN - archivos.length, 0);
        for (let i = 0; i < vacios; i++) {
            const vacio = document.createElement('button');
            vacio.type = 'button';
            vacio.className = 'sw-miniatura';
            vacio.setAttribute('aria-label', 'Agregar foto');
            vacio.textContent = '+';
            vacio.addEventListener('click', abrirSelector);
            miniaturas.appendChild(vacio);
        }
    }

    // Los "+" que vienen en el HTML también abren el selector
    miniaturas.querySelectorAll('button.sw-miniatura').forEach(b => b.addEventListener('click', abrirSelector));

    // --- Contador de la descripción ---
    const descripcion = document.getElementById('Descripcion');
    const contador = document.getElementById('contador-descripcion');
    if (descripcion && contador) {
        const max = descripcion.maxLength > 0 ? descripcion.maxLength : 500;
        const actualizarContador = () => { contador.textContent = `${descripcion.value.length}/${max}`; };
        descripcion.addEventListener('input', actualizarContador);
        actualizarContador();
    }
})();
