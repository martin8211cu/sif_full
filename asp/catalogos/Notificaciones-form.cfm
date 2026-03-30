<cfif isdefined("Form.NDid") and len(trim(form.NDid))>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfset modo="ALTA">  
</cfif>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="asp">
		select * 
		from Notificaciones
		where NDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.NDid#">
	</cfquery>
</cfif>

<form method="post" name="form1" action="Notificaciones-sql.cfm" onSubmit="return valida();">
	<cfoutput>
		<table width="300" align="center" border="0">
			<tr valign="baseline">
				<td nowrap align="right"><strong>Email:</strong></td>
				<td>
					<input type="text" name="email" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.email#</cfif>" 
						   size="60" maxlength="60" onFocus="this.select();"  >
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong>Nombre:</strong></td>
				<td>
					<input type="text" name="nombre" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.nombre#</cfif>" 
						   size="60" maxlength="60" onFocus="this.select();"  >
				</td>
			</tr>
			<tr valign="baseline">
				<td>&nbsp;</td>
				<td align="left">
					<input type="checkbox" name="Activo" 
						   <cfif isdefined('rsForm') and rsForm.Activo>checked</cfif>
						   size="60" maxlength="60" onFocus="this.select();"  > <strong>Activo</strong>
				</td>
			</tr>
			<tr valign="baseline">
				<td colspan="2" align="right" nowrap>
					<cf_botones modo="#modo#" include="Regresar">
				</td>
			</tr>
	  </table>
	  <input type="hidden" name="NDid" value="<cfif modo neq "ALTA">#rsform.NDid#</cfif>">
	</cfoutput>
</form>

<script language="JavaScript">
	function valida(){
		if(document.form1.email.value == ''){
			alert("Debe indicar la dirección de correo electrónico.")
			return false;
		}else if (!validarEmail(document.form1.email.value)){
			alert("Debe indicar una dirección de correo electrónico válida.")
			return false;
		}	
		if(document.form1.nombre.value == ''){
			alert("Debe indicar el nombre.")
			return false;
		}	
		return true;
	}
	
	
	 function validarEmail(valor) {
	  if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(valor)){
		return (true)
	  } else {
		return (false);
	  }
	}
	
	function funcRegresar(){
		location.href='/cfmx/home/menu/modulo.cfm?s=sys&m=oper';
		return false;
	}
</script>