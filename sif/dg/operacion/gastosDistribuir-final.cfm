<cf_templateheader title="Proceso de Distribuci&oacute;n de Gastos">

		<cfquery name="rsDatos1" datasource="#session.DSN#">
			select count(1)	as total
			from DGGastosxDistribuir
			where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		</cfquery>
		<cfquery name="rsDatos2" datasource="#session.DSN#">
			select count(1)	as total
			from DGGastosDistribuidos
			where Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		</cfquery>
		
		<cf_web_portlet_start border="true" titulo="Proceso de Distribuci&oacute;n de Gastos" >
		<cfinclude template="../../portlets/pNavegacion.cfm">
			<form style="margin:0" action="distribuirGastos-parametros.cfm" method="get" name="url1" id="url1" >
			<cfoutput>
			<input type="hidden" name="periodo" value="#url.periodo#" />
			<input type="hidden" name="mes" value="#url.mes#" />
			</cfoutput>
			<table align="center" border="0" cellspacing="0" cellpadding="10" width="100%" >
				<tr>
					<td colspan="2" align="center">
						<cfoutput>
						<cfset listaMes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>							
						<table width="50%" align="center" cellpadding="0" cellspacing="0">
							<tr><td align="center">El proceso de Distribuci&oacute;n de Gastos par ael per&iacute;odo #url.periodo# y el mes #listgetat(listaMes, url.mes)# ha finalizado.</td></tr>
						</table> 
						</cfoutput>
					</td>
				</tr>

				<tr>
					<td colspan="2" align="center">
						<input type="submit" name="btnRegresar" value="Regresar" class="btnAnterior" />
					</td>
				</tr>
			</table>
		</form>
		<cf_web_portlet_end>
	<cf_templatefooter>		