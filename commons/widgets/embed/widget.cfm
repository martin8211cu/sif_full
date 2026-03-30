
<!--- leer configuracion --->
<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfset lvarEmbed=objParam.ObtenerValor("#request.WidCodigo#","001")>

<cfif lvarEmbed NEQ "">
	<cfsavecontent variable="embedVar"><cfoutput>#lvarEmbed#</cfoutput></cfsavecontent>
	<cfoutput>
		#embedVar#
	</cfoutput>
<cfelse>
	No se pudo obetener codigo externo.
</cfif>
