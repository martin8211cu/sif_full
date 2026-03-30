<cfset fecha_desde = '(select EVfantig from EVacacionesEmpleado where DEid = LT.DEid)' >
<cfset vFecha = LSDateFormat(LSParseDateTime(Url.FechaHasta), 'yyyymmdd') >
<!---<cf_dump var="#URL#">--->

<cfif Application.dsinfo[session.DSN].type is 'oracle'>
	<cfset fecha_hasta = "to_date('#vFecha#', 'yyyymmdd')">
<cfelse>
	<cfset fecha_hasta = "convert(datetime,'#vFecha#')">
</cfif>
<cf_dbfunction name="datediff" args="#fecha_desde#|#fecha_hasta#|dd|false" delimiters="|" returnvariable="date_diff" >
<cfquery name="rsReporte" datasource="#session.DSN#">
	SELECT 
		DEidentificacion, 
		{fn concat({fn concat({fn concat({fn concat(DEapellido1 , ' ')}, DEapellido2 )}, ' ' )}, DEnombre)} as DEnombre, 
		DEsexo, 
		(select EVfantig from EVacacionesEmpleado where DEid = LT.DEid) as FechaIngreso
	FROM LineaTiempo LT
		INNER JOIN DatosEmpleado DE
		ON DE.DEid = LT.DEid
	WHERE LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
	<cfif not isdefined('ActivarRango')>
		and LT.LTid= (select max(LTid)
               		from LineaTiempo lineaT
			   		where lineaT.DEid = LT.DEid)
		and LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaDesde)#">
		and LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#">
	<cfelse>	
		AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#"> between LTdesde and LThasta
	</cfif>
	
	<!---AND datediff(dd, (select EVfantig from EVacacionesEmpleado where DEid = LT.DEid), <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#">)--->
	AND (#preservesinglequotes(date_diff)#)/365 >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Url.AnnosMinimo#">
	ORDER BY #Url.OrderBy#
</cfquery>
	<!---<cf_dump var="#rsReporte#">--->

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
	<cfreport format="#Url.formato#" template= "antiguedadEmpleados.cfr" query="rsReporte">
		<cfreportparam name="FechaHasta" value="#LSParseDateTime(Url.FechaHasta)#">
		<cfreportparam name="AnnosMinimo" value="#Url.AnnosMinimo#">
		<cfreportparam name="OrderBy" value="#Url.OrderBy#">
	</cfreport>
</cfif>