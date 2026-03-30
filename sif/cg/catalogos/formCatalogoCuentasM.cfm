

<cfif isdefined("LvarInfo")>
	<cfset LvarAction = 'SQLCatalogoCuentasMINFO.cfm'>
	<cfset LvarRegresar = 'listaCatalogoCuentasMINFO.cfm'>
	<cfset LvarRefrescar = 'CatalogoCuentasMINFO.cfm'>
	<cfset LvarIncluye = '../../INFO/catalogos/listaCuentasContablesMINFO.cfm'>
<cfelse>
	<cfset LvarAction = 'SQLCatalogoCuentasM.cfm'>
	<cfset LvarRegresar = 'listaCatalogoCuentasM.cfm'>
	<cfset LvarRefrescar = 'CatalogoCuentasM.cfm'>
	<cfset LvarIncluye = 'listaCuentasContablesM.cfm'>
</cfif>


<cfif isdefined("Form.Cambio")>
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
			CGICCid,
			CGICMid,
			CGICCcuenta,
			CGICCnombre,
			CGICinfo1,
			CGICinfo2,
			CGICinfo3,
			CGICinfo4,
			CGICinfo5,
			CGICinfo6,
			CGICinfo7,
			CGICinfo8,
			CGICinfo9
		from CGIC_Catalogo
		where CGICCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICCid#">
	</cfquery>	
</cfif>

<cfoutput>
	<form action="#LvarAction#" method="post" name="form1">
		<table border="0" align="center">
			<tr>
				<td style="vertical-align:top">
					<table align="center" border="0" style="vertical-align:top">
						<tr> 
							<td nowrap align="right"><strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate>:</strong>&nbsp;</td>
							<td>			
								<input type="text" name="CGICCcuenta" value="<cfif MODO NEQ "ALTA">#rs.CGICCcuenta#</cfif>"  size="12" maxlength="10" tabindex="1">
							</td>
						</tr>
						<tr> 
							<td nowrap align="right"><strong><cf_translate key=LB_Nombre>Nombre</cf_translate>:</strong>&nbsp;</td>
							<td>			
								<input type="text" name="CGICCnombre" value="<cfif MODO NEQ "ALTA">#rs.CGICCnombre#</cfif>"  size="50" maxlength="80" tabindex="1">
							</td>
						</tr>
					</table>
				</td>
			
				<td>
					<fieldset><legend><cf_translate key=LB_InformacionAdicional>Información Adicional</cf_translate><legend>
						<table align="center" border="0">
							<tr valign="baseline"> 
								<td nowrap align="right"><strong>1.</strong>&nbsp;</td>
								<td>			
									<input type="text" name="CGICinfo1" value="<cfif MODO NEQ "ALTA">#rs.CGICinfo1#</cfif>"  size="21" maxlength="20" tabindex="1">
								</td>
								<td nowrap align="right"><strong>2.</strong>&nbsp;</td>
								<td>			
									<input type="text" name="CGICinfo2" value="<cfif MODO NEQ "ALTA">#rs.CGICinfo2#</cfif>"  size="21" maxlength="20" tabindex="1">
								</td>
							</tr>
							<tr valign="baseline">
								<td nowrap align="right"><strong>3.</strong>&nbsp;</td>
								<td>			
									<input type="text" name="CGICinfo3" value="<cfif MODO NEQ "ALTA">#rs.CGICinfo3#</cfif>"  size="21" maxlength="20" tabindex="1">
								</td>
								<td nowrap align="right"><strong>4.</strong>&nbsp;</td>
								<td>			
									<input type="text" name="CGICinfo4" value="<cfif MODO NEQ "ALTA">#rs.CGICinfo4#</cfif>"  size="21" maxlength="20" tabindex="1">
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr valign="baseline"> 
				<td colspan="2">
					<input type="hidden" name="CGICCid" value="<cfif MODO NEQ "ALTA">#rs.CGICCid#</cfif>">
					<input type="hidden" name="CGICMid" value="<cfif isdefined("form.CGICMid")>#form.CGICMid#</cfif>">
					<cf_botones modo="#modo#" form="form1" include="Regresar" tabindex="1">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>
<cf_qforms>
<script language="javascript" type="text/javascript">
	function funcCambio(){
		funcAlta();
	}

	function funcAlta(){
		objForm.CGICCcuenta.required = true;
		objForm.CGICCcuenta.description = 'Cuenta';
		objForm.CGICCnombre.required = true;
		objForm.CGICCnombre.description = 'Nombre';
	}
	
	function funcBaja(){
		objForm.CGICCcuenta.required = false;
		objForm.CGICCnombre.required = false;
	}
	
	function funcRegresar(){
		document.form1.action='<cfoutput>#LvarRegresar#</cfoutput>';
		document.form1.submit();
	}
	document.form1.CGICCcuenta.focus();
	
	function funcRefrescar(){
		document.form1.action = '<cfoutput>#LvarRefrescar#</cfoutput>?modo=Cambio&CGICMid=' + document.form1.CGICMid.value+'&CGICCid='+document.form1.CGICCid.value;
		document.form1.submit();
	}

</script>

<cfif modo neq 'ALTA'>
	<cfinclude template="#LvarIncluye#">
</cfif>