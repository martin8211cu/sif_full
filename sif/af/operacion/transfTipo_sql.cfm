<!--- <cf_dump var="#form#"> --->

<cfif isdefined("form.btnCambiar") and isdefined("form.chk") and len(trim(form.chk))>
	<!--- Obtengo el Activo y el nuevo valor. --->
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset lista = listToArray(item,"|")>
		<cfset Aid = #lista[1]#>
		<cfset AFCcodigoN = #lista[2]#>

		<!--- Cambio el Tipo del Activo --->
		<cfinvoke component="sif.Componentes.AF_CambioTipoActivo"	 
			method="AF_CambioTipoActivo" 
			returnvariable="finalizadoOk"
			Aid="#Aid#" 
			AFCcodigo="#AFCcodigoN#"/>
	</cfloop>
	<cflocation url="transfTipo.cfm">

<cfelseif isdefined("form.btnCambiarTodo")>
	<!--- Obtiene todas las placas de la lista --->
	<cfquery name="rsPlacas" datasource="#session.DSN#">
		select
			Aid,
			AFCcodigoN
		from ##Activos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfloop query="rsPlacas">
		<!--- Cambio el Tipo del Activo --->
		<cfinvoke component="sif.Componentes.AF_CambioTipoActivo"	 
			method="AF_CambioTipoActivo" 
			returnvariable="finalizadoOk"
			Aid="#rsPlacas.Aid#" 
			AFCcodigo="#rsPlacas.AFCcodigoN#"/>
	</cfloop>
	<cflocation url="transfTipo.cfm">
	
<cfelseif isdefined("form.btnEliminar") and isdefined("form.chk") and len(trim(form.chk))>
	<!--- Obtengo el Activo --->
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset lista = listToArray(item,"|")>
		<cfset Aid = #lista[1]#>

		<cfquery datasource="#session.DSN#">
			delete from ##Activos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Aid = #Aid#
		</cfquery>
	</cfloop>
	<cflocation url="transfTipo_main.cfm">

<cfelseif isdefined("form.btnEliminarTodo")>
	<cfquery datasource="#session.DSN#">
		delete from ##Activos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cflocation url="transfTipo_main.cfm">

<cfelse>
	<cflocation url="transfTipo.cfm">
</cfif>
