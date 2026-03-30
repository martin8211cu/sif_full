<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBcuentaCobro">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="CTid" 				type="numeric" 	required="Yes" 				displayname="Cuenta">
  <cfargument name="CTcobro" 			type="string" 	required="Yes" 				displayname="Tipo de cobro">
  <cfargument name="CTtipoCtaBco" 		type="string" 	required="No" 	default="" 	displayname="Tipo Cta Bco">
  <cfargument name="CTbcoRef" 			type="string" 	required="No" 	default="" 	displayname="Cta bancaria">
  <cfargument name="CTmesVencimiento" 	type="string" 	required="No"  				displayname="Mes vencimiento">
  <cfargument name="CTanoVencimiento" 	type="string" 	required="No"  	default="" 	displayname="Año vencimiento">
  <cfargument name="CTverificadorTC" 	type="string" 	required="No" 	default="" 	displayname="Dígito verificador T.Cred.">
  <cfargument name="EFid" 				type="string" 	required="No" 	default="" 	displayname="Entidad Financiera">
  <cfargument name="MTid" 				type="string" 	required="No"  				displayname="Marca de tarjeta">
  <cfargument name="PpaisTH" 			type="string" 	required="No" 	default="" 	displayname="Nacionalidad tarjetahabiente">
  <cfargument name="CTcedulaTH" 		type="string" 	required="No" 	default="" 	displayname="Cedula tarjetahabiente">
  <cfargument name="CTnombreTH" 		type="string" 	required="No" 	default="" 	displayname="Nombre Tarjetahabiente">
  <cfargument name="CTapellido1TH" 		type="string" 	required="No" 	default="" 	displayname="Apellido 1 Tarjetahabiente">
  <cfargument name="CTapellido2TH" 		type="string" 	required="No" 	default="" 	displayname="Apellido 2 Tarjetahabiente">
  <cfargument name="ts_rversion" 		type="string" 	required="No"  	default="" 	displayname="ts_rversion">
  <cfargument name="datasource" 		type="string" 	required="No"   default="#session.DSN#">
	
	<cfif isdefined("Arguments.ts_rversion") and len(trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#Arguments.datasource#"
						table="ISBcuentaCobro"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="CTid"
						type1="numeric"
						value1="#Arguments.CTid#">
	</cfif>
	
	<cfquery datasource="#Arguments.datasource#">
		update ISBcuentaCobro
		set CTcobro = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcobro#" null="#Len(Arguments.CTcobro) Is 0#">
		, CTtipoCtaBco = <cfif isdefined("Arguments.CTtipoCtaBco") and Len(Trim(Arguments.CTtipoCtaBco))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTtipoCtaBco#"><cfelse>null</cfif>
		, CTbcoRef = <cfif isdefined("Arguments.CTbcoRef") and Len(Trim(Arguments.CTbcoRef))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTbcoRef#"><cfelse>null</cfif>
		
		, CTmesVencimiento = <cfif isdefined("Arguments.CTmesVencimiento") and Len(Trim(Arguments.CTmesVencimiento))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTmesVencimiento#"><cfelse>null</cfif>
		, CTanoVencimiento = <cfif isdefined("Arguments.CTanoVencimiento") and Len(Trim(Arguments.CTanoVencimiento))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTanoVencimiento#"><cfelse>null</cfif>
		, CTverificadorTC = <cfif isdefined("Arguments.CTverificadorTC") and Len(Trim(Arguments.CTverificadorTC))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTverificadorTC#"><cfelse>null</cfif>
		, EFid = <cfif isdefined("Arguments.EFid") and Len(Trim(Arguments.EFid))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.EFid#"><cfelse>null</cfif>
		
		, MTid = <cfif isdefined("Arguments.MTid") and Len(Trim(Arguments.MTid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MTid#"><cfelse>null</cfif>
		, PpaisTH = <cfif isdefined("Arguments.PpaisTH") and Len(Trim(Arguments.PpaisTH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PpaisTH#"><cfelse>null</cfif>
		, CTcedulaTH = <cfif isdefined("Arguments.CTcedulaTH") and Len(Trim(Arguments.CTcedulaTH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcedulaTH#"><cfelse>null</cfif>
		, CTnombreTH = <cfif isdefined("Arguments.CTnombreTH") and Len(Trim(Arguments.CTnombreTH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTnombreTH#"><cfelse>null</cfif>
		, CTapellido1TH = <cfif isdefined("Arguments.CTapellido1TH") and Len(Trim(Arguments.CTapellido1TH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTapellido1TH#"><cfelse>null</cfif>
		
		, CTapellido2TH = <cfif isdefined("Arguments.CTapellido2TH") and Len(Trim(Arguments.CTapellido2TH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTapellido2TH#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument 	name="CTid" 		type="numeric" 	required="Yes"  displayname="Cuenta">
  <cfargument 	name="datasource" 	type="string" 	required="No"   default="#session.DSN#"> 
    
	<cfquery datasource="#Arguments.datasource#">
		delete ISBcuentaCobro
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#">
	</cfquery>
	
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="CTcobro" type="string" required="Yes"  displayname="Tipo de cobro">
  <cfargument name="CTtipoCtaBco" type="string" required="No" default="" displayname="Tipo Cta Bco">
  <cfargument name="CTbcoRef" type="string" required="No" default="" displayname="Cta bancaria">
  <cfargument name="CTmesVencimiento" type="string" default=""  required="No"  displayname="Mes vencimiento">
  <cfargument name="CTanoVencimiento" type="string" default="" required="No"  displayname="Año vencimiento">
  <cfargument name="CTverificadorTC" type="string" required="No" default="" displayname="Dígito verificador T.Cred.">
  <cfargument name="EFid" 	type="string" required="No" default="" displayname="Entidad Financiera">
  <cfargument name="MTid" 	type="string" required="No"  displayname="Marca de tarjeta">
  <cfargument name="PpaisTH"type="string" required="No" default="" displayname="Nacionalidad tarjetahabiente">
  <cfargument name="CTcedulaTH" 	type="string" required="No" default="" displayname="Cedula tarjetahabiente">
  <cfargument name="CTnombreTH" 	type="string" required="No" default="" displayname="Nombre Tarjetahabiente">
  <cfargument name="CTapellido1TH"	type="string" required="No" default="" displayname="Apellido 1 Tarjetahabiente">
  <cfargument name="CTapellido2TH"	type="string" required="No" default="" displayname="Apellido 2 Tarjetahabiente">
  <cfargument name="datasource" 	type="string" required="No" default="#session.DSN#">	
	
	<cfquery datasource="#Arguments.datasource#" name="rsAlta">
		insert into ISBcuentaCobro (
			CTid,
			CTcobro,
			CTtipoCtaBco,
			CTbcoRef,
			
			CTmesVencimiento,
			CTanoVencimiento,
			CTverificadorTC,
			EFid,
			
			MTid,
			PpaisTH,
			CTcedulaTH,
			CTnombreTH,
			CTapellido1TH,
			
			CTapellido2TH,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcobro#" null="#Len(Arguments.CTcobro) Is 0#">,
			<cfif isdefined("Arguments.CTtipoCtaBco") and Len(Trim(Arguments.CTtipoCtaBco))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTtipoCtaBco#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTbcoRef") and Len(Trim(Arguments.CTbcoRef))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTbcoRef#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.CTmesVencimiento") and Len(Trim(Arguments.CTmesVencimiento))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTmesVencimiento#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTanoVencimiento") and Len(Trim(Arguments.CTanoVencimiento))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTanoVencimiento#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTverificadorTC") and Len(Trim(Arguments.CTverificadorTC))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTverificadorTC#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.EFid") and Len(Trim(Arguments.EFid))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.EFid#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.MTid") and Len(Trim(Arguments.MTid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MTid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.PpaisTH") and Len(Trim(Arguments.PpaisTH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PpaisTH#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTcedulaTH") and Len(Trim(Arguments.CTcedulaTH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcedulaTH#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTnombreTH") and Len(Trim(Arguments.CTnombreTH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTnombreTH#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CTapellido1TH") and Len(Trim(Arguments.CTapellido1TH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTapellido1TH#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.CTapellido2TH") and Len(Trim(Arguments.CTapellido2TH))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTapellido2TH#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
			
	</cfquery>

</cffunction>

</cfcomponent>

