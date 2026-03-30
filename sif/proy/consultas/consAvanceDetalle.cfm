<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Administraci&oacute;n de Proyectos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					  <cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Actividades y Recursos por Proyecto'>
						  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								  <td>
									  <cfinclude template="../../portlets/pNavegacion.cfm">
								  </td>
							  </tr>
					
							  <tr> 
								  <td valign="top"><cfinclude template="avanceDetalle-form.cfm"></td>
							  </tr>
						  </table>
					  </cf_web_portlet>	
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>