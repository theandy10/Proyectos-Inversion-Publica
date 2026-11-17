package pe.cibertec.util;

/**
 * Utilidad para escapar texto antes de mostrarlo en una pagina JSP.
 */
public final class Texto {

    private Texto() {
    }

    public static String escape(String valor) {
        if (valor == null) {
            return "";
        }
        StringBuilder salida = new StringBuilder(valor.length() + 16);
        for (int i = 0; i < valor.length(); i++) {
            char c = valor.charAt(i);
            switch (c) {
                case '&': salida.append("&amp;"); break;
                case '<': salida.append("&lt;"); break;
                case '>': salida.append("&gt;"); break;
                case '"': salida.append("&quot;"); break;
                case '\'': salida.append("&#39;"); break;
                default: salida.append(c);
            }
        }
        return salida.toString();
    }
}
