<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Error | Proyectos MML</title>
    <link href="<%= request.getContextPath() %>/assets/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="card border-0 shadow-sm mx-auto" style="max-width: 640px;">
        <div class="card-body p-5 text-center">
            <h1 class="h4 mb-3">Ocurrió un problema</h1>
            <p class="text-secondary mb-4">
                No se pudo procesar la solicitud. Verifique que el servidor de base de datos esté disponible
                e intente nuevamente.
            </p>
            <a class="btn btn-primary" href="<%= request.getContextPath() %>/ProyectoServlet">Volver al sistema</a>
        </div>
    </div>
</div>
</body>
</html>
