<cfinvoke Key="LB_ConsultaIncidenciasProceso" Default="Reporte de Estado de Incidencias" returnvariable="LB_ConsultaIncidenciasProceso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CalendarioDePago" Default="Calendario de Pago" returnvariable="LB_CalendarioDePago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TipoDeNomina" Default="Tipo de N&oacute;mina" returnvariable="LB_TipoDeNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaInicio" Default="Fecha Inicio" returnvariable="LB_FechaInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaFin" Default="Fecha Fin" returnvariable="LB_FechaFin" component="sif.Componentes.Translate" method="Translate"/>

<!--- CLASES --->
    <style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.tituloEncab {
		font-size:14px;
		font-weight:bold;
		text-align:left;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:12px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:12px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:12px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:12px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:11px;
		text-align:left;}
	.detaller {
		font-size:11px;
		text-align:right;}
	.detallec {
		font-size:11px;
		text-align:center;}	
		
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>
<!--- CONSULTAS ADICIONALES --->
<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- FIN CONSULTAS ADICIONALES --->

<!--- PINTADO DEL REPORTE --->
	<cfset Lvar_Titulo = ''>
	<!---<cfif isdefined('form.DEid')  and len(trim(form.DEid)) ><cfset Lvar_Titulo = '#session.reporteTemp.NombreEmp#'></cfif>--->
	<cfsavecontent variable="Reporte">
		<table width="85%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
			<tr>
				<td align="center">
							<cfset filtroFech = "#LB_FechaInicio#:#LSDateFormat(session.reporteTemp.filtro_fechaI,'dd/mm/yyyy')#">
							<cfif isdefined("url.filtro_fechaF") and len(trim(session.reporteTemp.filtro_fechaF))>
								<cfset filtroFech = filtroFech & "  #LB_FechaFin#:#LSDateFormat(session.reporteTemp.filtro_fechaF,'dd/mm/yyyy')#">
							</cfif>
							<cf_EncReporte
								Titulo="#LB_ConsultaIncidenciasProceso#"
								Color="##E3EDEF"
								Cols="5"
								filtro1="#filtroFech#"
								Filtro2="#Lvar_Titulo#">
				</td>
			</tr>
			<tr>
				<td width="100%">
					<table width="100%" cellpadding="2" cellspacing="2" align="center" border="0">
						<cfset groupBy = "CFid">
						
						<cfoutput query="session.reporteTemp" group="#groupBy#">
							 	<tr><td colspan="5" class="tituloEncab"><strong>#session.reporteTemp.centro#</strong></td></tr>
							  <tr>
								<td valign="bottom">&nbsp;<strong><cf_translate key="LB_Empleado">Empleado</cf_translate></strong></td>
								<td valign="bottom"><strong><cf_translate key="LB_Concepto">Concepto</cf_translate></strong></td>
								<td align="center" valign="bottom"><strong><cf_translate key="LB_Cantidad">Cantidad</cf_translate></strong></td>
								<td align="center" valign="bottom"><strong><cf_translate key="LB_Monto">Monto</cf_translate></strong></td>
								<td align="center" valign="bottom"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate></strong></td>
								<td align="center" valign="bottom" nowrap="nowrap"><strong><cf_translate key="LB_JefeAP">Aprobaci&oacute;n Jefe</cf_translate></strong></td>
								<td align="center" valign="bottom" nowrap="nowrap"><strong><cf_translate key="LB_AdminAP">Aprobaci&oacute;n Administrador</cf_translate></strong></td>
								<td align="center" valign="bottom"><strong><cf_translate key="LB_Admin">Pagada</cf_translate></strong></td>
							</tr>
							<cfoutput>
								<tr>
									<td  nowrap="nowrap">#session.reporteTemp.NombreEmp#</td>
									<td  nowrap="nowrap">#CIdescripcion#</td>
									<td  nowrap="nowrap">#LSCurrencyFormat(Ivalor,'none')#</td>
									<td  nowrap="nowrap"><cfif Imonto GT 0>#LSCurrencyFormat(Imonto,'none')#</cfif></td>
									<td  nowrap="nowrap">#LSDateFormat(Ifecha,'dd/mm/yyyy')#</td>
									<td  nowrap="nowrap"><center>#estadoJefeRep#</center></td>
									<td  nowrap="nowrap"><center>#estadoRep#</center></td>
									<td  nowrap="nowrap"><center>#pagada#</center></td>
									
								</tr>
							</cfoutput>
							<tr><td colspan="5">&nbsp;</td></tr>
					</cfoutput>
					</table>
				</td>
			</tr>
		</table>
	</cfsavecontent>	
<cfoutput>
	<cfparam name="vIrA" default="EstadoIncidenciasProceso.cfm">
	<table align="center"><tr><td colspan="2">
		<table align="right"><tr>
		<td><img src="../../imagenes/back.png" align="right" onClick="javascript:history.back()"></td>
		<td><cf_htmlReportsHeaders
			irA="#vIrA#"
			back="false"
			FileName="EstadoIncidenciasReporte.xls"
			title="Estados">
		</td></tr></table>
	</td></tr>
	<tr><td colspan="2">#Reporte#</td></tr>
	</table>
	<cfset tempfile = GetTempDirectory()>
	<cfset session.tempfile_xls = #tempfile# & "EstadoIncidenciasReporte#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<cffile action="write" file="#session.tempfile_xls#" output="#Reporte#" nameconflict="overwrite">
</cfoutput>	
<iframe id="FRAME_EXCEL" name="FRAME_EXCEL" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
	