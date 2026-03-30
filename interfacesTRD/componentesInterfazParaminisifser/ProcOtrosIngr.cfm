<cf_templateheader title="Procesa Documentos Otros Ingresos">
	  <cf_web_portlet_start titulo="Procesa Documentos Otros Ingresos">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLOtrosIngresosR2_Pre.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from #session.Dsource#otrosIngresosPMI where sessionid = #session.monitoreo.sessionid#
					delete from #session.Dsource#ErroresPMI where sessionid = #session.monitoreo.sessionid#
					delete from #session.Dsource#ProductosPMI where sessionid = #session.monitoreo.sessionid#
				</cfquery> 
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/OtrosIngresosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfinclude template="SQLAplicaOtrosIngr.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnErrores">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLErroresR2_Pre.cfm?Regresa=ProcOtrosIngr.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.generar")>
			<cfinclude template="OtrosIngresosA-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="OtrosIngresosA-lista.cfm">

		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
