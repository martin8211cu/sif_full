<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.ISBservicioTipo"
		method="Cambio" >
		<cfinvokeargument name="TScodigo" value="#form.TScodigo#">
		<cfinvokeargument name="TSnombre" value="#form.TSnombre#">
		<!---<cfinvokeargument name="TSdescripcion" value="#form.TSdescripcion#">--->
		<cfinvokeargument name="Habilitado" value="#form.Habilitado#">
		<cfinvokeargument name="TSobservacion" value="#form.TSobservacion#">
		<cfinvokeargument name="TStipo" value="#form.TStipo#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete ISBservicio
		where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TScodigo#" null="#Len(form.TScodigo) Is 0#">  
		and Habilitado = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
	</cfquery>
	<cfinvoke component="saci.comp.ISBservicioTipo"
		method="Baja" >
		<cfinvokeargument name="TScodigo" value="#form.TScodigo#">
	</cfinvoke>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>	
	<cfset form.TScodigo = UCase( form.TScodigo )>
	<cfinvoke component="saci.comp.ISBservicioTipo"
		method="Alta"  >
		<cfinvokeargument name="TScodigo" value="#form.TScodigo#">
		<cfinvokeargument name="TSnombre" value="#form.TSnombre#">
		<!---<cfinvokeargument name="TSdescripcion" value="#form.TSdescripcion#">--->
		<cfinvokeargument name="Habilitado" value="#form.Habilitado#">
		<cfinvokeargument name="TSobservacion" value="#form.TSobservacion#">
		<cfinvokeargument name="TStipo" value="#form.TStipo#">
	</cfinvoke>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cfinclude template="ISBservicioTipo-redirect.cfm">



