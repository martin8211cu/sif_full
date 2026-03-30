<cfparam name="session.tramites.dsn" default="tramites_cr">
<cfif session.tramites.dsn NEQ 'tramites_cr'>
	<cfset session.tramites = StructNew()>
	<cfset session.tramites.dsn = 'tramites_cr'>
	<cfinclude template="Operacion/portlet/ventanilla_sql.cfm">
</cfif>

<cflocation url="../menu/portal.cfm">