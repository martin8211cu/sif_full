<cf_templateheader title="Procesa Seguros">
	  <cf_web_portlet_start titulo="Procesa Seguros">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLSegurosR2.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from segurosPMI where sessionid = #session.monitoreo.sessionid#
						or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
					delete from segurosPolizasPMI where sessionid = #session.monitoreo.sessionid#
						or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
					delete from segurosVentasPMI where sessionid = #session.monitoreo.sessionid#
						or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
					delete from segurosArticulosPMI where sessionid = #session.monitoreo.sessionid#
						or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
				</cfquery> 
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/Seguros/SegurosParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfinclude template="SQLAplicaSeguros.cfm">
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/Seguros/SegurosParam.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnErrores">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLSegurosErroresR2.cfm?Regresa=ProcSeguros.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.generar")>
			<cfinclude template="SegurosA-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="SegurosA-lista.cfm">
		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
