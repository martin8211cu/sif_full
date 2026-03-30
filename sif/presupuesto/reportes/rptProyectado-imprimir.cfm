<cfsetting 	requesttimeout="600"
			enablecfoutputonly="yes">

<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfparam name="form.CPPid" default="#session.CPPid#">
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cfset LvarLineasPagina = 55>

<cftry>
	<cfif false>
		<cfset LvarCF = "">
	<cfelseif isdefined("form.CFid") AND form.CFid NEQ "" AND form.CFid GT 0>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select CFdescripcion 
			  from CFuncional 
			 where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfquery>
		<cfset LvarCF = "Cuentas del Centro Funcional: #rsSQL.CFdescripcion#">
	<cfelseif isdefined("form.CFid") AND form.CFid EQ -100>
		<cfset LvarCF = "Todas las cuentas permitidas para el usuario">
	<cfelse>
		<cfset LvarCF = "">
	</cfif>

	<cfif not isdefined("session.rptRnd")><cfset session.rptRnd = int(rand()*10000)></cfif>
	<cfif isdefined("form.btnCancelar")>
		<cfset session.rptProyectado_Cancel = true>
		<cflocation url="rptProyectado.cfm">
		<cfabort>	
	</cfif>
    
	<!---►►Tabla de Saldos: #empresas#◄◄--->
	<cf_dbtemp name="CPproy_V1" returnVariable="saldos">
		<cf_dbtempcol name="CPtipo"  	type="varchar(1)">
		<cf_dbtempcol name="CPcuenta"	type="numeric">
		<cf_dbtempcol name="anual"		type="money">
		<cf_dbtempcol name="mes1"		type="money">
		<cf_dbtempcol name="mes2"		type="money">
		<cf_dbtempcol name="mes3"		type="money">
		<cf_dbtempcol name="mes4"		type="money">
		<cf_dbtempcol name="mes5"		type="money">
		<cf_dbtempcol name="mes6"		type="money">
		<cf_dbtempcol name="mes7"		type="money">
		<cf_dbtempcol name="mes8"		type="money">
		<cf_dbtempcol name="mes9"		type="money">
		<cf_dbtempcol name="mes10"		type="money">
		<cf_dbtempcol name="mes11"		type="money">
		<cf_dbtempcol name="mes12"		type="money">
	</cf_dbtemp>
	
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cflock timeout="1" name="rptProyectado_#session.rptRnd#" throwontimeout="yes">
		<cfset structDelete(session, "rptProyectado_Cancel")>

		<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select CPPid, 
				   CPPtipoPeriodo, 
				   CPPfechaDesde, 
				   CPPfechaHasta, 
				   CPPfechaUltmodif, 
				   CPPestado,
				   'Presupuesto ' #_Cat#
						case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
							case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat# 
							case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
					as CPPdescripcion
			from CPresupuestoPeriodo p
			where p.Ecodigo = #Session.Ecodigo#
			  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		</cfquery>
		
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarCPPid = form.CPPid>
		<cfset LvarPAg = 1>  
		<cfset LvarContL = 5>  
		<cfset LvarMeses = arrayNew(1)>
		<cfset LvarMeses[1] = "ENERO">
		<cfset LvarMeses[2] = "FEBRERO">
		<cfset LvarMeses[3] = "MARZO">
		<cfset LvarMeses[4] = "ABRIL">
		<cfset LvarMeses[5] = "MAYO">
		<cfset LvarMeses[6] = "JUNIO">
		<cfset LvarMeses[7] = "JULIO">
		<cfset LvarMeses[8] = "AGOSTO">
		<cfset LvarMeses[9] = "SETIEMBRE">
		<cfset LvarMeses[10] = "OCTUBRE">
		<cfset LvarMeses[11] = "NOVIEMBRE">
		<cfset LvarMeses[12] = "DICIEMBRE">
		
		

		<cfquery name="rsCPmeses"   datasource="#Session.DSN#">
			select CPCano, CPCmes
			  from CPmeses
			 where CPPid = #LvarCPPid#
			 order by 1,2
		</cfquery>
		
		<cfquery datasource="#session.dsn#" name="rsContaPer">
			select Pvalor from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 30
		</cfquery>

		<cfquery datasource="#session.dsn#" name="rsContaMes">
			select Pvalor from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 40
		</cfquery>

		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarAno = #rsContaPer.Pvalor#>
		<cfset LvarMes = #rsContaMes.Pvalor#>  
		<cfset LvarAnoMesCONTA = LvarAno*100+LvarMes>
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarValor1 = evaluate("form.CPformato1")>
		<cfset LvarValor2 = evaluate("form.CPformato2")>
		<cfset LvarCPformato = "">
		<cfif LvarValor1 NEQ "">
			<cfif LvarValor2 EQ "">
				<cfset LvarCPformato = " and c.CPformato = '#LvarValor1#'">
			<cfelse>
				<cfset LvarCPformato = " and c.CPformato >= '#LvarValor1#' and c.CPformato <= '#LvarValor2 & chr(255)#'">
			</cfif>
		</cfif>
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->
		<cfset LvarOcodigo = "">
		<cfif LvarValor1 NEQ "">
			<cfif LvarValor2 EQ "">
				<cfset LvarCPformato = " and c.CPformato = '#LvarValor1#'">
			<cfelse>
				<cfset LvarCPformato = " and c.CPformato >= '#LvarValor1#' and c.CPformato <= '#LvarValor2 & chr(255)#'">
			</cfif>
		</cfif>
		<!--- ************************************************************* --->
		<!--- ************************************************************* --->

		<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"
					method				= "fnTipoPresupuesto"
					returnvariable		= "LvarCPtipo"
					
					CPPid				= "#LvarCPPid#"
					Ctipo				= "my.Ctipo"
					CPresupuestoAlias 	= "c"
					IncluirCOSTOS		= "false"
		/>
		<cfset LvarFormulados = 0>
		<cfset LvarEjecutados = 0>
		<cfset LvarTotales = ArrayNew(2)>
		<cfset LvarTotales[1][20] = 0>
		<cfset LvarTotales[1][21] = 0>
		<cfset LvarTotales[2][20] = 0>
		<cfset LvarTotales[2][21] = 0>
		<cfquery datasource="#Session.DSN#">
			insert into #saldos# (CPtipo,CPcuenta,anual
			<cfloop query="rsCPmeses">,mes#rsCPmeses.CPCmes#</cfloop>
			)
			Select #preserveSingleQuotes(LvarCPtipo)#,
				c.CPcuenta
				, coalesce( (select sum(round(CPCpresupuestado+CPCmodificado,2)) from CPresupuestoControl where Ecodigo = c.Ecodigo and CPPid=#LvarCPPid# and CPcuenta=c.CPcuenta), 0) as Formulado
			<cfloop query="rsCPmeses">
				<cfif rsCPmeses.CPCano*100+rsCPmeses.CPCmes LT LvarAnoMesCONTA>
					<cfset LvarEjecutados ++>
				, coalesce( (select sum(round(CPCejecutado+CPCejecutadoNC,2)) from CPresupuestoControl where Ecodigo = c.Ecodigo and CPPid=#LvarCPPid# and CPCano=#rsCPmeses.CPCano# and CPCmes=#rsCPmeses.CPCmes# and CPcuenta=c.CPcuenta), 0) as Mes_#rsCPmeses.CPCmes#
				<cfelse>
					<cfset LvarFormulados ++>
				, coalesce( (select sum(round(CPCpresupuestado+CPCmodificado,2)) from CPresupuestoControl where Ecodigo = c.Ecodigo and CPPid=#LvarCPPid# and CPCano=#rsCPmeses.CPCano# and CPCmes=#rsCPmeses.CPCmes# and CPcuenta=c.CPcuenta), 0) as Mes_#rsCPmeses.CPCmes#
				</cfif>
				<cfset LvarTotales[1][rsCPmeses.CPCmes] = 0>
				<cfset LvarTotales[2][rsCPmeses.CPCmes] = 0>
			</cfloop>
			  from CPresupuesto c
			  	inner join CtasMayor my
					 on my.Ecodigo = c.Ecodigo
					and my.Cmayor  = c.Cmayor
				<cfif form.Ctipo NEQ "">
					and my.Ctipo in (<cfqueryparam value="#form.Ctipo#" cfsqltype="cf_sql_varchar" list="yes">)
				</cfif>
			  	inner join CPCuentaPeriodo cp
					 on cp.Ecodigo	= c.Ecodigo
					and cp.CPPid	= #LvarCPPid#
					and cp.CPcuenta	= c.CPcuenta
			 where c.Ecodigo 		= #Session.Ecodigo#
				#PreserveSingleQuotes(LvarCPformato)#
				<cf_CPSegUsu_where Consultar="true" aliasCuentas="c" aliasOficina="">
		</cfquery>

		<cfquery name="rsReporte" datasource="#Session.DSN#">
			delete from #saldos# 
			 where CPtipo = 'X'
			    or (anual=0 AND mes1 = 0 AND mes2 = 0 AND mes3 = 0 AND mes4 = 0 AND mes5 = 0 AND mes6 = 0 AND mes7 = 0 AND mes8 = 0 AND mes9 = 0 AND mes10 = 0 AND mes11 = 0 AND mes12 = 0)
		</cfquery>

		<cfquery name="rsReporte" datasource="#Session.DSN#">
			select  case when CPtipo = 'I' then '1' else '2' end as TIPO, 
					c.CPcuenta, min(c.CPformato) as CPformato, min(c.CPdescripcion) as CPdescripcion,
					sum(anual) as anual,
					sum(mes1) as mes1,
					sum(mes2) as mes2,
					sum(mes3) as mes3,
					sum(mes4) as mes4,
					sum(mes5) as mes5,
					sum(mes6) as mes6,
					sum(mes7) as mes7,
					sum(mes8) as mes8,
					sum(mes9) as mes9,
					sum(mes10) as mes10,
					sum(mes11) as mes11,
					sum(mes12) as mes12
			  from #saldos# s
			  	inner join PCDCatalogoCuentaP cb
					 on cb.CPcuenta = s.CPcuenta
				<cfif form.CPCNivel EQ 'U'>
					and cb.CPcuenta = cb.CPcuentaniv
				<cfelse>
					and (cb.PCDCniv = #form.CPCNivel# or (cb.PCDCniv < #form.CPCNivel# AND cb.CPcuenta = cb.CPcuentaniv))
				</cfif>
			  	inner join CPresupuesto c
					 on c.CPcuenta = cb.CPcuentaniv
			group by case when CPtipo = 'I' then '1' else '2' end, c.CPcuenta
			order by 1,3
		</cfquery>
		<cfif isdefined("btnDownload")>
			<cfset LvarNoCortes = "1">
		</cfif>
		<cf_htmlReportsHeaders 
			title="Reporte de Proyeccion Anual de Presupuesto" 
			filename="rptProyeccion.xls"
			irA="rptProyectado.cfm" 
			>
		<cfoutput>
				<cfset sbGeneraEstilos()>
				<cfset Encabezado()>
				<cfset Creatabla()>
				<cfset titulos()>
				<cfflush interval="512">
				<cfset LvarTIPO = "">
				<cfloop query="rsReporte" >
					<cfif isdefined("session.rptProyectado_Cancel")>
						<cfset structDelete(session, "rptProyectado_Cancel")>
						<cf_errorCode	code = "50509" msg = "Reporte Cancelado por el Usuario">
					</cfif>

					<cfif LvarTIPO NEQ rsReporte.tipo>
						<cfset sbCorteTIPO(rsReporte.tipo)>
					<cfelse>
						<cfset sbCortePagina()>
					</cfif>
					<tr>
						<td align="left" class="Datos">#rsReporte.CPformato#&nbsp;&nbsp;</td>
						<td align="left" class="Datos" >#rsReporte.CPdescripcion#</td>
						
					<cfset LvarTotLin = 0>
					<cfloop query="rsCPmeses">
						<cfset LvarMonto = evaluate("rsReporte.Mes#rsCPmeses.CPCmes#")>
						<cfset LvarTotLin += LvarMonto>
						<cfset LvarTotales[LvarTIPO][rsCPmeses.CPCmes] += LvarMonto>
						<td align="right" class="Datos" >#LSNumberFormat(LvarMonto,',9.00')#</td>
					</cfloop>
						<td align="right" class="Datos" >#LSNumberFormat(LvarTotLin,',9.00')#</td>
						<td align="right" class="Datos" >#LSNumberFormat(LvarTotLin/12,',9.00')#</td>
						<td align="right" class="Datos" >#LSNumberFormat(rsReporte.Anual,',9.00')#</td>
						<td align="right" class="Datos" >#LSNumberFormat(rsReporte.Anual/12,',9.00')#</td>
						<cfset LvarTotales[LvarTIPO][20] += LvarTotLin>
						<cfset LvarTotales[LvarTIPO][21] += rsReporte.Anual>
				</tr>
				</cfloop>
				<cfset sbCorteTIPO(3)>
				<cfset Cierratabla()>
			</body>
		</html>
		</cfoutput>

	</cflock>
<cfcatch type="lock">
	<cfoutput>
	<script language="javascript">
		alert('Ya existe un reporte en ejecución, debe esperar a que termine su procesamiento');
		location.href = "rptProyectado.cfm";
	</script>
	</cfoutput>
</cfcatch>
</cftry>

<!--- ************************************************************* --->
<!--- *********    Creación de funciones  			   ************ --->
<!--- ************************************************************* --->
<cffunction name="Encabezado" output="true">
	<table width="100%" border="0">
		<tr>
			<td  class="Header1" colspan="16" align="center">
				<strong>#ucase(session.Enombre)#</strong>
			</td>
		</tr>
		<tr>
			<td  class="Header1" colspan="16" align="center"><strong>REPORTE DE PROYECCION ANUAL DE PRESUPUESTO</strong></td>
		</tr>
		<tr>
			<td class="Header" colspan="16" align="center"><strong>#ucase(rsPeriodo.CPPDESCRIPCION)#</strong></td>
		</tr>
		<tr> 
			<td class="Header" colspan="16" align="center"><strong>GENERADO EL MES DE #LvarMeses[LvarMes]#  #LvarAno#</strong></td>
		</tr>
	<cfif LvarCF NEQ "">
		<tr> 
			<td class="Header" colspan="16" align="center"><strong>(#LvarCF#)</strong></td>
		</tr>
	</cfif>		
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Creatabla" output="true">
	<table width="100%" border="0">
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Cierratabla" output="true">
	</table>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="titulos" output="true">
	<tr>
		<td align="center" class="ColHeader" rowspan="2">Cuenta Presupuesto</td>
		<td align="center" class="ColHeader" rowspan="2">Descripcion</td>

		<cfif LvarEjecutados NEQ 0>
			<td align="center" class="ColHeader" colspan="<cfoutput>#LvarEjecutados#</cfoutput>">EJECUTADO</td>
		</cfif>
		<cfif LvarFormulados NEQ 0>
			<td align="center" class="ColHeader" colspan="<cfoutput>#LvarFormulados#</cfoutput>">FORMULADO</td>
		</cfif>
			<td align="center" class="ColHeader" colspan="4">TOTALES</td>
	</tr>
	<tr>
	<cfloop query="rsCPmeses">
		<td align="center" class="ColHeader"><cfoutput>#LvarMeses[rsCPmeses.CPCmes]#</cfoutput></td>
	</cfloop>
		<td align="center" class="ColHeader" >Proyeccion Anual</td>
		<td align="center" class="ColHeader" >Proyeccion Mensual</td>
		<td align="center" class="ColHeader" >Plan Anual</td>
		<td align="center" class="ColHeader" >Plan Mensual</td>
	</tr>
</cffunction>
<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
	<!--
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		
		.ColHeader 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		8px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}
	
		.Header 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}
	
		.Header1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		8px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte2 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		7px;
			font-weight: 	bold;
			padding-left: 	10px;
		}
	
		.Corte3 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	bold;
			padding-left: 	20px;
		}
	
		.Corte4 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			padding-left: 	30px;
		}
	
		.Datos 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		7px;
			font-weight: 	none;
			white-space:nowrap;
		}
	
		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	-->
	</style>
</cffunction>

<cffunction name="sbCortePagina" output="true">
	<cfif isdefined("LvarNoCortes")>
		<cfreturn>
	</cfif>
	<cfif LvarContL GTE LvarLineasPagina>
		<tr><td><H1 class=Corte_Pagina></H1></td></tr>
		<cfset Cierratabla()>
		<cfset LvarPAg   = LvarPAg + 1>
		<cfset LvarContL = 5> 
		<cfset Encabezado()>
		<cfset Creatabla()>
		<cfset titulos()>
	</cfif>
	<cfset LvarContL = LvarContL + 1>  
</cffunction>
				


<cffunction name="sbCorteTIPO" output="true">
	<cfargument name="tipo">
	
	
	<cfif LvarTIPO NEQ "">
		<cfif LvarTIPO EQ 1>
			<tr>
				<td align="left" class="Corte1" colspan="2">TOTAL INGRESOS PRESUPUESTARIOS</td>
		<cfelseif LvarTIPO EQ 2>
			<tr>
				<td align="left" class="Corte1" colspan="2">TOTAL EGRESOS PRESUPUESTARIOS</td>
		</cfif>
			<cfloop query="rsCPmeses">
				<cfset LvarMonto = LvarTotales[LvarTIPO][rsCPmeses.CPCmes]>
				<td align="right" class="Corte1" >#LSNumberFormat(LvarMonto,',9.00')#</td>
			</cfloop>
				<cfset LvarMonto = LvarTotales[LvarTIPO][20]>
				<td align="right" class="Corte1" >#LSNumberFormat(LvarMonto,',9.00')#</td>
				<td align="right" class="Corte1" >#LSNumberFormat(LvarMonto/12,',9.00')#</td>
				<cfset LvarMonto = LvarTotales[LvarTIPO][21]>
				<td align="right" class="Corte1" >#LSNumberFormat(LvarMonto,',9.00')#</td>
				<td align="right" class="Corte1" >#LSNumberFormat(LvarMonto/12,',9.00')#</td>
			</tr>
	</cfif>
	<cfset sbCortePagina()>
	<cfif Arguments.tipo EQ 1>
		<tr>
			<td align="left" class="ColHeader" colspan="18">CUENTAS DE INGRESOS PRESUPUESTARIOS</td>
		</tr>
	<cfelseif Arguments.tipo EQ 2>
		<tr>
			<td align="left" class="ColHeader" colspan="18">CUENTAS DE EGRESOS PRESUPUESTARIOS</td>
		</tr>
	<cfelseif Arguments.tipo EQ 3>
		<tr>
			<td align="left" class="ColHeader" colspan="2">TOTALES PRESUPUESTARIOS</td>
			<cfloop query="rsCPmeses">
				<cfset LvarMonto = LvarTotales[1][rsCPmeses.CPCmes]-LvarTotales[2][rsCPmeses.CPCmes]>
				<td align="right" class="ColHeader" >#LSNumberFormat(LvarMonto,',9.00')#</td>
			</cfloop>
				<cfset LvarMonto = LvarTotales[1][20]-LvarTotales[2][20]>
				<td align="right" class="ColHeader" >#LSNumberFormat(LvarMonto,',9.00')#</td>
				<td align="right" class="ColHeader" >#LSNumberFormat(LvarMonto/12,',9.00')#</td>
				<cfset LvarMonto = LvarTotales[1][21]-LvarTotales[2][21]>
				<td align="right" class="ColHeader" >#LSNumberFormat(LvarMonto,',9.00')#</td>
				<td align="right" class="ColHeader" >#LSNumberFormat(LvarMonto/12,',9.00')#</td>
		</tr>
	</cfif>
	<cfset LvarTIPO = Arguments.tipo>
</cffunction>
