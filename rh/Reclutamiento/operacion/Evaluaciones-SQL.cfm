<cfif isdefined("Form.Descalificar")>
	<cfquery datasource="#session.DSN#">
		update RHConcursantes 
		set	RHCdescalifica = 1,
			RHCPpromedio = 0,
			RHCevaluado = 0,
			RHCrazondeacalifica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCrazondeacalifica#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from RHCalificaAreaConcursante
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from RHCalificaCompPrueOfer
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from RHCalificaPrueConcursante
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCPid#">		
	</cfquery>
</cfif>
			
<form action="RegistroEval.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined("form.RHCPid")><input name="RHCPid" type="hidden" value="#form.RHCPid#"></cfif>
		<cfif isdefined("form.RHCconcurso")><input name="RHCconcurso" type="hidden" value="#form.RHCconcurso#"></cfif>
	</cfoutput>
</form>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>