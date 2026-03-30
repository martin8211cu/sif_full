<cfif IsDefined("form.Cambio") or IsDefined("form.Alta") >
	<cfif len(trim(form.RHECfdesde)) eq 0><cfset form.RHECfdesde = '01/01/6100' ></cfif>
	<cfif len(trim(form.RHECfhasta)) eq 0><cfset form.RHECfhasta = '01/01/6100' ></cfif>
	<cfif datecompare(LSparseDateTime(form.RHECfdesde),LSparseDateTime(form.RHECfhasta)) gte 1>
		<cfset tmp = form.RHECfdesde >
		<cfset form.RHECfdesde = form.RHECfhasta >
		<cfset form.RHECfhasta = tmp >
	</cfif>
</cfif>

<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#">
		update RHEmpleadoCurso
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		, RHEMnotamin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.RHEMnotamin,',','','all')#" null="#Len(form.RHEMnotamin) Is 0#">
		, RHEMnota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.RHEMnota,',','','all')#" null="#Len(form.RHEMnota) Is 0#">
		, RHECtotempresa = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.RHECtotempresa,',','','all')#" null="#Len(form.RHECtotempresa) Is 0#">
		, RHECtotempleado = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.RHECtotempleado,',','','all')#" null="#Len(form.RHECtotempleado) Is 0#">
		
		, idmoneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idmoneda#" null="#Len(form.idmoneda) Is 0#">
		, RHECcobrar = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHECcobrar')#">
		, RHEMestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEMestado#" null="#Len(form.RHEMestado) Is 0#">
		, RHECfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHECfdesde)#" null="#compare(trim(form.RHECfdesde), '01/01/6100') is 0#">
		, RHECfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHECfhasta)#" null="#compare(trim(form.RHECfhasta), '01/01/6100') is 0#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#" null="#Len(form.DEid) Is 0#">
		  and RHECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECid#" null="#Len(form.RHECid) Is 0#">
	</cfquery>

	<cflocation url="expediente.cfm?DEid=#URLEncodedFormat(form.DEid)#&RHECid=#URLEncodedFormat(form.RHECid)#&tab=10">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHEmpleadoCurso
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#" null="#Len(form.DEid) Is 0#">  
		  and RHECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECid#" null="#Len(form.RHECid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHEmpleadoCurso (
			
			DEid,
			Ecodigo,
			Mcodigo,
			
			RHEMnotamin,
			RHEMnota,
			RHECtotempresa,
			RHECtotempleado,
			
			idmoneda,
			RHECcobrar,
			RHEMestado,

			RHECfdesde,
			RHECfhasta,
			
			
			BMfecha,
			
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#" null="#Len(form.DEid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.RHEMnotamin,',','','all')#" null="#Len(form.RHEMnotamin) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.RHEMnota,',','','all')#" null="#Len(form.RHEMnota) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.RHECtotempresa,',','','all')#" null="#Len(form.RHECtotempresa) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.RHECtotempleado,',','','all')#" null="#Len(form.RHECtotempleado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idmoneda#" null="#Len(form.idmoneda) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHECcobrar')#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEMestado#" null="#Len(form.RHEMestado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHECfdesde)#" null="#compare(trim(form.RHECfdesde), '01/01/6100') is 0#">,
		 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHECfhasta)#" null="#compare(trim(form.RHECfhasta), '01/01/6100') is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="expediente.cfm?DEid=#form.DEid#&tab=10">


