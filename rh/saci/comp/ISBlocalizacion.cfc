<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBpersona">

<cffunction name="Get" output="false" returntype="query" access="remote">
  <cfargument name="Lid" type="numeric" required="Yes" displayname="localizacion">

	<cfquery datasource="#session.dsn#" name="rsGet">
		select *
		from ISBlocalizacion
		where Lid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Lid#">
	</cfquery>
	
	<cfreturn rsGet>
</cffunction>


<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="Lid" type="numeric" required="Yes"  displayname="localizacion">
  <cfargument name="RefId" type="numeric" required="Yes"  displayname="Id de Referencia">
  <cfargument name="Ltipo" type="string" required="Yes" default="" displayname="Tipo">
  
  <cfargument name="CPid" type="numeric" required="No"  displayname="Codigo Postal">
  <cfargument name="Papdo" type="string" required="No" default="" displayname="Apdo Postal">
  <cfargument name="LCid" type="numeric" required="No"  displayname="Localidad">
  <cfargument name="Pdireccion" type="string" required="No" default="" displayname="Dirección">
  <cfargument name="Pbarrio" type="string" required="No" default="" displayname="Barrio">
  <cfargument name="Ptelefono1" type="string" required="No"  displayname="Teléfono">
  <cfargument name="Ptelefono2" type="string" required="No" default="" displayname="Teléfono 2">
  <cfargument name="Pfax" type="string" required="No" default="" displayname="Fax">
  <cfargument name="Pemail" type="string" required="No" default="" displayname="e-mail">
  <cfargument name="Pfecha" type="date" required="No" default="#Now()#" displayname="Fecha">
  <cfargument name="Pobservacion" type="string" required="No" default="" displayname="Observaciones">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

	<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBlocalizacion"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="Lid"
				type1="numeric"
				value1="#Arguments.Lid#">
	<cfquery datasource="#session.dsn#">
		update ISBlocalizacion
		set 
		  RefId = <cfif isdefined("Arguments.RefId") and Len(Trim(Arguments.RefId))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RefId#"><cfelse>null</cfif>
		, Ltipo = <cfif isdefined("Arguments.Ltipo") and Len(Trim(Arguments.Ltipo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ltipo#"><cfelse>null</cfif> 
		
		, CPid = <cfif isdefined("Arguments.CPid") and Len(Trim(Arguments.CPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#"><cfelse>null</cfif>
		, Papdo = <cfif isdefined("Arguments.Papdo") and Len(Trim(Arguments.Papdo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papdo#"><cfelse>null</cfif>
		, LCid = <cfif isdefined("Arguments.LCid") and Len(Trim(Arguments.LCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#"><cfelse>null</cfif>
		, Pdireccion = <cfif isdefined("Arguments.Pdireccion") and Len(Trim(Arguments.Pdireccion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pdireccion#"><cfelse>null</cfif>
		
		, Pbarrio = <cfif isdefined("Arguments.Pbarrio") and Len(Trim(Arguments.Pbarrio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pbarrio#"><cfelse>null</cfif>
		, Ptelefono1 = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono1#" null="#Len(Arguments.Ptelefono1) Is 0#">
		, Ptelefono2 = <cfif isdefined("Arguments.Ptelefono2") and Len(Trim(Arguments.Ptelefono2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono2#"><cfelse>null</cfif>
		, Pfax = <cfif isdefined("Arguments.Pfax") and Len(Trim(Arguments.Pfax))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pfax#"><cfelse>null</cfif>
		
		, Pemail = <cfif isdefined("Arguments.Pemail") and Len(Trim(Arguments.Pemail))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pemail#"><cfelse>null</cfif>
		, Pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Pfecha#" null="#Len(Arguments.Pfecha) Is 0#">
		, Pobservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pobservacion#" null="#Len(Arguments.Pobservacion) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Lid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Lid#" null="#Len(Arguments.Lid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Lid" type="numeric" required="Yes"  displayname="localizacion">

	<cfquery datasource="#session.dsn#">
		delete ISBlocalizacion
		where Lid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Lid#" null="#Len(Arguments.Lid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Lid" type="numeric" required="No"  displayname="localizacion">
  <cfargument name="RefId" type="numeric" required="Yes"  displayname="Id de Referencia">
  <cfargument name="Ltipo" type="string" required="Yes" default="" displayname="Tipo">
  
  <cfargument name="CPid" type="numeric" required="No"  displayname="Codigo Postal">
  <cfargument name="Papdo" type="string" required="No" default="" displayname="Apdo Postal">
  <cfargument name="LCid" type="numeric" required="No"  displayname="Localidad">
  <cfargument name="Pdireccion" type="string" required="No" default="" displayname="Dirección">
  <cfargument name="Pbarrio" type="string" required="No" default="" displayname="Barrio">
  <cfargument name="Ptelefono1" type="string" required="Yes"  displayname="Teléfono">
  <cfargument name="Ptelefono2" type="string" required="No" default="" displayname="Teléfono 2">
  <cfargument name="Pfax" type="string" required="No" default="" displayname="Fax">
  <cfargument name="Pemail" type="string" required="No" default="" displayname="e-mail">
  <cfargument name="Pobservacion" type="string" required="No" default="" displayname="Observaciones">
  <cfargument name="Pfecha" type="date" required="Yes" default="#Now()#" displayname="Fecha">
	
	<cfquery name="rsAlta" datasource="#session.dsn#">
		<cfif IsDefined('Arguments.Lid')>
			<!--- los valores que se agreguen desde sistemas externos (siic, crm) ya traerán su propia llave --->
			set identity_insert ISBlocalizacion on
		</cfif>
		insert into ISBlocalizacion (
		<cfif IsDefined('Arguments.Lid')>
			Lid,
		</cfif>
			RefId,
			Ltipo,
			Ecodigo,
			
			CPid,
			Papdo,
			LCid,
			Pdireccion,
			
			Pbarrio,
			Ptelefono1,
			Ptelefono2,
			Pfax,
			
			Pemail,
			Pobservacion,
			Pfecha,
			BMUsucodigo)
		values (
		<cfif IsDefined('Arguments.Lid')>
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Lid#">,
		</cfif>
			<cfif isdefined("Arguments.RefId") and Len(Trim(Arguments.RefId))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RefId#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Ltipo") and Len(Trim(Arguments.Ltipo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ltipo#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfif isdefined("Arguments.CPid") and Len(Trim(Arguments.CPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Papdo") and Len(Trim(Arguments.Papdo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papdo#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.LCid") and Len(Trim(Arguments.LCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pdireccion") and Len(Trim(Arguments.Pdireccion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pdireccion#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Pbarrio") and Len(Trim(Arguments.Pbarrio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pbarrio#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono1#" null="#Len(Arguments.Ptelefono1) Is 0#">,
			<cfif isdefined("Arguments.Ptelefono2") and Len(Trim(Arguments.Ptelefono2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono2#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pfax") and Len(Trim(Arguments.Pfax))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pfax#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Pemail") and Len(Trim(Arguments.Pemail))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pemail#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pobservacion") and Len(Trim(Arguments.Pobservacion))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pobservacion#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Pfecha#" null="#Len(Arguments.Pfecha) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
		<cfif IsDefined('Arguments.Lid')>
			set identity_insert ISBlocalizacion off
		<cfelse>
			<cf_dbidentity1 conexion="#Session.DSN#" verificar_transaccion="false">
		</cfif>
	</cfquery>
	<cfif IsDefined('Arguments.Lid')>
		<cfreturn Arguments.Lid>
	<cfelse>
		<cf_dbidentity2 conexion="#Session.DSN#" name="rsAlta" verificar_transaccion="false">
		<cfreturn rsAlta.identity>
	</cfif>
</cffunction>

</cfcomponent>

