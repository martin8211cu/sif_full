<cfif isdefined("form.btnCambiar") and isdefined("form.chk") and len(trim(form.chk))>
	<!--- Obtengo el Activo y el Nuevo Valor. --->
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset lista = listToArray(item,"|")>
		<cfset Aid = #lista[1]#>
		<cfset ACcodigoN = #lista[2]#>
		<cfset ACidN = #lista[3]#>

		<!--- Cambio la Clasificación --->
		<cfinvoke component="sif.Componentes.AF_ContabilizarTrfClasificacion"	 
			method="AF_ContabilizarTrfClasificacion" 
			returnvariable="finalizadoOk"
			Aid="#Aid#" 
			ACcodigo="#ACcodigoN#"
			ACid="#ACidN#"/>
	</cfloop>
	<cflocation url="transfcatclas.cfm">

<cfelseif isdefined("form.btnCambiarTodo")>
	<!--- Obtiene todas las placas de la lista --->
	<cfquery name="rsPlacas" datasource="#session.DSN#">
		select
			Aid,
			ACcodigoN,
			ACidN
		from ##Activos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfloop query="rsPlacas">
		<!--- Cambio la Clasificación del Activo --->
		<cfinvoke component="sif.Componentes.AF_ContabilizarTrfClasificacion"
			method="AF_ContabilizarTrfClasificacion"
			returnvariable="finalizadoOk"
			Aid="#rsPlacas.Aid#"
			ACcodigo="#rsPlacas.ACcodigoN#"
			ACid="#rsPlacas.ACidN#"/>
	</cfloop>
	<cflocation url="transfcatclas.cfm">
	
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
	<cflocation url="transfcatclas_main.cfm">

<cfelseif isdefined("form.btnEliminarTodo")>
	<cfquery datasource="#session.DSN#">
		delete from ##Activos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cflocation url="transfcatclas_main.cfm">

<cfelse>
	<cflocation url="transfcatclas.cfm">
</cfif>