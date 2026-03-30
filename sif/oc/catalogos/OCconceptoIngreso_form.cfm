<!--- Definición del modo --->
<cfset modo="ALTA">
<cfif isdefined("form.OCIid") and len(trim(form.OCIid))>
	<cfquery name="rsdatos" datasource="#Session.DSN#">
		select OCIid, rtrim(OCIcodigo) as OCIcodigo, OCIdescripcion, CFcomplementoIngreso
		from OCconceptoIngreso
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and OCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">
	</cfquery>
	<cfset modo="CAMBIO">
</cfif>

<cfoutput>
<form action="OCconceptoIngreso_sql.cfm" method="post" name="form1" >
	<table width="95%" align="center" border="0" cellspacing="2" cellpadding="0">
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>C&oacute;digo:&nbsp;</strong></td>
			<td>
				<input 	name="OCIcodigo" type="text" 
						value="<cfif modo neq 'ALTA'>#trim(rsdatos.OCIcodigo)#</cfif>" 
						size="10" maxlength="10" 
						alt="El campo c&oacute;digo" 
						onfocus="this.select();"
						<cfif modo neq 'ALTA' AND rsdatos.OCIcodigo EQ "00">
							readonly tabindex="-1" style="border:solid 1px ##CCCCCC;"
						<cfelse>
							tabindex="1" 
						</cfif>
				>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td>
				<input 	name="OCIdescripcion" type="text" 
						size="40" maxlength="40" alt="El campo descripci&oacute;n" 
						onfocus="this.select();"
						<cfif modo neq 'ALTA' AND rsdatos.OCIcodigo EQ "00">
							value="PRODUCTO EN TRANSITO" 
							readonly tabindex="-1" style="border:solid 1px ##CCCCCC;"
						<cfelse>
							value="<cfif modo neq 'ALTA'>#rsdatos.OCIdescripcion#</cfif>" 
							tabindex="1" 
						</cfif>
				>
			</td>
		</tr>
		<tr><td>&nbsp; </td></tr>
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Complemento Financiero&nbsp;<BR>para Máscara de Ingresos:&nbsp;</strong></td>
			<td>
				<input name="CFcomplementoIngreso" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFcomplementoIngreso#</cfif>" size="20" maxlength="100" alt="El campo complemento costo de venta" onfocus="this.select();">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td colspan="2" align="center" nowrap> 
				<cf_botones modo="#modo#" tabindex="4">
			</td>
		</tr>
	</table>
	<input type="hidden" name="OCIid" value="<cfif modo neq 'ALTA'>#rsdatos.OCIid#</cfif>">
</form>
</cfoutput>

<cf_qforms>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	objForm.OCIcodigo.description = "Código";
	objForm.OCIdescripcion.description = "Descripción";
	objForm.CFcomplementoIngreso.description = "Complemento para Ingresos";

	function habilitarValidacion(){
		deshabilitarValidacion()
		objForm.OCIcodigo.required = true;
		objForm.OCIdescripcion.required = true;
		objForm.CFcomplementoIngreso.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.OCIcodigo.required = false;
		objForm.OCIdescripcion.required = false;
		objForm.CFcomplementoIngreso.required = false;
	}	
	//-->
</script>