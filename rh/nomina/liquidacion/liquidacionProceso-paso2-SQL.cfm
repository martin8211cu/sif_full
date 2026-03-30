<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		 <cfif isdefined("Form.Alta")>
			<cfquery name="rsRHLiqCargas" datasource="#session.DSN#">
				insert into RHLiqCargas (DLlinea, DEid, DClinea, SNcodigo, Ecodigo, RHLCdescripcion, importe, fechaalta, RHLCautomatico, BMUsucodigo)
				select 
					DLlinea,
					DEid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">,
					0,
					Ecodigo,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DCdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.Ivalor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from RHLiquidacionPersonal 
				where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
			</cfquery>

		<cfelseif isdefined("Form.Baja")> 
			<cfquery name="delRHLiqCargas" datasource="#Session.DSN#">
				delete RHLiqCargas
				where RHLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLCid#">
				and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
			</cfquery>
			<cfset Form.Nuevo = "1">
			
		<cfelseif isdefined("Form.Cambio")>
 				
			<cfquery name="updRHConcursos" datasource="#Session.DSN#">
				update RHLiqCargas set
					importe = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.Ivalor#">
				where RHLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLCid#">
				and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
			</cfquery>
				
		</cfif>
	
	</cfif>
</cftransaction>
