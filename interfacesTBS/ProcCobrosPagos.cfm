<cf_templateheader title="Procesa Cobros Pagos">
	  <cf_web_portlet_start titulo="Procesa Cobros Pagos">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesTBS/Consultas/SQLCobrosPagosR2_Pre.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from sif_interfaces..PMIINT_IE11 where sessionid = #session.monitoreo.sessionid#
					delete from sif_interfaces..PMIINT_ID11 where sessionid = #session.monitoreo.sessionid#
				</cfquery> 
				<cflocation url="/cfmx/interfacesTBS/ConsCobrosPagosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfinclude template="SQLAplicaCobrosPagos.cfm">
				<cflocation url="/cfmx/interfacesTRD/ConsCobrosPagosParam.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.generar")>
			<cfinclude template="interfaz11PMI-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="interfaz11PMI-lista.cfm">

		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
