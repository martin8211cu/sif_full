<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Procesa Facturas de Fletes
	</cf_templatearea>
	<cf_templatearea name="body">
	  <cf_web_portlet titulo="Procesa Facturas de Fletes">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">

			<cfif isdefined("Form.botonsel")>
				<cfif form.botonsel EQ "btnImprimir">
					<cflocation url="/cfmx/interfacesPMI/Consultas/SQLFletesR2_Pre.cfm">
				</cfif>
			</cfif>
			<cfif isdefined("Form.botonsel")>
				<cfif form.botonsel EQ "btnErrores">
					<cflocation url="/cfmx/interfacesPMI/Consultas/SQLErroresR2_Pre.cfm?Regresa=ProcFactFlet.cfm">
				</cfif>
			</cfif>

			<cfif isdefined("Form.generar")>
				<cfinclude template="FacturasFletesA-sql.cfm">
			</cfif>

			<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
			<td valign="top" width="50%">

			<cfinclude template="FacturasFletesA-lista.cfm">

			</td>
			</tr>
			</table>
	  </cf_web_portlet>
	</cf_templatearea>
</cf_template>
