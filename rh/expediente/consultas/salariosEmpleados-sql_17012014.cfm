<cfquery name="rsReporte" datasource="#session.DSN#">
	SELECT 
		DEidentificacion, 
		{fn concat({fn concat({fn concat({fn concat(DEapellido1 , ' ')}, DEapellido2 )}, ' ' )}, DEnombre)} as DEnombre, 
		CF.CFcodigo,
		CF.CFdescripcion,
		coalesce(ltrim(rtrim(RHP.RHPcodigoext)),ltrim(rtrim(RHP.RHPcodigo))) as RHPcodigo,
		RHP.RHPdescpuesto,
		LT.LTsalario as Salario
	FROM LineaTiempo LT
		INNER JOIN DatosEmpleado DE
		ON DE.DEid = LT.DEid
		INNER JOIN RHPlazas RHPL
			INNER JOIN CFuncional CF
			ON CF.CFid = RHPL.CFid
		ON RHPL.RHPid = LT.RHPid
		INNER JOIN RHPuestos RHP
		ON RHP.RHPcodigo = LT.RHPcodigo
		AND RHP.Ecodigo = LT.Ecodigo
	WHERE LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#"> between LTdesde and LThasta
	ORDER BY <cfif url.GroupBy gt 0>#url.GroupBy#,</cfif>#url.OrderBy#
</cfquery>
<cfif rsReporte.recordcount GT 3000>
	<br>
	<br>
	<cf_translate  key="LB_SeGeneroUnReporteMasGrandeDeLoPermitido">Se gener&oacute; un reporte más grande de lo permitido.  Proceso Cancelado!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<cfreport format="#Url.formato#" template= "salariosEmpleados.cfr" query="rsReporte">
		<cfreportparam name="FechaHasta" value="#LSParseDateTime(Url.FechaHasta)#">
		<cfreportparam name="OrderBy" value="#Left(Url.OrderBy,1)#">
		<cfreportparam name="GroupBy" value="#Url.GroupBy#">
	</cfreport>
</cfif>