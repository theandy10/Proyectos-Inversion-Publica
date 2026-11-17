# Auditoría técnica y de requisitos — T1

Evaluación de Laboratorio Nro 1 · **Lenguaje de Programación I** · CIBERTEC
Alumno: **Ander Vásquez** · Docente: **Jorge Enrique Ventura Gonzáles**
Fecha de la auditoría: **16/11/2026**

## 1. Entorno verificado

| Componente | Versión usada | Estado |
|---|---|---|
| JDK de compilación | 17.0.20 (Microsoft OpenJDK) | OK |
| JVM de ejecución | 26.0.1 | OK |
| Apache Tomcat | 11.0.4 (`jakarta.servlet` 6.1) | OK |
| Microsoft SQL Server | 2025 (17.0.1155.3) | OK |
| Eclipse | 2026-09 (Enterprise Java) | OK |
| Navegador de pruebas | Microsoft Edge (Chromium) | OK |

## 2. Cumplimiento de los ítems del examen

### Ítem 01 — Diseño y validaciones (4 pts)

| Requisito del enunciado | Implementación | Verificación |
|---|---|---|
| Diseño con Bootstrap | Bootstrap 5.3.3 servido localmente desde `assets/` | Sin llamadas a CDN; CSS/JS responden 200 |
| Nombre del proyecto obligatorio, 4–60 caracteres | `ValidadorProyecto` + `minlength`/`maxlength` | 3 chars rechazado · 4 y 60 aceptados · 61 rechazado |
| Descripción técnica opcional | Sin `required`, máximo 255 | Vacío aceptado · 255 aceptado · 256 rechazado |
| Fecha de inicio obligatoria y válida | `LocalDate.parse`, `required` | Vacío rechazado · `2027-02-30` rechazado |
| Fecha de culminación obligatoria | `required` + comparación con el inicio | Vacío rechazado · anterior al inicio rechazado |
| Fecha de culminación ≥ fecha de inicio | `fechaFin.isBefore(fechaInicio)` + `check` en BD | Fechas iguales aceptadas |
| Asesor técnico obligatorio | Campo `required` + validación de longitud 3–80 | Vacío y 2 chars rechazados |
| Presupuesto obligatorio y numérico | `BigDecimal`, > 0, máximo 2 decimales | `0`, `-5`, `abc`, `10.555` rechazados; `0.01` aceptado |
| Mensajes de error visibles | `invalid-feedback` de Bootstrap + alerta resumen | 4+ campos marcados en rojo, datos conservados |

Las validaciones se aplican **en el cliente** (`validacion.js`, atributos HTML5) y **en el servidor**
(`ValidadorProyecto`). El servidor es la autoridad: aunque se desactive JavaScript, los datos inválidos
no llegan a la base de datos.

### Ítem 02 — Registro (8 pts)

| Aspecto | Evidencia |
|---|---|
| Formulario con los 6 campos | `proyectos.jsp` (nombre, descripción, fechas, asesor, presupuesto) |
| Envío al controlador | `POST /ProyectoServlet` |
| Persistencia real en base de datos | `ProyectoDAO.registrar()` con `INSERT` y `PreparedStatement` |
| Confirmación al usuario | Alerta verde «El proyecto … se registró correctamente» |
| Acentos y caracteres especiales | «Construcción de Vía Expresa Ñuñoa» / «José Muñoz Ríos» guardados y mostrados correctamente |
| Integridad | Restricciones `CHECK` de fechas y presupuesto en la tabla |

### Ítem 03 — Listado (8 pts)

| Aspecto | Evidencia |
|---|---|
| Tabla con todos los campos | `id`, nombre, descripción, inicio, culminación, asesor, presupuesto |
| Datos traídos de la base de datos | `ProyectoDAO.listar()` con `SELECT` y `ResultSet` |
| Orden | `ORDER BY id_proyecto DESC` (el más reciente primero) |
| Formato de fechas y moneda | `dd/MM/yyyy` y `S/ 1,234.56` |
| Detalle por registro | Botón *Ver* con modal de Bootstrap |
| Estado vacío | Fila «No hay proyectos registrados todavía» |

## 3. Pruebas ejecutadas (44 comprobaciones)

Instancia Tomcat aislada en el puerto 8090, desplegando el WAR entregable.

| Bloque | Comprobaciones | Resultado |
|---|---|---|
| Listado y diseño | 9 | 9 OK |
| Registro válido con acentos | 6 | 6 OK |
| Validaciones del servidor | 22 | 22 OK |
| Seguridad (XSS, inyección SQL) | 3 | 3 OK |
| Base de datos (columnas y `CHECK`) | 2 | 2 OK |
| Restauración de datos de prueba | 2 | 2 OK |

Casos límite cubiertos: nombre de 3/4/60/61 caracteres, fechas iguales, fecha imposible
(`2027-02-30`), presupuesto `0`, `0.01`, `10.555`, `abc`, asesor de 2 caracteres y descripción
de 255/256 caracteres.

### Seguridad

- **XSS:** un nombre `<script>alert('x')</script>` se guarda y se muestra escapado
  (`&lt;script&gt;`); no se ejecuta en el listado ni en el modal.
- **Inyección SQL:** `Robert'); DROP TABLE dbo.proyectos;--` se almacena como texto; la tabla queda intacta
  porque todas las consultas usan `PreparedStatement`.

### Calidad de código

- `javac -Xlint:all --release 17`: **0 advertencias, 0 errores**.
- Patrón por capas: entidad → interfaz DAO → DAO JDBC → servlet → JSP.
- Configuración de base de datos externalizada en `db.properties` (versionada para el entorno académico).

## 4. Entregables

| Entregable | Ubicación |
|---|---|
| Código fuente | `src/main/java`, `src/main/webapp` |
| Script de base de datos (SQL Server) | `db/bd_proyectos_muni_sqlserver.sql` |
| Script alternativo (MySQL) | `db/bd_proyectos_muni_mysql.sql` |
| WAR listo para desplegar | `dist/T1_ProyectosMuni.war` |
| Proyecto de Eclipse | `.project`, `.classpath`, `.settings/` |
| Repositorio | <https://github.com/theandy10/T1-Proyectos-Inversion-Publica> |

## 5. Observaciones

1. El proyecto está importado en Eclipse como `T1_ProyectosMuni` y asociado al servidor
   `apache-tomcat-11.0.4 at localhost`. Para ejecutarlo: clic derecho → `Run As → Run on Server`.
2. El puerto 8080 debe estar libre; si otra instancia de Tomcat está activa, Eclipse mostrará
   «Port 8080 required by Tomcat v11.0.4 Server at localhost is already in use».
3. `db.properties` contiene credenciales de desarrollo porque el docente necesita reproducir la
   evaluación. En un entorno productivo se usaría un *datasource* del servidor.
4. El driver `mssql-jdbc.jar` va dentro del WAR (`WEB-INF/lib`), por lo que no hay que configurarlo
   en Tomcat. Al detener la aplicación, Tomcat avisa que no pudo anular el registro del driver JDBC:
   es un aviso normal de `DriverManager` y no afecta el funcionamiento.
5. La base de datos debe existir antes de ejecutar la aplicación: `sqlcmd -S localhost -E -C -i db\bd_proyectos_muni_sqlserver.sql`.
