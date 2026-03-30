set define off;

CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "interfazToSoin" AS

import java.io.*;
import java.util.*;
import java.net.*; 
import java.math.*;
import java.sql.*;
import oracle.jdbc.*;

public class interfazToSoin
{
  static Hashtable GvarLastCookies = new Hashtable();
  static String    GvarLastURL = "";
  static String    GvarLastUID = "";
  static String    GvarLastPWD = "";
  static String    GvarUserDB = "";

  private static String fnUserDB()
         throws Exception
  {
    Connection conn = DriverManager.getConnection("jdbc:default:connection:");
    Statement stmt = conn.createStatement();
    ResultSet rset = stmt.executeQuery ("SELECT USER FROM DUAL");
    String LvarUserDB = "";
    while (rset.next())
       LvarUserDB = rset.getString(1);
    stmt.close();
    return LvarUserDB;
  }

  /* ----------------------------------------------------------------------------------- */

  public static String
         sendToSoin (String UrlSoin, String CESoin, String ESoin, String UidSoin, String PwdSoin, String NumeroInterfaz, String IdProceso)
         throws Exception
  {
    String RETORNO = "OK";
    return RETORNO;
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
        String LvarCookie = s.substring(0, s.indexOf(";")) + " ";
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

  private static String fnCodifica(String CESoin, String ESoin, String UidSoin, String PwdSoin, String NumeroInterfaz, String IdProceso)
          throws Exception
  {
     String LvarAU = "";
     if (!isNumber(ESoin))
       throw new Exception("El codigo de Empresa no es numérico");
     if (!isNumber(NumeroInterfaz))
       throw new Exception("El Número de Interfaz no es numérico");
     if (!isNumber(IdProceso))
       throw new Exception("El ID de Proceso no es numérico");
     if (GvarUserDB.length() == 0)
       GvarUserDB = fnUserDB();


     String LvarAUstr = CESoin + "," + ESoin + "," + UidSoin + "," + PwdSoin + "," + GvarUserDB;

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

;
/

set define on;

create or replace function interfazToSoin 
 (urlSoin IN VARCHAR2, CESoin IN VARCHAR2, ESoin IN VARCHAR2, uidSoin IN VARCHAR2, pwdSoin IN VARCHAR2, interfaz VARCHAR2, id VARCHAR2)
RETURN VARCHAR2 AS
LANGUAGE java NAME
'interfazToSoin.sendToSoin
(java.lang.String,
 java.lang.String,
 java.lang.String,
 java.lang.String,
 java.lang.String,
 java.lang.String,
 java.lang.String)
return java.lang.String'
;
/

/*
call dbms_java.revoke_permission('INTERFACES', 'java.net.SocketPermission', '*', 'accept, connect, listen, resolve'); 
call dbms_java.grant_permission('INTERFACES', 'java.net.SocketPermission', '10.7.7.201', 'accept, connect, listen, resolve'); 
call dbms_java.grant_permission('USUARIO_ORACLE', 'java.net.SocketPermission', '10.7.7.205', 'accept, connect, listen, resolve'); 
select interfazToSoin('http://10.5.10.17/cfmx/interfacesSoin/interfaz-service.cfm','','2','INTERFAZ','passw0rd','8','12345') as MSG from dual;
*/
call dbms_java.grant_permission('INTERFACES', 'java.net.SocketPermission', 'oracle.des.soin.net', 'accept, connect, listen, resolve'); 
select interfazToSoin('http://oracle.des.soin.net/cfmx/interfacesSoin/interfaz-service.cfm','soin','2','INTERFAZ','passw0rd','8','12345') as MSG from dual;

