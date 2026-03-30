<cf_dbfunction name="datediff" args="FEfnac,'#LSDateFormat(Url.FechaHasta,'dd/mm/yyyy')#'" returnvariable="Lvar_DiffFechas">
<cfquery name="rsReporte" datasource="#session.DSN#">
	SELECT 
		DEidentificacion, 
		{fn concat({fn concat({fn concat({fn concat(DEapellido1 , ' ')}, DEapellido2 )}, ' ' )}, DEnombre)} as DEnombre, 
		{fn concat({fn concat({fn concat({fn concat(FEapellido1 , ' ')}, FEapellido2 )}, ' ' )}, FEnombre)} as FEnombre, 
		FEsexo, 
		FEfnac
	FROM LineaTiempo LT
		INNER JOIN DatosEmpleado DE
		ON DE.DEid = LT.DEid
		INNER JOIN FEmpleado FE
		ON FE.DEid = DE.DEid
		AND FE.Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.Pid#">
	WHERE LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#"> between LTdesde and LThasta
	<cfif Url.EdadDesde gt 0>
	<!--- Si edad desde es mayor o igual que cero --->
	AND (#PreserveSingleQuotes(Lvar_DiffFechas)#)/365  >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.EdadDesde#">
	</cfif>
	<cfif Url.TipoCorte eq 1>
	<!--- Si incluye edad tope --->
	AND (#PreserveSingleQuotes(Lvar_DiffFechas)#)/365  <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.EdadHasta#">
	<cfelse>
	<!--- Si no --->
	AND (#PreserveSingleQuotes(Lvar_DiffFechas)#)/365  < <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.EdadHasta#">
	</cfif>
	<!--- Order By --->
	ORDER BY #Url.OrderBy#,#Url.ThenOrderBy#
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
	<cfquery name="rsParentesco" datasource="#session.dsn#">
		select Pdescripcion
		from RHParentesco
		where Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.Pid#">
	</cfquery>
	<cfreport format="#Url.formato#" template= "hijosEmpleados.cfr" query="rsReporte">
		<cfreportparam name="FechaHasta" value="#LSParseDateTime(Url.FechaHasta)#">
		<cfreportparam name="AnnosHasta" value="#Url.EdadHasta#">
		<cfreportparam name="OrderBy" value="#Url.OrderBy#">
		<cfreportparam name="NombreFamiliar" value="#rsParentesco.Pdescripcion#">
	</cfreport>
</cfif>