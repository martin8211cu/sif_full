
<cfset LvarXML_IE = "
<resultset>
    <row>
    	<Ecodigo>1</Ecodigo>
        <SNcodigoext>435833</SNcodigoext>
        <CFcodigo>GI401</CFcodigo>
        <CodEmpresa>LN</CodEmpresa>
        <CodProducto>LN</CodProducto>
        <CodSeccion>SA</CodSeccion>
    </row>
</resultset>">

<!---        <CFcodigo>GI401</CFcodigo>
        <CodEmpresa>28</CodEmpresa>
        <CodProducto>28</CodProducto>
        <CodSeccion>28</CodSeccion>
--->
 
<cfset LvarXML_ID = "">

<cfset LvarXML_IS = "">


<cfinvoke
	webservice="http://172.16.5.86:8300/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
	username	= "sinterfaces"
	password	= "interfaces2000"
	method		= "sendToSoinXML"
	returnvariable	= "LvarXML"
	Empresa			= "soin"
	EcodigoSDC		= "83"
	Num_Interfaz	= "754"
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


----------------------------------------------------------------
