<cfset LvarXML_IE = "
<resultset>
    <row>
        <Ecodigo>1</Ecodigo>
        <CFcodigo>00002</CFcodigo>
        <Sncodigoext>554</Sncodigoext>
        <Empresa>LN</Empresa>
        <Producto>LN</Producto>
        <Seccion>CR</Seccion>
        <Movimiento></Movimiento>
        <FormaPago></FormaPago>
        <Fecha></Fecha>
        <TipoResultado>2</TipoResultado>
    </row>
</resultset>">
 
<cfset LvarXML_ID = "">

<cfset LvarXML_IS = "">

<cfinvoke
	webservice="http://localhost:8502/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
	username	= "soin"
	password	= "sup3rman"
	method		= "sendToSoinXML"
	returnvariable	= "LvarXML"
	Empresa			= "soin"
	EcodigoSDC		= "2"
	Num_Interfaz	= "749"
	XML_IE			= "#LvarXML_IE#"
	XML_ID			= "#LvarXML_ID#"
	XML_IS			= "#LvarXML_IS#"
	XML_OUT 		= "true"
 >
	 
<cfoutput>
	MSG		= #LvarXML.MSG#<br>
	ID 		= #LvarXML.ID#<br>
	XML_OE 	= #LvarXML.XML_OE#<br>
	XML_OD 	= #LvarXML.XML_OD#<br>
	XML_OS 	= #LvarXML.XML_OS#<br>
</cfoutput>
