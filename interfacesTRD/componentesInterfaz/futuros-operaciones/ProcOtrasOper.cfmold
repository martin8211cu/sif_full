<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from OtrOperaPMI
	where MensajeError is not null 
	and sessionid = #session.monitoreo.sessionid#
</cfquery>
<cfset NumeroErrores = rsVerifica.recordcount>
<cfset BErrores = "Errores (#NumeroErrores#)">

<cf_templateheader title="Procesa Futuros Otras Operaciones">
	  <cf_web_portlet_start titulo="Futuros Otras Operaciones">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLOtrasOperR2.cfm?Regresa=ProcOtrasOper.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from RecProdTranPMI where sessionid = #session.monitoreo.sessionid#
					or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
				</cfquery> 
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/futuros-operaciones/OtrasOperParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfinclude template="SQLAplicaOtrasOper.cfm">
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/futuros-operaciones/OtrasOperParam.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btn#BErrores#">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLOtrasOperErroresR2.cfm?Regresa=ProcOtrasOper.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.generar")>
			<cfinclude template="OtrasOperA-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="OtrasOperA-lista.cfm">
		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
