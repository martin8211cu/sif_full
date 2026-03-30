<cf_templateheader title="Configuración"> 
	<cf_navegacion name="CxCGid" navegacion="">
		<cfset titulo = 'Configuraci&oacute;n de Cobros Automaticos'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<table width="100%">
		  <tr>
			<td valign="top">
			
			<cfif (isdefined('form.CxCGcod') and len(trim(form.CxCGcod))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo')or (isdefined('url.CxCGid') and not isdefined('form.btnFiltrar')))>
				<cfinclude template="generacion_form.cfm">
			<cfelse>
				<cfinclude template="genera_lista.cfm">				
			</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

