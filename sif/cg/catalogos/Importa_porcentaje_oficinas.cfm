<cf_templateheader title=" Importaci&oacute;n de Porcentajes de Oficinas">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Porcentajes de Oficina">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				<tr>
					<td align="center" valign="top" width="55%">
						<cf_sifFormatoArchivoImpr EIcodigo = 'IMPOF'>
					</td>
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar EIcodigo="IMPOF" mode="in">
							<cf_sifimportarparam name="smes" value="#url.smes#">
							<cf_sifimportarparam name="speriodo" value="#url.speriodo#">
							<cf_sifimportarparam name="PCCEclaid" value="#url.PCCEclaid#">
							<cf_sifimportarparam name="PCCDclaid" value="#url.PCCDclaid#">
						</cf_sifimportar>
						<cfoutput>
						<form name="reg" action="SQLPorcentajesOficinas.cfm" method="post">
							<!---<cfset AGTPid=#url.AGTPid#>--->
							<input type="hidden" value= "#url.smes#" name="smes" >
							<input type="hidden" value= "#url.speriodo#" name="speriodo" >
							<input type="hidden" value= "#url.PCCEclaid#" name="PCCEclaid" >
							<input type="hidden" value= "#url.PCCDclaid#" name="PCCDclaid" >
							<input type="submit" value="Regresar" name="regI">			
						</form>
						</cfoutput>
					</td>
				</tr>
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
	
	
	
	
