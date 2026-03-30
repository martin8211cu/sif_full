
	<!--- iframe --->
<cfif not IsDefined("request.WidCodigo")>
	<cfset request.WidCodigo = "#url.codewidget#">
</cfif>


 <cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfset lvarEmbed=objParam.ObtenerValor("#request.WidCodigo#","001")>
<cfset lvarHeight=objParam.ObtenerValor("#request.WidCodigo#","002")>
<cfset lvarWidth=objParam.ObtenerValor("#request.WidCodigo#","003")>

<cfif lvarEmbed NEQ "">
	<cfsavecontent variable="embedVar"><cfoutput>#lvarEmbed#</cfoutput></cfsavecontent>
	
	<aside style="background-color:##FFF"> 
		
		<iframe name="ifrCuentas" 
		style="vertical-align:top;"
		frameborder="0"
		src=<cfoutput>#lvarEmbed#</cfoutput> 
		width=
			<cfif lvarWidth EQ "">
				'100%' 
			<cfelse>
				<cfoutput>#lvarWidth&'px'#</cfoutput>
			</cfif>

		height=
			<cfif lvarHeight EQ "">
				'100%' 
			<cfelse>
				<cfoutput>#lvarHeight&'px'#</cfoutput>
			</cfif>
			>
		</iframe> 

	</aside>

<cfelse>
	No se pudo obtener codigo externo.
</cfif>  



