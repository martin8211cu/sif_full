<!--- 
	<cf_templateheader title="Contabilidad General - Consulta de Gastos"> --->
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td valign="top">

				<cfset params = "&CFid=#form.CFid#&periodo=#form.periodo#&mes=#form.mes#&nivel_resumen=#form.nivel_resumen#&nivel_totalizar=#form.nivel_totalizar#">
				<cfif isdefined("form.dependencias")>
					<cfset params = params & "&dependencias=1">
				</cfif>
				<!--- <cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Consulta de Gastos">
				 --->	<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td><!--- <cfinclude template="../../portlets/pNavegacion.cfm"> ---></td></tr>
						<tr><td>
							<cf_rhimprime objetosForm="false" datos="/sif/cg/consultas/gastos-form.cfm" paramsuri="#params#" regresar="/cfmx/sif/cg/consultas/gastos-filtro.cfm">
							<cfinclude template="gastos-form.cfm">
						</td></tr>
					</table>	
				<!--- <cf_web_portlet_end>	 --->
			</td></tr>
		</table>	
	<!--- <cf_templatefooter> --->