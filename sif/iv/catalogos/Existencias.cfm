<cf_templateheader title="Inventarios">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Existencias'>
			<table width="100%" border="0" cellpadding="0" cellspacing="0" >
			 	<tr><td><cfinclude template="paramURL-FORM.cfm"></td></tr>
				<tr><td><cfinclude template="articulos-link.cfm"></td></tr>
			    <tr><td><cfinclude template="formExistencias.cfm"></td></tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>