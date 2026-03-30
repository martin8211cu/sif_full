<cfset LvarCC =1>
<cfif NOT isdefined("form.origen") OR mid(form.origen,1,2) NEQ "CC">
	<cfset url.Origen = 'CC'>
	<cfset form.Origen = 'CC'>
</cfif>
<cfset sufix = 'CC'>
<cfinclude template="../../cg/operacion/DocumentosContables.cfm">