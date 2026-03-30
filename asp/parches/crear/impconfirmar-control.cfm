<!--- actualizar/buscar/continuar --->

<cfinvoke component="asp.parches.comp.parche" method="get_entries" collection="importar" returnvariable="col"></cfinvoke>

<cfparam name="form.sel" default="">

<cfloop collection="#col#" item="mapkey">
	<cfif Not ListFind(form.sel, mapkey)>
		<cfinvoke component="asp.parches.comp.parche" method="remove_entry" collection="importar" mapkey="#mapkey#"></cfinvoke>
	</cfif>
</cfloop>

<cfif IsDefined('form.actualizar')>
	<cflocation url="impbuscar.cfm">
<cfelseif IsDefined('form.buscar')>
	<cflocation url="impbuscar.cfm">
<cfelse>
	<cflocation url="generar.cfm">
</cfif>
