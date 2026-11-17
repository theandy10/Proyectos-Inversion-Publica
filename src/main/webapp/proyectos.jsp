<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="pe.cibertec.entidades.Proyecto" %>
<%@ page import="pe.cibertec.util.Texto" %>
<%!
    private String v(Map<String, String> valores, String campo) {
        String valor = valores.get(campo);
        return valor == null ? "" : Texto.escape(valor);
    }
%>
<%
    List<Proyecto> proyectos = (List<Proyecto>) request.getAttribute("proyectos");
    if (proyectos == null) {
        proyectos = Collections.emptyList();
    }

    Map<String, String> errores = (Map<String, String>) request.getAttribute("errores");
    if (errores == null) {
        errores = Collections.emptyMap();
    }

    Map<String, String> valores = (Map<String, String>) request.getAttribute("valores");
    if (valores == null) {
        valores = Collections.emptyMap();
    }

    String exito = (String) request.getAttribute("exito");
    String errorGeneral = (String) request.getAttribute("errorGeneral");
    String contexto = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Proyectos de Inversión Pública | MML</title>
    <link href="<%= contexto %>/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= contexto %>/assets/css/estilos.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-semibold d-flex align-items-center gap-2" href="<%= contexto %>/ProyectoServlet">
            <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="currentColor" class="bi bi-buildings" viewBox="0 0 16 16">
                <path d="M2 1a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v15H8v-3H6v3H2V1zm2 0v1h1V1H4zm0 2v1h1V3H4zm0 2v1h1V5H4zm0 2v1h1V7H4zm0 2v1h1V9H4zm0 2v1h1v-1H4zm5-8v1h1V3H9zm0 2v1h1V5H9zm0 2v1h1V7H9zm0 2v1h1V9H9zm0 2v1h1v-1H9z"/>
            </svg>
            <span class="d-none d-md-inline">Municipalidad Metropolitana de Lima</span>
            <span class="d-inline d-md-none">MML</span>
        </a>
        <span class="navbar-text text-white-50 d-none d-lg-inline">
            Sistema de Proyectos de Inversión Pública
        </span>
    </div>
</nav>

<main class="container-fluid px-4 py-4">

    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
        <div>
            <h1 class="h3 mb-1">Registro de Proyectos de Inversión Pública</h1>
            <p class="text-secondary mb-0">Gestión de proyectos para licitación y auditoría.</p>
        </div>
        <span class="badge rounded-pill text-bg-primary fs-6 px-3 py-2">
            <%= proyectos.size() %> proyecto<%= proyectos.size() == 1 ? "" : "s" %> registrado<%= proyectos.size() == 1 ? "" : "s" %>
        </span>
    </div>

    <% if (exito != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <strong>Registro correcto.</strong> <%= Texto.escape(exito) %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
    </div>
    <% } %>

    <% if (errorGeneral != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <strong>No se pudo completar la operación.</strong> <%= Texto.escape(errorGeneral) %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
    </div>
    <% } %>

    <div class="row g-4">

        <!-- ================= FORMULARIO ================= -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <h2 class="h5 mb-1">Registrar Proyecto</h2>
                    <p class="text-secondary small mb-4">Los campos marcados con <span class="text-danger">*</span> son obligatorios.</p>

                    <form id="formProyecto" method="post" action="<%= contexto %>/ProyectoServlet" novalidate>

                        <div class="mb-3">
                            <label class="form-label" for="nombre">Nombre del Proyecto <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-sm <%= errores.containsKey("nombre") ? "is-invalid" : "" %>"
                                   id="nombre" name="nombre" value="<%= v(valores, "nombre") %>"
                                   minlength="4" maxlength="60" required
                                   placeholder="Entre 4 y 60 caracteres">
                            <div class="invalid-feedback">
                                <%= errores.containsKey("nombre") ? Texto.escape(errores.get("nombre")) : "El nombre del proyecto debe tener entre 4 y 60 caracteres." %>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label" for="descripcion">Descripción técnica del Proyecto (Opcional)</label>
                            <textarea class="form-control form-control-sm <%= errores.containsKey("descripcion") ? "is-invalid" : "" %>"
                                      id="descripcion" name="descripcion" rows="3" maxlength="255"
                                      placeholder="Detalle del alcance del proyecto (opcional)"><%= v(valores, "descripcion") %></textarea>
                            <div class="invalid-feedback">
                                <%= errores.containsKey("descripcion") ? Texto.escape(errores.get("descripcion")) : "La descripción no debe superar los 255 caracteres." %>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label" for="fechaInicio">Fecha de inicio del Proyecto <span class="text-danger">*</span></label>
                            <input type="date" class="form-control form-control-sm <%= errores.containsKey("fechaInicio") ? "is-invalid" : "" %>"
                                   id="fechaInicio" name="fechaInicio" value="<%= v(valores, "fechaInicio") %>" required>
                            <div class="invalid-feedback">
                                <%= errores.containsKey("fechaInicio") ? Texto.escape(errores.get("fechaInicio")) : "Seleccione la fecha de inicio." %>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label" for="fechaFin">Fecha de culminación del Proyecto <span class="text-danger">*</span></label>
                            <input type="date" class="form-control form-control-sm <%= errores.containsKey("fechaFin") ? "is-invalid" : "" %>"
                                   id="fechaFin" name="fechaFin" value="<%= v(valores, "fechaFin") %>" required>
                            <div class="invalid-feedback">
                                <%= errores.containsKey("fechaFin") ? Texto.escape(errores.get("fechaFin")) : "La fecha de culminación debe ser igual o posterior a la fecha de inicio." %>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label" for="asesor">Asesor Técnico del Proyecto (Nombres y Apellidos) <span class="text-danger">*</span></label>
                            <input type="text" class="form-control form-control-sm <%= errores.containsKey("asesor") ? "is-invalid" : "" %>"
                                   id="asesor" name="asesor" value="<%= v(valores, "asesor") %>"
                                   minlength="3" maxlength="80" required
                                   placeholder="Ej: Julio Gómez">
                            <div class="invalid-feedback">
                                <%= errores.containsKey("asesor") ? Texto.escape(errores.get("asesor")) : "Ingrese el nombre completo del asesor técnico." %>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label" for="presupuesto">Presupuesto Asignado (S/) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control form-control-sm <%= errores.containsKey("presupuesto") ? "is-invalid" : "" %>"
                                   id="presupuesto" name="presupuesto" value="<%= v(valores, "presupuesto") %>"
                                   min="0.01" step="0.01" required
                                   placeholder="Ej: 15000.00">
                            <div class="invalid-feedback">
                                <%= errores.containsKey("presupuesto") ? Texto.escape(errores.get("presupuesto")) : "Ingrese un monto numérico mayor a 0, con hasta 2 decimales." %>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4">
                                Registrar
                            </button>
                            <button type="reset" class="btn btn-outline-secondary">Limpiar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- ================= LISTADO ================= -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="h5 mb-0">Proyectos Disponibles</h2>
                        <a class="btn btn-sm btn-outline-primary" href="<%= contexto %>/ProyectoServlet">Actualizar listado</a>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover table-sm align-middle tabla-proyectos mb-0">
                            <colgroup>
                                <col style="width: 4%">
                                <col style="width: 19%">
                                <col style="width: 17%">
                                <col style="width: 9.5%">
                                <col style="width: 9.5%">
                                <col style="width: 15%">
                                <col style="width: 15%">
                                <col style="width: 6%">
                            </colgroup>
                            <thead class="table-light">
                                <tr>
                                    <th scope="col">Id</th>
                                    <th scope="col">Nombre del Proyecto</th>
                                    <th scope="col">Descripción</th>
                                    <th scope="col">Inicio</th>
                                    <th scope="col">Fin</th>
                                    <th scope="col">Asesor Técnico</th>
                                    <th scope="col" class="text-end">Presupuesto</th>
                                    <th scope="col" class="text-center"></th>
                                </tr>
                            </thead>
                            <tbody>
                            <% if (proyectos.isEmpty()) { %>
                                <tr>
                                    <td colspan="8" class="text-center text-secondary py-4">
                                        No hay proyectos registrados todavía.
                                    </td>
                                </tr>
                            <% } else {
                                   for (Proyecto p : proyectos) { %>
                                <tr>
                                    <td class="fw-semibold"><%= p.getIdProyecto() %></td>
                                    <td title="<%= Texto.escape(p.getNombre()) %>"><%= Texto.escape(p.getNombre()) %></td>
                                    <td class="text-secondary" title="<%= Texto.escape(p.getDescripcion()) %>">
                                        <%= Texto.escape(p.getDescripcionCorta()) %>
                                    </td>
                                    <td><%= p.getFechaInicioTexto() %></td>
                                    <td><%= p.getFechaFinTexto() %></td>
                                    <td title="<%= Texto.escape(p.getAsesor()) %>"><%= Texto.escape(p.getAsesor()) %></td>
                                    <td class="text-end"><%= p.getPresupuestoTexto() %></td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-outline-primary py-0 px-2"
                                                data-bs-toggle="modal" data-bs-target="#detalle<%= p.getIdProyecto() %>"
                                                title="Ver detalle del proyecto">
                                            Ver
                                        </button>
                                    </td>
                                </tr>
                            <%     }
                               } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Ventanas de detalle -->
<% for (Proyecto p : proyectos) { %>
<div class="modal fade" id="detalle<%= p.getIdProyecto() %>" tabindex="-1" aria-labelledby="titulo<%= p.getIdProyecto() %>" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="titulo<%= p.getIdProyecto() %>">Proyecto #<%= p.getIdProyecto() %></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <dl class="row mb-0">
                    <dt class="col-sm-4">Nombre</dt>
                    <dd class="col-sm-8"><%= Texto.escape(p.getNombre()) %></dd>

                    <dt class="col-sm-4">Descripción</dt>
                    <dd class="col-sm-8"><%= p.getDescripcion() == null ? "—" : Texto.escape(p.getDescripcion()) %></dd>

                    <dt class="col-sm-4">Inicio</dt>
                    <dd class="col-sm-8"><%= p.getFechaInicioTexto() %></dd>

                    <dt class="col-sm-4">Culminación</dt>
                    <dd class="col-sm-8"><%= p.getFechaFinTexto() %></dd>

                    <dt class="col-sm-4">Asesor técnico</dt>
                    <dd class="col-sm-8"><%= Texto.escape(p.getAsesor()) %></dd>

                    <dt class="col-sm-4">Presupuesto</dt>
                    <dd class="col-sm-8 mb-0"><%= p.getPresupuestoTexto() %></dd>
                </dl>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>
<% } %>

<script src="<%= contexto %>/assets/js/bootstrap.bundle.min.js"></script>
<script src="<%= contexto %>/assets/js/validacion.js"></script>
</body>
</html>
