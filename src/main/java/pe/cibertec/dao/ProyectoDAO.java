package pe.cibertec.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import pe.cibertec.database.Conexion;
import pe.cibertec.entidades.Proyecto;
import pe.cibertec.interfaces.IProyectoDAO;

/**
 * Implementacion del patron DAO con JDBC y PreparedStatement.
 */
public class ProyectoDAO implements IProyectoDAO {

    private static final String SQL_LISTAR =
            "SELECT id_proyecto, nombre, descripcion, fecha_inicio, fecha_fin, asesor, presupuesto "
          + "FROM dbo.proyectos ORDER BY id_proyecto DESC";

    private static final String SQL_REGISTRAR =
            "INSERT INTO dbo.proyectos (nombre, descripcion, fecha_inicio, fecha_fin, asesor, presupuesto) "
          + "VALUES (?, ?, ?, ?, ?, ?)";

    @Override
    public List<Proyecto> listar() {
        List<Proyecto> proyectos = new ArrayList<>();

        try (Connection conexion = Conexion.getConnection();
             PreparedStatement sentencia = conexion.prepareStatement(SQL_LISTAR);
             ResultSet resultado = sentencia.executeQuery()) {

            while (resultado.next()) {
                proyectos.add(mapearProyecto(resultado));
            }

        } catch (Exception e) {
            throw new RuntimeException("Error al listar los proyectos: " + e.getMessage(), e);
        }

        return proyectos;
    }

    @Override
    public int registrar(Proyecto proyecto) {
        try (Connection conexion = Conexion.getConnection();
             PreparedStatement sentencia = conexion.prepareStatement(SQL_REGISTRAR)) {

            sentencia.setString(1, proyecto.getNombre());
            sentencia.setString(2, proyecto.getDescripcion());
            sentencia.setDate(3, Date.valueOf(proyecto.getFechaInicio()));
            sentencia.setDate(4, Date.valueOf(proyecto.getFechaFin()));
            sentencia.setString(5, proyecto.getAsesor());
            sentencia.setBigDecimal(6, proyecto.getPresupuesto());

            return sentencia.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error al registrar el proyecto: " + e.getMessage(), e);
        }
    }

    private Proyecto mapearProyecto(ResultSet resultado) throws Exception {
        Proyecto proyecto = new Proyecto();
        proyecto.setIdProyecto(resultado.getInt("id_proyecto"));
        proyecto.setNombre(resultado.getString("nombre"));
        proyecto.setDescripcion(resultado.getString("descripcion"));

        Date inicio = resultado.getDate("fecha_inicio");
        Date fin = resultado.getDate("fecha_fin");
        proyecto.setFechaInicio(inicio == null ? null : inicio.toLocalDate());
        proyecto.setFechaFin(fin == null ? null : fin.toLocalDate());

        proyecto.setAsesor(resultado.getString("asesor"));
        proyecto.setPresupuesto(resultado.getBigDecimal("presupuesto"));
        return proyecto;
    }
}
