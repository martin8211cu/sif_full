
<cfset LvarXML_IE = "<resultset>
    <row>
        <Ecodigo>1</Ecodigo>
	<Relacion>6</Relacion>
	<Nota>80</Nota>
	<Identificacion>601840925</Identificacion>
    </row>
</resultset>">

<cfsetting requesttimeout="30000">    
<cfinvoke
	webservice="http://172.20.18.33/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
	username = "tecrh"
	password = "12345x"

	method		= "sendToSoinXML"
	returnvariable	= "LvarXML"
	
	Empresa			= "itcr"
	EcodigoSDC		= "2"
	Num_Interfaz		= "419"
	XML_IE			= "#LvarXML_IE#"
	XML_ID			= ""
	XML_IS			= ""
	XML_OUT 		= "true">
	
<cfoutput>
	MSG		= #LvarXML.MSG#<br>
	ID 		= #LvarXML.ID#<br>
	XML_OE 	= #LvarXML.XML_OE#<br>
	
</cfoutput>




