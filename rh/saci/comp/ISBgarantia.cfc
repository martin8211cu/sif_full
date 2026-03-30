<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBgarantia">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="Gid" type="string" required="Yes"  displayname="Garantía">
  <cfargument name="Contratoid" type="numeric" required="No"  displayname="Contratoid">
  <cfargument name="EFid" type="string" required="No" default="" displayname="Entidad">
  <cfargument name="Miso4217" type="string" required="No" default="" displayname="Iso4217">
  <cfargument name="Gtipo" type="string" required="Yes"  displayname="Tipo">
  <cfargument name="Gref" type="string" required="No" default="" displayname="Referencia">
  <cfargument name="Gmonto" type="numeric" required="Yes"  displayname="Monto">
  <cfargument name="Ginicio" type="date" required="No"  displayname="Inicio">
  <cfargument name="Gvence" type="date" required="Yes"  displayname="Fecha de cese">
  <cfargument name="Gcustodio" type="string" required="No" default="" displayname="Custodio">
  <cfargument name="Gestado" type="string" required="Yes"  displayname="Estado">
  <cfargument name="Gobs" type="string" required="No" default="" displayname="Observación">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBgarantia"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="Gid"
						type1="char"
						value1="#Arguments.Gid#">
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update ISBgarantia
		set Contratoid = <cfif isdefined("Arguments.Contratoid") and Len(Trim(Arguments.Contratoid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"><cfelse>null</cfif>
		, EFid = <cfif isdefined("Arguments.EFid") and Len(Trim(Arguments.EFid))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.EFid#"><cfelse>null</cfif>
		, Miso4217 = <cfif isdefined("Arguments.Miso4217") and Len(Trim(Arguments.Miso4217))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Miso4217#"><cfelse>null</cfif>
		
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, Gtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gtipo#" null="#Len(Arguments.Gtipo) Is 0#">
		, Gref = <cfif isdefined("Arguments.Gref") and Len(Trim(Arguments.Gref))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gref#"><cfelse>null</cfif>
		, Gmonto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Gmonto#" scale="2" null="#Len(Arguments.Gmonto) Is 0#">
		
		, Ginicio = <cfif isdefined("Arguments.Ginicio") and Len(Trim(Arguments.Ginicio))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Ginicio#"><cfelse>null</cfif>
		, Gvence = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Gvence#" null="#Len(Arguments.Gvence) Is 0#">
		, Gcustodio = <cfif isdefined("Arguments.Gcustodio") and Len(Trim(Arguments.Gcustodio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gcustodio#"><cfelse>null</cfif>
		, Gestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gestado#" null="#Len(Arguments.Gestado) Is 0#">
		
		, Gobs = <cfif isdefined("Arguments.Gobs") and Len(Trim(Arguments.Gobs))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gobs#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Gid = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gid#" null="#Len(Arguments.Gid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Gid" type="string" required="Yes"  displayname="Garantía">

	<cfquery datasource="#session.dsn#">
		delete ISBgarantia
		where Gid = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gid#" null="#Len(Arguments.Gid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="BajaContrato" output="false" returntype="void" access="remote">
  <cfargument name="Contratoid" type="numeric" required="Yes"  displayname="ID Producto">

	<cfquery datasource="#session.dsn#">
		delete ISBgarantia
		where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="BajaCuenta" output="false" returntype="void" access="remote">
  <cfargument name="CTid" 			type="numeric" 	required="Yes"  displayname="ID Cuenta">
  <cfargument name="soloEnCaptura" 	type="string" 	required="no" 	default="0" displayname="Solo_Productos_en_captura">  

	<cfquery datasource="#session.dsn#">
		delete ISBgarantia
		where exists (
			select 1
			from ISBproducto x
			where x.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
			and x.Contratoid = ISBgarantia.Contratoid
				<cfif isdefined('Arguments.soloEnCaptura') and Arguments.soloEnCaptura NEQ '0'>
					and x.CTcondicion = 'C'
				</cfif>					
		)
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="Gid" type="string" required="Yes"  displayname="Garantía">
  <cfargument name="Contratoid" type="numeric" required="No"  displayname="Contratoid">
  <cfargument name="EFid" type="string" required="No" default="" displayname="Entidad">
  <cfargument name="Miso4217" type="string" required="No" default="" displayname="Iso4217">
  <cfargument name="Gtipo" type="string" required="Yes"  displayname="Tipo">
  <cfargument name="Gref" type="string" required="No" default="" displayname="Referencia">
  <cfargument name="Gmonto" type="numeric" required="Yes"  displayname="Monto">
  <cfargument name="Ginicio" type="date" required="No"  displayname="Inicio">
  <cfargument name="Gvence" type="date" required="Yes"  displayname="Fecha de cese">
  <cfargument name="Gcustodio" type="string" required="No" default="" displayname="Custodio">
  <cfargument name="Gestado" type="string" required="Yes"  displayname="Estado">
  <cfargument name="Gobs" type="string" required="No" default="" displayname="Observación">

	<cfquery datasource="#session.dsn#">
		insert into ISBgarantia (
			Gid,
			Contratoid,
			EFid,
			Miso4217,			
			Ecodigo,
			Gtipo,
			Gref,
			Gmonto,			
			Ginicio,
			Gvence,
			Gcustodio,
			Gestado,			
			Gobs,
			BMUsucodigo)
		values (			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gid#" null="#Len(Arguments.Gid) Is 0#">,
			<cfif isdefined("Arguments.Contratoid") and Len(Trim(Arguments.Contratoid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.EFid") and Len(Trim(Arguments.EFid))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.EFid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Miso4217") and Len(Trim(Arguments.Miso4217))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Miso4217#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gtipo#" null="#Len(Arguments.Gtipo) Is 0#">,
			<cfif isdefined("Arguments.Gref") and Len(Trim(Arguments.Gref))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gref#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Gmonto#" scale="2" null="#Len(Arguments.Gmonto) Is 0#">,
			
			<cfif isdefined("Arguments.Ginicio") and Len(Trim(Arguments.Ginicio))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Ginicio#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Gvence#" null="#Len(Arguments.Gvence) Is 0#">,
			<cfif isdefined("Arguments.Gcustodio") and Len(Trim(Arguments.Gcustodio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gcustodio#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gestado#" null="#Len(Arguments.Gestado) Is 0#">,
			
			<cfif isdefined("Arguments.Gobs") and Len(Trim(Arguments.Gobs))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Gobs#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
	</cfquery>
</cffunction>

</cfcomponent>

