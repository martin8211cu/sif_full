<cfif isdefined("Form.Cambio") or isdefined("form.btnRegresar") or isdefined("form.BotonSel")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#Session.DSN#" name="rs">
		select
			Clave,
			Concepto,
			Ecodigo
		from CEMtdoPago
		where Clave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Clave#">
	</cfquery>
</cfif>
<cfset LvarAction   = 'ActionSql.cfm'>

<cfoutput>
	<form action="#LvarAction#" method="post" name="form1">
		<cfset form.LVarClave="">
		<table align="center" cellpadding="0" cellspacing="2">
			<tr valign="baseline">
				<td nowrap align="right"><strong><cf_translate key=LB_Codigo> Clave</cf_translate>:</strong>&nbsp;</td>
				<td>
					<input type="text" name="Clave" id="Clave" value="<cfif MODO NEQ "ALTA">#rs.Clave#</cfif>"  size="12" maxlength="10" tabindex="1">
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong><cf_translate key=LB_Concepto>Concepto</cf_translate>:</strong>&nbsp;</td>
				<td>
					<input type="text" name="Concepto" id="Concepto" value="<cfif MODO NEQ "ALTA">#rs.Concepto#</cfif>"  size="47" maxlength="200" tabindex="1">
				</td>
			</tr>

			<!--- <tr>
				<td align="right"><input type="checkbox" name="Empresa" <cfif MODO NEQ "ALTA"><cfif #rs.Ecodigo# neq ''>checked="true"></cfif></cfif> </td>
			    <td><strong><cf_translate key=LB_Solo>Solo para esta empresa</cf_translate></strong></td>
			</tr> --->
			<tr valign="baseline">
				<td colspan="2">
					<input type="hidden" name="ClaveOld" value="<cfif MODO NEQ "ALTA">#rs.Clave#</cfif>">

					<cfif modo NEQ 'ALTA'>
						<cf_botones modo="#modo#" form="form1" tabindex="1">
					<cfelse>
						<cf_botones modo="#modo#" form="form1" tabindex="1" >
					</cfif>
				</td>
			</tr>

		</table>
	</form>
</cfoutput>


<cf_qforms form="form1">
<script language="javascript" type="text/javascript">
	function funcCambio(){
		funcAlta();
	}

	function funcAlta(){
		if(document.getElementById('Clave').value != ""){
	    	if(document.getElementById('Concepto').value != ""){
				   return true;
			}else{
				document.getElementById('Concepto').focus();
				alert("El Campo Concepto es requerido")
		        return false
			}

		}else{
			document.getElementById('Clave').focus();
			alert("El Campo Clave es requerido")
		    return false
		}

	}
	function funcBaja(){
		if (confirm('¿Esta seguro de eliminar este método de pago?' )){
			return true;
		}
		else{
			return false;
		}
	}
</script>