<cfif isdefined("Form.generar")>
	<cfinclude template="IncluyeOrdenesCompra.cfm">
<cfelse>
<cf_templateheader title="Incluye Ordenes de Compra">
	  <cf_web_portlet_start titulo="Incluye Ordenes de Compra">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">

			<cfif isdefined("Form.botonsel")>
				<cfif form.botonsel EQ "btnImprimir">
					<cflocation url="/cfmx/interfacesTRD/Consultas/SQLProductosR2_Pre.cfm">
				</cfif>
			</cfif>

			<cfif isdefined("Form.botonsel")>
				<cfif form.botonsel EQ "btnErrores">
					<cflocation url="/cfmx/interfacesTRD/Consultas/SQLErroresR2_Pre.cfm?Regresa=ProcConsCompr.cfm">
				</cfif>
			</cfif>

			<cfif isdefined("Form.generar")>
				<cfinclude template="ConsFacturasCompras.cfm">
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