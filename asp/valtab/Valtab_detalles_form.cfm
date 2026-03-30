<cfif isdefined("Form.id") and len(trim(form.id))>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfset modo="ALTA">  
</cfif>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="asp">
		select * 
		from ValTabDetalle
		where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>
</cfif>

<form method="post" name="form1" action="ValTab_detalles_sql.cfm" onSubmit="return valida();">
	<cfoutput>
		<table width="300" align="center" border="0">
			<tr valign="baseline">
				<td nowrap align="right"><strong>Código:</strong></td>
				<td>
					<input type="text" name="codigo" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.codigo#</cfif>" 
						   size="60" maxlength="60" onFocus="this.select();"  >
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong>Descripción:</strong></td>
				<td>
					<input type="text" name="descripcion" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.descripcion#</cfif>" 
						   size="60" maxlength="60" onFocus="this.select();"  >
				</td>
			</tr>
			 
			<tr valign="baseline">
				<td colspan="2" align="right" nowrap>
					<cf_botones modo="#modo#" include="Regresar">
				</td>
			</tr>
	  </table>
	  <input type="hidden" name="id" value="<cfif modo neq "ALTA">#rsform.id#</cfif>">
	  <input type="hidden" name="valtabId" value="#Form.valtabId#">
	</cfoutput>
</form>

<script language="JavaScript">
	function valida(){
		if(document.form1.codigo.value.trim() == ''){
			alert("Debe indicar el código.")
			return false;
		} 	
		if(document.form1.descripcion.value.trim() == ''){
			alert("Debe indicar el descripción.")
			return false;
		}	
		return true;
	}
	 
	function funcRegresar(){
		location.href='/cfmx/asp/valtab/Valtab.cfm?id=' + document.form1.valtabId.value ;
		return false;
	}
</script>