Dim c   
Dim ws
Dim r
dim xml_IE
dim xml_ID
dim xml_IS

xml_IE = ""
xml_IE = xml_IE + "<resultset>"
xml_IE = xml_IE + "    <row>"
xml_IE = xml_IE + "       <moduloOrigen>01</moduloOrigen> "
xml_IE = xml_IE + "       <numeroDocumento>11111111</numeroDocumento> "
xml_IE = xml_IE + "       <numeroReferencia>11111111</numeroReferencia> "
xml_IE = xml_IE + "       <FechaDocumento>2000-01-01 01:01:01</FechaDocumento> "
xml_IE = xml_IE + "       <AnoPresupuesto>2000</AnoPresupuesto> "
xml_IE = xml_IE + "       <MesPresupuesto>1</MesPresupuesto> "
xml_IE = xml_IE + "       <NAPreversado></NAPreversado> "
xml_IE = xml_IE + "       <SoloConsultar>1</SoloConsultar> "
xml_IE = xml_IE + "	</row>"
xml_IE = xml_IE + "</resultset>"

xml_ID = ""
xml_ID = xml_ID + "<resultset>"
xml_ID = xml_ID + "    <row>"
xml_ID = xml_ID + "       <NumeroLinea>-123456789</NumeroLinea>" 
xml_ID = xml_ID + "       <TipoMovimiento>E</TipoMovimiento>" 
xml_ID = xml_ID + "       <CuentaFinanciera>XXXX</CuentaFinanciera>" 
xml_ID = xml_ID + "       <CodigoOficina>XXXX</CodigoOficina>" 
xml_ID = xml_ID + "       <CodigoMonedaOrigen>XXXX</CodigoMonedaOrigen>" 
xml_ID = xml_ID + "       <MontoOrigen>-12345678901234.5678</MontoOrigen>" 
xml_ID = xml_ID + "       <TipoCambio>-0.1234567890123456</TipoCambio>" 
xml_ID = xml_ID + "       <Monto>-12345678901234.5678</Monto>" 
xml_ID = xml_ID + "       <NAPreferencia>-123456789012345678</NAPreferencia>" 
xml_ID = xml_ID + "       <LINreferencia>-123456789</LINreferencia>" 
xml_ID = xml_ID + "	</row>"
xml_ID = xml_ID + "</resultset>"

xml_IS = ""

  

'---------------------------------------------------
'INVOCAR:
'	webservice	= "http://localhost:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
'	username	= "ymena" 	
'	password	= "inso2000"
'
'	method		= "sendToSoinXML(Empresa,EcodigoSDC,Num_Interfaz,XML_IE,XML_ID,xml_ID,XML_OUT)"
'	Parametros:
'		Empresa			= "soin"
'		EcodigoSDC		= "2"
'		Num_Interfaz		= "8"
'		XML_IE			= "#LvarXML_IE#"
'		XML_ID			= "#LvarXML_ID#"
'		xml_ID			= "#Lvarxml_ID#"
'		XML_OUT 		= "true"
'Este metodo da un RESULTADO con la siguiente estructura:
'	RESULTADO.ID
'	RESULTADO.MSG
'	RESULTADO.XML_OE
'	RESULTADO.XML_OD
'	RESULTADO.XML_OS
'---------------------------------------------------


'---------------------------------------------------
'OJO: CreateWebService NO FUNCIONA, se debe usar la forma de invocar un WebService
'ws = createWebService("http://localhost:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL","ymena","inso2000")
'set c = ws.sendToSoinXML ("soin","86","600",(xml),"","",true)
'---------------------------------------------------


'---------------------------------------------------
'ESTE EJEMPLO ES EN MS-SOAP-3
set ws = CreateObject("MSSOAP.SOAPClient30")
ws.mssoapinit("http://localhost:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL")
'ws.ClientProperty("ServerHTTPRequest") = True
ws.ConnectorProperty("WinHTTPAuthScheme") = 1
ws.ConnectorProperty("AuthUser") 	= "obonilla66"
ws.ConnectorProperty("AuthPassword") 	= "sup3rman"
set c = ws.sendToSoinXML ("soin","2","8",(xml_IE),(xml_ID),(xml_IS),true)

'msgbox c.context.xml
msgbox "MSG = " 	& c(2).text
msgbox "ID = " 		& c(1).text
msgbox "XML_OE = " 	& c(4).text
msgbox "XML_OD = " 	& c(3).text
msgbox "XML_OS = " 	& c(5).text
'---------------------------------------------------

