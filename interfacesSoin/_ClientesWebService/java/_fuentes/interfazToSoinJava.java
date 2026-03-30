
package com.soin.interfaces;

public final class interfazToSoinJava extends interfazToSoin
{

  private static String fnUserJava()
         throws Exception
  {
    return "JAVA:";
  }

  /* ----------------------------------------------------------------------------------- */

  public String
         sendToSoin (	String UrlSoin, 
											String CESoin, String ESoin, String UidSoin, String PwdSoin, 
											String NumeroInterfaz, String IdProceso
								    )
         throws Exception
  {
    return sendToSoin (	UrlSoin, 
												CESoin, ESoin, UidSoin, PwdSoin, 
												NumeroInterfaz, IdProceso,
												fnUserJava()
								      );
  }

  public String
         sendToSoinXML( String UrlSoin, 
												String CESoin, String ESoin, String UidSoin, String PwdSoin, 
												String NumeroInterfaz, 
												String XML_IE, String XML_ID, String XML_IS,
												boolean XML_out
											)
         throws Exception
  {
    return sendToSoinXML( UrlSoin, 
												  CESoin, ESoin, UidSoin, PwdSoin, 
												  NumeroInterfaz, 
												  XML_IE, XML_ID, XML_IS,
													XML_out,
												  fnUserJava()
												);
	}
}
