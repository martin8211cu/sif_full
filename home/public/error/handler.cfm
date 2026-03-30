<cftransaction action="rollback"/>
<!--- Este texto solo aparece si la página de error no se ejecutó --->
Ha ocurrido un error.  Por favor reintente m&aacute;s tarde.
<cftry>
	<cfinvoke component="home.Componentes.aspmonitor" method="MonitorearProceso" Estado="2" Error="#error#"/><!---- finalizado con error---->
	<cfinvoke component="home.Componentes.ErrorHandler" method="guardarError"
		error="#error#"
		returnvariable="errorid"/>
	<cfset Request.errorid = errorid>
	<cfset session.errorid = errorid>
	
	<cfif Not IsDefined('Request.NoErrorDisplay')>
		<cfinclude template="/home/public/error/display.cfm">
	</cfif>
<cfcatch type="any">
	<cfif IsDefined("error.RootCause")>
		<cfoutput>
		<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;background-color:##CCCCCC">
		<hr><strong>#error.RootCause.Message#</strong> <br>#error.RootCause.Detail#<br>
		<xmp>#error.RootCause.StackTrace#</xmp>
		<hr></div></cfoutput>
		<cfoutput>Error en handler_cfm: #cfcatch.Message#<br>#cfcatch.Detail#</cfoutput>
		<cfdump var="#error.RootCause#" label="Error en handler_cfm">
	<cfelseif IsDefined("cfcatch.RootCause")>
		<cfdump var="#cfcatch.RootCause#" label="Error en handler_cfm">
	<cfelse>
		<cfdump var="#error#" label="error en handler_cfm: error original">
	</cfif>
</cfcatch>
</cftry>
