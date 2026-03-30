package com.soin.interfaces;

import java.io.*;
import java.util.*;
import java.net.*; 
import java.math.*;
import sun.misc.BASE64Encoder;
import sun.misc.BASE64Decoder;

public class interfazToSoin
{
  String    GvarLastURL = "";
  String    GvarLastUID = "";
  String    GvarLastPWD = "";
  String    GvarUID = "";

  String    GvarMSG = "";
  String    GvarID = "";
  String    GvarXML_OE = "";
  String    GvarXML_OD = "";
  String    GvarXML_OS = "";

  static Hashtable 		 	GvarLastCookies = new Hashtable();
  static BASE64Encoder 	LvarEncode = new BASE64Encoder();
  static BASE64Decoder 	LvarDecode = new BASE64Decoder();

  /* ----------------------------------------------------------------------------------- */
  protected String
         sendToSoin (	String UrlSoin, 
			String CESoin, String ESoin, String UidSoin, String PwdSoin, 
			String NumeroInterfaz, String IdProceso,
			String UID
		    )
         throws Exception
  {
    GvarUID 				= UID;
    GvarMSG 				= "";
    GvarID  				= IdProceso;
    GvarXML_OE 			= "";
    GvarXML_OD 			= "";
    GvarXML_OS 			= "";

    try
    {
      String LvarDatos		= "AU=" + fnCodifica(CESoin, ESoin, UidSoin, PwdSoin, NumeroInterfaz, IdProceso, GvarUID) + "&NI=" + NumeroInterfaz + "&ID=" + IdProceso;
      String LvarUrl		= UrlSoin + "?" + LvarDatos;
      URL url = new URL(LvarUrl);

      HttpURLConnection conn = (HttpURLConnection) url.openConnection();
      conn.setRequestMethod("GET");

      if (UrlSoin.equals(GvarLastURL) && UidSoin.equals(GvarLastUID) && PwdSoin.equals(GvarLastPWD))
        conn = writeCookies(conn);
      else
      {
        GvarLastCookies.clear();
        GvarLastURL = UrlSoin;
        GvarLastUID = UidSoin;
        GvarLastPWD = PwdSoin;
      }

      conn.setRequestProperty("Host", url.getHost());

      BufferedReader bufferedreader = new BufferedReader(new InputStreamReader(conn.getInputStream()));

      readCookies(conn);

      GvarMSG = conn.getHeaderField("SOIN-MSG");
      if (GvarMSG == null || GvarMSG.trim().equals(""))
      {
        GvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ: no hubo resultado";
      }
      else
      {
        GvarMSG = URLDecoder.decode(GvarMSG);
      }
    }  
    catch (Exception e) 
    {
      GvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ: " + e.toString();
    }

    if (GvarMSG.length() > 255)
    {
      GvarMSG = GvarMSG.substring(0,255);
    }

    return GvarMSG;
  }

  /* ----------------------------------------------------------------------------------- */
  protected String
         sendToSoinXML( String UrlSoin, 
												String CESoin, String ESoin, String UidSoin, String PwdSoin, 
												String NumeroInterfaz, 
												String XML_IE, String XML_ID, String XML_IS,
												boolean XML_output,
												String UID
											)
         throws Exception
  {
    GvarUID 				= UID;
    GvarMSG 				= "";
    GvarID  				= "";
    GvarXML_OE 			= "";
    GvarXML_OD 			= "";
    GvarXML_OS 			= "";

    BufferedReader rd = null;

    String RESPONSE = "";

    try
    {
      String LvarDatos			= "AU="  	+ URLEncoder.encode(fnCodifica(CESoin, ESoin, UidSoin, PwdSoin, NumeroInterfaz, "0", GvarUID));
      LvarDatos = LvarDatos	+ "&NI=" 	+ URLEncoder.encode(NumeroInterfaz);
      LvarDatos = LvarDatos	+ "&ID=" 	+ URLEncoder.encode("0");
      LvarDatos = LvarDatos	+ "&XML_IE=" 	+ URLEncoder.encode(XML_IE); 
      LvarDatos = LvarDatos	+ "&XML_ID=" 	+ URLEncoder.encode(XML_ID); 
      LvarDatos = LvarDatos	+ "&XML_IS=" 	+ URLEncoder.encode(XML_IS); 
	   	LvarDatos = LvarDatos	+ "&XML_OUT=" + (XML_output ? "1" : "0"); 
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
      GvarMSG = "ERROR ANTES DE LA INVOCACION DE LA INTERFAZ: " + e.toString();
    }

    try
    {
	    StringBuffer LvarXML = new StringBuffer("<interfazToSoinXMLResponse>");
	
	    LvarXML.append ("<response name=\"MSG\">").append(GvarMSG).append("</response>");
	
	    if (GvarID != null)
	      LvarXML.append ("<response name=\"ID\">").append(GvarID).append("</response>");
	
	    if (XML_output && GvarMSG.equals("OK"))
	    {
	      readerToXML("XML_OE",rd,LvarXML);
	      readerToXML("XML_OD",rd,LvarXML);
	      readerToXML("XML_OS",rd,LvarXML);
	    }

	    LvarXML.append ("</interfazToSoinXMLResponse>");
	    RESPONSE = LvarXML.toString();

	    if (XML_output && GvarMSG.equals("OK"))
	    {
		    GvarXML_OE = responseFromXML("XML_OE",RESPONSE);
		    GvarXML_OD = responseFromXML("XML_OD",RESPONSE);
		    GvarXML_OS = responseFromXML("XML_OS",RESPONSE);
	    }
    }  
    catch (Exception e) 
    {
      GvarMSG = "ERROR DESPUES DE LA INVOCACION DE LA INTERFAZ: " + e.toString();
	    StringBuffer LvarXML = new StringBuffer("<interfazToSoinXMLResponse>");
	
	    LvarXML.append ("<response name=\"MSG\">").append(GvarMSG).append("</response>");
	
	    if (GvarID != null)
	      LvarXML.append ("<response name=\"ID\">").append(GvarID).append("</response>");

	    LvarXML.append ("</interfazToSoinXMLResponse>");
	    RESPONSE = LvarXML.toString();
    }
    return RESPONSE;
  }

  /* ----------------------------------------------------------------------------------- */

  public static String
         responseFromXML (String responseType, String responseXML)
         throws Exception
  {
    int LvarPtoIni;
    int LvarPtoFin;

    LvarPtoIni = responseXML.indexOf("<response name=\"" + responseType + "\">");
    if (LvarPtoIni == -1)
      return "";

    LvarPtoIni = responseXML.indexOf(">", LvarPtoIni) + 1;

    LvarPtoFin = responseXML.indexOf("</response>", LvarPtoIni);
    if (LvarPtoFin == -1)
      return "";

    return responseXML.substring(LvarPtoIni, LvarPtoFin);
  }

  public String getMSG()
  {
    return GvarMSG;
  }

  public String getID()
  {
    return GvarID;
  }

  public String getXML_OE()
  {
    return GvarXML_OE;
  }

  public String getXML_OD()
  {
    return GvarXML_OD;
  }

  public String getXML_OS()
  {
    return GvarXML_OS;
  }

  public static String STRencode(String dato)
				throws Exception
  {
    int    i;
    StringBuffer strOut  = new StringBuffer("");
    int    	 lenData = dato.length();
    char[] 	 bytData = new char[lenData];

    dato.getChars(0,lenData,bytData,0);
    for (i = 0; i<lenData; i++)
    {
       if (bytData[i] == 13)          // chr(13) + chr(10) o chr(13) lo convierte a chr(10)
       {
         if (i == lenData-1)
           strOut.append((char) 10);
         else if (bytData[i + 1] != 10)
           strOut.append((char) 10);
       }
       else if (bytData[i] == 34)
         strOut.append("&quot;");
       else if (bytData[i] == 38)
         strOut.append("&amp;");
       else if (bytData[i] == 39)
         strOut.append("&apos;");
       else if (bytData[i] == 60)
         strOut.append("&lt;");
       else if (bytData[i] == 62)
         strOut.append("&gt;");
       else if (bytData[i] == 9 || bytData[i] == 10 || (bytData[i] >= 32 && bytData[i] <= 126))
         //ok in range 32 to 126 and not any other special character so just append the character
         strOut.append((char) bytData[i]);
       else if (bytData[i] >= 0 && bytData[i] <= 31)
         ; //strOut = strOut & ""    	// Caracter incorrecto: se ignora
       else if (bytData[i] >= 128 && bytData[i] <= 255)
         strOut.append("&#x").append(Integer.toHexString(bytData[i])).append(";");
       else       			// 128 to 65535
         strOut.append("&#x").append(Integer.toHexString(bytData[i])).append(";");
    }
    
    return strOut.toString();
  }

  private static int byteToInt(byte b)
  {
    return (b & 0xff);
  }

  public static String STRdecode(String strData)
         throws Exception
  {
    int i;
    String strChar = "";
    StringBuffer strOut = new StringBuffer("");
    int pPos = 0;
    int pos  = 0;
    int pos3 = 0;
    
    pos = strData.indexOf("&",pPos);
    if (pos == -1)
      return strData;
    else
    {
        while (pos != -1)
        {
          strOut.append(strData.substring(pPos, pos));
          pos3 = strData.indexOf(";",pos);
          if (pos3 > pos)
          {

            strChar = strData.substring(pos, pos3).toLowerCase();
            if (strChar.equals("&gt;"))
              strOut.append(">");
            else if (strChar.equals("&lt;"))
              strOut.append("<");
            else if (strChar.equals("&apos;"))
              strOut.append("'");
            else if (strChar.equals("&quot;"))
              strOut.append("\"");
            else if (strChar.equals("&amp;"))
              strOut.append("&");
            else if (strChar.substring(0, 3).equals("&#x"))
            {
              strChar = strChar.substring(3,strChar.length());
              // if (isnumeric(strChar))
              strOut.append((char) Integer.parseInt(strChar,16));
            }
            else if (strChar.substring(0, 2).equals("&#"))
            {
              strChar = strChar.substring(2,strChar.length());
              // if (isnumeric(strChar))
              strOut.append((char) Integer.parseInt(strChar,10));
            }
            else 
            {
              strOut.append ("&");
              pos3 = pPos;
            }
          }
          else 
          {
            strOut.append ("&");
            pos3 = pPos;
          }
          pPos = pos3 + 1;
          pos = strData.indexOf("&",pPos);
        }
        if (pPos <= strData.length())
          strOut.append (strData.substring(pPos));
        return strOut.toString();
    }
  }

  public static String BASE64encode(byte[] dato)
         throws Exception
  {
    return LvarEncode.encode(dato);
  }

  public static byte[] BASE64decode(String dato)
	throws Exception
  {
    return LvarDecode.decodeBuffer(dato);
  }

  public static String DATEencode(java.util.Date dato)
         throws Exception
  {
	java.sql.Timestamp ts = new java.sql.Timestamp(dato.getTime());
	return ts.toString().substring(0,19);
  }

  public static java.util.Date DATEdecode(String dato)
	throws Exception
  {
	java.util.Date d = new java.util.Date(java.sql.Timestamp.valueOf(dato).getTime());
	return d;
  }

  /* ----------------------------------------------------------------------------------- */

  protected static void
         readerToXML (String response, BufferedReader rd, StringBuffer LvarXML)
         throws Exception
  {
    String LvarLine = "";
    boolean LvarIncluir = false;
    int LvarIni = 0;
    int LvarFin = 0;
    while ((LvarLine = rd.readLine()) != null) 
    {
      LvarLine = URLDecoder.decode(LvarLine).trim();
      if (LvarIncluir == false)
      {
				LvarIni = LvarLine.indexOf("<response name=\"" + response + "\">");
        if (LvarIni > -1)
          LvarIncluir = true;
      }
			else
				LvarIni = 0;

			LvarFin = LvarLine.indexOf("</response>", LvarIni);
      if (LvarIncluir)
      {
			  if (LvarFin > -1)
        	LvarXML.append (LvarLine.substring(LvarIni, LvarFin+11));
				else
        	LvarXML.append (LvarLine.substring(LvarIni));
      }

      if (LvarFin > -1)
        break;
    }
  }

  /**
   * Envia todos los cookies almacenados al Servidor WEB
   *
   * @param   urlConn  		The connection to write the cookies to.
   *
   * @return  The urlConn with the all the cookies in it.
  */
  public static HttpURLConnection writeCookies(HttpURLConnection urlConn)
  {
    String LvarCookies = "";
    Enumeration LvarCookieKeys = GvarLastCookies.keys();
    while (LvarCookieKeys.hasMoreElements()) 
    {
      String LvarCookieKey = (String) LvarCookieKeys.nextElement();
      String LvarCookieVal = (String) GvarLastCookies.get(LvarCookieKey);
      LvarCookies += LvarCookieKey + "=" + LvarCookieVal;
      if (LvarCookieKeys.hasMoreElements())
         LvarCookies += "; ";
    }
    urlConn.setRequestProperty("Cookie", LvarCookies);

    return urlConn;
  }

  /**
   * Lee las Cookies que vienen del Servidor y las almacena en un Hashtable
   *
   * @param   urlConn  	the connection to read from
  */
  public static void readCookies(URLConnection urlConn)
  {
    String LvarHdrCookies = urlConn.getHeaderField("Set-Cookie");
    if (LvarHdrCookies != null) 
    {
      StringTokenizer st = new StringTokenizer(LvarHdrCookies,",");
      while (st.hasMoreTokens()) 
      {
        String s = st.nextToken();
        String LvarCookie = s.substring(0, s.indexOf(";"));
        int j = LvarCookie.indexOf("=");
        if (j != -1) 
        {
          String LvarCookieKey = LvarCookie.substring(0, j);
          String LvarCookieVal = LvarCookie.substring(j+1);
          GvarLastCookies.put(LvarCookieKey,LvarCookieVal);
        }
      }
    }
  }

  protected static String fnCodifica(String CESoin, String ESoin, String UidSoin, String PwdSoin, String NumeroInterfaz, String IdProceso, String UID)
          throws Exception
  {
     String LvarAU = "";
     if (!isNumber(ESoin))
       throw new Exception("El codigo de Empresa no es numérico");
     if (!isNumber(NumeroInterfaz))
       throw new Exception("El Número de Interfaz no es numérico");
     if (!isNumber(IdProceso))
       throw new Exception("El ID de Proceso no es numérico");
     //if (GvarUID.length() == 0)
       //GvarUID = fnUserDB();


     String LvarAUstr = CESoin + "," + ESoin + "," + UidSoin + "," + PwdSoin + "," + UID;

     BigInteger ID = new BigInteger(IdProceso);
     BigInteger LN = new BigInteger(""+LvarAUstr.length());
     int LvarPos = ID.remainder(LN).intValue() + 1;
     int LvarRnd = (int) Math.floor(Math.random()*256);

     byte[] LvarAUbts = LvarAUstr.getBytes();
     int LvarXor = 1;
     for (int i=0; i<LvarAUbts.length; i++)
     {
        LvarXor = LvarXor ^ LvarAUbts[i];
     }

     StringBuffer LvarAUcod = new StringBuffer("");
     for (int i=0; i<LvarAUbts.length; i++)
     {
        int LvarChar = LvarAUbts[i] ^ LvarRnd;
        if (i+1 == LvarPos)
        {
          LvarAUcod.append(fnHex(LvarRnd));
          LvarAUcod.append(fnHex(LvarXor));
        }
        LvarAUcod.append(fnHex(LvarChar));
     }
     return LvarAUcod.toString();
  }
  
  private static String fnHex(int LprmInt)
  {
    if (LprmInt < 16)
      return "0" + Integer.toHexString(LprmInt);
    else
      return Integer.toHexString(LprmInt);
  }

  private static boolean isNumber(String LprmString)
  {
    for (int i=0; i<LprmString.length(); i++)
    {
      if (LprmString.charAt(i) < '0' || LprmString.charAt(i) > '9')
        return false;
    }
    return true;
  }
}
