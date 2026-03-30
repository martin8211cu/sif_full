<!---Proceso: CIERRECR: Control de Transacciones--->

<cfset title="Control de Transacciones de Control de Responsables">
<cf_templateheader title="#title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#title#'>
		 <cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr><td>
					<cfinclude template="formCierreCtrResp.cfm">
				</td></tr>
				<tr><td>
				<hr width="50%">
					<cfinclude template="CierreCtrResp-lista.cfm">
				</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>
				<img src="/cfmx/sif/imagenes/stop.gif">&nbsp; Error! El registro se marco con errores en la última desactivación del Control de Transacciones!
				</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
