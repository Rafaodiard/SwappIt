(() => {
    const form = document.querySelector('form[data-cambiar-contrasena]');
    if (!form) return;
    const error = form.querySelector('[data-contrasena-error]');
    const exito = form.querySelector('[data-contrasena-exito]');
    const boton = form.querySelector('button[type="submit"]');

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        error.textContent = '';
        exito.textContent = '';
        exito.hidden = true;
        boton.disabled = true;
        try {
            const respuesta = await fetch(form.action, { method: 'POST', body: new FormData(form) });
            if (respuesta.status === 401) {
                location.href = document.body.dataset.urlLogin;
                return;
            }
            if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`);
            const resultado = await respuesta.json();
            if (resultado.ok) {
                form.reset();
                exito.textContent = resultado.mensaje;
                exito.hidden = false;
            } else {
                error.textContent = resultado.mensaje;
            }
        } catch {
            error.textContent = 'No pudimos cambiar la contraseña. Probá de nuevo en un rato.';
        } finally {
            boton.disabled = false;
        }
    });
})();
