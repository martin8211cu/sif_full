<cfparam name="session.tramites.dsn" default="tramites_pa">
<cfif session.tramites.dsn NEQ 'tramites_pa'>
	<cfset session.tramites = StructNew()>
	<cfset session.tramites.dsn = 'tramites_pa'>
	<cfinclude template="Operacion/portlet/ventanilla_sql.cfm">
</cfif>

<cflocation url="../menu/portal.cfm">