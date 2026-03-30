<cfif isdefined("Form.generar")>
	<cfinclude template="FacturasProductosA-sql.cfm">
<cfelse>
	<cf_templateheader title="Procesa Facturas de Producto">
		  <cf_web_portlet_start titulo="Procesa Facturas de Producto">
				<cfinclude template="/sif/portlets/pNavegacion.cfm">
	
				<cfif isdefined("Form.botonsel")>
					<cfif form.botonsel EQ "btnAplicar">
						<cfinclude template="SQLAplicaProductos.cfm">
					</cfif>
					<cfif form.botonsel EQ "btnImprimir">
						<cflocation url="/cfmx/interfacesTRD/Consultas/SQLProductosR2_Pre.cfm">
					</cfif>
					<cfif form.botonsel EQ "btnErrores">
						<cflocation url="/cfmx/interfacesTRD/Consultas/SQLErroresR2_Pre.cfm?Regresa=ProcFactProd.cfm">
					</cfif>
				</cfif>
	
	
				<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
				<td valign="top" width="50%">
	
				<cfinclude template="FacturasProductosA-lista.cfm">
	
				</td>
				</tr>
				</table>
		  <cf_web_portlet_end>
	<cf_templatefooter>
</cfif>

