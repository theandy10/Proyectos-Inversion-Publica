package pe.cibertec.database;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

/**
 * Clase utilitaria que centraliza la conexion a la base de datos.
 * Los datos de conexion se leen de db.properties (WEB-INF/classes/db.properties).
 */
public class Conexion {

    private static final Properties PROPIEDADES = new Properties();

    static {
        try (InputStream entrada = Conexion.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (entrada == null) {
                throw new IllegalStateException("No se encontro db.properties en WEB-INF/classes");
            }
            PROPIEDADES.load(entrada);
        } catch (Exception e) {
            throw new ExceptionInInitializerError("No se pudo leer la configuracion de la base de datos: " + e.getMessage());
        }
    }

    private Conexion() {
    }

    public static Connection getConnection() throws Exception {
        Class.forName(PROPIEDADES.getProperty("db.driver"));
        return DriverManager.getConnection(
                PROPIEDADES.getProperty("db.url"),
                PROPIEDADES.getProperty("db.usuario"),
                PROPIEDADES.getProperty("db.clave"));
    }
}
