<cfquery name="rsReporte" datasource="#session.DSN#">
	SELECT 
		DEidentificacion, 
		{fn concat({fn concat({fn concat({fn concat(DEapellido1 , ' ')}, DEapellido2 )}, ' ' )}, DEnombre)} as DEnombre, 
		(select EVfantig from EVacacionesEmpleado where DEid = LT.DEid) as FechaIngreso,
		DLfvigencia as FechaEgreso,
		{fn concat({fn concat(RHTcodigo , ' - ')}, RHTdesc)} as Accion,
		DLobs as MotivoSalida		
	FROM DLaboralesEmpleado LT
		INNER JOIN DatosEmpleado DE
		ON DE.DEid = LT.DEid
		INNER JOIN RHTipoAccion RHT
		ON RHT.RHTid = LT.RHTid
		AND RHT.RHTcomportam = 2
	WHERE LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		AND DLfvigencia between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaDesde)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#">
	ORDER BY #Url.OrderBy#
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

	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 AND Url.formato EQ "excel">
	  <cfset typeRep = 1>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cp.consultas.reportes.Estado_Cuenta_ClienteCP"/>
	<cfelse>
		<cfreport format="#Url.formato#" template= "egresosEmpleados.cfr" query="rsReporte">
			<cfreportparam name="FechaDesde" value="#LSParseDateTime(Url.FechaDesde)#">
			<cfreportparam name="FechaHasta" value="#LSParseDateTime(Url.FechaHasta)#">
			<cfreportparam name="OrderBy" value="#Url.OrderBy#">
		</cfreport>
	</cfif>
</cfif>