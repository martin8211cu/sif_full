<cfif isdefined("form.ACAid") and len(trim(form.ACAid))>
	<cfinvoke component="rh.asoc.Componentes.ACAsociados" method="get" acaid="#form.ACAid#" returnvariable="rsAsociado" long="true" Activo="#Lvar_Activo#">
	<cfset form.DEid = rsAsociado.DEid>
</cfif>
<cfif isdefined("form.DEid") and len(trim(form.DEid))>
	<cfinclude template="/rh/portlets/pEmpleado.cfm">
</cfif>