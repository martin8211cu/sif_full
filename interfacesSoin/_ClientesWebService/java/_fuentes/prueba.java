import com.soin.interfaces.interfazToSoinJava;
import com.soin.*;
import java.io.*;
import java.sql.Date;
import java.util.Date;


public class prueba {

  public static void main(String[] args) 
	throws Exception   
  {
	interfazToSoinJava x = new interfazToSoinJava();
	String LvarPrueba = "0011-03-02,0,2005-01-01,V";
	String r = x.sendToSoinXML(
		"http://localhost:8300/cfmx/interfacesSoin/webService/interfaz-serviceXML.cfm", 
    		"soin", "2", "marcel", "sup3rman", 
		"17", 
		LvarPrueba, "", "", true);
	System.out.println("MSG="+x.getMSG());        
	System.out.println("ID="+x.getID());        
	System.out.println("XML_OE="+x.getXML_OE());        
	System.out.println("XML_OD="+x.getXML_OD());        
	System.out.println("XML_OS="+x.getXML_OS());        
java.util.Date d1 = new java.util.Date();
java.sql.Date d2 = new java.sql.Date(d1.getTime());
java.sql.Time t = new java.sql.Time(d1.getTime());
java.sql.Timestamp ts = new java.sql.Timestamp(d1.getTime());
	System.out.println(x.DATEencode(d1));
	System.out.println(x.DATEencode(d2));
	System.out.println(x.DATEencode(t));
	System.out.println(x.DATEencode(ts));
String f="2005-10-06 16:16:35";
	System.out.println(x.DATEdecode(f));

f="Est™o Ávría sido ¢50 colones";
	System.out.println(f);
f=x.STRencode(f);
	System.out.println(f);
	System.out.println(x.STRdecode(f));
  }
}