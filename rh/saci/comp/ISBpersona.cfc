<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBpersona">

<cffunction name="Get" output="false" returntype="query" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes" displayname="Persona">

	<cfquery datasource="#session.dsn#" name="rsGet">
		select Pquien, Ppersoneria, Pid, Pnombre, Papellido, Papellido2, PrazonSocial, Ppais, Pobservacion, Pprospectacion, Ecodigo, AEactividad, CPid, Papdo, LCid, Pdireccion, Pbarrio, Ptelefono1, Ptelefono2, Pfax, Pemail, Pfecha, BMUsucodigo, ts_rversion
		from ISBpersona
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">
	</cfquery>
	
	<cfreturn rsGet>
</cffunction>


<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Persona">
  <cfargument name="Ppersoneria" type="string" required="Yes"  displayname="Personería">
  <cfargument name="Pid" type="string" required="Yes"  displayname="Identificación">
  <cfargument name="Pnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="Papellido" type="string" required="No" default="" displayname="Apellido">
  <cfargument name="Papellido2" type="string" required="No" default="" displayname="Apellido materno">
  <cfargument name="PrazonSocial" type="string" required="No" default="" displayname="Razón Social">
  <cfargument name="Ppais" type="string" required="No" default="" displayname="País de Origen">
  <cfargument name="Pobservacion" type="string" required="No" default="" displayname="Observaciones">
  <cfargument name="Pprospectacion" type="string" required="No" default="" displayname="Prospectación">
  <cfargument name="AEactividad" type="numeric" required="No"  displayname="Código actividad">
  <cfargument name="CPid" type="numeric" required="No"  displayname="Codigo Postal">
  <cfargument name="Papdo" type="string" required="No" default="" displayname="Apdo Postal">
  <cfargument name="LCid" type="numeric" required="No"  displayname="Localidad">
  <cfargument name="Pdireccion" type="string" required="No" default="" displayname="Dirección">
  <cfargument name="Pbarrio" type="string" required="No" default="" displayname="Barrio">
  <cfargument name="Ptelefono1" type="string" required="NO"  displayname="Teléfono">
  <cfargument name="Ptelefono2" type="string" required="No" default="" displayname="Teléfono 2">
  <cfargument name="Pfax" type="string" required="No" default="" displayname="Fax">
  <cfargument name="Pemail" type="string" required="No" default="" displayname="e-mail">
  <cfargument name="Pfecha" type="date" required="No" default="#Now()#" displayname="Fecha">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">
  <cfargument name="cambialocalizacion" type="boolean" required="No" default="true"  displayname="Cambia los atributos de localización en Persona">

	<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBpersona"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="Pquien"
				type1="numeric"
				value1="#Arguments.Pquien#">
	<cfquery datasource="#session.dsn#">
		update ISBpersona
		set Ppersoneria = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppersoneria#" null="#Len(Arguments.Ppersoneria) Is 0#">
		, Pid = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pid#" null="#Len(Arguments.Pid) Is 0#">
		, Pnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pnombre#" null="#Len(Arguments.Pnombre) Is 0#">
		
		, Papellido = <cfif isdefined("Arguments.Papellido") and Len(Trim(Arguments.Papellido))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papellido#"><cfelse>null</cfif>
		, Papellido2 = <cfif isdefined("Arguments.Papellido2") and Len(Trim(Arguments.Papellido2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papellido2#"><cfelse>null</cfif>
		, PrazonSocial = <cfif isdefined("Arguments.PrazonSocial") and Len(Trim(Arguments.PrazonSocial))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PrazonSocial#"><cfelse>null</cfif>
		, Ppais = <cfif isdefined("Arguments.Ppais") and Len(Trim(Arguments.Ppais))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppais#"><cfelse>null</cfif>
		
		, Pobservacion = <cfif isdefined("Arguments.Pobservacion") and Len(Trim(Arguments.Pobservacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pobservacion#"><cfelse>null</cfif>
		, Pprospectacion = <cfif isdefined("Arguments.Pprospectacion") and Len(Trim(Arguments.Pprospectacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pprospectacion#"><cfelse>null</cfif>
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, AEactividad = <cfif isdefined("Arguments.AEactividad") and Len(Trim(Arguments.AEactividad))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AEactividad#"><cfelse>null</cfif>
		
		
		<cfif Arguments.cambialocalizacion> 
		
		, CPid = <cfif isdefined("Arguments.CPid") and Len(Trim(Arguments.CPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#"><cfelse>null</cfif>
		, Papdo = <cfif isdefined("Arguments.Papdo") and Len(Trim(Arguments.Papdo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papdo#"><cfelse>null</cfif>
		, LCid = <cfif isdefined("Arguments.LCid") and Len(Trim(Arguments.LCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#"><cfelse>null</cfif>
		, Pdireccion = <cfif isdefined("Arguments.Pdireccion") and Len(Trim(Arguments.Pdireccion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pdireccion#"><cfelse>null</cfif>
		
		, Pbarrio = <cfif isdefined("Arguments.Pbarrio") and Len(Trim(Arguments.Pbarrio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pbarrio#"><cfelse>Pbarrio</cfif>
		, Ptelefono1 = <cfif isdefined("Arguments.Ptelefono1") and Len(Trim(Arguments.Ptelefono1))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono1#"><cfelse>null</cfif>
		, Ptelefono2 = <cfif isdefined("Arguments.Ptelefono2") and Len(Trim(Arguments.Ptelefono2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono2#"><cfelse>null</cfif>
		, Pfax = <cfif isdefined("Arguments.Pfax") and Len(Trim(Arguments.Pfax))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pfax#"><cfelse>null</cfif>
		
		, Pemail = <cfif isdefined("Arguments.Pemail") and Len(Trim(Arguments.Pemail))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pemail#"><cfelse>null</cfif>
		
		</cfif>
		
		, Pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Pfecha#" null="#Len(Arguments.Pfecha) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Persona">

	<cfquery datasource="#session.dsn#">
		delete ISBpersona
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Pquien" type="numeric" required="No"  displayname="Código por insertar con 'set identity insert on' ">

  <cfargument name="Ppersoneria" type="string" required="Yes"  displayname="Personería">
  <cfargument name="Pid" type="string" required="Yes"  displayname="Identificación">
  <cfargument name="Pnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="Papellido" type="string" required="No" default="" displayname="Apellido">
  <cfargument name="Papellido2" type="string" required="No" default="" displayname="Apellido materno">
  <cfargument name="PrazonSocial" type="string" required="No" default="" displayname="Razón Social">
  <cfargument name="Ppais" type="string" required="No" default="" displayname="País de Origen">
  <cfargument name="Pobservacion" type="string" required="No" default="" displayname="Observaciones">
  <cfargument name="Pprospectacion" type="string" required="No" default="" displayname="Prospectación">
  <cfargument name="AEactividad" type="numeric" required="No"  displayname="Código actividad">
  <cfargument name="CPid" type="numeric" required="No"  displayname="Codigo Postal">
  <cfargument name="Papdo" type="string" required="No" default="" displayname="Apdo Postal">
  <cfargument name="LCid" type="numeric" required="No" default="99999" displayname="Localidad">
  <cfargument name="Pdireccion" type="string" required="No" default="" displayname="Dirección">
  <cfargument name="Pbarrio" type="string" required="No" default="" displayname="Barrio">
  <cfargument name="Ptelefono1" type="string" required="No" displayname="Teléfono">
  <cfargument name="Ptelefono2" type="string" required="No" default="" displayname="Teléfono 2">
  <cfargument name="Pfax" type="string" required="No" default="" displayname="Fax">
  <cfargument name="Pemail" type="string" required="No" default="" displayname="e-mail">
  <cfargument name="Pfecha" type="date" required="Yes" default="#Now()#" displayname="Fecha">
	
	<cfquery name="rsAlta" datasource="#session.dsn#">
		<cfif IsDefined('Arguments.Pquien')>
			<!--- los valores que se agreguen desde sistemas externos (siic, crm) ya traerán su propia llave --->
			set identity_insert ISBpersona on
		</cfif>
		insert into ISBpersona (
		<cfif IsDefined('Arguments.Pquien')>
			Pquien,
		</cfif>
			Ppersoneria,
			Pid,
			Pnombre,
			
			Papellido,
			Papellido2,
			PrazonSocial,
			Ppais,
			
			Pobservacion,
			Pprospectacion,
			Ecodigo,
			AEactividad,
			
			CPid,
			Papdo,
			LCid,
			Pdireccion,
			
			Pbarrio,
			Ptelefono1,
			Ptelefono2,
			Pfax,
			
			Pemail,
			Pfecha,
			BMUsucodigo)
		values (
		<cfif IsDefined('Arguments.Pquien')>
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">,
		</cfif>
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppersoneria#" null="#Len(Arguments.Ppersoneria) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pid#" null="#Len(Arguments.Pid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pnombre#" null="#Len(Arguments.Pnombre) Is 0#">,
			
			<cfif isdefined("Arguments.Papellido") and Len(Trim(Arguments.Papellido))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papellido#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Papellido2") and Len(Trim(Arguments.Papellido2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papellido2#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.PrazonSocial") and Len(Trim(Arguments.PrazonSocial))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PrazonSocial#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Ppais") and Len(Trim(Arguments.Ppais))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppais#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Pobservacion") and Len(Trim(Arguments.Pobservacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pobservacion#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pprospectacion") and Len(Trim(Arguments.Pprospectacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pprospectacion#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfif isdefined("Arguments.AEactividad") and Len(Trim(Arguments.AEactividad))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AEactividad#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.CPid") and Len(Trim(Arguments.CPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Papdo") and Len(Trim(Arguments.Papdo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papdo#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.LCid") and Len(Trim(Arguments.LCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pdireccion") and Len(Trim(Arguments.Pdireccion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pdireccion#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Pbarrio") and Len(Trim(Arguments.Pbarrio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pbarrio#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono1#" null="#Len(Arguments.Ptelefono1) Is 0#">,
			<cfif isdefined("Arguments.Ptelefono2") and Len(Trim(Arguments.Ptelefono2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono2#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pfax") and Len(Trim(Arguments.Pfax))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pfax#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Pemail") and Len(Trim(Arguments.Pemail))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pemail#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Pfecha#" null="#Len(Arguments.Pfecha) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
		<cfif IsDefined('Arguments.Pquien')>
			set identity_insert ISBpersona off
		<cfelse>
			<cf_dbidentity1 conexion="#Session.DSN#" verificar_transaccion="false">
		</cfif>
	</cfquery>
	<cfif IsDefined('Arguments.Pquien')>
		<cfreturn Arguments.Pquien>
	<cfelse>
		<cf_dbidentity2 conexion="#Session.DSN#" name="rsAlta" verificar_transaccion="false">
		<cfreturn rsAlta.identity>
	</cfif>
</cffunction>

</cfcomponent>

