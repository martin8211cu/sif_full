<cfoutput>
	<cfif IsDefined("form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
					table="RHAreaGrupoMat"
					redirect="areasCapacitacion.cfm"
					timestamp="#form.ts_rversion#"
					field1="RHAGMid"
					type1="numeric"
					value1="#form.RHAGMid#"
			>
		
		<cfquery datasource="#session.dsn#">
			update RHAreaGrupoMat
			set RHAGMnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHAGMnombre#" null="#Len(form.RHAGMnombre) Is 0#">
			where RHAGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAGMid#" null="#Len(form.RHAGMid) Is 0#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
	<cfelseif IsDefined("form.Baja")>
		<cfquery datasource="#session.dsn#">
			delete from RHAreaGrupoMat
			where RHAGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAGMid#" null="#Len(form.RHAGMid) Is 0#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	<cfelseif IsDefined("form.Nuevo")>
		<cfelseif IsDefined("form.Alta")>
			<cfquery datasource="#session.dsn#">
				insert into RHAreaGrupoMat (
					Ecodigo,
					RHAGMnombre,				
					BMfecha,
					BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHAGMnombre#" null="#Len(form.RHAGMnombre) Is 0#">,
					
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			</cfquery>
		<!---<cfelse>
			 Tratar como form.nuevo --->
		</cfif>
	
	<form action="RHAreaGrupoMat.cfm" method="post" name="sql">
		<cfif isdefined("form.Cambio")>
			<input name="RHAGMid" type="hidden" value="#form.RHAGMid#">
		</cfif>
	</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>


