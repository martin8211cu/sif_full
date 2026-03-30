<cfsetting enablecfoutputonly="yes">
<cfif CGI.SCRIPT_NAME NEQ '/cfmx/home/Componentes/mon_test/index.cfm'>
<cfinclude template="/home/check/aspmonitor-end.cfm">
</cfif>
<cfsetting enablecfoutputonly="no">