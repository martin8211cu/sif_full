<cfparam name="form.la_empresa" type="numeric">
<cfparam name="form.PBinactivo" type="numeric" default="0">
<cfquery datasource="asp" name="empresa">
	select Ecodigo, coalesce (Ereferencia, -1) as Ereferencia, Enombre
	from Empresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.la_empresa#">
</cfquery>
<cfif empresa.RecordCount is 0>
	<cfthrow message="Empresa inválida">
</cfif>

<cfquery datasource="asp" name="registro_actual">
	select e.PBtabla
	from PBitacoraEmp e
	where e.PBtabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PBtabla#" null="#Len(form.PBtabla) Is 0#">
	  and e.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.la_empresa#" null="#Len(form.la_empresa) Is 0#">
</cfquery>

<cfif registro_actual.RecordCount and form.PBinactivo Is 1>
		<cf_dbtimestamp datasource="asp"
				table="PBitacoraEmp"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="PBtabla"
				type1="char"
				value1="#form.PBtabla#"
			
				field2="EcodigoSDC"
				type2="numeric"
				value2="#empresa.Ecodigo#"
		>
	
	<cfquery datasource="asp">
		update PBitacoraEmp
		set PBinactivo = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.PBinactivo Is 1#">
		  , Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa.Ereferencia#">
		where PBtabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PBtabla#" null="#Len(form.PBtabla) Is 0#">
		  and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa.Ecodigo#">
	</cfquery>

	<cflocation url="PBitacoraEmp.cfm?PBtabla=#URLEncodedFormat(form.PBtabla)#&la_empresa=#URLEncodedFormat(empresa.Ecodigo)#">

<cfelseif registro_actual.RecordCount and form.PBinactivo Is 0>
	<cfquery datasource="asp">
		delete PBitacoraEmp
		where PBtabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.PBtabla#" null="#Len(form.PBtabla) Is 0#">
		  and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa.Ecodigo#">
	</cfquery>
<cfelseif registro_actual.RecordCount is 0 and form.PBinactivo Is 1>
	<cfquery datasource="asp">
		insert into PBitacoraEmp (
			PBtabla,
			Ecodigo,
			PBinactivo,
			EcodigoSDC)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.PBtabla#" null="#Len(form.PBtabla) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#empresa.Ereferencia#" null="#Len(empresa.Ereferencia) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#form.PBinactivo Is 1#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa.Ecodigo#" null="#Len(empresa.Ecodigo) Is 0#">)
	</cfquery>
<cfelse>
	<!---
		registro_actual.RecordCount is 0 and form.PBinactivo Is 0 : No hacer nada
	--->
</cfif>

<cflocation url="PBitacoraEmp.cfm?la_empresa=#URLEncodedFormat(form.la_empresa)#&PBtabla=#URLEncodedFormat(form.PBtabla)#">


