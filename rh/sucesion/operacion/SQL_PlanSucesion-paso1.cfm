<cfif isdefined("Form.PSporcreq")>
	<cftransaction>
		<cfif isdefined("modo") and modo eq "ALTA">
			<cfquery name="insConcursos" datasource="#Session.DSN#">
				insert into RHPlanSucesion               
				(	RHPcodigo,  
					Ecodigo,
					PSporcreq,
					BMUsucodigo,
					fechaalta  
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PSporcreq#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
				)
			</cfquery>	
		<cfelseif isdefined("modo")  and modo eq "CAMBIO">
			<cfquery name="updatePruebas" datasource="#Session.DSN#">
				update RHPlanSucesion  set 
				PSporcreq = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PSporcreq#">
				where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
			</cfquery>
		</cfif>
	</cftransaction> 
	<cfif isdefined("Form.anterior")>
		<cfset paso = form.paso - 1> 
	<cfelseif isdefined("Form.siguiente")>
		<cfset paso = form.paso + 1> 
	<cfelse>
		<cfset paso = form.paso > 
	</cfif>
	<form name="form1" method="post" action="PlanSucesion.cfm">
		<input type="hidden"       name="paso" value="<cfoutput>#paso#</cfoutput>">
		<input name="RHPcodigo"  type="hidden" value="<cfif isdefined("Form.RHPcodigo")and (Form.RHPcodigo GT 0)><cfoutput>#Form.RHPcodigo#</cfoutput></cfif>">
	</form>
	<script language="javascript1.2" type="text/javascript">
		document.form1.submit();
	</script>
</cfif>

