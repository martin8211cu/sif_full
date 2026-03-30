<!---  --->
<cfif not isdefined("Form.Nuevo")>
	
	<cfif isdefined("form.alta")>
		
		<cfquery name="rsSelect" datasource="#session.DSN#">
			select count(1) as error
			from CRCentroCustodia
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and upper(ltrim(rtrim(CRCCcodigo))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(form.CRCCcodigo))#">
		</cfquery>
		
		<cfif rsSelect.RecordCount NEQ 0 and rsSelect.error EQ 0>
		
			<cftransaction>
			<cfquery name="RSInsert" datasource="#session.DSN#">
				insert into CRCentroCustodia (Ecodigo,DEid,CRCCcodigo,CRCCdescripcion,CRCCfalta,BMUsucodigo)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(form.CRCCcodigo)#">,	
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRCCdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
						<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="RSInsert">
			<cfset form.CRCCid = RSInsert.identity >
			<cfset p = "?tab=1&CRCCid=#form.CRCCid#">
			</cftransaction>
		
		<cfelse>
			<cf_errorCode	code = "50116" msg = "El Código de Centro de Custodia que desea agregar ya existe.">
			<cfset p = "?tab=1&ErrEmp=1&cod="&#form.CRCCcodigo#&"&desc="&#form.CRCCdescripcion#>
		</cfif>
		
	<cfelseif isdefined("form.cambio")>
		<cf_dbtimestamp datasource="#session.DSN#"
				table="CRCentroCustodia"
				redirect="CentroCustodia-form.cfm"
				timestamp="#form.ts_rversion#"
				field1="CRCCid" 
				type1="numeric" 
				value1="#form.CRCCid#" >
		<cfquery datasource="#session.DSN#">
			update CRCentroCustodia
			set DEid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,	
				CRCCcodigo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(form.CRCCcodigo)#">,	
				CRCCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CRCCdescripcion#">,
				CRCCfalta 		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
		</cfquery>
		<cfset p = "?tab=1&CRCCid=#form.CRCCid#">
	<cfelseif isdefined("form.Baja")>

		<cfquery name="rsVerifica1" datasource="#session.DSN#">
			select CRCCid
			from AFResponsables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			  and CRCCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
		</cfquery>

		<cfquery name="rsVerifica2" datasource="#session.DSN#">
			select CRCCid
			from AFTResponsables
			where CRCCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
		</cfquery>
			
		<cfif #rsVerifica1.recordCount# eq 0 and #rsVerifica2.recordCount# eq 0>

			<cftransaction>
				<cfquery datasource="#session.DSN#">
					delete from CRCCUsuarios
					where  CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
				</cfquery>			
	
				<cfquery datasource="#session.DSN#">
					delete from CRCCCFuncionales 
					where  CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
				</cfquery>			
	
				<cfquery datasource="#session.DSN#">
					delete from CRAClasificacion 
					where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					   and CRCCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
				</cfquery>			
				
				<cfquery datasource="#session.DSN#">
					delete from CRCentroCustodia
					where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
				</cfquery>			
			</cftransaction>
		</cfif>
		<cfset p = "?tab=1">
	</cfif>
	<cflocation url="CentroCustodia.cfm#p#">
<cfelse>	
	<cfset p = "?tab=1">
	<cflocation url="CentroCustodia.cfm#p#">
</cfif>


