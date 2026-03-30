<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBtarifaHorario">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="TAtarifa" type="numeric" required="Yes"  displayname="Identificador tarifa">
  <cfargument name="TAlinea" type="numeric" required="Yes"  displayname="Detalle de tarifa">
  <cfargument name="TAdia" type="numeric" required="Yes"  displayname="Dia (D=1..S=7)">
  <cfargument name="TAhoraDesde" type="date" required="Yes"  displayname="Hora desde">
  <cfargument name="TAhoraHasta" type="date" required="Yes"  displayname="Hora hasta">
  <cfargument name="_TAdia" type="numeric" required="Yes"  displayname="Dia (D=1..S=7)">
  <cfargument name="_TAhoraDesde" type="date" required="Yes"  displayname="Hora desde">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBtarifaHorario"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="TAtarifa"
				type1="numeric"
				value1="#Arguments.TAtarifa#"
				field2="TAlinea"
				type2="integer"
				value2="#Arguments.TAlinea#"
				field3="TAdia"
				type3="integer"
				value3="#Arguments._TAdia#"
				field4="TAhoraDesde"
				type4="time"
				value4="#Arguments._TAhoraDesde#">
	<cfquery datasource="#session.dsn#">
		update ISBtarifaHorario
		
		set TAhoraHasta = <cfqueryparam cfsqltype="cf_sql_time" value="#Arguments.TAhoraHasta#" null="#Len(Arguments.TAhoraHasta) Is 0#">
		, TAhoraDesde = <cfqueryparam cfsqltype="cf_sql_time" value="#Arguments.TAhoraDesde#" null="#Len(Arguments.TAhoraDesde) Is 0#">
		, TAdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAdia#" null="#Len(Arguments.TAdia) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
		  and TAlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAlinea#" null="#Len(Arguments.TAlinea) Is 0#">
		  and TAdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments._TAdia#" null="#Len(Arguments._TAdia) Is 0#">
		  and TAhoraDesde = <cfqueryparam cfsqltype="cf_sql_time" value="#Arguments._TAhoraDesde#" null="#Len(Arguments._TAhoraDesde) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="TAtarifa" type="numeric" required="Yes"  displayname="Identificador tarifa">
  <cfargument name="TAlinea" type="numeric" required="Yes"  displayname="Detalle de tarifa">
  <cfargument name="TAdia" type="numeric" required="Yes"  displayname="Dia (D=1..S=7)">
  <cfargument name="TAhoraDesde" type="date" required="Yes"  displayname="Hora desde">
  <cfargument name="TAhoraHasta" type="date" required="Yes"  displayname="Hora hasta">
	<!-----<cfquery datasource="#session.dsn#">
		update ISBtarifaHorario
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
		  and TAlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAlinea#" null="#Len(Arguments.TAlinea) Is 0#">
		  and TAdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAdia#" null="#Len(Arguments.TAdia) Is 0#">
		  and TAhoraDesde = <cfqueryparam cfsqltype="cf_sql_time" value="#Arguments.TAhoraDesde#" null="#Len(Arguments.TAhoraDesde) Is 0#">
	</cfquery>---->
	<cfquery datasource="#session.dsn#">
		delete ISBtarifaHorario
		
		where TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">
		  and TAlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAlinea#" null="#Len(Arguments.TAlinea) Is 0#">
		  and TAdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAdia#" null="#Len(Arguments.TAdia) Is 0#">
		  and TAhoraDesde = <cfqueryparam cfsqltype="cf_sql_time" value="#Arguments.TAhoraDesde#" null="#Len(Arguments.TAhoraDesde) Is 0#">
		  and TAhoraHasta = <cfqueryparam cfsqltype="cf_sql_time" value="#Arguments.TAhoraHasta#" null="#Len(Arguments.TAhoraHasta) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="TAtarifa" type="numeric" required="Yes"  displayname="Identificador tarifa">
  <cfargument name="TAlinea" type="numeric" required="Yes"  displayname="Detalle de tarifa">
  <cfargument name="TAdia" type="numeric" required="Yes"  displayname="Dia (D=1..S=7)">
  <cfargument name="TAhoraDesde" type="date" required="Yes"  displayname="Hora desde">
  <cfargument name="TAhoraHasta" type="date" required="Yes"  displayname="Hora hasta">

	<cfquery datasource="#session.dsn#">
		insert into ISBtarifaHorario (
			
			TAtarifa,
			TAlinea,
			TAdia,
			TAhoraDesde,
			
			TAhoraHasta,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Len(Arguments.TAtarifa) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAlinea#" null="#Len(Arguments.TAlinea) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TAdia#" null="#Len(Arguments.TAdia) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_time" value="#Arguments.TAhoraDesde#" null="#Len(Arguments.TAhoraDesde) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_time" value="#Arguments.TAhoraHasta#" null="#Len(Arguments.TAhoraHasta) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

