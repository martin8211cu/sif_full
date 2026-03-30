<cfset session.dsn = "minisif">
<cfif not isdefined("form.nuevo")>
	<cfquery name="rs" datasource="#session.dsn#">
		select getdate()	
	</cfquery>
	
	<cfset param = "textfield2=1">
<cfelse>
	<cfset param = "">	
</cfif>
<cflocation url="prueba-colo.cfm?#param#">