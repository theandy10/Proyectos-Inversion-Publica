package pe.cibertec.modelo;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Entidad que representa un Proyecto de Inversion Publica.
 */
public class Proyecto {

    private static final DateTimeFormatter FORMATO_VISTA = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter FORMATO_ISO = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DecimalFormat FORMATO_MONEDA =
            new DecimalFormat("#,##0.00", DecimalFormatSymbols.getInstance(Locale.US));

    private int idProyecto;
    private String nombre;
    private String descripcion;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String asesor;
    private BigDecimal presupuesto;

    public Proyecto() {
    }

    public Proyecto(int idProyecto, String nombre, String descripcion, LocalDate fechaInicio,
                    LocalDate fechaFin, String asesor, BigDecimal presupuesto) {
        this.idProyecto = idProyecto;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.asesor = asesor;
        this.presupuesto = presupuesto;
    }

    public int getIdProyecto() {
        return idProyecto;
    }

    public void setIdProyecto(int idProyecto) {
        this.idProyecto = idProyecto;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public LocalDate getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(LocalDate fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public LocalDate getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(LocalDate fechaFin) {
        this.fechaFin = fechaFin;
    }

    public String getAsesor() {
        return asesor;
    }

    public void setAsesor(String asesor) {
        this.asesor = asesor;
    }

    public BigDecimal getPresupuesto() {
        return presupuesto;
    }

    public void setPresupuesto(BigDecimal presupuesto) {
        this.presupuesto = presupuesto;
    }

    /* ---------- Apoyo para la vista JSP ---------- */

    public String getFechaInicioTexto() {
        return fechaInicio == null ? "" : fechaInicio.format(FORMATO_VISTA);
    }

    public String getFechaFinTexto() {
        return fechaFin == null ? "" : fechaFin.format(FORMATO_VISTA);
    }

    public String getFechaInicioIso() {
        return fechaInicio == null ? "" : fechaInicio.format(FORMATO_ISO);
    }

    public String getFechaFinIso() {
        return fechaFin == null ? "" : fechaFin.format(FORMATO_ISO);
    }

    public String getPresupuestoTexto() {
        return presupuesto == null ? "" : "S/ " + FORMATO_MONEDA.format(presupuesto);
    }

    public String getPresupuestoSinSimbolo() {
        return presupuesto == null ? "" : presupuesto.toPlainString();
    }

    public String getDescripcionCorta() {
        if (descripcion == null) {
            return "";
        }
        return descripcion.length() <= 45 ? descripcion : descripcion.substring(0, 45) + "...";
    }
}
