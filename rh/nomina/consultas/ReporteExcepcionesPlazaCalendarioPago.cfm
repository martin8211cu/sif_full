
<cf_templateheader title="Reporte de Excepciones por Plaza y Calendario de Pago" template="#session.sitio.template#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start titulo="Reporte de Excepciones por Plaza y Calendario de Pago" skin="#Session.Preferences.Skin#">
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="ReporteExcepcionesPlazaCalendarioPago-filtro.cfm">			
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>