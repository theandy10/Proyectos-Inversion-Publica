package pe.cibertec.validacion;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

import pe.cibertec.modelo.Proyecto;

/**
 * Validaciones del lado del servidor para el registro de proyectos.
 * Cubre los 6 campos solicitados en el examen T1.
 */
public final class ValidadorProyecto {

    private ValidadorProyecto() {
    }

    /**
     * Valida los datos recibidos del formulario.
     *
     * @param valores  valores tal como llegaron del formulario
     * @param proyecto objeto que se completa solo cuando el dato es valido
     * @return mapa campo -> mensaje de error (vacio si todo esta correcto)
     */
    public static Map<String, String> validar(Map<String, String> valores, Proyecto proyecto) {
        Map<String, String> errores = new LinkedHashMap<>();

        // 1. Nombre del proyecto: requerido, entre 4 y 60 caracteres
        String nombre = limpiar(valores.get("nombre"));
        if (nombre.isEmpty()) {
            errores.put("nombre", "El nombre del proyecto es obligatorio.");
        } else if (nombre.length() < 4 || nombre.length() > 60) {
            errores.put("nombre", "El nombre del proyecto debe tener entre 4 y 60 caracteres.");
        } else {
            proyecto.setNombre(nombre);
        }

        // 2. Descripcion tecnica: opcional, maximo 255 caracteres
        String descripcion = limpiar(valores.get("descripcion"));
        if (descripcion.length() > 255) {
            errores.put("descripcion", "La descripción no debe superar los 255 caracteres.");
        } else {
            proyecto.setDescripcion(descripcion.isEmpty() ? null : descripcion);
        }

        // 3. Fecha de inicio: requerida y con formato valido
        LocalDate fechaInicio = null;
        String textoInicio = limpiar(valores.get("fechaInicio"));
        if (textoInicio.isEmpty()) {
            errores.put("fechaInicio", "La fecha de inicio es obligatoria.");
        } else {
            fechaInicio = parsearFecha(textoInicio);
            if (fechaInicio == null) {
                errores.put("fechaInicio", "La fecha de inicio no es válida.");
            } else {
                proyecto.setFechaInicio(fechaInicio);
            }
        }

        // 4. Fecha de culminacion: requerida y posterior o igual al inicio
        String textoFin = limpiar(valores.get("fechaFin"));
        if (textoFin.isEmpty()) {
            errores.put("fechaFin", "La fecha de culminación es obligatoria.");
        } else {
            LocalDate fechaFin = parsearFecha(textoFin);
            if (fechaFin == null) {
                errores.put("fechaFin", "La fecha de culminación no es válida.");
            } else if (fechaInicio != null && fechaFin.isBefore(fechaInicio)) {
                errores.put("fechaFin", "La fecha de culminación no puede ser anterior a la fecha de inicio.");
            } else {
                proyecto.setFechaFin(fechaFin);
            }
        }

        // 5. Asesor tecnico: requerido, entre 3 y 80 caracteres
        String asesor = limpiar(valores.get("asesor"));
        if (asesor.isEmpty()) {
            errores.put("asesor", "El asesor técnico es obligatorio.");
        } else if (asesor.length() < 3 || asesor.length() > 80) {
            errores.put("asesor", "El asesor técnico debe tener entre 3 y 80 caracteres.");
        } else {
            proyecto.setAsesor(asesor);
        }

        // 6. Presupuesto: requerido, numerico, mayor a 0 y con 2 decimales como maximo
        String textoPresupuesto = limpiar(valores.get("presupuesto"));
        if (textoPresupuesto.isEmpty()) {
            errores.put("presupuesto", "El presupuesto asignado es obligatorio.");
        } else {
            try {
                BigDecimal presupuesto = new BigDecimal(textoPresupuesto.replace(",", ""));
                if (presupuesto.compareTo(BigDecimal.ZERO) <= 0) {
                    errores.put("presupuesto", "El presupuesto debe ser mayor a 0.");
                } else if (presupuesto.scale() > 2) {
                    errores.put("presupuesto", "El presupuesto solo admite 2 decimales.");
                } else if (presupuesto.compareTo(new BigDecimal("999999999.99")) > 0) {
                    errores.put("presupuesto", "El presupuesto supera el límite permitido.");
                } else {
                    proyecto.setPresupuesto(presupuesto);
                }
            } catch (NumberFormatException e) {
                errores.put("presupuesto", "El presupuesto debe ser un número válido.");
            }
        }

        return errores;
    }

    private static String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private static LocalDate parsearFecha(String valor) {
        try {
            return LocalDate.parse(valor);
        } catch (Exception e) {
            return null;
        }
    }
}
