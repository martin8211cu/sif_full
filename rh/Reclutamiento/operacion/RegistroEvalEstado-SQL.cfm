<cfif isdefined("form.Aplicar") >
	 <cfquery datasource="#Session.DSN#" name="rsUPD_RHIC">
		update RHConcursos
		set RHCestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCestado#">,
			RHCjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCjustificacion#">
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfoutput>
	<form action="/cfmx/rh/Reclutamiento/operacion/RegistroEval.cfm" method="post" name="sql">
		<input name="RHCconcurso" type="hidden" value="">
	</form>
	</cfoutput>
</cfif>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML> 
