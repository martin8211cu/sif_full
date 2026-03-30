<!--- actualizar/buscar/continuar --->

<cfinvoke component="asp.parches.comp.parche" method="get_entries" collection="tabla" returnvariable="col"></cfinvoke>
<cfinvoke component="asp.parches.comp.parche" method="get_entries" collection="procedimiento" returnvariable="col2"></cfinvoke>
<cfparam name="form.sel" default="">
<cfparam name="form.sel2" default="">

<cfloop collection="#col#" item="mapkey">
	<cfif Not ListFind(form.sel, mapkey)>
		<cfinvoke component="asp.parches.comp.parche" method="remove_entry" collection="tabla" mapkey="#mapkey#"></cfinvoke>
	</cfif>
</cfloop>
<cfloop collection="#col2#" item="mapkey">
	<cfif Not ListFind(form.sel2, mapkey)>
		<cfinvoke component="asp.parches.comp.parche" method="remove_entry" collection="procedimiento" mapkey="#mapkey#"></cfinvoke>
	</cfif>
</cfloop>

<cfif IsDefined('form.actualizar')>
	<cflocation url="objconfirmar.cfm">
<cfelseif IsDefined('form.buscar')>
	<cflocation url="objbuscar.cfm">
<cfelse>
	<cflocation url="impbuscar.cfm">
</cfif>
