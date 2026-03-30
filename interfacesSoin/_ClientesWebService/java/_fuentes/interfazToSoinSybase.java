package com.soin.interfaces;

import java.sql.*;
import com.sybase.jdbc2.jdbc.*;

public class interfazToSoinSybase extends com.soin.interfaces.interfazToSoinSQL
{
  private static String fnUserDB()
         throws Exception
  {
    Statement stmt = fnOpenSQL(
																"sybase.asejdbc.ASEDriver", "jdbc:default:connection",
																"integer", 		9,				// DBSmaxInteger
																"numeric",
																"float",
																"varchar", 		16384,		// DBSmaxString
																"text",
																"varbinary", 	16384,		// DBSmaxBinary
																"image",
																"datetime"
															);
    ResultSet rset = fnSQL(stmt, "SELECT suser_name()");
    String LvarUserDB = "";
    while (rset.next())
       LvarUserDB = rset.getString(1);
    stmt.close();
    return LvarUserDB;
  }

  /* ----------------------------------------------------------------------------------- */

  public static String
         sendToSoin (	String UrlSoin, 
											String CESoin, String ESoin, String UidSoin, String PwdSoin, 
											String NumeroInterfaz, String IdProceso
								    )
         throws Exception
  {
		interfazToSoin x = new interfazToSoin();
    return x.sendToSoin (	UrlSoin, 
													CESoin, ESoin, UidSoin, PwdSoin, 
													NumeroInterfaz, IdProceso,
													fnUserDB()
									      );
  }

  public static String
         sendToSoinXML( String UrlSoin, 
												String CESoin, String ESoin, String UidSoin, String PwdSoin, 
												String NumeroInterfaz, 
												String XML_IE, String XML_ID, String XML_IS,
												boolean XML_out
											)
         throws Exception
  {
		interfazToSoin x = new interfazToSoin();
    return x.sendToSoinXML( UrlSoin, 
													  CESoin, ESoin, UidSoin, PwdSoin, 
													  NumeroInterfaz, 
													  XML_IE, XML_ID, XML_IS,
														XML_out,
													  fnUserDB()
													);
  }

  public static String
         sendToSoinSQL( String UrlSoin, 
												String CESoin, String ESoin, String UidSoin, String PwdSoin, 
												String NumeroInterfaz, 
												String XML_IE, String XML_ID, String XML_IS,
												boolean XML_out
											)
         throws Exception
  {
		interfazToSoinSQL x = new interfazToSoinSQL();
    return x.sendToSoinSQL( UrlSoin, 
													  CESoin, ESoin, UidSoin, PwdSoin, 
													  NumeroInterfaz, 
													  XML_IE, XML_ID, XML_IS,
														XML_out,
													  fnUserDB()
													);
  }
}
