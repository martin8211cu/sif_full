<cfparam name="url.DGidPadre" default="-1">
<cfif isdefined('url.id') and len(trim(url.id)) gt 0>
	<cfset form.id = url.id>
</cfif>
<cfparam name="url.Ppais" default="-1">
<cfif isdefined('url.Ppais') and len(trim(url.Ppais)) gt 0>
	<cfset form.Ppais = url.Ppais>
</cfif>
<cfparam name="url.Action" default="Niveles">
<cfif isdefined('url.Action') and len(trim(url.Action)) gt 0>
	<cfset form.Action = url.Action>
</cfif>
<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="rsDistribuciones">
		<cfinvokeargument name="Ppais" 			value="#form.Ppais#">
	<cfif form.Action eq 'Niveles'>
		<cfinvokeargument name="DGidPadre" 		value="#form.id#">
	<cfelseif form.Action eq 'Apartado'>
		<cfinvokeargument name="DGid" 			value="#form.id#">
	</cfif>
		<cfinvokeargument name="OrderBy" 		value="d.DGDescripcion">
</cfinvoke>
<cfoutput>
	<cfif form.Action eq 'Niveles'>
		<option value="-1">--No Seleccionado--</option>
		<cfloop query="rsDistribuciones">
			<option value="#rsDistribuciones.DGid#">#rsDistribuciones.DGDescripcion#</option>
		</cfloop>
	<cfelseif form.Action eq 'Apartado'>
		#rsDistribuciones.DGcodigoPostal#
	</cfif>
</cfoutput>
