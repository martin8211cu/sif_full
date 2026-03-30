<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Procesa documentos NoFact de Producto
	</cf_templatearea>
	<cf_templatearea name="body">
	  <cf_web_portlet titulo="Procesa Documentos NoFact de Producto">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">

			<cfif isdefined("Form.botonsel")>
				<cfif form.botonsel EQ "btnImprimir">
					<cflocation url="/cfmx/interfacesPMI/Consultas/SQLNoFactProductosR2_Pre.cfm">
				</cfif>
			</cfif>
			<cfif isdefined("Form.botonsel")>
				<cfif form.botonsel EQ "btnErrores">
					<cflocation url="/cfmx/interfacesPMI/Consultas/SQLErroresR2_Pre.cfm?Regresa=ProcNoFactProd.cfm">
				</cfif>
			</cfif>

			<cfif isdefined("Form.generar")>
				<cfinclude template="NoFactProductosA-sql.cfm">
			</cfif>

			<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
			<td valign="top" width="50%">

			<cfinclude template="NoFactProductosA-lista.cfm">

			</td>
			</tr>
			</table>
	  </cf_web_portlet>
	</cf_templatearea>
</cf_template>
