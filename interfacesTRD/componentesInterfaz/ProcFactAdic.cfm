<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Procesa Facturas de Gastos Adicionales
	</cf_templatearea>
	<cf_templatearea name="body">
	  <cf_web_portlet titulo="Procesa Facturas de Gastos Adicionales">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">

			<cfif isdefined("Form.generar")>
				<cfinclude template="FacturasGastosAdicA-sql.cfm">
			</cfif>

			<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
			<td valign="top" width="50%">

			<cfinclude template="FacturasGastosAdicA-lista.cfm">

			</td>
			</tr>
			</table>
	  </cf_web_portlet>
	</cf_templatearea>
</cf_template>
