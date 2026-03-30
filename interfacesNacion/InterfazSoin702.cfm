<!--- Incluye una Factura Directa 
	Recibe de la variable global GvarXML_IE, una hilera xml con el formato transacciones
	que se puede ver en http://s-aplicaciones:8080/cfmx/WS/cajas/dtds/FactDirectas.dtd
	Devuelve el resultado de la operacion en la variable global GvarXML_IE
--->
<!---Invoque el componente para Procesar los Caracteres que el xml no puede procesar--->

<cfset componente = CreateObject("Component", "caracteres") >
<cfset xmlString = componente.procesaCaracteres(#GvarXML_IE#) >
<cfset resultado = "">

<cfinvoke webservice="http://172.16.5.85:8300/cfmx/WS/cajas/ws/IS702.cfc?WSDL" method="incluye_facturadirecta" returnvariable="resultado">
<!---CAMBIAR  DIRECCION 
	EN PRODUCCION 172.16.19.24:8080
	EN PRUEBAS 172.16.5.85:8300
--->
	<cfinvokeargument name="xmlString" value="#xmlString#">			
	
</cfinvoke>

<cfset GvarXML_OE = "#resultado#" >
<cftry>
	<cfcatch type = "ANY">
		<cfset envio = "Error: #CFCATCH.message#, Detalle: #CFCATCH.detail#" >
	</cfcatch>
</cftry>
<cfif GvarXML_OE NEQ "OK">
	<cfthrow message="#GvarXML_OE#">
</cfif>	