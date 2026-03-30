<cfoutput>
	<cfif IsDefined("form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
					table="RHAreasCapacitacion"
					redirect="areasCapacitacion.cfm"
					timestamp="#form.ts_rversion#"
					field1="RHACid"
					type1="numeric"
					value1="#form.RHACid#"
			>
		
		<cfquery datasource="#session.dsn#">
			update RHAreasCapacitacion
			set RHACcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHACcodigo#" null="#Len(form.RHACcodigo) Is 0#">, 
				RHACdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHACdescripcion#" null="#Len(form.RHACdescripcion) Is 0#">
			where RHACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACid#" null="#Len(form.RHACid) Is 0#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
	<cfelseif IsDefined("form.Baja")>
		<cfquery datasource="#session.dsn#">
			delete from RHAreasCapacitacion
			where RHACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACid#" null="#Len(form.RHACid) Is 0#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	<cfelseif IsDefined("form.Nuevo")>
		<cfelseif IsDefined("form.Alta")>
			<cfquery datasource="#session.dsn#">
				insert into RHAreasCapacitacion (
					Ecodigo,
					RHACcodigo,
					RHACdescripcion,				
					BMfecha,
					BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHACcodigo#" null="#Len(form.RHACcodigo) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHACdescripcion#" null="#Len(form.RHACdescripcion) Is 0#">,
					
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			</cfquery>
		<!---<cfelse>
			 Tratar como form.nuevo --->
		</cfif>
	
	<form action="areasCapacitacion.cfm" method="post" name="sql">
		<cfif isdefined("form.Cambio")>
			<input name="RHACid" type="hidden" value="#form.RHACid#">
		</cfif>
	</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>


