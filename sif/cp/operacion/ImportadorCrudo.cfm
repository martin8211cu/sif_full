		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		            <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importador de Crudo">
	 				<cfinclude template="/sif/portlets/pNavegacion.cfm">
					<table width="100%" border="0" cellspacing="1" cellpadding="1">
					  <tr>
						<td colspan="2" valign="top">
							<cf_sifFormatoArchivoImpr EIcodigo = 'CRUDO'>
						 </td>
						<td colspan="2" valign="top"><cf_sifimportar eicodigo="CRUDO" mode="in" /></td>
					  </tr>
                        <tr>
                        <td colspan="4" align="center">
                          <input type="button" value="Regresar" onclick="javascript:location.href='RegistroFacturasCP.cfm?_';"/>
                         </td>
                       </tr>
				  </table>	
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
