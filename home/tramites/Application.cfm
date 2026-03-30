<cfsetting enablecfoutputonly="yes">
<cfinclude template="../Application.cfm">
<cfinclude template="Operacion/portlet/ventanilla_sql.cfm">
<cfparam name="session.tramites.dsn" default="tramites_cr">
<cfset session.dsn = session.tramites.dsn>
<cfsetting enablecfoutputonly="no">