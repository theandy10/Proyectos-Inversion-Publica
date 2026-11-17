document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('formProyecto');
    if (!form) {
        return;
    }

    const inicio = document.getElementById('fechaInicio');
    const fin = document.getElementById('fechaFin');

    function validarFechas() {
        fin.setCustomValidity('');
        if (inicio.value && fin.value && fin.value < inicio.value) {
            fin.setCustomValidity('La fecha de culminación no puede ser anterior a la fecha de inicio.');
        }
    }

    [inicio, fin].forEach(function (campo) {
        campo.addEventListener('change', validarFechas);
        campo.addEventListener('input', validarFechas);
    });

    form.addEventListener('submit', function (event) {
        validarFechas();

        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }

        form.classList.add('was-validated');
    });
});
