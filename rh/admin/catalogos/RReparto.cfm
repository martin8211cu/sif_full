<!---Este mantenimiento fue creado para el ITCR. Su funcionamiento es gestionar
las la tabla del regimen de reparto------------------------------------------->
<cf_templateheader title="Regimen de Reparto"> 
	<cf_web_portlet_start border="true" titulo="Tabla del Régimen de Reparto" skin="#Session.Preferences.Skin#">	
		<table border="0" width="100%">
			<tr>
				<td valign="top" width="50%"><cfinclude template="RReparto_lista.cfm"></td>
				<td width="50%"><cfinclude template="RReparto_form.cfm"></td>
			</tr>
		</table>	
  <cf_web_portlet_end>
<cf_templatefooter>