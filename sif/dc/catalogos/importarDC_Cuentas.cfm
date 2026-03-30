<cf_templateheader title="Contabilidad General">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Importación de  Distribución'>
		<cfparam name="RETIRADOS" default="false">
		<cfparam name="EICODIGO"  default="DC_IMPCUENTA">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td align="center" valign="top" width="55%">
					<cf_sifFormatoArchivoImpr EIcodigo= "#EICODIGO#">
				</td>
				<td align="center" style="padding-left: 15px " valign="top">
					<cf_sifimportar EIcodigo="#EICODIGO#" mode="in">
						<cf_sifimportarparam name="IDDISTRIBUCION" 	value= "#form.IDDISTRIBUCION#">
						<cf_sifimportarparam name="CBOTIPO" 		value= "#form.CBOTIPO#">
						<cf_sifimportarparam name="Debug" 			value= "false">
					</cf_sifimportar>
					<form action="Distribuciones.cfm" method="post" name="fomdist">
						<cf_botones values="Regresar" names="Regresar">
						<cfoutput>
						<input type="hidden" name="tab" value="1">	
						<input type="hidden" name="IDDISTRIBUCION" value="#form.IDDISTRIBUCION#">	
						<input type="hidden" name="IDGD" value="#form.IDGD#">
						</cfoutput>
					</form>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>