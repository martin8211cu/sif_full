<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBpaquete">

<cffunction name="PQpordefecto" output="false" returntype="string" access="remote">
	<cfargument name="datasourse"	type="string" required="No"  default="#session.DSN#" displayname="datasourse">
	<cfargument name="Ecodigo"		type="numeric" required="No" default="#session.Ecodigo#" displayname="datasourse">
	
	<cfquery  name="rsPQpordefecto" datasource="#Arguments.datasourse#">
		select PQcodigo from ISBpaquete 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		 and PQpordefecto=1
	</cfquery>
	<cfset pq = ""><cfif rsPQpordefecto.RecordCount GT 0><cfset pq = rsPQpordefecto.PQcodigo></cfif>
	<cfreturn pq>
</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="Miso4217" type="string" required="No" default="" displayname="Iso4217">
  <cfargument name="MRidMayorista" type="string" required="No"  displayname="ID de mayorista de Red (CT/AMNET)">
  <cfargument name="PQnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="PQdescripcion" type="string" required="Yes"  displayname="Descripción">
  <cfargument name="PQinicio" type="string" required="No"  displayname="Inicio">
  <cfargument name="PQcierre" type="string" required="No"  displayname="Cese">
  <cfargument name="PQcomisionTipo" type="string" required="Yes"  displayname="Tipo de comisión">
  <cfargument name="PQpagodeposito" type="string" required="Yes"  displayname="Modo pago depósito">
  <cfargument name="PQcomisionPctj" type="string" required="No"  displayname="% Comisión">
  <cfargument name="PQcomisionMnto" type="string" required="No"  displayname="Monto comisión">
  <cfargument name="PQtoleranciaGarantia" type="string" required="No"  displayname="Tolerancia garantía">
  <cfargument name="PQtarifaBasica" type="string" required="No"  displayname="Tarifa básica">
  <cfargument name="PQcompromiso" type="boolean" required="Yes"  displayname="compromiso">
  <cfargument name="PQhorasBasica" type="string" required="No"  displayname="Horas básicas">
  <cfargument name="PQprecioExc" type="string" required="No"  displayname="Precio excedente">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="PQroaming" type="boolean" required="Yes"  displayname="Permite roaming">
  <cfargument name="PQmailQuota" type="string" required="No"  displayname="Mail Quota">
  <cfargument name="PQinterfaz" type="boolean" required="Yes"  displayname="Interno para interfaz">
  <cfargument name="PQautogestion" type="boolean" required="Yes"  displayname="Permite autogestion">
  <cfargument name="PQutilizadoagente" type="boolean" required="Yes"  displayname="Utilizado para Agente">
  <cfargument name="PQtelefono" type="boolean" required="Yes"  displayname="Requiere telefono de acceso único">
  <cfargument name="PQmaxSession" type="numeric" required="no" displayname="Limitar máximo número de sesiones">
  <cfargument name="CINCAT" type="numeric" required="no" displayname="Código para interfaz">
  <cfargument name="PQagrupa" type="numeric" required="no" displayname="Código la agrupacion">  
  <cfargument name="PQadelanto" type="string" required="no" displayname="Si aplica, No aplica Pago adelantado">
  <cfargument name="PQtransaccion" type="string" required="no" displayname="Código de la transaccion">
  <cfargument name="TRANUC" type="string" required="no" displayname="TRANUC">
    
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBpaquete"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="PQcodigo"
				type1="char"
				value1="#Arguments.PQcodigo#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBpaquete
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, Miso4217 = <cfif isdefined("Arguments.Miso4217") and Len(Trim(Arguments.Miso4217))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Miso4217#"><cfelse>null</cfif>
		, MRidMayorista = <cfif isdefined("Arguments.MRidMayorista") and Len(Trim(Arguments.MRidMayorista))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRidMayorista#"><cfelse>null</cfif>
		
		, PQnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQnombre#" null="#Len(Arguments.PQnombre) Is 0#">
		, PQdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQdescripcion#" null="#Len(Arguments.PQdescripcion) Is 0#">
		, PQinicio = <cfif isdefined("Arguments.PQinicio") and Len(Trim(Arguments.PQinicio))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.PQinicio#"><cfelse>null</cfif>
		, PQcierre = <cfif isdefined("Arguments.PQcierre") and Len(Trim(Arguments.PQcierre))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.PQcierre#"><cfelse>null</cfif>
		
		, PQcomisionTipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcomisionTipo#" null="#Len(Arguments.PQcomisionTipo) Is 0#">
		, PQpagodeposito = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQpagodeposito#" null="#Len(Arguments.PQpagodeposito) Is 0#">
		, PQcomisionPctj = <cfif isdefined("Arguments.PQcomisionPctj") and Len(Trim(Arguments.PQcomisionPctj))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQcomisionPctj#" scale="2"><cfelse>null</cfif>
		, PQcomisionMnto = <cfif isdefined("Arguments.PQcomisionMnto") and Len(Trim(Arguments.PQcomisionMnto))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQcomisionMnto#" scale="2"><cfelse>null</cfif>
		, PQtoleranciaGarantia = <cfif isdefined("Arguments.PQtoleranciaGarantia") and Len(Trim(Arguments.PQtoleranciaGarantia))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQtoleranciaGarantia#" scale="2"><cfelse>null</cfif>
		
		, PQtarifaBasica = <cfif isdefined("Arguments.PQtarifaBasica") and Len(Trim(Arguments.PQtarifaBasica))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQtarifaBasica#" scale="2"><cfelse>null</cfif>
		, PQcompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQcompromiso#" null="#Len(Arguments.PQcompromiso) Is 0#">
		, PQhorasBasica = <cfif isdefined("Arguments.PQhorasBasica") and Len(Trim(Arguments.PQhorasBasica))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PQhorasBasica#"><cfelse>null</cfif>
		, PQprecioExc = <cfif isdefined("Arguments.PQprecioExc") and Len(Trim(Arguments.PQprecioExc))><cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.PQprecioExc#"><cfelse>null</cfif>
		
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, PQroaming = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQroaming#" null="#Len(Arguments.PQroaming) Is 0#">
		, PQautogestion = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQautogestion#" null="#Len(Arguments.PQautogestion) Is 0#">
		, PQutilizadoagente = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQutilizadoagente#">
		, PQmailQuota = <cfif isdefined("Arguments.PQmailQuota") and Len(Trim(Arguments.PQmailQuota))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PQmailQuota#"><cfelse>null</cfif>
		, PQinterfaz = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQinterfaz#" null="#Len(Arguments.PQinterfaz) Is 0#">
		
		, PQtelefono = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQtelefono#" null="#Len(Arguments.PQtelefono) Is 0#">
		, PQmaxSession = <cfif IsDefined("Arguments.PQmaxSession")><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQmaxSession#"><cfelse>null</cfif>
		, CINCAT = <cfif IsDefined("Arguments.CINCAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CINCAT#"><cfelse>null</cfif>
		
		, PQagrupa = <cfif IsDefined("Arguments.PQagrupa")><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQagrupa#"><cfelse>null</cfif>		
		, PQadelanto = <cfif IsDefined("Arguments.PQadelanto")><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQadelanto#"><cfelse>null</cfif>				
		, PQtransaccion = <cfif IsDefined("Arguments.PQtransaccion")><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQtransaccion#"><cfelse>null</cfif>						
		, TRANUC = <cfif IsDefined("Arguments.TRANUC")><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TRANUC#"><cfelse>null</cfif>								

		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">

	<cfquery datasource="#session.dsn#">
		delete ISBpaquete
		where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="Miso4217" type="string" required="No" default="" displayname="Iso4217">
  <cfargument name="MRidMayorista" type="string" required="No"  displayname="ID de mayorista de Red (CT/AMNET)">
  <cfargument name="PQnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="PQdescripcion" type="string" required="Yes"  displayname="Descripción">
  <cfargument name="PQinicio" type="string" required="No"  displayname="Inicio">
  <cfargument name="PQcierre" type="string" required="No"  displayname="Cese">
  <cfargument name="PQcomisionTipo" type="string" required="Yes"  displayname="Tipo de comisión">
  <cfargument name="PQpagodeposito" type="string" required="Yes"  displayname="Modo pago depósito">
  <cfargument name="PQcomisionPctj" type="string" required="No"  displayname="% Comisión">
  <cfargument name="PQcomisionMnto" type="string" required="No"  displayname="Monto comisión">
  <cfargument name="PQtoleranciaGarantia" type="string" required="No"  displayname="Tolerancia garantía">
  <cfargument name="PQtarifaBasica" type="string" required="No"  displayname="Tarifa básica">
  <cfargument name="PQcompromiso" type="boolean" required="Yes"  displayname="compromiso">
  <cfargument name="PQhorasBasica" type="string" required="No"  displayname="Horas básicas">
  <cfargument name="PQprecioExc" type="string" required="No"  displayname="Precio excedente">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="PQroaming" type="boolean" required="Yes"  displayname="Permite roaming">
  <cfargument name="PQautogestion" type="boolean" required="Yes"  displayname="Permite autogestion">
  <cfargument name="PQutilizadoagente" type="boolean" required="Yes"  displayname="Utilizado para Agente">
  <cfargument name="PQmailQuota" type="string" required="No"  displayname="Mail Quota">
  <cfargument name="PQinterfaz" type="boolean" required="Yes"  displayname="Interno para interfaz">
  <cfargument name="PQtelefono" type="boolean" required="Yes"  displayname="Requiere telefono de acceso único">
  <cfargument name="PQmaxSession" type="numeric" required="no" displayname="Limitar máximo número de sesiones">
  <cfargument name="CINCAT" type="numeric" required="no" displayname="Código para interfaz">  
  <cfargument name="PQagrupa" type="numeric" required="no" displayname="Código la agrupacion">  
  <cfargument name="PQadelanto" type="string" required="no" displayname="Si aplica, No aplica Pago adelantado">
  <cfargument name="PQtransaccion" type="string" required="no" displayname="Código de la transaccion">
  <cfargument name="TRANUC" type="string" required="no" displayname="TRANUC">
  <cfargument name="PQfileconfigura" type="string" default="N">
	
	<cfquery  name="rsAlta" datasource="#session.dsn#">
		insert into ISBpaquete (
			
			PQcodigo,
			Ecodigo,
			Miso4217,
			MRidMayorista,
			
			PQnombre,
			PQdescripcion,
			PQinicio,
			PQcierre,
			
			PQcomisionTipo,
			PQpagodeposito,
			PQcomisionPctj,
			PQcomisionMnto,
			PQtoleranciaGarantia,
			
			PQtarifaBasica,
			PQcompromiso,
			PQhorasBasica,
			PQprecioExc,
			
			Habilitado,
			PQroaming,
			PQautogestion,
			PQutilizadoagente,
			PQmailQuota,
			PQinterfaz,
			
			PQtelefono,
			PQmaxSession,
			CINCAT,
			
			PQagrupa,
			PQadelanto,
			PQtransaccion,
			TRANUC,
			PQfileconfigura,	
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfif isdefined("Arguments.Miso4217") and Len(Trim(Arguments.Miso4217))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Miso4217#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.MRidMayorista") and Len(Trim(Arguments.MRidMayorista))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRidMayorista#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQnombre#" null="#Len(Arguments.PQnombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQdescripcion#" null="#Len(Arguments.PQdescripcion) Is 0#">,
			<cfif isdefined("Arguments.PQinicio") and Len(Trim(Arguments.PQinicio))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.PQinicio#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.PQcierre") and Len(Trim(Arguments.PQcierre))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.PQcierre#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcomisionTipo#" null="#Len(Arguments.PQcomisionTipo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQpagodeposito#" null="#Len(Arguments.PQpagodeposito) Is 0#">,
			<cfif isdefined("Arguments.PQcomisionPctj") and Len(Trim(Arguments.PQcomisionPctj))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQcomisionPctj#" scale="2"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.PQcomisionMnto") and Len(Trim(Arguments.PQcomisionMnto))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQcomisionMnto#" scale="2"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.PQtoleranciaGarantia") and Len(Trim(Arguments.PQtoleranciaGarantia))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQtoleranciaGarantia#" scale="2"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.PQtarifaBasica") and Len(Trim(Arguments.PQtarifaBasica))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQtarifaBasica#" scale="2"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQcompromiso#" null="#Len(Arguments.PQcompromiso) Is 0#">,
			<cfif isdefined("Arguments.PQhorasBasica") and Len(Trim(Arguments.PQhorasBasica))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PQhorasBasica#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.PQprecioExc") and Len(Trim(Arguments.PQprecioExc))><cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.PQprecioExc#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQroaming#" null="#Len(Arguments.PQroaming) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQautogestion#" null="#Len(Arguments.PQautogestion) Is 0#">,			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQutilizadoagente#">,
			<cfif isdefined("Arguments.PQmailQuota") and Len(Trim(Arguments.PQmailQuota))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PQmailQuota#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQinterfaz#" null="#Len(Arguments.PQinterfaz) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.PQtelefono#" null="#Len(Arguments.PQtelefono) Is 0#">,
			<cfif IsDefined("Arguments.PQmaxSession")><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQmaxSession#"><cfelse>null</cfif>,
			<cfif IsDefined("Arguments.CINCAT")><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CINCAT#"><cfelse>null</cfif>,
			
			<cfif IsDefined("Arguments.PQagrupa")><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PQagrupa#"><cfelse>null</cfif>,
			<cfif IsDefined("Arguments.PQadelanto")><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQadelanto#"><cfelse>null</cfif>,
			<cfif IsDefined("Arguments.PQtransaccion")><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQtransaccion#"><cfelse>null</cfif>,			
			<cfif IsDefined("Arguments.TRANUC")><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TRANUC#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PQfileconfigura#" null="#Len(Arguments.PQfileconfigura) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
	
</cffunction>

<cffunction name="DeshabilitarPQ" output="false" returntype="void" access="remote">
 	 <cfargument name="Ecodigo" type="numeric" required="No" default="#session.Ecodigo#"  displayname="Empresa">
	 <cfargument name="datasource" type="string" required="No" default="#session.DSN#"  displayname="Conexión">

	<cfdump var="entro">
	
	<cfquery datasource="#Arguments.datasource#">
		Update ISBpaquete Set Habilitado = 0
		Where PQcierre <= getdate()
	</cfquery>
</cffunction>

</cfcomponent>

