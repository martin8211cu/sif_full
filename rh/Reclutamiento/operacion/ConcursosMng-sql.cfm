
<cfif isdefined('form.Aplicar')>
	<cfif isdefined ('form.RHCconcurso') and len(trim(form.RHCconcurso)) gt 0>
		<cfquery name="plazas" datasource="#Session.DSN#">
			select count(1) as cantidad from RHPlazasConcurso
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		</cfquery>
		<!---<cfif plazas.cantidad eq 0 and not isdefined('form.rhpid2')>
			<cfthrow message="No se puede aplicar un concurso que no tiene asociado plazas">
		</cfif>--->
		<cfquery name="concursante" datasource="#session.dsn#">
			select count(1) as cantidad from RHConcursantes
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		</cfquery>
		<cfif concursante.cantidad eq 0>
			<cfthrow message="No se puede aplicar un concurso que no tiene asociado concursantes">
		</cfif>
	</cfif>
</cfif>
<cfif isdefined("Form.tab") and Len(Trim(Form.tab))>
	<cfif Form.tab EQ 1>
		<cfinclude template="ConcursosMng-sqlDatosConcurso.cfm">
	<cfelseif Form.tab EQ 2>
		<cfinclude template="ConcursosMng-sqlPlazas.cfm">
	<cfelseif Form.tab EQ 3>
		<cfinclude template="ConcursosMng-sql_Aplica_para.cfm">
    <cfelseif Form.tab EQ 4>
		<cfinclude template="ConcursosMng-sqlCriterios.cfm">
	<cfelseif Form.tab EQ 5>
		<cfinclude template="ConcursosMng-frmConcursantes-sql.cfm">
	<cfelseif Form.tab EQ 6>
		<cfinclude template="ConcursosMng-sqlEstado.cfm">
	</cfif>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="ConcursosMng.cfm">
		<cfif isdefined("Form.tab") and Len(Trim(Form.tab))>
			<input type="hidden" name="tab" value="#Form.tab#">
		</cfif>
        <cfif isdefined("Form.externo") and Len(Trim(Form.externo))>
			<input type="hidden" name="externo" value="#Form.externo#">
		</cfif>
		<cfif isdefined("Form.op") and Len(Trim(Form.op))>
			<input type="hidden" name="op" value="<cfif Form.op EQ 4>0<cfelse>#Form.op#</cfif>">
		</cfif>
		<cfif isdefined("Form.flag") and Len(Trim(Form.flag))>
			<input type="hidden" name="flag" value="#Form.flag#">
		</cfif>
		<cfif isdefined("Form.RHCconcurso") and Len(Trim(Form.RHCconcurso)) and not (isdefined("Form.tab") and Form.tab EQ 1 and (isdefined("Form.Baja") or isdefined("Form.Aplicar")))>
			<input type="hidden" name="RHCconcurso" value="#Form.RHCconcurso#">
			<cfif isdefined("Form.RHCPid") and Len(Trim(Form.RHCPid))>
				<input type="hidden" name="RHCPid" value="#Form.RHCPid#">
			</cfif>
		</cfif>
		<!--- hiddens de campos de filtro --->
		<cfif isdefined("Form.fRHCcodigo") and Len(Trim(Form.fRHCcodigo))>
			<input type="hidden" name="fRHCcodigo" value="#Form.fRHCcodigo#">
		</cfif>
		<cfif isdefined("Form.fRHCdescripcion") and Len(Trim(Form.fRHCdescripcion))>
			<input type="hidden" name="fRHCdescripcion" value="#Form.fRHCdescripcion#">
		</cfif>
		<cfif isdefined("Form.fCFid") and Len(Trim(Form.fCFid))>
			<input type="hidden" name="fCFid" value="#Form.fCFid#">
		</cfif>
		<cfif isdefined("Form.fRHPcodigo") and Len(Trim(Form.fRHPcodigo))>
			<input type="hidden" name="fRHPcodigo" value="#Form.fRHPcodigo#">
		</cfif>
		<cfif isdefined("Form.fRHCfapertura") and Len(Trim(Form.fRHCfapertura))>
			<input type="hidden" name="fRHCfapertura" value="#Form.fRHCfapertura#">
		</cfif>
		<cfif isdefined("Form.fRHCfcierre") and Len(Trim(Form.fRHCfcierre))>
			<input type="hidden" name="fRHCfcierre" value="#Form.fRHCfcierre#">
		</cfif>
		<cfif isdefined("Form.solicitante") and Len(Trim(Form.solicitante)) and Form.solicitante NEQ -1>
			<input type="hidden" name="solicitante" value="#Form.solicitante#">
		</cfif>
	</form>
</cfoutput>

<HTML>
  <head>
  </head>
  <body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
  </body>
</HTML>
