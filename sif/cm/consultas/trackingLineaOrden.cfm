<cf_templateheader title="Compras - Detalle de Tracking de Linea de Orden de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Seguimiento de Solicitudes'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<cfif isdefined("Url.DOlinea") and not isdefined("Form.DOlinea")>
				<cfset Form.DOlinea = Url.DOlinea>
			</cfif>
			
			<cfif isdefined("Form.DOlinea") and Len(Trim(Form.DOlinea))>
				<cfoutput>
					<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td>&nbsp;</td></tr>
						<tr><td><cf_rhimprime datos="/sif/cm/consultas/trackingLineaOrden-Imprime.cfm" paramsuri="?DOlinea=#Form.DOlinea#"></td></tr>
						<tr><td><cfinclude template="trackingLineaOrden-Imprime.cfm"></td></tr>	 		
					</table>						
				</cfoutput>
			<cfelse>
				<div align="center">
					<br>
					<strong>No se ha seleccionado ninguna l&iacute;nea de orden de compra</strong>
					<br>
					<br>
				</div>
			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>
