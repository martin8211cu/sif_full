package sp;

import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class LikeToRegEx
{
    public static int fnLIKE (
		String varchar,
		String likeMask 
	) throws SQLException, java.io.IOException
    {

		/* Esconde caracteres especiales SQL */
		likeMask = likeMask.replaceAll ("\\\\%",	"" + (char) 250 + (char) 1);
		likeMask = likeMask.replaceAll ("\\\\_",	"" + (char) 250 + (char) 2);
		likeMask = likeMask.replaceAll ("\\\\\\[",	"" + (char) 250 + (char) 3);
		likeMask = likeMask.replaceAll ("\\\\\\]",	"" + (char) 250 + (char) 4);
		likeMask = likeMask.replaceAll ("\\\\\\\\",	"" + (char) 250 + (char) 5);
		likeMask = likeMask.replaceAll ("\\\\","");

		/* ESCAPE de caracteres especial RegExp de ^ excepto que sea [^ */
		likeMask = likeMask.replaceAll ("\\^","\\\\^");
		likeMask = likeMask.replaceAll ("\\[\\\\\\^","[^");
		/* ESCAPE de los demas caracteres especiales RegExp (Buscar mas caracteres RegExp) */
		likeMask = likeMask.replaceAll ("\\.","\\\\.");
		likeMask = likeMask.replaceAll ("\\$","\\\\\\$");
		likeMask = likeMask.replaceAll ("\\*","\\\\*");
		likeMask = likeMask.replaceAll ("\\+","\\\\+");
		likeMask = likeMask.replaceAll ("\\?","\\\\?");
		likeMask = likeMask.replaceAll ("\\(","\\\\(");
		likeMask = likeMask.replaceAll ("\\)","\\\\)");
		likeMask = likeMask.replaceAll ("\\{","\\\\{");
		likeMask = likeMask.replaceAll ("\\}","\\\\}");
		likeMask = likeMask.replaceAll ("\\&","\\\\&");
	
		boolean LvarIni = likeMask.startsWith("%");
		boolean LvarFin = likeMask.endsWith("%");
	
		int LvarPto = likeMask.indexOf('%') + likeMask.indexOf('_') + likeMask.indexOf('[') + likeMask.indexOf(']') + 4;
		if (LvarPto >= 0)
		{
			likeMask = likeMask.replaceAll ("%","(.*)");
			likeMask = likeMask.replaceAll ("_","(.{1})");
		}
	
		/* Devuelve caracteres especiales SQL */
		likeMask = likeMask.replaceAll ( "" + (char) 250 + (char) 1,"%");
		likeMask = likeMask.replaceAll ( "" + (char) 250 + (char) 2,"_");
		likeMask = likeMask.replaceAll ( "" + (char) 250 + (char) 3,"\\\\[");
		likeMask = likeMask.replaceAll ( "" + (char) 250 + (char) 4,"\\\\]");
		likeMask = likeMask.replaceAll ( "" + (char) 250 + (char) 5,"\\\\\\\\");
	
		if (LvarIni)
			likeMask = "^" + likeMask;
		if (LvarFin)
			likeMask = likeMask + "$"; 

		try
		{
			Pattern p = Pattern.compile(likeMask);
			Matcher m = p.matcher(varchar);
			if (m.matches())
			{
				return 1;
			}
		}
		catch ( Exception e) {}
		
        return 0;
    }
}
