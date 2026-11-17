package pe.cibertec.interfaces;

import java.util.List;

import pe.cibertec.modelo.Proyecto;

/**
 * Contrato del patron DAO para la tabla proyectos.
 */
public interface IProyectoDAO {

    List<Proyecto> listar();

    int registrar(Proyecto proyecto);
}
