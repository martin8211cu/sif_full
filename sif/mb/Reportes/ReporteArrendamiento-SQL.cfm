<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  03/05/2014                                              --->
<!--- Última Modificación: 04/05/2014                                 --->
<!--- =============================================================== --->
<cfprocessingdirective pageencoding = "utf-8">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfparam name="date"	default="">
<cfparam name="ID"		default="">

<cfset TIT_TituloRep	= t.Translate('TIT_TituloRep','Reporte - Arrendamientos')>
<cfset LB_Hora 			= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha 		= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Banco 		= t.Translate('LB_Banco','Bancos')>
<cfset LB_Capital 		= t.Translate('LB_Capital','Capital')>
<cfset LB_Interes 		= t.Translate('LB_Interes','Interes')>
<cfset LB_Total 		= t.Translate('LB_Total','Total')>
<cfset LB_Totales		= t.Translate('LB_Totales','Totales')>
<cfset MSG_FinRep 		= t.Translate('MSG_FinRep','Fin del Reporte')>
<cfset LB_Moneda 		= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>

<cfset date 			= "#dateformat(now(),'YYYY-MM-DD')#">
<cfset ID				= #url.NombreArrend#>

<!--- Define cual reporte va a llamar --->
<cfset archivo = "ReporteArrendamiento.cfr">

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo =  #session.Ecodigo# 
</cfquery>

<cfquery name="rsMonedas" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo =  #session.Ecodigo# 
</cfquery>

<cfquery name="rsNombreArr" datasource="#session.dsn#">
	SELECT 	ArrendNombre
	FROM	CatalogoArrend
	WHERE	IDCatArrend = #id#
	  AND	Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsReporte" datasource="#session.dsn#">
	declare @añoInicio Date
	declare @añoFin Date
	declare @IDArrend int
	declare @Ecodigo int
	set @añoInicio = '#date#'
	set @añoFin = DATEADD(dd,-1,DATEADD(YY,1,@añoInicio))
	set @IDArrend = #ID#
	set @Ecodigo = #Session.Ecodigo#

	SELECT 'Cobrado' AS Col1, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total, Miso4217 AS Moneda FROM TablaAmort a INNER JOIN Monedas b ON a.Mcodigo = b.Mcodigo WHERE IDArrend = @IDArrend AND a.Ecodigo = @Ecodigo AND FechaInicio < @añoInicio group by b.Miso4217
	UNION ALL
	SELECT 'Por Cobrar Año 1' AS Col1, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total, Miso4217 AS Moneda FROM TablaAmort a INNER JOIN Monedas b ON a.Mcodigo = b.Mcodigo WHERE IDArrend = @IDArrend AND a.Ecodigo = @Ecodigo AND FechaInicio BETWEEN @añoInicio AND @añoFin group by b.Miso4217
	UNION ALL
	SELECT 'Por Cobrar Año 2' AS Col1, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total, Miso4217 AS Moneda FROM TablaAmort a INNER JOIN Monedas b ON a.Mcodigo = b.Mcodigo WHERE IDArrend = @IDArrend AND a.Ecodigo = @Ecodigo AND FechaInicio BETWEEN DATEADD(YY,1,@añoInicio) AND DATEADD(YY,1,@añoFin) group by b.Miso4217
	UNION ALL
	SELECT 'Por Cobrar Año 3' AS Col1, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total, Miso4217 AS Moneda FROM TablaAmort a INNER JOIN Monedas b ON a.Mcodigo = b.Mcodigo WHERE IDArrend = @IDArrend AND a.Ecodigo = @Ecodigo AND FechaInicio BETWEEN DATEADD(YY,2,@añoInicio) AND DATEADD(YY,2,@añoFin) group by b.Miso4217
	UNION ALL
	SELECT 'Por Cobrar Año 4' AS Col1, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total, Miso4217 AS Moneda FROM TablaAmort a INNER JOIN Monedas b ON a.Mcodigo = b.Mcodigo WHERE IDArrend = @IDArrend AND a.Ecodigo = @Ecodigo AND FechaInicio BETWEEN DATEADD(YY,3,@añoInicio) AND DATEADD(YY,3,@añoFin) group by b.Miso4217
	UNION ALL
	SELECT 'Por Cobrar Año 5 - Fin' AS Col1, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total, Miso4217 AS Moneda FROM TablaAmort a INNER JOIN Monedas b ON a.Mcodigo = b.Mcodigo WHERE IDArrend = @IDArrend AND a.Ecodigo = @Ecodigo AND FechaInicio > DATEADD(YY,3,@añoFin) group by b.Miso4217
</cfquery>

<!--- INVOCA EL REPORTE --->
<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
				select Pvalor as valParam
				from Parametros
				where Pcodigo = 20007
				and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	<cfset typeRep = 1>
	<cfif url.formato EQ "pdf">
		<cfset typeRep = 2>
	</cfif>
	<cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = typeRep
		fileName = "mb.consultas.ReporteArrendamiento"
		headers = "title:#TIT_TituloRep#"/>
<cfelse>
<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
	<cfreportparam name="TIT_TituloRep" 	value="#TIT_TituloRep#">
	<cfreportparam name="Edescripcion" 		value="#rsEmpresa.Edescripcion#">
	<cfreportparam name="LB_NombreArr" 		value="#rsNombreArr.ArrendNombre#">
	<cfreportparam name="LB_Moneda" 		value="#LB_Moneda#">
	<cfreportparam name="LB_Capital" 		value="#LB_Capital#">
	<cfreportparam name="LB_Interes" 		value="#LB_Interes#">
	<cfreportparam name="LB_Total"	 		value="#LB_Total#">
	<cfreportparam name="LB_Hora" 			value="#LB_Hora#">
	<cfreportparam name="LB_Fecha" 			value="#LB_Fecha#">
	<cfreportparam name="LB_Banco" 			value="#LB_Banco#">
	<cfreportparam name="LB_Totales"		value="#LB_Totales#">
	<cfreportparam name="MSG_FinRep" 		value="#MSG_FinRep#">
</cfreport>
</cfif>