<cfif Not Isdefined("session.monitoreo")>
	<cfset session.monitoreo = StructNew()>
	<cfset session.monitoreo.SScodigo = ''>
	<cfset session.monitoreo.SMcodigo = ''>
	<cfset session.monitoreo.SPcodigo = ''>
	<cfset session.monitoreo.sessionid = 0>
</cfif>
<!---<cfif isdefined("application.politicas_pglobal.sesion.multiple") and application.politicas_pglobal.sesion.multiple NEQ 1>--->
    <cftry>
    <cfinvoke component="home.Componentes.aspmonitor" method="Monitoreo">
        <cfinvokeargument name="SScodigo" value="#session.monitoreo.SScodigo#">
        <cfinvokeargument name="SMcodigo" value="#session.monitoreo.SMcodigo#">
        <cfinvokeargument name="SPcodigo" value="#session.monitoreo.SPcodigo#">
    </cfinvoke>
    <cfcatch type="any2">
        <cflog file="monitoreo" text="Error en monitoreo: #cfcatch.Message# - #cfcatch.Detail#">
        <cfif IsDefined('session.sitio.ip') and session.sitio.ip is '10.7.7.30' and not IsDefined('url.noerr')>
            <cfthrow message="#cfcatch.Message# - #cfcatch.Detail#">
        </cfif>
    </cfcatch>
    </cftry>
<!---</cfif>--->
