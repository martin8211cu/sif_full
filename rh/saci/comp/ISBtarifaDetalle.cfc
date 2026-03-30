<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBtarifaDetalle">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="TAtarifa" type="numeric" required="Yes"  displayname="Identificador tarifa">
  <cfargument name="TAlinea" type="numeric" required="Yes"  displayname="Detalle de tarifa">
  <cfargument name="TAlineaNombre" type="string" required="Yes"  displayname="Nombre de línea">
  <cfargument name="TAtarifaBasica" type="numeric" required="Yes"  displayname="Unidades incluidas">
  <cfargument name="TAprecioBase" type="numeric" required="Yes"  displayname="Precio base">
  <cfargument name="TAprecioExc" type="numeric" required="Yes"  displayname="Unidad excedente">
  <cfargument name="TAredondeoMetodo" type="string" required="Yes"  displayname="Redondeo">
  <cfargument name="TAredondeoMultiplo" type="numeric" required="Yes"  displayname="Segundos redondeo">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBtarifaDetalle"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="TAtarifa"
				type1="numeric"
				value1="#Arguments.TAtarifa#"
				field2="TAlinea"
				type2="integer"
				value2="#Arguments.TAlinea#">
	<cfquery datasource="#session.dsn#">
		update ISBtarifaDetalle
		set TAlineaNombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TAlineaNombre#" null="#Len(Arguments.TAlineaNombre) Is 0#">
		
		, TAtarifaBasica = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.TAtarifaBasica#" null="#Len(Arguments.TAtarifaBasica) Is 0#">
		, TAprecioBase = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.TAprecioBase#" null="#Len(Arguments.TAprecioBase) Is 0#">
		, TAprecioExc = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.TAprecioExc#" null="#Len(Arguments.TAprecioExc) Is 0#">
		, TAredondeoMetodo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TAredondeoMetodo#" null="#Len(Arguments.TAredondeoMetodo) Is 0#">
		
		, TAredondeoMultiplo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAredondeoMultiplo#" null="#Len(Arguments.TAredondeoMultiplo) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
		  and TAlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAlinea#" null="#Len(Arguments.TAlinea) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote" hint="no borra la linea default. Solo se borra junto con el encabezado">
  <cfargument name="TAtarifa" type="numeric" required="Yes"  displayname="Identificador tarifa">
  <cfargument name="TAlinea" type="numeric" required="Yes"  displayname="Detalle de tarifa">
	<cfquery datasource="#session.dsn#">
		update ISBtarifaDetalle
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
		  and TAlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAlinea#" null="#Len(Arguments.TAlinea) Is 0#">
		  and TAlineaDefault = 0
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBtarifaDetalle
		
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
		  and TAlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAlinea#" null="#Len(Arguments.TAlinea) Is 0#">
		  and TAlineaDefault = 0
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="TAtarifa" type="numeric" required="Yes"  displayname="Identificador tarifa">
  <cfargument name="TAlinea" type="numeric" required="Yes"  displayname="Detalle de tarifa">
  <cfargument name="TAlineaNombre" type="string" required="Yes"  displayname="Nombre de línea">
  <cfargument name="TAlineaDefault" type="boolean" required="Yes"  displayname="Linea de default">
  <cfargument name="TAtarifaBasica" type="numeric" required="Yes"  displayname="Unidades incluidas">
  <cfargument name="TAprecioBase" type="numeric" required="Yes"  displayname="Precio base">
  <cfargument name="TAprecioExc" type="numeric" required="Yes"  displayname="Unidad excedente">
  <cfargument name="TAredondeoMetodo" type="string" required="Yes"  displayname="Redondeo">
  <cfargument name="TAredondeoMultiplo" type="numeric" required="Yes"  displayname="Segundos redondeo">

	<cfquery datasource="#session.dsn#">
		insert into ISBtarifaDetalle (
			
			TAtarifa,
			TAlinea,
			TAlineaNombre,
			TAlineaDefault,
			
			TAtarifaBasica,
			TAprecioBase,
			TAprecioExc,
			TAredondeoMetodo,
			
			TAredondeoMultiplo,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAlinea#" null="#Len(Arguments.TAlinea) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TAlineaNombre#" null="#Len(Arguments.TAlineaNombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.TAlineaDefault#" null="#Len(Arguments.TAlineaDefault) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.TAtarifaBasica#" null="#Len(Arguments.TAtarifaBasica) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.TAprecioBase#" null="#Len(Arguments.TAprecioBase) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.TAprecioExc#" null="#Len(Arguments.TAprecioExc) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TAredondeoMetodo#" null="#Len(Arguments.TAredondeoMetodo) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAredondeoMultiplo#" null="#Len(Arguments.TAredondeoMultiplo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

