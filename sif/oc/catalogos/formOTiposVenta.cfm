<!--- Definición del modo --->
<cfset modo="ALTA">
<cfif isdefined("form.OCVid") and len(trim(form.OCVid))>
	<cfquery name="rsdatos" datasource="#Session.DSN#">
		select OCVid,OCVcodigo,OCVdescripcion,CFmascaraCostoVenta,CFmascaraIngreso
		from OCtipoVenta 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and OCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCVid#">
	</cfquery>
	<cfset modo="CAMBIO">
</cfif>

<cfoutput>
<form action="SQLOTiposVenta.cfm" method="post" name="form1" >
	<table width="95%" align="center" border="0" cellspacing="2" cellpadding="0">
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>C&oacute;digo:&nbsp;</strong></td>
			<td>
				<input name="OCVcodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.OCVcodigo#</cfif>" size="20" maxlength="20" alt="El campo c&oacute;digo" onfocus="this.select();">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td>
				<input name="OCVdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.OCVdescripcion#</cfif>" size="40" maxlength="40" alt="El campo descripci&oacute;n" onfocus="this.select();">
			</td>
		</tr>
		<tr><td>&nbsp; </td></tr>
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Máscara de Cuenta Financiera&nbsp;<BR>para Costo de Ventas:&nbsp;</strong></td>
			<td>
				<font style="font-size:9px">Puede utilizar los comodines S,A,C:<BR>S=Socio Negocio de COMPRA, A=Articulo,<BR>C=Concepto de Compra</font><BR>
				<input name="CFmascaraCostoVenta" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFmascaraCostoVenta#</cfif>" size="50" maxlength="100" alt="El campo mascara costo de venta" onfocus="this.select();">
			</td>
		</tr>
		<tr><td>&nbsp; </td></tr>
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Máscara de Cuenta Financiera&nbsp;<BR>para Ingresos:&nbsp;</strong></td>
			<td>
				<font style="font-size:9px">Puede utilizar los comodines S,A,I:<BR>S=Socio Negocio de VENTA, A=Articulo,<BR>I=Concepto de Ingreso</font><BR>
				<input name="CFmascaraIngreso" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFmascaraIngreso#</cfif>" size="50" maxlength="100" alt="El campo mascara ingreso" onfocus="this.select();">
			</td>
		</tr>				
		<tr valign="baseline"> 
			<td colspan="2" align="center" nowrap> 
				<cf_botones modo="#modo#" tabindex="4">
			</td>
		</tr>
	</table>
	<input type="hidden" name="OCVid" value="<cfif modo neq 'ALTA'>#rsdatos.OCVid#</cfif>">
</form>
</cfoutput>

<cf_qforms>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	objForm.OCVcodigo.description = "Código";
	objForm.OCVdescripcion.description = "Descripción";
	objForm.CFmascaraCostoVenta.description = "Máscara costo de venta";
	objForm.CFmascaraIngreso.description = "Máscara ingreso";

	function habilitarValidacion(){
		deshabilitarValidacion()
		objForm.OCVcodigo.required = true;
		objForm.OCVdescripcion.required = true;
		objForm.CFmascaraCostoVenta.required = true;
		objForm.CFmascaraIngreso.required = true;

	}
	
	function deshabilitarValidacion(){
		objForm.OCVcodigo.required = false;
		objForm.OCVdescripcion.required = false;
		objForm.CFmascaraCostoVenta.required = false;
		objForm.CFmascaraIngreso.required = false;

	}	
	//-->
</script>