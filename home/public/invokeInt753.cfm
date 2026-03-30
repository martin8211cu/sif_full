<cfset LvarXML_IE = "
<resultset>
    <row>
        <Ecodigo>28</Ecodigo>
        <Justificacion>Probando Notas de credito</Justificacion>
        <esExterna>S</esExterna>
    </row>
</resultset>">
 
<cfset LvarXML_ID = "">

 
<cfset LvarXML_ID = "<resultset>
    <row>
		<NumDoc>LPT2498</NumDoc>
		<CodSistema>LIB</CodSistema>
		<NumLineaDet>1</NumLineaDet>
		<Monto>15686723000</Monto>
	</row>
</resultset>">

<cfinvoke
	webservice="http://172.16.5.86:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
	username	= "sinterfaces"
	password	= "interfaces2000"
	method		= "sendToSoinXML"
	returnvariable	= "LvarXML"
	Empresa			= "soin"
	EcodigoSDC		= "83"
	Num_Interfaz	= "753"
	XML_IE			= "#LvarXML_IE#"
	XML_ID			= "#LvarXML_ID#"
	XML_IS			= ""
	XML_OUT 		= "0"
 >
	 
<cfoutput>
	MSG		= #LvarXML.MSG#<br>
	ID 		= #LvarXML.ID#<br>
	XML_OE 	= #LvarXML.XML_OE#<br>
	XML_OD 	= #LvarXML.XML_OD#<br>
	XML_OS 	= #LvarXML.XML_OS#<br>
</cfoutput>
