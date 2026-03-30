public class AplicarMascara {

/**
 * Reemplaza los caracteres '?' en "cuenta" por los caracteres de "valor", uno a la vez
 * ej aplicar("42-?-??0", "123") regresa "42-1-230"
 */
public static String aplicar(String cuenta, String valor) {
  if (cuenta == null || cuenta.length() == 0) return "";
  if (valor == null || valor.length() == 0) return cuenta;
  StringBuffer sb = new StringBuffer(cuenta.length());
  int pos = 0;
  for (int i = 0; i < cuenta.length(); i++) {
    char ch = cuenta.charAt(i);
    if (ch == '?') {
      sb.append(valor.charAt(pos++));
      if (pos >= valor.length()) pos = 0;
    } else {
      sb.append(ch);
    }
  }
  return sb.toString();
}

}