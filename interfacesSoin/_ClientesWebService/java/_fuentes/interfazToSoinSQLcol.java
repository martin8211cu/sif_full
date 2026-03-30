package com.soin.interfaces;

public class interfazToSoinSQLcol
{
  public String  name="";
  public char	 	 type=0;
	public int		 len=0;
	public int		 ent=0;
	public int		 dec=0;
	public boolean mandatory=false;
	public int		 SQLtype = -1;
	public int		 SQLpos  = -1;
  public String  value="";

	public interfazToSoinSQLcol (String definition)
         throws Exception
	{
		name 			= fnValor("name", definition);
		type 			= fnValor("type", definition).charAt(0);
		len 			= Integer.parseInt(fnValor("len", definition));
		ent 			= Integer.parseInt(fnValor("ent", definition));
		dec 			= Integer.parseInt(fnValor("dec", definition));
		mandatory	= fnValor("mandatory", definition).equals("1");
	}

  private static String fnValor(String attribute, String definition)
         throws Exception
  {
		int LvarPtoIni = -1;
		int LvarPtoFin = -1;
		String LvarValue = "-1";

		LvarPtoIni = definition.indexOf(" "+attribute+"=");
		if (LvarPtoIni < 0)
			return "-1";

		LvarPtoIni = definition.indexOf("\"", LvarPtoIni) + 1;
		LvarPtoFin = definition.indexOf("\"", LvarPtoIni);

		LvarValue = definition.substring(LvarPtoIni, LvarPtoFin).trim();

		return (LvarValue.equals("") ? "-1" : LvarValue);
  }
}
