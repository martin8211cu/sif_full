<cfif not isdefined("form.btnNuevo")>
	<cfif isdefined("form.ALTA")>
	  	<cfquery name="RHExportacionesInsert" datasource="#Session.DSN#">
			insert into RHExportaciones 
			(Ecodigo, Bid, EIid, RHEdescripcion, Usucodigo, Ulocalizacion)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
			<cfif len(trim(Form.Bid)) gt 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#"><cfelse>null</cfif>, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEdescripcion#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">)
		</cfquery>
	  <cfelseif isdefined("form.CAMBIO")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHExportaciones"
				redirect="FExportacion.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo" 	type1="numeric" 	value1="#session.Ecodigo#"
				field2="Bid" 		type2="numeric" 	value2="#Form.Bid#"
				field3="EIid" 		type3="numeric" 	value3="#Form.EIid#">

		<cfquery name="RHExportacionesUpdate" datasource="#Session.DSN#">
			Update RHExportaciones 
			set RHEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEdescripcion#">,
				Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
				and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
		</cfquery>		
	<cfelseif isdefined("form.BAJA")>
		<cfquery name="RHExportacionesDelete" datasource="#Session.DSN#">	  	
			delete RHExportaciones 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
				and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
		</cfquery>
	</cfif>
</cfif>
<cflocation url="FExportacion.cfm">