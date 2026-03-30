<!--- 
	<cf_templateheader title="Contabilidad General - Consulta de Gastos"> --->
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td valign="top">

				<cfset params = "&snTipo=#form.snTipo#&snEstado=#form.snEstado#&snE=#form.snE#&snD=#form.snD#&txtsnd=#form.txtsnd#&txtsne=#form.txtsne#">
				
				<!--- <cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Consulta de Gastos">
				 --->	<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td><!--- <cfinclude template="../../portlets/pNavegacion.cfm"> ---></td></tr>
						<tr><td>
							<cf_rhimprime objetosForm="false" datos="/sif/ad/consultas/sociosNegocios-form.cfm" paramsuri="#params#" regresar="/cfmx/sif/ad/catalogos/listaSocios.cfm">
							<cfinclude template="sociosNegocios-form.cfm">
						</td></tr>
					</table>	
				<!--- <cf_web_portlet_end>	 --->
			</td></tr>
		</table>	
	<!--- <cf_templatefooter> --->