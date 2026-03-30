<cfset LvarXML_IE = "2010,01,-1,-1,-1">
    
<cfset LvarXML_ID = "">

<cfset LvarXML_IS = "">

<cfinvoke
	webservice="http://10.7.7.78:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
	username="gustavof" password="sup3rman"
	method			= "sendToSoinXML"
	returnvariable	= "LvarXML"
	
	Empresa			= "soin"
	EcodigoSDC		= "2"
	Num_Interfaz	= "406"
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
