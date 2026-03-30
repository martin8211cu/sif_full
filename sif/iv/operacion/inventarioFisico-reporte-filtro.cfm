<cf_templateheader title=" Inventario F&iacute;sico">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Inventario F&iacute;sico'>
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<form name="form1" method="url" action="inventarioFisico-reporte.cfm" style="margin:0;">
			<table width="50%" align="center" cellpadding="1" cellspacing="0">
				<tr>
					<td width="35%" nowrap="nowrap" align="right"><strong>Almac&eacute;n Inicial:</strong>&nbsp;</td>
					<td><cf_sifalmacen tabindex="1" Aid="Aidini" Almcodigo="Acodigoini" bdescripcion="Adescripcionini" frame="fralmacen1" FilUsucodigo="true" ></td>
				</tr>

				<tr>
					<td width="35%" nowrap="nowrap" align="right"><strong>Almac&eacute;n Final:</strong>&nbsp;</td>
					<td><cf_sifalmacen tabindex="1" Aid="Aidfin" Almcodigo="Acodigofin" Bdescripcion="Adescripcionfin" frame="fralmacen2" FilUsucodigo="true" ></td>
				</tr>

				<tr>
					<td width="35%" nowrap="nowrap" align="right"><strong>Clasificacion Inicial:</strong>&nbsp;</td>
					<td><cf_sifclasificacion tabindex="1" id="Cidini" name="Ccodigoini" desc="Cdescripcionini" ></td>
				</tr>
				<tr>
					<td width="35%" nowrap="nowrap" align="right"><strong>Clasificacion Final:</strong>&nbsp;</td>
					<td><cf_sifclasificacion tabindex="1" id="Cidfin" name="Ccodigofin" desc="Cdescripcionfin" ></td>
				</tr>

				<tr>
					<td align="center" colspan="2"><input type="submit" tabindex="1" class="btnNormal" name="btnFiltrar" value="Generar"></td>
				</tr>
			</table>
			</form>				
			</cfoutput>			
			
			<cf_qforms>
			
			<script language="javascript1.2" type="text/javascript">
				objForm.Acodigoini.required = true;
				objForm.Acodigoini.description = 'Almacén Inicial';
				objForm.Acodigofin.required = true;
				objForm.Acodigofin.description = 'Almacén Final';
			</script>
			
		<cf_web_portlet_end>
	<cf_templatefooter>