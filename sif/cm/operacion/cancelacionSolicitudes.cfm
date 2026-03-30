<cf_templateheader title="Solicitudes de Compra">
	<cfinclude template="../../portlets/pNavegacionCM.cfm">
    <cf_web_portlet_start titulo='Cancelar Solicitud de Compra'>		
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
						<cfinclude template="cancelacionSolicitudes-cancelar.cfm">				
						<cfinclude template="cancelacionSolicitudes-filtro.cfm">
					<cfif isdefined("form.fESnumero") and len(trim(fESnumero))>
						<cfinclude template="cancelacionSolicitudes-lista.cfm">
					</cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>