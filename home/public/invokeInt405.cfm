<!---Ecodigo--->
<!---Codigo Oficina--->
<!---Codigo Centro Funcional--->
<!---Tipo de Cuenta--->
<!---Cuenta Mayor--->
<!---Valores--->
<!---Niveles--->


 <!--- <cfset LvarXML_IE = "1,01,1,-1,GA,5000,01|01,9|10,1"> (405) --->
 <!--- <cfset LvarXML_IE = "-1,-1,-1,-1,-1,-1,-1,-1,1"> --->

 <cfset LvarXML_IE =
 "<resultset>

  <row>

    <Ecodigo>1</Ecodigo>

    <Oficodigo>-1</Oficodigo>

    <CFcodigo>601</CFcodigo>

    <DEidentificacion>-1</DEidentificacion>

    <TipoCuenta>-1</TipoCuenta>

    <Cmayor>-1</Cmayor>

    <ListaPCDvalor>-1</ListaPCDvalor>

    <ListaPosiciones>-1</ListaPosiciones>

    <Orderby>0</Orderby>

  </row>

</resultset>">


  <cfset LvarXML_ID = "">
  <cfset LvarXML_IS = "">
  <cfsetting requesttimeout="30000">


 <cfinvoke 
		webservice="http://172.20.18.33/cfmx/interfacesSoin/ws/interfaz.cfc?WSDL"
		username	="tecrh"
		password	="12345x"

		method		= "sendToSoinXML"
		returnvariable	= "LvarXML"
	
		Empresa			= "itcr"
		EcodigoSDC		= "2"
		
		Num_Interfaz	= "405"
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


