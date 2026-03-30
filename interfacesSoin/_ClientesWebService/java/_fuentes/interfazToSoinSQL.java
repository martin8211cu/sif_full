package com.soin.interfaces;

import java.io.*;
import java.util.*;
import java.net.*; 
import java.math.*;

import java.sql.*;

public class interfazToSoinSQL extends interfazToSoin
{
  static String    			GvarJDBCdriver   = "";
  static String    			GvarJDBCconector = "";

  static String    			GvarDBSinteger    = "";
  static int	    			GvarDBSmaxInteger = 0;
  static String    			GvarDBSnumber     = "";
  static String    			GvarDBSfloat      = "";
  static String    			GvarDBSstring     = "";
  static int	    			GvarDBSmaxString  = 0;
  static String    			GvarDBSbigString  = "";
  static String    			GvarDBSbinary     = "";
  static int	    			GvarDBSmaxBinary  = 0;
  static String    			GvarDBSbigBinary  = "";
  static String    			GvarDBSdate       = "";

  String GvarXML = null;

  int GvarPASO						= -1;
  int GvarResponsePtoIni	= -1;
  int GvarResponsePtoFin	= -1;
  int GvarChildPtoIni			= -1;
  int GvarChildPtoFin			= -1;
  int GvarRowPtoIni 			= -1;
  int GvarRowPtoFin 			= -1;
  int GvarColPtoIni 			= -1;
  int GvarColPtoFin 			= -1;

	Vector GvarCols = new Vector(10,10);

  /* ----------------------------------------------------------------------------------- */
  protected String
         sendToSoinSQL( String UrlSoin, 
												String CESoin, String ESoin, String UidSoin, String PwdSoin, 
												String NumeroInterfaz, 
												String SQL_IE, String SQL_ID, String SQL_IS,
												boolean XML_output,
												String UID
											)
         throws Exception
  {
    String XML_IE = "";
    String XML_ID = "";
    String XML_IS = "";
    BufferedReader rd = null;

	  GvarUID					= UID;
    GvarMSG 				= "";
    GvarID  				= "";
    GvarXML_OE 			= "";
    GvarXML_OD 			= "";
    GvarXML_OS 			= "";

    String RESPONSE = "";

    try
    {
			GvarPASO = 1;		// Invocando la Interfaz
      String LvarDatos		= "AU="  	+ URLEncoder.encode(fnCodifica(CESoin, ESoin, UidSoin, PwdSoin, NumeroInterfaz, "0", GvarUID));
      LvarDatos = LvarDatos	+ "&NI=" 	+ URLEncoder.encode(NumeroInterfaz);
      LvarDatos = LvarDatos	+ "&ID=" 	+ URLEncoder.encode("0");
	   	LvarDatos = LvarDatos	+ "&XML_OUT=" + (XML_output ? "1" : "0"); 
	   	LvarDatos = LvarDatos	+ "&XML_DBS=1"; 

      String LvarUrl		= UrlSoin;
      URL url = new URL(LvarUrl);

      HttpURLConnection conn = (HttpURLConnection) url.openConnection();

      conn.setRequestMethod("POST");
      conn.setDoInput( true);
      conn.setDoOutput( true);

      conn.setRequestProperty("Host", url.getHost());

      if (UrlSoin.equals(GvarLastURL) && UidSoin.equals(GvarLastUID) && PwdSoin.equals(GvarLastPWD))
        conn = writeCookies(conn);
      else
      {
        GvarLastCookies.clear();
        GvarLastURL = UrlSoin;
        GvarLastUID = UidSoin;
        GvarLastPWD = PwdSoin;
      }

      OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream());
      out.write(LvarDatos);

			GvarPASO = 0;		// Convirtiendo Datos de Entrada del SQL al XML
      out.write("&XML_IE=");
      if (SQL_IE != null && !SQL_IE.trim().equals(""))
				SQLtoXMLoutURLEncoder(out, SQL_IE);
      out.write("&XML_ID=");
      if (SQL_ID != null && !SQL_ID.trim().equals(""))
				SQLtoXMLoutURLEncoder(out, SQL_ID);
      out.write("&XML_IS=");
      if (SQL_IS != null && !SQL_IS.trim().equals(""))
				SQLtoXMLoutURLEncoder(out, SQL_IS);

      out.write( "\r\n");
      out.flush();
      out.close();

      rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));

      readCookies(conn);

      GvarMSG = conn.getHeaderField("SOIN-MSG");
      GvarID  = conn.getHeaderField("SOIN-ID");
      if (GvarMSG == null || GvarMSG.trim().equals(""))
        GvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ: no hubo resultado";
      else
        GvarMSG = URLDecoder.decode(GvarMSG);
    }  
    catch (Exception e) 
    {
			if (GvarPASO == 0)
      	GvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ (Conversion de los SQLs de Datos de Entrada a XML): " + e.toString();
			else
      	GvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ (Durante la invocacion a la Interfaz): " + e.toString();
    }

    try
    {
			GvarPASO = 10;		// Interpretando XML resultado
	    StringBuffer LvarXML = new StringBuffer("<interfazToSoinXMLResponse>");
	
			LvarXML.append ("<response name=\"MSG\">").append(GvarMSG).append("</response>");
	
	    if (GvarID != null)
	      LvarXML.append ("<response name=\"ID\">").append(GvarID).append("</response>");
	
		  if (XML_output)
		  {
		    if (GvarMSG.equals("OK"))
		    {
			    StringBuffer LvarXMLtoSQL = new StringBuffer("<interfazToSoinXMLResponse>");

		      readerToXML("XML_OE",rd,LvarXMLtoSQL);
		      readerToXML("XML_OD",rd,LvarXMLtoSQL);
		      readerToXML("XML_OS",rd,LvarXMLtoSQL);

			    LvarXMLtoSQL.append ("</interfazToSoinXMLResponse>");

			    GvarXML = LvarXMLtoSQL.toString();
			    XMLtoSQL("OE", NumeroInterfaz);
			    XMLtoSQL("OD", NumeroInterfaz);
			    XMLtoSQL("OS", NumeroInterfaz);
		    }
		  }
			LvarXML.append ("</interfazToSoinXMLResponse>");
	    RESPONSE = LvarXML.toString();
    }  
    catch (Exception e) 
    {
      GvarMSG = "ERROR DESPUES DE LA INVOCACION DE LA INTERFAZ ";
			switch (GvarPASO)
			{
				case 10:
					GvarMSG += "(Durante la interpretacion del XML de Resultado): ";
					break;
				case 11:
					GvarMSG += "(Durante la ubicacion del ResponseType): ";
					break;
				case 12:
					GvarMSG += "(Interpretacion del XML dbStruct de Datos de Salida): ";
					break;
				case 13:
					GvarMSG += "(Creacion de la Tabla Fisica Local de Datos de Salida): ";
					break;
				case 14:
					GvarMSG += "(Correpondencia entre el XML dbStruct y la estructura de la Tabla Fisica Local de Datos de Salida): ";
					break;
				case 15:
					GvarMSG += "(Durante la insercion de los Datos de Salida en la Tabla Fisica Local): ";
					break;
			}

      String LvarMSG =  e.toString();

			int LvarPto = LvarMSG.indexOf("java.lang.Exception");
			if (LvarPto != -1)
				GvarMSG += LvarMSG.substring(LvarPto + 21);
			else
			{
				GvarMSG += LvarMSG;
				e.printStackTrace();
			}

	    StringBuffer LvarXML = new StringBuffer("<interfazToSoinXMLResponse>");
	
	    LvarXML.append ("<response name=\"MSG\">").append(GvarMSG).append("</response>");
	
	    if (GvarID != null)
	      LvarXML.append ("<response name=\"ID\">").append(GvarID).append("</response>");

	    LvarXML.append ("</interfazToSoinXMLResponse>");
	    RESPONSE = LvarXML.toString();
    }
    return RESPONSE;
  }


  private static String
         SQLtoXMLoutURLEncoder( OutputStreamWriter out, String SQL )
         throws Exception
  {
    return SQLtoXML( out, SQL );
  }

  private static String
         SQLtoXML( String SQL )
         throws Exception
  {
    return SQLtoXML( null, SQL );
  }

  private static String
         SQLtoXML( OutputStreamWriter out, String SQL )
         throws Exception
  {
    StringBuffer LvarXML = new StringBuffer("<resultset>");

    Statement stmt = fnOpenSQL();
    ResultSet rset = fnSQL(stmt, SQL);
    ResultSetMetaData LvarCols = rset.getMetaData();
    while (rset.next())
    {
      LvarXML.append("<row>");
      int i;
      for (i=1; i<=LvarCols.getColumnCount(); i++)
      {
         String LvarName  = LvarCols.getColumnName(i);
         int    LvarType  = LvarCols.getColumnType(i);
         String LvarValue = rset.getString(i);
         LvarValue = "";
         if (!rset.wasNull())
           switch (LvarType)
           {
             case Types.CHAR:
             case Types.VARCHAR:
             case Types.LONGVARCHAR:
               LvarValue = STRencode(rset.getString(i));
               break;
             case Types.CLOB:
               LvarValue = STRencode(rset.getClob(i).getSubString((long) 1, (int) rset.getClob(i).length()));
               break;

             case Types.TINYINT:
               LvarValue = rset.getByte(i)+"";
               break;
             case Types.SMALLINT:
               LvarValue = rset.getShort(i)+"";
               break;
             case Types.INTEGER:
               LvarValue = rset.getInt(i)+"";
               break;
             case Types.BIGINT:
               LvarValue = rset.getLong(i)+"";
               break;

             case Types.DOUBLE:
             case Types.REAL:
             case Types.FLOAT:
               LvarValue = rset.getDouble(i)+"";
               break;

             case Types.DECIMAL:
             case Types.NUMERIC:
               LvarValue = rset.getBigDecimal(i).toString();
               break;

             case Types.BIT:
             //case Types.BOOLEAN:
               if (rset.getBoolean(i))
                 LvarValue = "1";
               else
                 LvarValue = "0";
               break;

             case Types.DATE:
               LvarValue = DATEencode(rset.getDate(i));
               break;
             case Types.TIMESTAMP:
               LvarValue = DATEencode(rset.getTimestamp(i));
               break;
             case Types.TIME:
               LvarValue = DATEencode(rset.getTime(i));
               break;

             case Types.LONGVARBINARY:
             case Types.VARBINARY:
             case Types.BINARY:
               LvarValue = BASE64encode(rset.getBytes(i));
               break;

             case Types.BLOB:
               LvarValue = BASE64encode(rset.getBlob(i).getBytes((long) 1, (int) rset.getClob(i).length()));
               break;
         }
         LvarXML.append("<").append(LvarName).append(">").append(LvarValue).append("</").append(LvarName).append(">");
      }
      LvarXML.append("</row>");

			if (out != null)
				if (LvarXML.length() >= 65536)
				{
					out.write(URLEncoder.encode(LvarXML.toString()));
				}
    }

    LvarXML.append("</resultset>");

    stmt.close();
    return LvarXML.toString();
  }

  private void
         XMLtoSQL(String responseType, String numeroInterfaz)
         throws Exception
  {
		GvarPASO = 11;		// Ubicando el ResponseType
		if (!sbUbicarResponse("XML_" + responseType))
			return;

		GvarPASO = 12;		// Interpretando XML dbstruct
		fnXMLdbstruct(responseType, numeroInterfaz);

    try
    {
      Statement stmt = fnOpenSQL();
      ResultSet rset = fnSQL(stmt, "SELECT count(1) from " + responseType + numeroInterfaz + " where ID = " + GvarID);
	    while (rset.next())
	      if (rset.getInt(1) > 0)
				{
		      stmt.close();
					return;
				}
      stmt.close();
    }
    catch (Exception e) 
    {
			GvarPASO = 13;		// Crea Tabla Fisica Local
			fnCrearTabla(responseType, numeroInterfaz);
    }

		GvarPASO = 14;		// Verificando correspondencia entre XML dbstruct y Tabla Fisica Local
		sbVerificarCols(responseType, numeroInterfaz);

		GvarPASO = 15;		// Insertando datos XML a tabla fisica local
		if (!sbUbicarChild("recordset"))
			return;

		// Crea el SQL INSERT para el PreparedStatement
		interfazToSoinSQLcol LvarCol = null;
		StringBuffer LvarSQL1 = new StringBuffer("");
		StringBuffer LvarSQL2 = new StringBuffer("");
		for (int idx = 0; idx < GvarCols.size(); idx++)
		{
			if (idx == 0)
			{
				LvarSQL1.append("insert into ").append(responseType).append(numeroInterfaz+" (");
				LvarSQL2.append("values ( ");
			}
			else
			{
				LvarSQL1.append(", ");
				LvarSQL2.append(", ");
			}
			LvarCol = (interfazToSoinSQLcol) GvarCols.get(idx);
			LvarSQL1.append(LvarCol.name);
			LvarSQL2.append("?");
		}

		String LvarSQL = LvarSQL1.append(") ").toString() + LvarSQL2.append(")").toString();

		int idx = 0;
		int LvarRow = 0;
		while (fnNextRow())
		{
			LvarRow++;
			// Limpia Valores
			for (idx = 0; idx < GvarCols.size(); idx++)
			{
				((interfazToSoinSQLcol) GvarCols.get(idx)).value = "";
			}

			// Llena Valores
			idx = 0;
		  while (fnNextCol(idx))
		  {
				idx++;
		  }

			PreparedStatement pstm = fnOpenSQL(LvarSQL);

			for (idx = 0; idx < GvarCols.size(); idx++)
			{
				LvarCol = (interfazToSoinSQLcol) GvarCols.get(idx);
				int i = idx + 1;

				if (LvarCol.value.trim().equals(""))
				{
					if (LvarCol.mandatory)
						throw new Exception ("El campo '" + LvarCol.name + "' es obligatorio en la Tabla Fisica Local, pero no viene valor en los Datos de Salida XML para la fila " + LvarRow);
					else
						pstm.setNull(i, LvarCol.SQLtype);
				}
				else
				{
					switch (LvarCol.SQLtype)
					{
						case Types.CHAR:
						case Types.VARCHAR:
						case Types.LONGVARCHAR:
							pstm.setString(i, STRdecode(LvarCol.value));
							break;
						case Types.CLOB:
							String LvarStrValue = STRdecode(LvarCol.value);
							pstm.setCharacterStream(i, new StringReader(LvarStrValue), LvarStrValue.length());
							break;
				
						case Types.TINYINT:
							pstm.setByte(i, Byte.parseByte(LvarCol.value));
							break;
						case Types.SMALLINT:
							pstm.setShort(i, Short.parseShort(LvarCol.value));
							break;
						case Types.INTEGER:
							pstm.setInt(i, Integer.parseInt(LvarCol.value));
							break;
						case Types.BIGINT:
							pstm.setLong(i, Long.parseLong(LvarCol.value));
							break;
							
						case Types.DOUBLE:
						case Types.REAL:
						case Types.FLOAT:
							pstm.setDouble(i, Double.parseDouble(LvarCol.value));
							break;
							
						case Types.DECIMAL:
						case Types.NUMERIC:
							pstm.setBigDecimal(i, new BigDecimal(LvarCol.value));
							break;
							
						case Types.BIT:
							pstm.setBoolean(i, (LvarCol.value != "0"));
							break;
							
						case Types.DATE:
							pstm.setDate(i, new java.sql.Date (DATEdecode(LvarCol.value).getTime()));
							break;
						case Types.TIMESTAMP:
							pstm.setTimestamp(i, new java.sql.Timestamp (DATEdecode(LvarCol.value).getTime()));
							break;
						case Types.TIME:
							pstm.setTime(i, new java.sql.Time (DATEdecode(LvarCol.value).getTime()));
							break;
							
						case Types.LONGVARBINARY:
						case Types.VARBINARY:
						case Types.BINARY:
							pstm.setBytes(i, BASE64decode(LvarCol.value));
							break;
							
						case Types.BLOB:
							byte[] LvarBinValue = BASE64decode(LvarCol.value);
							pstm.setBinaryStream(i, new ByteArrayInputStream(LvarBinValue), LvarBinValue.length);
							break;
					}		// switch
				}			// if no blanco
			}				// for cada col

			pstm.executeUpdate();
		}					// while cada row
  }

  public boolean fnXMLdbstruct(String responseType, String numeroInterfaz)
         throws Exception
  {
		GvarCols.clear();
		interfazToSoinSQLcol LvarCol = null;

		if (!sbUbicarChild("dbstruct"))
			return false;

    while ( (LvarCol = fnNextColStruct()) != null)
		{
			GvarCols.add (LvarCol);
		}
		return true;
	}

  public void sbVerificarCols(String responseType, String numeroInterfaz)
         throws Exception
  {
    Statement stmt = fnOpenSQL();
    ResultSet rset = fnSQL(stmt, "SELECT * from " + responseType + numeroInterfaz + " where ID=-1");
    ResultSetMetaData LvarCols = rset.getMetaData();
    int i;
		int idx;
    for (i=1; i<=LvarCols.getColumnCount(); i++)
    {
			idx = fnBuscarCol(LvarCols.getColumnName(i));
			((interfazToSoinSQLcol) GvarCols.get(idx)).name = LvarCols.getColumnName(i);
			((interfazToSoinSQLcol) GvarCols.get(idx)).SQLtype = LvarCols.getColumnType(i);
			((interfazToSoinSQLcol) GvarCols.get(idx)).SQLpos = i;
		}
		for (idx=0; idx < GvarCols.size(); idx++)
		{
			if (((interfazToSoinSQLcol) GvarCols.get(idx)).SQLpos == -1)
				throw new Exception ("campo '" + ((interfazToSoinSQLcol) GvarCols.get(idx)).name + "' debe ser agregado en la tabla fisica local");
		}
	}

  public int fnBuscarCol(String colName)
         throws Exception
  {
		int i=0;
		String LvarColName = colName.toUpperCase();
		for (i=0; i < GvarCols.size(); i++)
		{
			if (((interfazToSoinSQLcol) GvarCols.get(i)).name.toUpperCase().equals(LvarColName))
				return i;
		}
		throw new Exception ("el campo '" + colName + "' no debe existir en la tabla fisica local");
	}

  public boolean fnCrearTabla(String responseType, String numeroInterfaz)
         throws Exception
  {
		StringBuffer SQL = new StringBuffer("");
		interfazToSoinSQLcol LvarCol = null;

		for (int i = 0; i < GvarCols.size(); i++)
		{
			if (i == 0)
				SQL.append("create table ").append(responseType).append(numeroInterfaz + " (");
			else
				SQL.append (",");

    	LvarCol = (interfazToSoinSQLcol) GvarCols.get(i);

			SQL.append (LvarCol.name).append(" ");

			switch (LvarCol.type)
			{
				case 'S':
					if (LvarCol.len < GvarDBSmaxString)
						SQL.append(GvarDBSstring).append("("+LvarCol.len+")");
					else
						SQL.append(GvarDBSbigString);
					break;
				case 'B':
					if (LvarCol.len < GvarDBSmaxBinary)
						SQL.append(GvarDBSbinary).append("("+LvarCol.len+")");
					else
						SQL.append(GvarDBSbigBinary);
					break;
				case 'N':
					if (LvarCol.ent == 0)
						SQL.append(GvarDBSfloat);
					else if (LvarCol.dec == 0 && LvarCol.len <= GvarDBSmaxInteger)
						SQL.append(GvarDBSinteger);
					else
						SQL.append(GvarDBSnumber).append("("+LvarCol.len+","+LvarCol.dec+")");
					break;
				case 'D':
					SQL.append(GvarDBSdate);
					break;
			}

			if (LvarCol.mandatory)
				SQL.append(" not null");
			else
				SQL.append(" null");
		}
		if ( SQL.toString().equals("") )
			return true;

		SQL.append(")");

		Statement stmt = fnOpenSQL();
		stmt.executeUpdate(SQL.toString());

		return true;
	}

  public boolean sbUbicarResponse(String responseType)
         throws Exception
  {
		GvarChildPtoIni = -1;
    GvarResponsePtoIni = fnBuscar("response name=\"" + responseType + "\"", 0);
    if (GvarResponsePtoIni == -1)
      return false;

    GvarResponsePtoFin = fnBuscar("/response", GvarResponsePtoIni);
    if (GvarResponsePtoFin == -1)
		{
    	GvarResponsePtoIni = -1;
      return false;
		}

		return true;
  }

  public boolean sbUbicarChild(String childType)
         throws Exception
  {
    if (GvarResponsePtoIni == -1)
      return false;

    GvarChildPtoIni = fnBuscar(childType, GvarResponsePtoIni);

    if (GvarChildPtoIni == -1 || GvarChildPtoIni > GvarResponsePtoFin)
      return false;

    GvarChildPtoFin = fnBuscar("/"+childType, GvarChildPtoIni);
    if (GvarChildPtoFin == -1 || GvarChildPtoFin > GvarResponsePtoFin)
		{
    	GvarChildPtoIni = -1;
      return false;
		}

  	GvarRowPtoFin = GvarChildPtoIni;
  	GvarColPtoFin = GvarChildPtoIni;
    return true;
  }

  private int fnBuscar(String element, int ini)
          throws Exception
	{
		if (GvarXML == null)
			return -1;

		int LvarPto = GvarXML.indexOf("<" + element + ">", ini);
		if (LvarPto < 0)
			LvarPto = GvarXML.indexOf("<" + element + " ", ini);

    return LvarPto;
	}

  public interfazToSoinSQLcol fnNextColStruct()
         throws Exception
  {
    if (GvarChildPtoIni == -1)
      return null;

		GvarColPtoIni = GvarXML.indexOf("<", GvarColPtoFin+1);

    if (GvarColPtoIni == -1 || GvarColPtoIni >= GvarChildPtoFin)
      return null;

		GvarColPtoFin = GvarXML.indexOf(">", GvarColPtoIni);

    if (GvarColPtoFin == -1 || GvarColPtoFin >= GvarChildPtoFin)
		{
    	GvarColPtoIni = -1;
      return null;
		}
		return new interfazToSoinSQLcol(GvarXML.substring(GvarColPtoIni, GvarColPtoFin+1));
	}

  public boolean fnNextRow()
         throws Exception
  {
    if (GvarChildPtoIni == -1)
      return false;

		GvarRowPtoIni = fnBuscar("row", GvarRowPtoFin+1);

    if (GvarRowPtoIni == -1 || GvarRowPtoIni >= GvarChildPtoFin)
      return false;

		GvarColPtoFin = GvarRowPtoIni + 1;
		GvarRowPtoFin = fnBuscar("/row", GvarRowPtoIni);

    if (GvarRowPtoFin == -1 || GvarRowPtoFin >= GvarChildPtoFin)
		{
    	GvarRowPtoIni = -1;
      return false;
		}
		return true;
	}

  public boolean fnNextCol(int idx)
         throws Exception
  {
    if (GvarRowPtoIni == -1)
      return false;

		GvarColPtoIni = GvarXML.indexOf("<", GvarColPtoFin+1);

    if (GvarColPtoIni == -1 || GvarColPtoIni >= GvarRowPtoFin)
      return false;

		GvarColPtoFin = GvarXML.indexOf(">", GvarColPtoIni);

    if (GvarColPtoFin == -1 || GvarColPtoFin >= GvarRowPtoFin)
		{
			GvarColPtoIni = -1;
      return false;
		}

		String LvarName = GvarXML.substring(GvarColPtoIni+1,GvarColPtoFin);

		if ( !((interfazToSoinSQLcol) GvarCols.get(idx)).name.toUpperCase().equals(LvarName.toUpperCase()) )
			throw new Exception ("El orden de los campos del XML Recordset no corresponde con el orden del XML dbStruct");

		GvarColPtoIni = GvarColPtoFin + 1;
		GvarColPtoFin = GvarXML.indexOf("</", GvarColPtoFin+1);

    if (GvarColPtoFin == -1 || GvarColPtoFin >= GvarRowPtoFin)
      return false;

		String LvarValue = GvarXML.substring(GvarColPtoIni,GvarColPtoFin);
		((interfazToSoinSQLcol) GvarCols.get(idx)).value = LvarValue;

		return true;
	}

  protected static Statement fnOpenSQL(
																				String driver, String jdbc,

																				String DBSinteger,
																				int    DBSmaxInteger,
																				String DBSnumber,
																				String DBSfloat,
																				String DBSstring,
																				int    DBSmaxString,
																				String DBSbigString,
																				String DBSBinary,
																				int    DBSmaxBinary,
																				String DBSbigBinary,
																				String DBSdate
																			)
						         throws Exception
  {
    GvarJDBCdriver   = driver;
    GvarJDBCconector = jdbc;

    GvarDBSinteger   = DBSinteger;
    GvarDBSmaxInteger= DBSmaxInteger;
    GvarDBSnumber    = DBSnumber;
    GvarDBSfloat     = DBSfloat;
    GvarDBSstring    = DBSstring;
    GvarDBSmaxString = DBSmaxString;
    GvarDBSbigString = DBSbigString;
    GvarDBSbinary    = DBSBinary;
    GvarDBSmaxBinary = DBSmaxBinary;
    GvarDBSbigBinary = DBSbigBinary;
    GvarDBSdate      = DBSdate;

    return fnOpenSQL();
  }

  private static Statement fnOpenSQL()
         throws Exception
  {
    Class.forName(GvarJDBCdriver);
    Connection conn = DriverManager.getConnection(GvarJDBCconector);
    Statement stmt = conn.createStatement();
    return stmt;
  }

  private static PreparedStatement fnOpenSQL(String pSQL)
         throws Exception
  {
    Class.forName(GvarJDBCdriver);
    Connection conn = DriverManager.getConnection(GvarJDBCconector);
    PreparedStatement pstmt = conn.prepareStatement(pSQL);
    return pstmt;
  }

  protected static ResultSet fnSQL(Statement stmt, String SQL)
         throws Exception
  {
    ResultSet rset = stmt.executeQuery (SQL);
    return rset;
  }

}
