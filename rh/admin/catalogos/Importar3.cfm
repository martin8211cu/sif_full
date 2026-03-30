<cfparam name="form.RHRPTNid" default="">
<cfset qenc = session.importar_enc>
<cfset qdet = session.importar_det>

<cfloop from="1" to="#ListLen(form.RHRPTNid)#" index="current">
	<cfset CurrentRHRPTNid = ListGetAt(form.RHRPTNid,Current)>
	<cfoutput><cf_translate  key="LB_Procesando">Procesando</cf_translate>: #CurrentRHRPTNid#<br></cfoutput>

	<cfquery dbtype="query" name="enc">
		select * from qenc
		where RHRPTNid = #CurrentRHRPTNid#
	</cfquery>
	<cfif enc.RecordCount NEQ 1>
		<cf_errorCode	code = "50383"
						msg  = "El archivo no contenía uno, sino @errorDat_1@ registros para @errorDat_2@"
						errorDat_1="#enc.RecordCount#"
						errorDat_2="#CurrentRHRPTNid#"
		>
	</cfif>
	
	<cfquery dbtype="query" name="det">
		select *
		from qdet
		where RHRPTNid = #CurrentRHRPTNid#
	</cfquery>

	<cftransaction>
		<!--- Renombrar anterior 
		<cfset prefix = Trim(Left(enc.RHRPTNcodigo,8))>
		<cfquery datasource="#session.DSN#" name="maxcodigo" maxrows="1">
			select RHRPTNcodigo
			from RHReportesNomina
			where RHRPTNcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#prefix#.%">
			order by 1 desc
		</cfquery>
		<cfif Len(maxcodigo.RHRPTNcodigo)>
			<cfset maxext = Trim(Mid(maxcodigo.RHRPTNcodigo,Len(prefix)+2,3))+1>
		<cfelse>
			<cfset maxext = 1>
		</cfif>
		<cfset renameto = UCase(Trim(Left(enc.RHRPTNcodigo,8))) & '.' & NumberFormat(maxext,'000')>
		<cfquery datasource="#session.DSN#">
			update RHReportesNomina
			set RHRPTNcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(ltrim(renameto))#">
			where RHRPTNcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(ltrim(enc.RHRPTNcodigo))#">
		</cfquery>--->
		<!--- Encabezado DImportador --->
		<cfquery datasource="#session.DSN#" name="inserta">
			insert into RHReportesNomina(Ecodigo,RHRPTNcodigo, RHRPTNdescripcion, RHRPTNlineas,BMUsucodigo, fechaalta)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				'#UCase(rtrim(enc.RHRPTNcodigo))#',
				'#enc.RHRPTNdescripcion#',
				#enc.RHRPTNlineas#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
		<cfset InsertedRHRPTNid = inserta.identity>
		<!--- Detalle RHColumnasReporte --->
		<cfloop query="det">
			<cfquery datasource="#session.DSN#">
				insert into RHColumnasReporte(RHRPTNid,RHCRPTcodigo ,RHCRPTdescripcion,RHRPTNcolumna,BMUsucodigo,fechaalta)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#InsertedRHRPTNid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#det.RHCRPTcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#det.RHCRPTdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer"  value="#det.RHRPTNcolumna#">,
					<!---<cfqueryparam cfsqltype="cf_sql_varchar"  value="#det.RHRPTNcolumna#">,--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>
		</cfloop>
	</cftransaction>

	<cfoutput><cf_translate  key="LB_Terminado">Terminado</cf_translate>:  #CurrentRHRPTNid#<br></cfoutput>
</cfloop>
<cfif Not IsDefined('form.included')>
	<cflocation url="ReportesDinamicos-lista.cfm">
</cfif>

