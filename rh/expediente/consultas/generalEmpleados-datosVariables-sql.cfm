
<cfif isdefined("url.CFid") and Len(Trim(url.CFid)) and isdefined("url.dependencias")>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
		CFid = "#url.CFid#"
		Nivel = 5
		returnvariable="Dependencias"/>
	<cfset Centros = ValueList(Dependencias.CFid)>
</cfif>

<cfif url.OrderBy is 1>
	<cfset url.OrderBy =  "CF.CFdescripcion"> 
<cfelseif url.OrderBy is 5>
	<cfset url.OrderBy =  "RHP.RHPdescpuesto"> 
<cfelseif url.OrderBy is 7>
	<cfset url.OrderBy =  "DE.DEidentificacion"> 
<cfelseif url.OrderBy is 8>
	<cfset url.OrderBy =  "DE.DEapellido1, DE.DEapellido2, DE.DEnombre"> 
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
 SELECT 
		CF.CFcodigo,
		CF.CFdescripcion,
		coalesce(CFconta.CFcodigo,'&nbsp;') as CFcodigoconta,
		coalesce(CFconta.CFdescripcion,'&nbsp;') as CFdescripcionconta,
		coalesce(ltrim(rtrim(RHP.RHPcodigoext)),ltrim(rtrim(RHP.RHPcodigo))) as RHPcodigo,
		RHP.RHPdescpuesto,
		DEP.Deptocodigo,
		DEP.Ddescripcion,
		DE.DEidentificacion, 
		DE.DEid,
		{fn concat({fn concat({fn concat({fn concat(DE.DEapellido1 , ' ')}, DE.DEapellido2 )}, ' ' )}, DE.DEnombre)} as DEnombre, 
		DE.DEfechanac,
		DE.DEsexo,
		CASE DE.DEcivil
			  WHEN 0 THEN 'Soltero(a)'
			  WHEN 1 THEN 'Casado(a)'
			  WHEN 2 THEN 'Divorciado(a)'
			  WHEN 3 THEN 'Viudo(a)'
			  WHEN 4 THEN 'Union Libre'
			  WHEN 5 THEN 'Separado(a)'
		END AS DEcivil,
		CASE RHJ.RHJornadahora WHEN 0 THEN 'Por Salario Base' ELSE 'Por Hora' END AS FormaDePago,
		CASE TN.Ttipopago
			WHEN 0 THEN 'Semanal'
			WHEN 1 THEN 'Bisemanal'
			WHEN 2 THEN 'Quincenal'
			WHEN 3 THEN 'Mensual'
		END AS FrecuenciaDePago,
		LT.LTsalario as Salario,
		coalesce(DE.DEdireccion,'&nbsp;') as DEdireccion,
		coalesce(DE.DEtelefono1,'&nbsp;') as DEtelefono,
		coalesce(DE.DEtelefono2,'&nbsp;') as DEcelular,
		coalesce(ve.EVfantig,ve.EVfecha) as Antiguedad,
		coalesce(DE.DEtelefono2,'&nbsp;') as DEcelular,
		DE.DEobs1, 
		DE.DEobs2,		
		DE.DEobs3,			
		DE.DEobs4,			
		DE.DEobs5,
		DE.DEdato1,		
		DE.DEdato2,			
		DE.DEdato3,			
		DE.DEdato4, 
		DE.DEdato5,		
		DE.DEdato6,			
		DE.DEdato7,			
		DE.DEinfo1, 
		DE.DEinfo2, 	
		DE.DEinfo3, 
		DE.DEinfo4,
		DE.DEinfo5
	FROM LineaTiempo LT
		INNER JOIN DatosEmpleado DE
		ON DE.DEid = LT.DEid
		INNER JOIN RHPlazas RHPL
			INNER JOIN CFuncional CF
			ON CF.CFid = RHPL.CFid
			<cfif isdefined("url.CFid") and Len(Trim(url.CFid)) and isdefined('url.dependencias')>
				and CF.CFid in (#Centros#)
			<cfelseif isdefined("url.CFid") and Len(Trim(url.CFid))>
				and CF.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			</cfif>
			LEFT OUTER JOIN CFuncional CFconta
			ON CFconta.CFid = RHPL.CFidconta
		ON RHPL.RHPid = LT.RHPid
		INNER JOIN RHPuestos RHP
		ON RHP.RHPcodigo = LT.RHPcodigo
		AND RHP.Ecodigo = LT.Ecodigo
		LEFT OUTER JOIN Departamentos DEP
		ON DEP.Dcodigo = LT.Dcodigo
		AND DEP.Ecodigo = LT.Ecodigo
		INNER JOIN RHJornadas RHJ
		ON RHJ.RHJid = LT.RHJid
		INNER JOIN TiposNomina TN
		ON TN.Ecodigo = LT.Ecodigo
		AND TN.Tcodigo = LT.Tcodigo
		inner join EVacacionesEmpleado ve
		on ve.DEid = DE.DEid
	WHERE LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	and DE.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	
	AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#"> between LTdesde and LThasta
	<!---AND LTdesde < = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#">
	AND LThasta > = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Url.FechaHasta)#">--->
	
	<cfif not (isdefined("url.DEid") and len(trim(url.DEid)) and (isdefined("url.Ord") and url.Ord EQ 8)) >
		ORDER BY #url.OrderBy#
	</cfif>

</cfquery>

<!---<cfdump var="#rsReporte#">--->

<cfquery name="rsDatosVariablesEtiquetas" datasource="#session.DSN#">
select Ecodigo,RHEcol,RHEtiqueta 
	from RHEtiquetasEmpresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and RHdisplay=1
	and RHEcol not like 'FE%'
	order by RHEcol
</cfquery>

<!---
<cfquery name="prueb" datasource="#session.DSN#" maxrows="5">
select *
	from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfdump var="#rsDatosVariablesEtiquetas#">
<cf_dump var="#prueb#">

--->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo2" Default="Mensaje" returnvariable="LB_titulo2"/>
<cfif rsReporte.recordcount GT 3000 and Url.formato neq 'HTML'>
	<cf_web_portlet_start titulo="#LB_titulo2#">
	<br>
	<br>
	<center>
	<cf_translate  key="LB_SeGeneroUnReporteMasGrandeDeLoPermitido">Se gener&oacute; un reporte mÃ¡s grande de lo permitido.  Proceso Cancelado!</cf_translate>
	<br><br>
		<input type="button" value="Regresar" name="Regresar" onclick="history.back()" />
	</center>
	<br>
	<br>
	<cf_web_portlet_end>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
	<cf_web_portlet_start titulo="#LB_titulo2#">
	<br>
	<br>
	<center>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br><br>
		<input type="button" value="Regresar" name="Regresar" onclick="history.back()" />
	</center>
	<br>
	<br>
	<cf_web_portlet_end>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<cfif Url.formato neq 'HTML'>		
		<cfreport format="#Url.formato#" template= "generalEmpleados-datosVariables.cfr" query="rsReporte">
			<cfreportparam name="FechaHasta" value="#LSParseDateTime(Url.FechaHasta)#">
			<cfif isdefined('ActivarRango')>
				<cfreportparam name="FechaDesde" value="#LSParseDateTime(Url.FechaDesde)#">
			</cfif>
			<cfreportparam name="OrderBy" value="#Left(Url.OrderBy,1)#">
		</cfreport>
	<cfelse>
		<cfinclude template="generalEmpleados-datosVariables-html.cfm">
	</cfif>	
</cfif>