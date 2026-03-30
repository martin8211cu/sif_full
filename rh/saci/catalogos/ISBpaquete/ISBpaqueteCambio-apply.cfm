<cfif IsDefined("url.Guardar")>	
	<cfinvoke component="saci.comp.ISBpaqueteCambio"
		method="Alta"  >
		<cfinvokeargument name="PQcodDesde" value="#url.PQcodigo#">
		<cfinvokeargument name="PQcodHacia" value="#url.PQcodigo2#">
	</cfinvoke>

<cfelseif IsDefined("url.Baja")>
	<cfinvoke component="saci.comp.ISBpaqueteCambio"
		method="Baja" >
		<cfinvokeargument name="PQcodDesde" value="#url.PQcodigo#">
		<cfinvokeargument name="PQcodHacia" value="#url.PQcodigo2#">
	</cfinvoke>
	
<cfelseif IsDefined("url.Nuevo")>

<cfelse>

</cfif>

<cfset extraParams = "pagina2=#url.pagina2#&Filtro_nombre2=#url.Filtro_nombre2#&HFiltro_nombre2=#url.Filtro_nombre2#&Filtro_descripcion2=#url.Filtro_descripcion2#&HFiltro_descripcion2=#url.Filtro_descripcion2#&Filtro_Habilitado2=#url.Filtro_Habilitado2#&HFiltro_Habilitado2=#url.Filtro_Habilitado2#">

<cfinclude template="ISBpaquete-redirect.cfm">
