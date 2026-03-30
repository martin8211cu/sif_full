<cfparam name="form.EIcodigo" default="*">

<cfif form.EIcodigo EQ '*'>
	<cflocation url="impbuscar.cfm">
</cfif>

<cfquery datasource="sifcontrol" name="eis">
	select EIid, rtrim(EIcodigo) as EIcodigo, rtrim(EImodulo) as EImodulo, EIdescripcion
	from EImportador
	where EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EIcodigo#">
</cfquery>

  <cftry>
	<cfinvoke component="asp.parches.comp.parche"
		method="add_entry" collection="importar"
		mapkey="#eis.EIcodigo#" 
		EIcodigo="#eis.EIcodigo#"
		EIdescripcion="#eis.EIdescripcion#"
		EImodulo="#eis.EImodulo#"
		checksum=""/>
    <cfcatch type="any">
      <cfset str = StructNew()>
      <cfset str.msg = cfcatch.Message & ' ' & cfcatch.Detail>
      <cfset str.archivo = #EIcodigo#>
      <cfset ArrayAppend(session.parche.errores, str)>
    </cfcatch>
  </cftry>

<cflocation url="impbuscar.cfm?EImodulo=# URLEncodedFormat( eis.EImodulo) #">
