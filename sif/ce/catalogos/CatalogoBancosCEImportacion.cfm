<cfset LvarAction = 'CatalogoBancosCE.cfm'>

<cf_templateheader title="Mapeo de Cuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Importación de Bancos'>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
		  <tr>
			<td valign="top" width="60%">
				<cf_sifFormatoArchivoImpr EIcodigo = 'CEBANCOS'>
			</td>
			<td align="center" style="padding-left: 15px " valign="top">
				
				<cf_sifimportar EIcodigo="CEBANCOS" mode="in" />
			</td>
		  </tr>
		  <tr><td colspan="3" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='<cfoutput>#LvarAction#</cfoutput>'"></td></tr>
		  <tr><td colspan="3" align="center">&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>