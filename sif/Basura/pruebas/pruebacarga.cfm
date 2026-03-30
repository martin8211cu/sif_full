<!--- <cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
			Administraci&oacute;n del Sistema prueba
	</cf_templatearea>
	
	<cf_templatearea name="body"> --->
		
			<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Clasificaci&oacute;n de Conceptos de Servicio Prueba Arbol'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<!--- <tr><td colspan="3" valign="top"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr> --->
					<tr valign="top"> 
						<td valign="top" width="50%"> 
							<cfinclude template="pruebaarbol.cfm">
						</td>
						<td valign="top" width="5%">&nbsp;</td>
						<td width="50%" valign="top" ><cfinclude template="pruebacargaform.cfm"></td>
					</tr>
					<tr><td colspan="3">&nbsp;</td></tr>
				</table>
			</cf_web_portlet>
	<!--- </cf_templatearea>
</cf_template> --->