<cfset params = "">
<cfset modoreturn = "ALTA">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_Error_la_fecha_de_corte_seleccionada_es_invalida_Existen_Relaciones_con_fechas_de_corte_superiores_a_la_fecha_de_corte_seleccionada"
Default="Error, la fecha de corte seleccionada es inv&aacute;lida. Existen Relaciones con fechas de corte superiores a la fecha de corte seleccionada."
returnvariable="MG_FechaCorte"/> 

<cftransaction>
	<cfif isdefined("form.Alta")>
		<cfquery name="rsFechaCorte" datasource="#Session.DSN#">
			Select 1
			from RHRelacionCalificacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHRCfcorte > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHRCfcorte)#">		
				and RHRCestado > 0
		</cfquery>
	
		<cfif isdefined('rsFechaCorte') and rsFechaCorte.recordCount GT 0>
			<cf_throw message="#MG_FechaCorte#" errorcode="10005">
			<cfset modoreturn = "ALTA">
		<cfelse>
			<cfquery name="ABC_ActCompe" datasource="#Session.DSN#">
				insert into RHRelacionCalificacion 
					(Ecodigo, RHRCdesc, RHRCfdesde, RHRCfhasta, RHRCfcorte, RHRCitems, RHRCestado, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.RHRCdesc#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.RHRCfdesde)#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.RHRCfhasta)#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.RHRCfcorte)#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.RHRCitems#">
					, 0
					, <cfqueryparam cfsqltype="cf_sql_numeric" 		value="#session.Usucodigo#">)
					
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_ActCompe">
			
			<cfset modoreturn = "CAMBIO">
		</cfif>	
	<cfelseif isdefined("form.Cambio")>
		<cfquery name="rsFechaCorte" datasource="#Session.DSN#">
			Select 1
			from RHRelacionCalificacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
				and RHRCfcorte > <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.RHRCfcorte)#">	
				and RHRCestado > 0
		</cfquery>
	
		<cf_dbtimestamp datasource="#session.dsn#"
						table="RHRelacionCalificacion"
						redirect="actCompetencias.cfm"
						timestamp="#form.ts_rversion#"				
						field1="RHRCid" 
						type1="numeric" 
						value1="#Form.RHRCid#">
							
		<cfquery name="ABC_ActCompe" datasource="#Session.DSN#">
			update RHRelacionCalificacion set 
				RHRCdesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRCdesc#">
				, RHRCfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.RHRCfdesde)#">
				, RHRCfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.RHRCfhasta)#">
				, RHRCfcorte = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.RHRCfcorte)#">
				, RHRCitems = <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.RHRCitems#">
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">
			where RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		
		<cfset modoreturn = "CAMBIO">	
	<cfelseif isdefined("form.Baja")>
		<cfquery name="ABC_ActCompe" datasource="#Session.DSN#">
			Delete from RHEvaluacionComp 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
				and RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
		</cfquery>
			
		<cfquery name="ABC_ActCompe" datasource="#Session.DSN#">
			Delete from RHEmpleadosCF 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
				and RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
		</cfquery>			

		<cfquery name="ABC_ActCompe" datasource="#Session.DSN#">
			Delete from RHEvaluadoresCalificacion 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
				and RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
		</cfquery>			

		<cfquery name="ABC_ActCompe" datasource="#Session.DSN#">
			Delete from RHRelacionCalificacion 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
				and RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
		</cfquery>			

		<cfset modoreturn = "ALTA">
	</cfif>
</cftransaction>
<cfif modoreturn eq "CAMBIO">
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=CAMBIO">
	<cfif isdefined('form.Alta') and isdefined("ABC_ActCompe")>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHRCid="  &  ABC_ActCompe.identity>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "Sel=1">		
	<cfelseif isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0 and form.RHRCid neq -1>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHRCid="  &  form.RHRCid>
	</cfif>
<cfelseif isdefined("form.Nuevo")>
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=ALTA">
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "btnNuevo=Nuevo">
</cfif>
<cflocation url="actCompetencias.cfm#params#">
