<cfif isdefined("Form.ETid") and len(trim(form.ETid))>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfset modo="ALTA">
</cfif>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="sifpublica">
		select * 
		from EmpresaOrganizacion
		where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
	</cfquery>
</cfif>

<form method="post" name="form1" action="SQLTEOrganizaciones.cfm" onSubmit="return valida();">
	<cfoutput>
		<cfif modo NEQ 'ALTA'>
			<input type="hidden" name="ETid" value="#rsform.ETid#">
		</cfif>
		<input type="hidden" name="EEid" value="#form.EEid#">
		
		<table align="center" border="0">
			<tr valign="baseline">
				<td nowrap align="right"><strong>Descripción:</strong></td>
				<td colspan="3">
					<input type="text" name="ETdescripcion" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.ETdescripcion#</cfif>" 
						   size="60" maxlength="60" onFocus="this.select();">
				</td>
			</tr>
			<tr valign="baseline">
				<td colspan="4" align="right" nowrap>
					 <cf_botones modo="#modo#">
				</td>
			</tr>
	  </table>
	 </cfoutput>
</form>

<script language="JavaScript">
	function valida(){
		if (document.form1.ETdescripcion.value == ''){
			alert("Debe indicar una descripción");
			return false;
		}
		
		return true;
	}
</script>

