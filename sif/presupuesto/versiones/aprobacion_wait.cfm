<cfif isdefined("url.MesesAnt")>
	<cfset request.CFaprobacion_MesesAnt = true>
</cfif>
<cf_templateheader title="Aprobación de la Formulación Presupuestaria">
	  <cf_web_portlet_start titulo="Ejecutando la Aprobación de una Version de Formulación Presupuestaria" style="cursor:wait">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="versiones_config.cfm">
			<br>
			<cf_web_portlet_start width="60%" titulo="Aprobacion en proceso, favor esperar...">
			<cfoutput>
				<table border="0" align="center">
					<tr>
						<td >
							<strong>&nbsp;&nbsp;PASO</strong>
						</td>
						<td align="center">
							<strong>ESTADO</strong>
						</td>
					</tr>
<cfscript>
	sbLinea("Inicialización",0);
	sbLinea("Ajuste de Tipos de Cambio y Totales a Aprobar", 1);
	sbLinea("Eliminación de Cuentas sin Monto Solicitado", 2);
	sbLinea("Ajuste de Vigencias de Cuentas Mayor", 3);
	sbLinea("Creación de Cuentas nuevas de Presupuesto", 4);
	sbLinea("Ajuste de Saldos de Control de Presupuesto", 5);
	sbLinea("Creación de Control de Monedas Aprobadas", 6);
	sbLinea("Preparación de Datos para enviar a Control de Presupuesto", 7);
	sbLinea("Ejecución de Control de Presupuesto", 8);
	sbLinea("Finalización de la Aprobación", 9);
</cfscript>
					<tr>
						<td colspan="2" align="center">
							<input type="text" disabled id="paso" style="width:200px;border:none; background-color:##FFFFFF; text-align:center">
							<span style="text-align:left;border:1px solid ##CCCCCC;width:175px;">
								<span id="spnAvance" style="background-color:##66ccff;width:0%;"></span>
							</span>
						</td>
					</tr>
				</table>
</cfoutput>
			<cf_web_portlet_end>
			<BR>
			<div align="center">
			<input type="button" value="Refrescar" onClick="document.ifrRefrescar.location.reload();">
			</div>
			<BR>
			<cfif isdefined("request.CFaprobacion_MesesAnt")>
				<cfset LvarCFM = "aprobacion_refresh.cfm?MesesAnt">
			<cfelse>
				<cfset LvarCFM = "aprobacion_refresh.cfm">
			</cfif>
			<cfoutput>
			<iframe name="ifrRefrescar" style="cursor:wait" frameborder="0" src="#LvarCFM#" width="0" height="0">
			</iframe>
			</cfoutput>
		<cflock scope="session" type="exclusive" timeout="5" throwontimeout="yes">
			<cfif session.CFaprobacion.Paso EQ -1000>
				<cfset session.CFaprobacion.Paso = -1001>
				<cfoutput>
				<iframe name="ifrSQL" style="cursor:wait" frameborder="0" src="aprobacion_sql.cfm?CVid=#form.CVid#<cfif isdefined("form.chkConFormulacion")>&conFormulacion=1</cfif><cfif isdefined("form.chkActualizarControl")>&actualizarControl=1</cfif><cfif isdefined("request.CFaprobacion_MesesAnt")>&MesesAnt=1</cfif>" width="0" height="0">
				</iframe>
				</cfoutput>
			</cfif>
		</cflock>
	  <cf_web_portlet_end>
<cf_templatefooter>
<cffunction name="sbLinea" output="true">
	<cfargument name="Titulo"	type="string" required="yes">
	<cfargument name="Paso" 	type="numeric" required="yes">
					<tr>
						<td>
							#Arguments.Titulo#
						</td>
						<td align="center">
							<input disabled id="paso#Arguments.Paso#" type="text" size="40" style="width:200px;border:none; background-color:##FFFFFF; text-align:center"><cfif Arguments.Paso EQ 4><BR></cfif>
						</td>
					</tr>
</cffunction>
