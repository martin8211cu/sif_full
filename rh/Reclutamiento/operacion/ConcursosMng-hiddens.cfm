<cfoutput>
	<input type="hidden" name="tab" value="#Form.tab#">
	<input type="hidden" name="RHCconcurso" value="<cfif modoAdmConcursos EQ "CAMBIO" and isdefined("Form.RHCconcurso") and Len(Trim(Form.RHCconcurso))>#Form.RHCconcurso#</cfif>">
    <input type="hidden" name="externo" value="<cfif modoAdmConcursos EQ "CAMBIO"> #rsRHConcursos.RHCexterno#</cfif>">
	<cfif modoAdmConcursos EQ "CAMBIO" and Form.tab EQ 5>
		<input type="hidden" name="RHCPid" value="<cfif isdefined("Form.RHCPid") and Len(Trim(Form.RHCPid))>#Form.RHCPid#</cfif>">
	</cfif>
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
</cfoutput>