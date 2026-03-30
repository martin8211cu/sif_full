<cfinclude template="../../../Utiles/sifConcat.cfm">

<cfset LvarCPPid = form.CPPid>
<cfset LvarCPCano = mid(LvarCPCanoMes,1,4)>
<cfset LvarCPCMes = mid(LvarCPCanoMes,5,2)>
<cfset LvarAnoMesAnterior = (LvarCPCano-1)*100+LvarCPCMes>

<cfquery name="rsPeriodoAnterior" datasource="#session.dsn#">
	select 	CPPid,
			CPPanoMesDesde,
			CPPanoMesHasta
	from CPresupuestoPeriodo p
	where p.Ecodigo	= #Session.Ecodigo#
	  and CPPanoMesDesde >= #LvarAnoMesAnterior#
	  and CPPanoMesHasta <= #LvarAnoMesAnterior#
</cfquery>
<cfif rsPeriodoAnterior.RecordCount GT 0>
	<cfset LvarCPPidAnterior 		= rsPeriodoAnterior.CPPid>
	<cfset LvarAnoMesDesdeAnterior 	= rsPeriodoAnterior.CPPanoMesDesde>
	<cfset LvarAnoMesHastaAnterior 	= rsPeriodoAnterior.CPPanoMesHasta>
<cfelse>
	<cfset LvarCPPidAnterior 		= -1>
	<cfset LvarAnoMesDesdeAnterior 	= (dateFormat(rsPeriodo.CPPfechaDesde,"YYYY")-1)*100 + dateFormat(rsPeriodo.CPPfechaDesde,"MM")>
	<cfset LvarAnoMesHastaAnterior 	= (dateFormat(rsPeriodo.CPPfechaHasta,"YYYY")-1)*100 + dateFormat(rsPeriodo.CPPfechaHasta,"MM")>
</cfif>

<cfset LarrCorte = listToArray(LvarRptDef.Cortes[1],"·")>
<cfquery name="rsPCCE" datasource="#session.dsn#">
	select PCCEclaid, PCCEcodigo, PCCEdescripcion, PCCEempresa
	  from PCClasificacionE
	 where CEcodigo 	= #session.CEcodigo#
	   and PCCEcodigo	= '#LarrCorte[2]#'
</cfquery>
<cfquery name="rsSQL" datasource="#session.DSN#">
	Select  
		coalesce(pccd1.PCCDvalor, '0') as Corte1, 
		substring('Objeto de Gasto: ' #_Cat# coalesce(pccd1.PCCDdescripcion,'Sin Clasificar'),1,69) as Corte1d,
		0 as Corte2, 0 as Corte3, 0 as Corte4, 0 as Corte5, 0 as Corte6, 0 as Corte7, 0 as Corte8, 0 as Corte9, 0 as Corte10, 
		coalesce(sum((
				select sum(m.CPCejecutado + m.CPCejecutadoNC)
				  from CPresupuestoControl m
				 where m.CPcuenta  = cp.CPcuenta
				   and m.CPPid     = #LvarCPPid#
				   and m.CPCanoMes = #LvarCPCanoMes#
				   and m.Ocodigo = o.Ocodigo
			)), 0.00) as Dato1,
		coalesce(sum((
				select sum(m.CPCpresupuestado+m.CPCmodificado+m.CPCvariacion+m.CPCtrasladado+m.CPCtrasladadoE) 
				  from CPresupuestoControl m
				 where m.CPcuenta  = cp.CPcuenta
				   and m.CPPid     = #LvarCPPid#
				   and m.CPCanoMes = #LvarCPCanoMes#
				   and m.Ocodigo = o.Ocodigo
			)), 0.00) as Dato2,
		0.00 as Dato3,
		coalesce(sum((
				select sum(m.CPCejecutado + m.CPCejecutadoNC)
				  from CPresupuestoControl m
				 where m.CPcuenta  = cp.CPcuenta
				   and m.CPPid     = #LvarCPPid#
				   and m.CPCanoMes <= #LvarCPCanoMes#
				   and m.Ocodigo = o.Ocodigo
			)), 0.00) as Dato4,
		coalesce(sum((
				select sum(m.CPCpresupuestado+m.CPCmodificado+m.CPCvariacion+m.CPCtrasladado+m.CPCtrasladadoE) 
				  from CPresupuestoControl m
				 where m.CPcuenta  = cp.CPcuenta
				   and m.CPPid     = #LvarCPPid#
				   and m.CPCanoMes <= #LvarCPCanoMes#
				   and m.Ocodigo = o.Ocodigo
			)), 0.00) as Dato5,
		0.00 as Dato6,
		coalesce(sum((
				select sum(m.CPCejecutado + m.CPCejecutadoNC)
				  from CPresupuestoControl m
				 where m.CPcuenta  	= cp.CPcuenta
				   and m.CPPid     	= #LvarCPPidAnterior#
				   and m.CPCanoMes	>= #LvarAnoMesDesdeAnterior#
				   and m.CPCanoMes	<= #LvarAnoMesAnterior#
				   and m.Ocodigo = o.Ocodigo
			)), 0.00) as Dato7,
		0.00 as Dato8
	from PCClasificacionE pcce1
		inner join PCEClasificacionCatalogo pcecc1
			inner join PCDCatalogoCuentaP cubo1
				inner join CPresupuesto cp
					inner join Oficinas o
						 on o.Ecodigo = cp.Ecodigo
					inner join CtasMayor my
						 on my.Ecodigo = cp.Ecodigo
						and my.Cmayor  = cp.Cmayor
						and my.Ctipo   = 'G'
					 on cp.CPcuenta = cubo1.CPcuenta
					and cp.Ecodigo  = #session.Ecodigo#
		<cfset LvarValor1 = form.CPformato1>
		<cfset LvarValor2 = form.CPformato2>
		<cfif LvarValor1 NEQ "">
			<cfif LvarValor2 EQ "">
					and cp.CPformato = '#LvarValor1#'
			<cfelse>
					and cp.CPformato >= '#LvarValor1#'
					and cp.CPformato <= '#LvarValor2#'
			</cfif>
		</cfif>
		<cfset LvarValor1 = form.PCCDvalor1_1>
		<cfset LvarValor2 = form.PCCDvalor2_1>
		<cfif LvarValor1 NEQ "">
				inner join PCDClasificacionCatalogo pcdcc1
		<cfelse>
				left join PCDClasificacionCatalogo pcdcc1
		</cfif>
					inner join PCClasificacionD pccd1
						 on pccd1.PCCDclaid = pcdcc1.PCCDclaid
		<cfif LvarValor1 NEQ "">
			<cfif LvarValor2 EQ "">
						and pccd1.PCCDvalor = '#LvarValor1#'
			<cfelse>
						and pccd1.PCCDvalor >= '#LvarValor1#'
						and pccd1.PCCDvalor <= '#LvarValor2#'
			</cfif>
		</cfif>
					  on pcdcc1.PCDcatid  = cubo1.PCDcatid
					 and pcdcc1.PCEcatid  = cubo1.PCEcatid
				 on cubo1.PCEcatid  = pcecc1.PCEcatid
			 on pcecc1.PCCEclaid = pcce1.PCCEclaid
	where pcce1.PCCEclaid = #rsPCCE.PCCEclaid#
	<cf_CPSegUsu_where Consultar="true" aliasCuentas="cp" aliasOficina="o">
	group by coalesce(pccd1.PCCDvalor, '0'), substring('Objeto de Gasto: ' #_Cat# coalesce(pccd1.PCCDdescripcion,'Sin Clasificar'),1,69)
	<cfif LvarAbort>
		<cfabort>
	</cfif>
</cfquery>
