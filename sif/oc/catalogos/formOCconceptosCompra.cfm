<!--- Definición del modo --->
<cfset modo="ALTA">
<cfif isdefined("form.OCCid") and len(trim(form.OCCid))>
	<cfquery name="rsdatos" datasource="#Session.DSN#">
		select OCCid, rtrim(OCCcodigo) as OCCcodigo, OCCdescripcion, CFcomplementoCostoVenta, CFmascaraTransito
		from OCconceptoCompra
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and OCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCCid#">
	</cfquery>11721
	<cfset modo="CAMBIO">
</cfif>

<cfoutput>
<form action="SQLOCconceptosCompra.cfm" method="post" name="form1" >
	<table width="95%" align="center" border="0" cellspacing="2" cellpadding="0">
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>C&oacute;digo:&nbsp;</strong></td>
			<td>
				<input 	name="OCCcodigo" type="text" 
						value="<cfif modo neq 'ALTA'>#trim(rsdatos.OCCcodigo)#</cfif>" 
						size="10" maxlength="10" 
						alt="El campo c&oacute;digo" 
						onfocus="this.select();"
						<cfif modo neq 'ALTA' AND rsdatos.OCCcodigo EQ "00">
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
				<input 	name="OCCdescripcion" type="text" 
						size="40" maxlength="40" alt="El campo descripci&oacute;n" 
						onfocus="this.select();"
						<cfif modo neq 'ALTA' AND rsdatos.OCCcodigo EQ "00">
							value="PRODUCTO EN TRANSITO" 
							readonly tabindex="-1" style="border:solid 1px ##CCCCCC;"
						<cfelse>
							value="<cfif modo neq 'ALTA'>#rsdatos.OCCdescripcion#</cfif>" 
							tabindex="1" 
						</cfif>
				>
			</td>
		</tr>
		<tr><td>&nbsp; </td></tr>
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Complemento Financiero&nbsp;<BR>para Máscara de Costo de Ventas:&nbsp;</strong></td>
			<td>
				<input name="CFcomplementoCostoVenta" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFcomplementoCostoVenta#</cfif>" size="20" maxlength="100" alt="El campo complemento costo de venta" onfocus="this.select();">
			</td>
		</tr>
		<tr><td>&nbsp; </td></tr>
		<tr valign="baseline"> 
			<td align="right" nowrap><strong>Máscara de Cuenta Financiera&nbsp;<BR>para Producto en Tránsito:&nbsp;</strong></td>
			<td>
				<font style="font-size:9px">Puede utilizar los comodines S,A:<BR>S=Socio Negocio de COMPRA, A=Articulo</font><BR>
				<input name="CFmascaraTransito" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsdatos.CFmascaraTransito#</cfif>" size="50" maxlength="100" alt="El campo mascara" onfocus="this.select();">
			</td>
		</tr>				
		<tr valign="baseline"> 
			<td colspan="2" align="center" nowrap> 
				<cf_botones modo="#modo#" tabindex="4">
			</td>
		</tr>
	</table>
	<input type="hidden" name="OCCid" value="<cfif modo neq 'ALTA'>#rsdatos.OCCid#</cfif>">
</form>
</cfoutput>

<cf_qforms>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	objForm.OCCcodigo.description = "Código";
	objForm.OCCdescripcion.description = "Descripción";
	objForm.CFcomplementoCostoVenta.description = "Complemento para Costo Ventas";
	objForm.CFmascaraTransito.description = "Máscara para Producto en Trásito";

	function habilitarValidacion(){
		deshabilitarValidacion()
		objForm.OCCcodigo.required = true;
		objForm.OCCdescripcion.required = true;
		objForm.CFcomplementoCostoVenta.required = true;
		objForm.CFmascaraTransito.required = true;

	}
	
	function deshabilitarValidacion(){
		objForm.OCCcodigo.required = false;
		objForm.OCCdescripcion.required = false;
		objForm.CFcomplementoCostoVenta.required = false;
		objForm.CFmascaraTransito.required = false;

	}	
	//-->
</script>