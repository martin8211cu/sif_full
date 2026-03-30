<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBtarifa">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="TAtarifa" type="numeric" required="Yes"  displayname="Identificador tarifa">
  <cfargument name="Miso4217" type="string" required="Yes"  displayname="Moneda">
  <cfargument name="TAnombreTarifa" type="string" required="Yes"  displayname="Nombre de tarifa">
  <cfargument name="TAunidades" type="numeric" required="Yes"  displayname="Unidades (segundos)">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBtarifa"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="TAtarifa"
				type1="numeric"
				value1="#Arguments.TAtarifa#">
	<cfquery datasource="#session.dsn#">
		update ISBtarifa
		
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Miso4217#" null="#Len(Arguments.Miso4217) Is 0#">
		, TAnombreTarifa = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TAnombreTarifa#" null="#Len(Arguments.TAnombreTarifa) Is 0#">
		
		, TAunidades = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAunidades#" null="#Len(Arguments.TAunidades) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="TAtarifa" type="numeric" required="Yes"  displayname="Identificador tarifa">
	<cfquery datasource="#session.dsn#">
		update ISBtarifaHorario
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update ISBtarifaDetalle
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		update ISBtarifa
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete ISBtarifaHorario
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBtarifaDetalle
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBtarifa
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Miso4217" type="string" required="Yes"  displayname="Moneda">
  <cfargument name="TAnombreTarifa" type="string" required="Yes"  displayname="Nombre de tarifa">
  <cfargument name="TAunidades" type="numeric" required="Yes"  displayname="Unidades (segundos)">

	<cfquery datasource="#session.dsn#" name="alta_tarifa">
		insert into ISBtarifa (
			Ecodigo,
			Miso4217,
			TAnombreTarifa,
			
			TAunidades,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Miso4217#" null="#Len(Arguments.Miso4217) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TAnombreTarifa#" null="#Len(Arguments.TAnombreTarifa) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAunidades#" null="#Len(Arguments.TAunidades) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 datasource="#session.dsn#" name="alta_tarifa" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#session.dsn#" name="alta_tarifa" verificar_transaccion="false">
	
	<cfinvoke component="saci.comp.ISBtarifaDetalle" method="Alta"  >
		<cfinvokeargument name="TAtarifa" value="#alta_tarifa.identity#">
		<cfinvokeargument name="TAlinea" value="1">
		<cfinvokeargument name="TAlineaNombre" value="Tarifa regular">
		<cfinvokeargument name="TAlineaDefault" value="true">
		<cfinvokeargument name="TAtarifaBasica" value="0">
		<cfinvokeargument name="TAprecioBase" value="0">
		<cfinvokeargument name="TAprecioExc" value="0">
		<cfinvokeargument name="TAredondeoMetodo" value="C">
		<cfinvokeargument name="TAredondeoMultiplo" value="1">
	</cfinvoke>
	
	<cfreturn alta_tarifa.identity>
	
</cffunction>

</cfcomponent>

