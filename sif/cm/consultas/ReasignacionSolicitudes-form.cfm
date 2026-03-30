<cf_templateheader title="Reasignaci&oacute;n de Solicitudes de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reasignaci&oacute;n de Solicitudes de Compra'>
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			  <td><cfinclude template="../../portlets/pNavegacionCM.cfm"></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td>
			  	<cf_rhimprime datos="/sif/cm/consultas/ReasignacionSolicitudes-Imprime.cfm" paramsuri="">
			  </td>
			</tr>
			<tr>
			  <td>
			  	<cfinclude template="ReasignacionSolicitudes-Imprime.cfm">
			  </td>
			</tr>
		  </table>
		<cf_web_portlet_end>
<cf_templatefooter>
