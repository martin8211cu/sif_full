<cf_templateheader title="Procesa Futuros Abiertos">
	  <cf_web_portlet_start titulo="Procesa Futuros Abiertos">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLFuturosAbiertosR2_Pre.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from #session.Dsource#futurosabiertosPMI where sessionid = #session.monitoreo.sessionid#
				</cfquery> 
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/FuturosAbiertosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfinclude template="SQLAplicaFutuAbie.cfm">
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/FuturosAbiertosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnErrores">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLErroresR2_Pre.cfm?Regresa=ProcFutuAbie.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.generar")>
			<cfinclude template="FuturosAbiertosA-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="FuturosAbiertosA-lista.cfm">

		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
