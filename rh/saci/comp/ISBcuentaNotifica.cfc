<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBcuentaNotifica">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes" displayname="Cuenta">
  <cfargument name="CTtipoEnvio" type="string" required="No" default="" displayname="Envío de documentación">
  <cfargument name="CTatencionEnvio" type="string" required="No" default="" displayname="Atención a (direccion)">
  <cfargument name="CTdireccionEnvio" type="string" required="No" default="" displayname="Direccion completa">
  <cfargument name="CTapdoPostal" type="string" required="No" default="" displayname="Apartado Postal">
  <cfargument name="CTcopiaModo" type="string" required="Yes" displayname="Modalidad copia estado cuenta">
  <cfargument name="CTcopiaDireccion" type="string" required="No" default="" displayname="Dirección de copia de estado de cuenta1">
  <cfargument name="CTcopiaDireccion2" type="string" required="No" default="" displayname="Dirección de copia de estado de cuenta2">
  <cfargument name="CTcopiaDireccion3" type="string" required="No" default="" displayname="Dirección de copia de estado de cuenta3">
  <cfargument name="CPid" type="string"	required="No" displayname="Código Postal">
  <cfargument name="LCid" type="string"	required="No" displayname="Localidad">
  <cfargument name="CTbarrio" type="string" required="No" default="" displayname="Barrio">
  <cfargument name="ts_rversion" type="string" 	required="No"   displayname="ts_rversion">
 	
	<cfif isdefined("Arguments.ts_rversion") and len(trim(Arguments.ts_rversion))>	
		<cf_dbtimestamp datasource="#session.DSN#"
						table="ISBcuentaNotifica"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="CTid"
						type1="numeric"
						value1="#Arguments.CTid#">
	</cfif>
	<cfquery datasource="#session.DSN#">
		update ISBcuentaNotifica
		set CTtipoEnvio = <cfif isdefined("Arguments.CTtipoEnvio") and Len(Trim(Arguments.CTtipoEnvio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTtipoEnvio#"><cfelse>null</cfif>
		, CTatencionEnvio = <cfif isdefined("Arguments.CTatencionEnvio") and Len(Trim(Arguments.CTatencionEnvio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTatencionEnvio#"><cfelse>null</cfif>
		, CTdireccionEnvio = <cfif isdefined("Arguments.CTdireccionEnvio") and Len(Trim(Arguments.CTdireccionEnvio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTdireccionEnvio#"><cfelse>null</cfif>
		
		, CTapdoPostal = <cfif isdefined("Arguments.CTapdoPostal") and Len(Trim(Arguments.CTapdoPostal))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTapdoPostal#"><cfelse>null</cfif>
		, CTcopiaModo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcopiaModo#" null="#Len(Arguments.CTcopiaModo) Is 0#">

		, CTcopiaDireccion = <cfif isdefined("Arguments.CTcopiaDireccion") and Len(Trim(Arguments.CTcopiaDireccion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcopiaDireccion#"><cfelse>null</cfif>
		, CTcopiaDireccion2 = <cfif isdefined("Arguments.CTcopiaDireccion2") and Len(Trim(Arguments.CTcopiaDireccion2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcopiaDireccion2#"><cfelse>null</cfif>
		, CTcopiaDireccion3 = <cfif isdefined("Arguments.CTcopiaDireccion3") and Len(Trim(Arguments.CTcopiaDireccion3))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcopiaDireccion3#"><cfelse>null</cfif>

		, CPid = <cfif isdefined("Arguments.CPid") and Len(Trim(Arguments.CPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#"><cfelse>null</cfif>
		, LCid = <cfif isdefined("Arguments.LCid") and Len(Trim(Arguments.LCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		, CTbarrio = <cfif isdefined("Arguments.CTbarrio") and Len(Trim(Arguments.CTbarrio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTbarrio#"><cfelse>null</cfif>
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  	<cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
	
	<cfquery datasource="#session.DSN#" name="rsBaja">
		delete ISBcuentaNotifica
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="CTtipoEnvio" type="string" required="No" default="" displayname="Envío de documentación">
  <cfargument name="CTatencionEnvio" type="string" required="No" default="" displayname="Atención a (direccion)">
  <cfargument name="CTdireccionEnvio" type="string" required="No" default="" displayname="Direccion completa">
  <cfargument name="CTapdoPostal" type="string" required="No" default="" displayname="Apartado Postal">
  <cfargument name="CTcopiaModo" type="string" required="Yes"  displayname="Modalidad copia estado cuenta">
  <cfargument name="CTcopiaDireccion" type="string" required="No" default="" displayname="Dirección de copia de estado de cuenta1">
  <cfargument name="CTcopiaDireccion2" type="string" required="No" default="" displayname="Dirección de copia de estado de cuenta2">
  <cfargument name="CTcopiaDireccion3" type="string" required="No" default="" displayname="Dirección de copia de estado de cuenta3">
  <cfargument name="CPid" type="string" required="No" displayname="Código Postal">
  <cfargument name="LCid" type="string" required="No" displayname="Localidad">
  <cfargument name="CTbarrio" type="string" required="No" default="" displayname="Barrio">
	
	<cfquery datasource="#session.DSN#" name="rsAlta">
		insert into ISBcuentaNotifica (
			CTid,
			CTtipoEnvio,
			CTatencionEnvio,
			CTdireccionEnvio,
			
			CTapdoPostal,
			CTcopiaModo,
			CTcopiaDireccion,
			CTcopiaDireccion2,
			
			CTcopiaDireccion3,
			CPid,
			LCid,
			BMUsucodigo,
			CTbarrio)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">,
			<cfif isdefined("Arguments.CTtipoEnvio") and Len(Trim(Arguments.CTtipoEnvio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTtipoEnvio#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTatencionEnvio") and Len(Trim(Arguments.CTatencionEnvio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTatencionEnvio#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTdireccionEnvio") and Len(Trim(Arguments.CTdireccionEnvio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTdireccionEnvio#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.CTapdoPostal") and Len(Trim(Arguments.CTapdoPostal))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTapdoPostal#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcopiaModo#" null="#Len(Arguments.CTcopiaModo) Is 0#">,
			<cfif isdefined("Arguments.CTcopiaDireccion") and Len(Trim(Arguments.CTcopiaDireccion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcopiaDireccion#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTcopiaDireccion2") and Len(Trim(Arguments.CTcopiaDireccion2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcopiaDireccion2#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.CTcopiaDireccion3") and Len(Trim(Arguments.CTcopiaDireccion3))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcopiaDireccion3#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CPid") and Len(Trim(Arguments.CPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.LCid") and Len(Trim(Arguments.LCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfif isdefined("Arguments.CTbarrio") and Len(Trim(Arguments.CTbarrio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTbarrio#"><cfelse>null</cfif>
		)
			
	</cfquery>

</cffunction>

</cfcomponent>

