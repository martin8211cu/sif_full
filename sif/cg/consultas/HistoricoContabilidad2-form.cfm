<cfif isdefined("form.chkResumido")>
	<cfinclude template="HistoricoContabilidad2_form_Resumido.cfm">
<cfelse>
	<cfinclude template="HistoricoContabilidad2_form_Detallado.cfm">
</cfif>
