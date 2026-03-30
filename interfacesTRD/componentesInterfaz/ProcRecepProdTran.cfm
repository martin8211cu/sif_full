<cf_templateheader title="Procesa Recepcion de Producto en Transito">
	  <cf_web_portlet_start titulo="Recepcion de Producto en Transito">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnImprimir">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLRecProdTranR2.cfm?Regresa=ProcRecepProdTran.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnRegresar">
				<cfquery datasource="sifinterfaces">
					delete from RecProdTranPMI where sessionid = #session.monitoreo.sessionid#
					or fecharegistro <= <cfqueryparam cfsqltype="cf_sql_date" value="# DateAdd('d', -1, Now())#">
				</cfquery> 
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/RecepProdTranParam.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnAplicar">
				<cfinclude template="SQLAplicaRecepProdTran.cfm">
				<cflocation url="/cfmx/interfacesTRD/componentesInterfaz/RecepProdTranParam.cfm">
			</cfif>
		</cfif>

		<cfif isdefined("Form.botonsel")>
			<cfif form.botonsel EQ "btnErrores">
				<cflocation url="/cfmx/interfacesTRD/Consultas/SQLRecProdTranErroresR2.cfm?Regresa=ProcRecepProdTran.cfm">
			</cfif>
		</cfif>
		<cfif isdefined("Form.generar")>
			<cfinclude template="RecepProdTranA-sql.cfm">
		</cfif>

		<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td valign="top" width="50%">

		<cfinclude template="RecepProdTranA-lista.cfm">
		</td>
		</tr>
		</table>
	  <cf_web_portlet_end>
<cf_templatefooter>
