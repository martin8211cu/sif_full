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
			CGICMid,
			CGICMcodigo,
			CGICMnombre
		from CGIC_Mapeo
		where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
	</cfquery>
</cfif>
<cfif isdefined("LvarInfo")>
	<cfset LvarAction   = 'SQLTipoMapeoCuentasINFO.cfm'>
	<cfset LvarCuentas  = 'listaCatalogoCuentasMINFO.cfm'>
	<cfset LvarImporta  = 'MapeoImportacion-impformINFO.cfm'>
	<cfset LvarEmpresas = 'EmpresasMapeoInf.cfm'>
<cfelse>
	<cfset LvarAction   = 'SQLTipoMapeoCuentas.cfm'>
	<cfset LvarCuentas  = 'listaCatalogoCuentasM.cfm'>
	<cfset LvarImporta  = 'MapeoImportacion-impform.cfm'>
	<cfset LvarEmpresas = 'EmpresasMapeo.cfm'>
</cfif>
<cfoutput>
	<form action="#LvarAction#" method="post" name="form1">
		<table align="center" cellpadding="0" cellspacing="2">
			<tr valign="baseline"> 
				<td nowrap align="right"><strong><cf_translate key=LB_Codigo> C&oacute;digo</cf_translate>:</strong>&nbsp;</td>
				<td>			
					<input type="text" name="CGICMcodigo" id="CGICMcodigo" value="<cfif MODO NEQ "ALTA">#rs.CGICMcodigo#</cfif>"  size="12" maxlength="10" tabindex="1">
				</td>
			</tr>
			<tr valign="baseline"> 
				<td nowrap align="right"><strong><cf_translate key=LB_NombreMapeo>Nombre de Mapeo</cf_translate>:</strong>&nbsp;</td>
				<td>			
					<input type="text" name="CGICMnombre" value="<cfif MODO NEQ "ALTA">#rs.CGICMnombre#</cfif>"  size="50" maxlength="80" tabindex="1">
				</td>
			</tr>
			<tr valign="baseline"> 
				<td colspan="2">
					<input type="hidden" name="CGICMid" value="<cfif MODO NEQ "ALTA">#rs.CGICMid#</cfif>">
					<cfif modo NEQ 'ALTA'>
						<cf_botones modo="#modo#" form="form1" include="Cuentas,Importar,Empresas" tabindex="1">
					<cfelse>
						<cf_botones modo="#modo#" form="form1" tabindex="1">
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
		objForm.CGICMcodigo.required = true;
		objForm.CGICMcodigo.description = 'Código';
		objForm.CGICMnombre.required = true;
		objForm.CGICMnombre.description = 'Nombre de Mapeo';
	}
	function funcBaja(){
		if (confirm('¿Esta seguro de eliminar este Mapeo?' )){
			return true;
		}
		else{
			return false;
		}
		
		objForm.CGICMcodigo.required = false;
		objForm.CGICMnombre.required = false;
	}

	function funcCuentas(){
		document.form1.action='<cfoutput>#LvarCuentas#</cfoutput>';
		document.form1.submit();
	}
	function funcImportar(){
		document.form1.action='<cfoutput>#LvarImporta#</cfoutput>';
		document.form1.submit();
	}
	function funcEmpresas(){
		document.form1.action='<cfoutput>#LvarEmpresas#</cfoutput>';
		document.form1.submit();
	}
	
	document.form1.CGICMcodigo.focus();
</script>