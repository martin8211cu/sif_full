<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		 <cfif isdefined("Form.Alta")>
			<cfquery name="rsRHLiqCargas" datasource="#session.DSN#">
				insert into RHLiqCargasPrev (RHPLPid, DEid, DClinea, SNcodigo, Ecodigo, RHLCdescripcion, importe, fechaalta, RHLCautomatico, BMUsucodigo)
				select 
					RHPLPid,
					DEid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">,
					0,
					Ecodigo,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.Ivalor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from RHPreLiquidacionPersonal 
				where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
			</cfquery>

		<cfelseif isdefined("Form.Baja")> 
			<cfquery name="delRHLiqCargas" datasource="#Session.DSN#">
				delete RHLiqCargasPrev
				where RHLPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLPCid#">
				and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			</cfquery>
			<cfset Form.Nuevo = "1">
			
		<cfelseif isdefined("Form.Cambio")>
 				
			<cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHLiqCargasPrev set
					importe = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.Ivalor#">
				where RHLPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLPCid#">
				and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
			</cfquery>
				
		</cfif>
	
	</cfif>
</cftransaction>
