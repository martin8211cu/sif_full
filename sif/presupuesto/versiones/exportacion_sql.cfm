<cfsetting 	enablecfoutputonly="yes"
			requesttimeout="36000">
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.ecodigo#
	   and Pcodigo = 50
</cfquery>
<cfset LvarAuxAno = rsSQL.Pvalor>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select Pvalor
	  from Parametros
	 where Ecodigo = #session.ecodigo#
	   and Pcodigo = 60
</cfquery>
<cfset LvarAuxMes = rsSQL.Pvalor>
<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>
<cfparam name="url.CPPid" default="-1">

<cfquery name="rsSQL" datasource="#session.dsn#">
	select CPPid, CPPtipoPeriodo, CPPestado, CPPfechaDesde, CPPfechaHasta, CPPanoMesDesde, CPPanoMesHasta
	  from CPresupuestoPeriodo
	 where CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPPid#">
	   and Ecodigo = #session.Ecodigo#
</cfquery>

<cfif rsSQL.recordCount EQ 0>
	<cf_errorCode	code = "50550" msg = "No se ha indicado el Período de Presupuesto a Trabajar">
<cfelseif rsSQL.CPPestado NEQ "1">
	<cf_errorCode	code = "50551" msg = "El Período de Presupuesto no está Abierto">
<cfelseif LvarAuxAnoMes GT rsSQL.CPPanoMesHasta>
	<cf_errorCode	code = "50552" msg = "El mes de Auxiliables es posterior al Período de Presupuesto">
</cfif>
<cfset LvarCPPid = rsSQL.CPPid>

<cfif isdefined("url.ExportacionReales")>
	<cfset LvarArchivo = "EjecutadoReal-#LvarAuxAno#-#LvarAuxMes#.xls">
<cfelse>
	<cfset LvarArchivo = "Formulacion-#LvarAuxAno#-#LvarAuxMes#.xls">
</cfif>
<cfheader name="Content-Type" 			value="text/plain">
<cfheader name="Content-Disposition"	value="attachment;filename=#LvarArchivo#">
<cfoutput><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html 	xmlns:o="urn:schemas-microsoft-com:office:office"
		xmlns:x="urn:schemas-microsoft-com:office:excel"
		xmlns="http://www.w3.org/TR/REC-html40">
	<head>
		<title>Exportación de Montos de Control de Presupuesto</title>
	</head>
	<body>
</cfoutput>
<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
	select Mcodigo
	  from Empresas 
	 where Ecodigo = #session.ecodigo#
</cfquery>

<cfif isdefined("url.ExportacionFormulado")>
	<cfif LvarAuxAnoMes LTE rsSQL.CPPanoMesDesde OR (isdefined("url.chkForzarInicio") AND url.chkForzarInicio EQ "1")>
		<cfset LvarFechaIni = rsSQL.CPPfechaDesde>
	<cfelse>
		<cfset LvarFechaIni = createDate(LvarAuxAno,LvarAuxMes,1)>
	</cfif>
	<cfset LvarAno = datepart("yyyy",LvarFechaIni)>
	<cfset LvarMes = datepart("m",LvarFechaIni)>
	<cfset LvarMesN   = rsSQL.CPPtipoPeriodo>
	<cfset LvarAnoMesIni = LvarAno*100+LvarMes>
	<cfset LvarAnoMesFin = rsSQL.CPPanoMesHasta>
	<cfquery name="rsFormulacion" datasource="#session.dsn#">
		select distinct c.CPformato, coalesce(c.CPdescripcionF,c.CPdescripcion) as CPdescripcion, cp.CPCPtipoControl, cp.CPCPcalculoControl, o.Oficodigo, m.Miso4217, #LvarAno# as Ano, #LvarMes# as Mes,
		<cfloop index="i" from="1" to="12">
			<cfif LvarAno*100+LvarMes LTE LvarAnoMesFin>
				coalesce(
					(select CPCMpresupuestado+CPCMmodificado 
					   from CPControlMoneda
					  where Ecodigo 	= f.Ecodigo
						and CPPid		= f.CPPid
						and CPCano		= #LvarAno#
						and CPCmes		= #LvarMes#
						and CPcuenta	= f.CPcuenta
						and Ocodigo		= f.Ocodigo
						and Mcodigo		= f.Mcodigo
					)
						, 0)
				as Aplicado#i#,
			<cfelse>
				<!--- null as Aplicado#i#, --->
                ' ' as Aplicado#i#,
			</cfif>
			<cfset LvarMes = LvarMes + 1>
			<cfif LvarMes GT 12>
				<cfset LvarMes = 1>
				<cfset LvarAno = LvarAno + 1>
			</cfif>
		</cfloop>
		<!--- null as nada --->
        ' ' as nada
		  from CPControlMoneda f
			inner join CPresupuesto c
				 on c.Ecodigo 	= f.Ecodigo
				and c.CPcuenta	= f.CPcuenta
			inner join CPCuentaPeriodo cp
				 on cp.Ecodigo 	= f.Ecodigo
				and cp.CPPid	= f.CPPid
				and cp.CPcuenta	= f.CPcuenta
			inner join Oficinas o
				 on o.Ecodigo	= f.Ecodigo
				and o.Ocodigo	= f.Ocodigo
			inner join Monedas m
				 on m.Ecodigo	= f.Ecodigo
				and m.Mcodigo	= f.Mcodigo
		 where f.Ecodigo 	= #session.ecodigo#
		   and f.CPPid		= #LvarCPPid#
		   <cf_CPSegUsu_setCFid value="#url.CFid#">
		   <cf_CPSegUsu_where Consultar="true" aliasCuentas="c" aliasOficina="f">
		 order by c.CPformato, o.Oficodigo, m.Miso4217, Ano, Mes
	</cfquery>
	<cfflush interval="512">
	<cfoutput><table></cfoutput>
	<cfoutput query="rsFormulacion">
		<tr>
			<td x:str>#trim(CPformato)#</td><td x:str>#trim(CPdescripcion)#</td><td>#CPCPtipoControl#</td><td>#CPCPcalculoControl#</td><td x:str>#trim(Oficodigo)#</td><td x:str>#Miso4217#</td><td>#Ano#</td><td>#Mes#</td><td>#Aplicado1#</td><td>#Aplicado2#</td><td>#Aplicado3#</td><td>#Aplicado4#</td><td>#Aplicado5#</td><td>#Aplicado6#</td><td>#Aplicado7#</td><td>#Aplicado8#</td><td>#Aplicado9#</td><td>#Aplicado10#</td><td>#Aplicado11#</td><td>#Aplicado12#</td>
		</tr>
	</cfoutput>
	<cfoutput></table></cfoutput>
<cfelseif isdefined("url.ExportacionReales")>
	<cfset LvarAno = datepart("yyyy",rsSQL.CPPfechaDesde)>
	<cfset LvarMes = datepart("m",rsSQL.CPPfechaDesde)>
	<cfset LvarAnoMesIni = LvarAno*100+LvarMes>

	<cfset LvarAnoMesFin = rsSQL.CPPanoMesHasta>

	<cfquery name="rsReales" datasource="#session.dsn#">
		select distinct c.CPformato, coalesce(c.CPdescripcionF,c.CPdescripcion) as CPdescripcion, cp.CPCPtipoControl, cp.CPCPcalculoControl, o.Oficodigo, m.Miso4217, #LvarAno# as Ano, #LvarMes# as Mes,
		<cfloop index="i" from="1" to="12">
			<!--- 
				Ejecutado Estimado por Moneda Origen:
				
				Si Formulado en moneda origen [FM] <> 0
					Formulado en moneda origen [FM] ====> Total Formulado Colones ([A]+[M]+[VC])
								   X                ====> Total Ejecutado Colones ([E]+[E2])
								   
					X ====> [FM] * ([E]+[E2]) / ([A]+[M]+[VC])

				sino

					X = ([E]+[E2]) / TipoCambioAplicado
				
			--->
			<cfif LvarAno*100+LvarMes LTE LvarAnoMesFin>
				coalesce(
				<cfif isdefined("form.chkEstimarMoneda")>
					(select 
						case 
							when (CPCMpresupuestado+CPCMmodificado) = (CPCpresupuestado + CPCmodificado + CPCvariacion)
								then (CPCejecutado+CPCejecutadoNC)
							when (CPCpresupuestado + CPCmodificado + CPCvariacion) <> 0 
								then (CPCejecutado+CPCejecutadoNC) * ((CPCMpresupuestado+CPCMmodificado) / (CPCpresupuestado + CPCmodificado + CPCvariacion))
							when (CPCMtipoCambioAplicado) <> 0 
								then (CPCejecutado+CPCejecutadoNC) / CPCMtipoCambioAplicado
							else 0
						end
					   from CPresupuestoControl ctl, CPControlMoneda mnd
					  where mnd.Ecodigo 	= f.Ecodigo
						and mnd.CPPid		= f.CPPid
						and mnd.CPCano		= #LvarAno#
						and mnd.CPCmes		= #LvarMes#
						and mnd.CPcuenta	= f.CPcuenta
						and mnd.Ocodigo		= f.Ocodigo
					    and mnd.Mcodigo		= f.Mcodigo
						and ctl.Ecodigo 	= mnd.Ecodigo
						and ctl.CPPid		= mnd.CPPid
						and ctl.CPCano		= mnd.CPCano
						and ctl.CPCmes		= mnd.CPCmes
						and ctl.CPcuenta	= mnd.CPcuenta
						and ctl.Ocodigo		= mnd.Ocodigo
					)
				<cfelse>
					(select (CPCejecutado+CPCejecutadoNC)
					   from CPresupuestoControl ctl
					  where ctl.Ecodigo 	= f.Ecodigo
						and ctl.CPPid		= f.CPPid
						and ctl.CPCano		= #LvarAno#
						and ctl.CPCmes		= #LvarMes#
						and ctl.CPcuenta	= f.CPcuenta
						and ctl.Ocodigo		= f.Ocodigo
					)
				</cfif>
						, 0)
				as Ejecutado#i#,
			<cfelse>
				0 as Ejecutado#i#,
			</cfif>
			<cfset LvarMes = LvarMes + 1>
			<cfif LvarMes GT 12>
				<cfset LvarMes = 1>
				<cfset LvarAno = LvarAno + 1>
			</cfif>
		</cfloop>
		<!--- null as nada --->
        ' ' as nada
		<cfif isdefined("form.chkEstimarMoneda")>
		  from CPControlMoneda f
		<cfelse>
		  from CPresupuestoControl f
		</cfif>
			inner join CPresupuesto c
				 on c.Ecodigo 	= f.Ecodigo
				and c.CPcuenta	= f.CPcuenta
			inner join CPCuentaPeriodo cp
				 on cp.Ecodigo 	= f.Ecodigo
				and cp.CPPid	= f.CPPid
				and cp.CPcuenta	= f.CPcuenta
			inner join Oficinas o
				 on o.Ecodigo	= f.Ecodigo
				and o.Ocodigo	= f.Ocodigo
		<cfif isdefined("form.chkEstimarMoneda")>
			inner join Monedas m
				 on m.Ecodigo	= f.Ecodigo
				and m.Mcodigo	= f.Mcodigo
		<cfelse>
			inner join Empresas ee
				inner join Monedas m
					 on m.Ecodigo	= ee.Ecodigo
					and m.Mcodigo	= ee.Mcodigo
				 on ee.Ecodigo	= f.Ecodigo
		</cfif>
		 where f.Ecodigo 	= #session.ecodigo#
		   and f.CPPid		= #LvarCPPid#
		   <cf_CPSegUsu_setCFid value="#url.CFid#">
		   <cf_CPSegUsu_where Consultar="true" aliasCuentas="c" aliasOficina="f">
		 order by c.CPformato, o.Oficodigo, m.Miso4217, Ano, Mes
	</cfquery>
	<cfflush interval="512">
	<cfoutput><table></cfoutput>
	<cfoutput query="rsReales">
		<tr>
			<td x:str>#trim(CPformato)#</td><td x:str>#trim(CPdescripcion)#</td><td>#CPCPtipoControl#</td><td>#CPCPcalculoControl#</td><td x:str>#trim(Oficodigo)#</td><td x:str>#Miso4217#</td><td>#Ano#</td><td>#Mes#</td><td>#Ejecutado1#</td><td>#Ejecutado2#</td><td>#Ejecutado3#</td><td>#Ejecutado4#</td><td>#Ejecutado5#</td><td>#Ejecutado6#</td><td>#Ejecutado7#</td><td>#Ejecutado8#</td><td>#Ejecutado9#</td><td>#Ejecutado10#</td><td>#Ejecutado11#</td><td>#Ejecutado12#</td>
		</tr>
	</cfoutput>
	<cfoutput></table></cfoutput>
</cfif>
<cfoutput>
	</body>
</html>
</cfoutput>

