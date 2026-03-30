<cfif isdefined("Form.EAid") and len(trim(form.EAid))>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfset modo="ALTA">  
</cfif>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="sifpublica">
		select * 
		from EmpresaArea
		where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">
	</cfquery>
</cfif>

<form method="post" name="form1" action="SQLTEArea.cfm" onSubmit="return valida();">
	<cfoutput>
		<input name="EEid" type="hidden" value="#Form.EEid#"> 
		<table align="center" border="0">
			<tr valign="baseline">
				<td nowrap align="right"><strong>C&oacute;digo:</strong></td>
				<td colspan="3">
					<input type="text" name="EACodigo" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.EACodigo#</cfif>" 
						   size="10" maxlength="10" onFocus="this.select();"  >
				</td>
			</tr>		
			<tr valign="baseline">
				<td nowrap align="right"><strong>Descripci&oacute;n:</strong></td>
				<td colspan="3">
					<input type="text" name="EAdescripcion" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.EAdescripcion#</cfif>" 
						   size="60" maxlength="60" onFocus="this.select();"  >
				</td>
			</tr>
			<tr valign="baseline">
				<td colspan="4" align="right" nowrap>
					<cf_botones modo="#modo#">
				</td>
			</tr>
	  </table>
	  <input type="hidden" name="EAid" value="<cfif modo neq "ALTA">#rsform.EAid#</cfif>">
	</cfoutput>
</form>

<script language="JavaScript">
	function valida(){
		if(document.form1.EACodigo.value == ''){
			alert("Debe indicar un código")
			return false;
		}
		if(document.form1.EAdescripcion.value == ''){
			alert("Debe indicar una descripción")
			return false;
		}			
		return true;
	}
</script>