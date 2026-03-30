<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Totales 	= t.Translate('LB_Totales','Totales')>
<cfset TIT_TituloRep = t.Translate('TIT_TituloRep','Reporte - Financiamiento')>
<cfset LB_Banco 		= t.Translate('LB_Banco','Bancos')>
<cfset LB_Periodo 	= t.Translate('LB_Periodo','Periodo')>
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset CMB_Mes = t.Translate('CMB_Mes','Mes','/sif/generales.xml')>
<cfset MSG_FinRep 	= t.Translate('MSG_FinRep','Fin del Reporte')>
<cfset LB_Total 	= t.Translate('LB_Total','Total')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Anio = t.Translate('LB_Anio','Ano')>
<cfset LB_Capital 	= t.Translate('LB_Capital','Capital')>


<cfset LB_Interes 	= t.Translate('LB_Interes','Interes')>
<cfset LB_PROVEEDOR = t.Translate('LB_PROVEEDOR','Proveedor','/sif/generales.xml')>
<cfset LB_Concepto = t.Translate('LB_Concepto','Concepto','/sif/generales.xml')>
<cfset LB_Domicilio = t.Translate('LB_Domicilio','Domicilio Fiscal')>
<cfset LB_Impuestos = t.Translate('LB_Impuestos','Impuestos')>



<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="rsMonloc" datasource="#session.DSN#">
	select Mcodigo
	from EncFinanciamiento
	where Ecodigo =  #session.Ecodigo#
	and IDFinan=#url.buque#
</cfquery>

<cfquery name="rsReporte" datasource="#session.DSN#">
declare @anoInicio Date
declare @anoFin Date
declare @IDFinan int
declare @Ecodigo int
declare @Mcodigo int
set @anoInicio = #Now()#
set @anoFin = DATEADD(dd,-1,DATEADD(YY,1,@anoInicio))
set @IDFinan = #url.buque#
set @Ecodigo = #session.Ecodigo#
set @Mcodigo = #rsMonloc.Mcodigo#

<cfquery name="rsMonloc" datasource="#session.DSN#">
	select Mcodigo
	from Empresas
	where Ecodigo =  #session.Ecodigo#
</cfquery>

SELECT 'Pagado' as Col1, MIN(FechaInicio) AS Desde, MAX(FechaInicio) AS Hasta,Miso4217 as Mnombre, SUM(Capital) AS Capital,SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total FROM TablaAmortFinanciamiento a left join Monedas b on a.Ecodigo = b.Ecodigo WHERE IDFinan = @IDFinan AND a.Ecodigo = @Ecodigo AND b.Mcodigo=@Mcodigo AND FechaInicio < @anoInicio group by Miso4217
UNION ALL
SELECT 'Por Pagar A�o 1' as Col1, MIN(FechaInicio) AS Desde, MAX(FechaInicio) AS Hasta,Miso4217 as Mnombre, SUM(Capital) AS Capital , SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total FROM TablaAmortFinanciamiento a left join Monedas b on a.Ecodigo = b.Ecodigo WHERE IDFinan = @IDFinan AND a.Ecodigo = @Ecodigo AND b.Mcodigo=@Mcodigo AND FechaInicio BETWEEN @anoInicio AND @anoFin group by Miso4217
UNION ALL
SELECT 'Por Pagar A�o 2' as Col1, MIN(FechaInicio) AS Desde, MAX(FechaInicio) AS Hasta,Miso4217 as Mnombre, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total FROM TablaAmortFinanciamiento a left join Monedas b on a.Ecodigo = b.Ecodigo WHERE IDFinan = @IDFinan AND a.Ecodigo = @Ecodigo AND b.Mcodigo=@Mcodigo AND FechaInicio BETWEEN DATEADD(YY,1,@anoInicio) AND DATEADD(YY,1,@anoFin) group by Miso4217
UNION ALL
SELECT 'Por Pagar A�o 3' as Col1, MIN(FechaInicio) AS Desde, MAX(FechaInicio) AS Hasta,Miso4217 as Mnombre, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total FROM TablaAmortFinanciamiento a left join Monedas b on a.Ecodigo = b.Ecodigo WHERE IDFinan = @IDFinan AND a.Ecodigo = @Ecodigo AND b.Mcodigo=@Mcodigo AND FechaInicio BETWEEN DATEADD(YY,2,@anoInicio) AND DATEADD(YY,2,@anoFin) group by Miso4217
UNION ALL
SELECT 'Por Pagar A�o 4' as Col1, MIN(FechaInicio) AS Desde, MAX(FechaInicio) AS Hasta,Miso4217 as Mnombre, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total FROM TablaAmortFinanciamiento a left join Monedas b on a.Ecodigo = b.Ecodigo WHERE IDFinan = @IDFinan AND a.Ecodigo = @Ecodigo AND b.Mcodigo=@Mcodigo AND FechaInicio BETWEEN DATEADD(YY,3,@anoInicio) AND DATEADD(YY,3,@anoFin) group by Miso4217
UNION ALL
SELECT 'Por Pagar A�o 5 - Fin' as Col1, MIN(FechaInicio) AS Desde, MAX(FechaInicio) AS Hasta,Miso4217 as Mnombre, SUM(Capital) AS Capital, SUM(Intereses) AS Intereses, SUM(PagoMensual) AS Total FROM TablaAmortFinanciamiento a left join Monedas b on a.Ecodigo = b.Ecodigo WHERE IDFinan = @IDFinan AND a.Ecodigo = @Ecodigo AND b.Mcodigo=@Mcodigo AND FechaInicio > DATEADD(YY,3,@anoFin) group by Miso4217
</cfquery>

<cfif rsReporte.recordcount GT 10000>
<cfset MSG_LimRep 	= t.Translate('MSG_LimRep','Se genero un reporte más grande de lo permitido.  Se abortó el proceso')>
	<br><br>
	<div align="center">*************#MSG_LimRep#**************</div>
	<br><br>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
<cfset MSG_SinDatos 	= t.Translate('MSG_SinDatos','No hay datos para generar el reporte.  Se abortó el proceso')>
	<br><br>
	<div align="center">*************#MSG_SinDatos#**************</div>
	<cfabort>
</cfif>

<!--- Define cual reporte va a llamar --->
<cfset archivo = "ReporteFinanciamiento.cfr">

<cfquery name="Emp" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
 	where Ecodigo =  #session.Ecodigo#
</cfquery>

<cfset Edescripcion = #Emp.Edescripcion#>

<cfquery name="rsBuque" datasource="#session.DSN#">
	select Documento
	from EncFinanciamiento
 	where Ecodigo =  #session.Ecodigo#
	and IDFinan = #url.buque#
</cfquery>
<cfset LB_NombreArr= #rsBuque.Documento#>




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
				fileName = "mb.consultas.ReporteFinanciamiento"
				headers = "title:#TIT_TituloRep#"/>
		<cfelse>
<cfreport format="#url.formato#" template= "#archivo#" query="rsReporte">
	<cfreportparam name="Edescripcion"   value="#Edescripcion#">
	<cfreportparam name="LB_NombreArr"    value="#LB_NombreArr#">
	<cfreportparam name="TIT_TituloRep" 	value="#TIT_TituloRep#">
	<cfreportparam name="LB_Banco" 			value="#LB_Banco#">
	<cfreportparam name="MSG_FinRep" 		value="#MSG_FinRep#">
	<cfreportparam name="LB_Total" 			value="#LB_Total#">
	<cfreportparam name="LB_Moneda" 		value="#LB_Moneda#">
	<cfreportparam name="LB_Anio" 		    value="#LB_Anio#">
	<cfreportparam name="LB_Interes" 	    value="#LB_Interes#">
	<cfreportparam name="LB_Capital" 	    value="#LB_Capital#">
	<cfreportparam name="LB_Fecha" 	        value="#LB_Fecha#">
	<cfreportparam name="LB_Hora" 	        value="#LB_Hora#">

</cfreport>
</cfif>