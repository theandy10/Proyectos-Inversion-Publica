package pe.cibertec.servlet;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import pe.cibertec.dao.ProyectoDAO;
import pe.cibertec.entidades.Proyecto;
import pe.cibertec.interfaces.IProyectoDAO;
import pe.cibertec.validacion.ValidadorProyecto;

/**
 * Controlador (Servlet) del mantenimiento de Proyectos de Inversion Publica.
 * Atiende el listado (GET) y el registro con validaciones (POST).
 */
@WebServlet(name = "ProyectoServlet", urlPatterns = { "/ProyectoServlet" })
public class ProyectoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String VISTA = "/proyectos.jsp";

    private final IProyectoDAO proyectoDAO = new ProyectoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        request.setAttribute("valores", new HashMap<String, String>());
        mostrarVista(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Map<String, String> valores = new HashMap<>();
        valores.put("nombre", request.getParameter("nombre"));
        valores.put("descripcion", request.getParameter("descripcion"));
        valores.put("fechaInicio", request.getParameter("fechaInicio"));
        valores.put("fechaFin", request.getParameter("fechaFin"));
        valores.put("asesor", request.getParameter("asesor"));
        valores.put("presupuesto", request.getParameter("presupuesto"));

        Proyecto proyecto = new Proyecto();
        Map<String, String> errores = ValidadorProyecto.validar(valores, proyecto);

        if (errores.isEmpty()) {
            try {
                if (proyectoDAO.registrar(proyecto) == 1) {
                    request.setAttribute("exito", "El proyecto \"" + proyecto.getNombre() + "\" se registró correctamente.");
                    valores.clear();
                } else {
                    request.setAttribute("errorGeneral", "No se pudo registrar el proyecto. Intente nuevamente.");
                }
            } catch (RuntimeException e) {
                request.setAttribute("errorGeneral", "Ocurrió un problema al guardar en la base de datos.");
                log("Error al registrar proyecto", e);
            }
        } else {
            request.setAttribute("errorGeneral", "Revise los datos marcados en rojo antes de registrar.");
        }

        request.setAttribute("valores", valores);
        request.setAttribute("errores", errores);
        mostrarVista(request, response);
    }

    private void mostrarVista(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getAttribute("errores") == null) {
            request.setAttribute("errores", Collections.emptyMap());
        }

        try {
            request.setAttribute("proyectos", proyectoDAO.listar());
        } catch (RuntimeException e) {
            request.setAttribute("proyectos", Collections.emptyList());
            if (request.getAttribute("errorGeneral") == null) {
                request.setAttribute("errorGeneral", "No se pudo obtener el listado de proyectos: " + e.getMessage());
            }
            log("Error al listar proyectos", e);
        }

        request.getRequestDispatcher(VISTA).forward(request, response);
    }
}
