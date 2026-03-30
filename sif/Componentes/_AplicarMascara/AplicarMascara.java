public class AplicarMascara 
{
	public static String aplicar(String cuenta, String valor) 
	{
	  String  letra = "?";  
	  return aplicar_mascara(cuenta,valor, letra );
	}

	public static String 
         aplicar_mascara (String cuenta, String valor, String cual) 
	{
	  if (cuenta == null || cuenta.length() == 0) 
			return "";
	  if (valor == null || valor.length() == 0) 
			return cuenta;
	  StringBuffer sb = new StringBuffer(cuenta.length());
	  int pos = 0;
	  for (int i = 0; i < cuenta.length(); i++) 
		{
	    char ch = cuenta.charAt(i);
	    if (ch == cual.charAt(0) ) 
			{
	      sb.append(valor.charAt(pos++));
	      if (pos >= valor.length()) pos = 0;
	    } 
			else 
			{
	      sb.append(ch);
	    }
	  }
	  return sb.toString();
	}

  public static String
         extraerNivelesP (String CFformato, String nivelesP)
  {
		if (CFformato == null || CFformato.length() == 0 || nivelesP == null || nivelesP.length() == 0)
			return "";

    StringBuffer LvarCPformato = new StringBuffer("");
		String LvarNivelesP = ","+nivelesP+",";
		int Posicion = 0;
		while (true)
		{
			try
			{
        int LvarPto1 = LvarNivelesP.indexOf(",", Posicion);
				if (LvarPto1 == -1)
					break;
				
				int	LvarPto2 = LvarNivelesP.indexOf("-", LvarPto1+1);
				if (LvarPto2 == -1)
					break;

				int	LvarPto3 = LvarNivelesP.indexOf(",", LvarPto2+1);
				if (LvarPto3 == -1)
					break;

				Posicion = LvarPto3;
				int LvarIni = Integer.parseInt(LvarNivelesP.substring(LvarPto1+1,LvarPto2)) - 1;
				int LvarFin = LvarIni + Integer.parseInt(LvarNivelesP.substring(LvarPto2+1,LvarPto3));

				LvarCPformato.append(CFformato.substring(LvarIni,LvarFin));
			}
	    catch (Exception e) 
			{
				return "";
			}
		}
		return LvarCPformato.toString();
	}
}
