<cfif isdefined("Form.btnGuardar")>
	<cfif isdefined("Form.RHPAMid") and Len(Trim(Form.RHPAMid))>
		<!--- MODO CAMBIO --->
		<cfquery name="rsUpdate" datasource="#Session.DSN#">
			update RHPeriodosAccionesM set 
				RHPAcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPAcodigo#">, 
				RHPAdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPAdescripcion#">, 
				RHPAManio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHPAManio#">, 
				RHPAMfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHPAMfdesde)#">, 
				RHPAMfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHPAMfhasta)#">
			where RHPAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPAMid#">
				and RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<!--- Actualiza campos de periodos en la tabla RHAccionesMasiva --->
		<cfquery name="rsUpdateAcciones" datasource="#Session.DSN#">
			update RHAccionesMasiva set
				RHAAperiodom = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAAperiodom#">,
				RHAAnumerop= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAnumerop#">
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
	<cfelse>
		<!--- MODO ALTA --->
		<cfquery name="rsInsert" datasource="#Session.DSN#">
			insert into RHPeriodosAccionesM (RHAid, RHPAcodigo, RHPAdescripcion, RHPAManio, RHPAMfdesde, RHPAMfhasta, Ecodigo, BMUsucodigo)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPAcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPAdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHPAManio#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHPAMfdesde)#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHPAMfhasta)#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>
		
		<!--- Actualiza campos de periodos en la tabla RHAccionesMasiva --->
		<cfquery name="rsUpdateAcciones" datasource="#Session.DSN#">
			update RHAccionesMasiva set
				RHAAperiodom = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAAperiodom#">,
				RHAAnumerop= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAnumerop#">
			where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>

	</cfif>
	
	<cfset Form.paso = 4>
</cfif>
