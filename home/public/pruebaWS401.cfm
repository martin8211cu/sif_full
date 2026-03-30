<cfset LvarXML_IE = 
"<resultset>
    <row>
        <CVdescripcion>Prueba interfaz 401 2</CVdescripcion>
        <CVtipo>1</CVtipo>
        <Ecodigo>1</Ecodigo>
        <CPPano>2014</CPPano>
        <CPPmes>3</CPPmes>
    </row>
</resultset>"
	>
    
<cfset LvarXML_ID = 
"<resultset>
    <row>
        <CPformato>0020-01-01-0000000002</CPformato>
        <CPdescripcion>Lápices</CPdescripcion>
        <CVPtipoControl>2</CVPtipoControl>
        <CVPcalculoControl>3</CVPcalculoControl>
        <Oficodigo>002</Oficodigo>
        <Miso4217>CRC</Miso4217>
        <CPCano1>2014</CPCano1>
        <CPCmes1>3</CPCmes1>
		<MonTotal>3500</MonTotal>
        <Monto1></Monto1>
        <Monto2></Monto2>
        <Monto3></Monto3>
        <Monto4></Monto4>
        <Monto5></Monto5>
        <Monto6></Monto6>
        <Monto7></Monto7>
        <Monto8></Monto8>
        <Monto9></Monto9>
        <Monto10></Monto10>
        <Monto11></Monto11>
        <Monto12></Monto12>
    </row>
</resultset>"
	>

<cfset LvarXML_IS = "">

<cfinvoke
	webservice="http://10.7.7.78:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
	username="gustavof" password="sup3rman"
	method			= "sendToSoinXML"
	returnvariable	= "LvarXML"
	
	Empresa			= "soin"
	EcodigoSDC		= "2"
	Num_Interfaz	= "401"
	XML_IE			= "#LvarXML_IE#"
	XML_ID			= "#LvarXML_ID#"
	XML_IS			= "#LvarXML_IS#"
	XML_OUT 		= "true"
>
	
<cfoutput>
	MSG= #LvarXML.MSG#<br>
	ID = #LvarXML.ID#<br>
	XML_OE = <textarea cols="80" rows="10">#LvarXML.XML_OE#</textarea><BR>
	XML_OD = <textarea cols="80" rows="10">#LvarXML.XML_OD#</textarea><BR>
	XML_OS = <textarea cols="80" rows="10">#LvarXML.XML_OS#</textarea><BR>
</cfoutput>
