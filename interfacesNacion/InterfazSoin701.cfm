<cfset componente = CreateObject("Component", "caracteres") >
<cfset xmlString = componente.procesaCaracteres(GvarXML_IE) >
<cfset resultado = "">
<cfinvoke component="WS.cajas.ws.InterfazRuteros" method="fnProcesaLiquidacionRuteros" returnvariable="resultado">
	<cfinvokeargument name="XMLString" value="#xmlString#">			
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