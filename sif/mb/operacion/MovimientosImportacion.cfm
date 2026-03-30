<cfset LvarAction = 'Movimientos.cfm?EMid=#url.EMid#'>

<cf_templateheader title="Importador de Movimientos Bancarios">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Importaci&oacuten de Complementos'>
		<cflock timeout=20 scope="Session" type="Exclusive">
    		<cfset session.EMid = #url.EMid#>
    	</cflock>
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
		  <tr>
			<td valign="top" width="40%">
				<cf_sifFormatoArchivoImpr EIcodigo = 'MBMOVBAN'>
			</td>
			<td align="center"  width="60%" valign="top">
				<cf_sifimportar EIcodigo="MBMOVBAN" mode="in" width="450"/>
			</td>
		  </tr>
		  <tr><td colspan="3" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='<cfoutput>#LvarAction#</cfoutput>'"></td></tr>
		  <tr><td colspan="3" align="center"></td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>