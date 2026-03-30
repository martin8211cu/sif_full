<!---
	Creado por Martin S. Estevez
		Fecha: 09-06-2014.
	Situacion Financiera Detallada
 --->

<cfoutput>
<cfif isdefined("url.mes1") and not isdefined("form.mes1")>
	<cfparam name="form.mes1" default="#url.mes1#"></cfif>
<cfif isdefined("url.mes2") and not isdefined("form.mes2")>
	<cfparam name="form.mes2" default="#url.mes2#"></cfif>
<cfif isdefined("url.Unidad") and not isdefined("form.Unidad")>
	<cfparam name="form.Unidad" default="#url.Unidad#"></cfif>
<cfif isdefined("url.periodo1") and not isdefined("form.periodo1")>
	<cfparam name="form.periodo1" default="#url.periodo1#"></cfif>
<cfif isdefined("url.periodo2") and not isdefined("form.periodo2")>
	<cfparam name="form.periodo2" default="#url.periodo2#"></cfif>
<cfif isdefined("url.mcodigoopt") and not isdefined("form.mcodigoopt")>
	<cfparam name="form.mcodigoopt" default="#url.mcodigoopt#"></cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfparam name="form.Mcodigo" default="#url.Mcodigo#"></cfif>
<cfif isdefined("url.formato") and not isdefined("form.formato")>
	<cfparam name="form.formato" default="#url.formato#"></cfif>
<cfif isdefined("url.mensAcum") and not isdefined("form.mensAcum")>
	<cfparam name="form.mensAcum" default="#url.mensAcum#"></cfif>
<cfif isdefined("url.chkCeros")>
	<cfparam name="form.chkCeros" default="1">
<cfelse>
   	<cfparam name="form.chkCeros" default="0">
</cfif>
<cfif isdefined("url.PrIngAprob") and not isdefined("form.PrIngAprob")>
	<cfparam name="form.PrIngAprob" type="numeric" default="#url.PrIngAprob#"></cfif>
<cfif isdefined("url.PrIngModif") and not isdefined("form.PrIngModif")>
	<cfparam name="form.PrIngModif" type="numeric" default="#url.PrIngModif#"></cfif>
</cfoutput>
<!--- <cf_dump var="#form#"> --->
<cfif form.periodo1 lt year(NOW())>
	<cfset LabelFechaInicio = #DateFormat(CreateDate(form.periodo1,#form.mes1#,01),"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes1 lt month(NOW())>
        <cfset LabelFechaInicio = #DateFormat(CreateDate(form.periodo1,#form.mes1#,01),"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaInicio = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>

<cfif form.periodo2 lt year(NOW())>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo2,#form.mes2#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes2 lt month(NOW())>
        <cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo2,#form.mes2#+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>

<cfinvoke key="MSG_SitucionFDet" default="Estado Analítico del Activo"	returnvariable="MSG_SitucionFDet"
component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfif #form.Unidad# eq 1>
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en"				returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1>
<cfelseif #form.Unidad# eq 2>
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en miles de"	returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1000>
<cfelseif #form.Unidad# eq 3>
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en millones de"	returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 100000>
</cfif>

<cfinvoke key="LB_Concepto" 		default="Concepto"	returnvariable="LB_Concepto"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total" 		default="Total"	returnvariable="LB_Total"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Descripcion" default="Descripci&oacute;n"		returnvariable="MSG_Descripcion"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Momentos" 	default="Momentos contables del ingreso"	returnvariable="MSG_Momentos"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Propuesto" 	default="Presupuesto de Ingresos"			returnvariable="MSG_Propuesto"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Aprobado" 	default="Aprobado"			returnvariable="MSG_Aprobado"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Recibir" 	default="por Recibir"		returnvariable="MSG_Recibir"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Modificado" 	default="Modificado"		returnvariable="MSG_Modificado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Periodo" 	default="Periodo"			returnvariable="MSG_Periodo"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Devengado" 	default="Devengado"			returnvariable="MSG_Devengado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Cobrado" 	default="Cobrado"			returnvariable="MSG_Cobrado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Avance" 		default="Avance de cobro"	returnvariable="MSG_Avance"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_CobrApr" 	default="(cobrado/aprobado)"	returnvariable="MSG_CobrApr"		component="sif.Componentes.Translate" method="Translate"/>

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
    select e.Edescripcion,e.Mcodigo,cliente_empresarial
    from Empresas e
    where e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfquery name="rsAliasEmpresa" datasource="asp">
    select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = #rsNombreEmpresa.cliente_empresarial#
</cfquery>

<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select
        case Mnombre
        when 'Mexico, Peso' then 'Pesos'
        else Mnombre
	end as Mnombre
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #rsNombreEmpresa.Mcodigo#
</cfquery>

<cfif isdefined("form.mcodigoopt") and form.mcodigoopt EQ "0">
	<cfset varMcodigo = form.Mcodigo>
    <cfset varMonlocal= "false">
<cfelse>
	<cfset varMcodigo = #rsNombreEmpresa.Mcodigo#>
    <cfset varMonlocal= "true">
</cfif>

<cfset LvarIrA = 'RepSitFinD.cfm'>
<cfset LvarFile = 'RepSitFinD'>
<cfset Request.LvarTitle = #MSG_SitucionFDet#>

<!---<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>
--->
<cfset rsAnoMes = #form.periodo1#&left("0"&#form.mes1#,2)>
<cfquery name="rsCPPid" datasource="#Session.DSN#">
	select CPPid from CPresupuestoPeriodo
    where Ecodigo=#Session.Ecodigo#
    	and #rsAnoMes# between CPPanoMesDesde and CPPanoMesHasta
</cfquery>
<cfoutput>
<cfif rsCPPid.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuentas de la contabilidad presupuestaria para el periodo &#form.mes# mes &#form.periodo#">
<!--- <cfelse>
    <cfquery name="rsCuentas" datasource="#Session.DSN#">
        select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where (m.CPTMtipoMov in ('D','A','M','VC','E','P') or m.CPTMtipoMov in ('T1','T6','T7'))
                    and Cmayor <> 'NULL'
            order by c.Cmayor
    </cfquery>
<!---Verificación de las cuentas de mayor entre la estructura programática y la parametrización de la contabilidad presupuestaria--->
    <cfloop query="rsCuentas">
        <cfquery name="rsVerifCuentas" datasource="#Session.DSN#">
            select m.CGEPCtaMayor,r.SPcodigo
            from dbo.CGEstrProgCtaM m
            inner join CGEstrProg ep
            on ep.ID_Estr=m.ID_Estr
			inner join CGReEstrProg r
            on r.ID_Estr=ep.ID_Estr
            where r.SPcodigo='#session.menues.SPCODIGO#'

            and m.CGEPCtaMayor = #rsCuentas.Cmayor#
        </cfquery>
        <cfif rsVerifCuentas.RecordCount eq 0>
            <cfset rsMensaje = "No se encuentran parametrizadas en la estructura programática las cuentas de la contabilidad presupuestaria">
        </cfif>
    </cfloop> --->
</cfif>

<cfif isdefined('rsMensaje')>
	<cflocation url="RepSitFinD.cfm?rsMensaje=#rsMensaje#">
</cfif>

</cfoutput>

<cfquery name="rsNumEst" datasource="#session.dsn#">
	select top 1 r.ID_Estr, r.ID_Firma from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>


<cfset permes1 = form.periodo1 * 100 + form.mes1>
<cfset periodoAnt = form.periodo1 -1>
<cfset permesAnt = (form.periodo1 - 1) * 100 + form.mes1>


<cfinvoke returnvariable="rsArbol" component="sif.ep.componentes.EP_EstrGruposCmayor" method="CG_EstructuraGrupo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
	<cfinvokeargument name="incluyeCuentas"	value="N">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke>

<cfinvoke returnvariable="rsSaldoMes" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#form.periodo1#">
    <cfinvokeargument name="MesInicio" 	value="1">
    <cfinvokeargument name="PerFin" 	value="#form.periodo1#">
    <cfinvokeargument name="MesFin" 	value="1">
    <cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke>

<cfinvoke returnvariable="rsSaldoMesAnt" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#form.periodo1#">
    <cfinvokeargument name="MesInicio" 	value="#form.mes1#">
    <cfinvokeargument name="PerFin" 	value="#form.periodo2#">
    <cfinvokeargument name="MesFin" 	value="#form.mes2#">
    <cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke>


<!--- Inicio Neteo entre cuentas --->
<cfset saldo1122 = 0>
<cfset saldo2112 = 0>
<cfset saldo1122Ant = 0>
<cfset saldo2112Ant = 0>

<!--- solo para comercio internacional --->
<cfif trim(rsAliasEmpresa.CEaliaslogin) EQ trim("pmi")>
	<cfquery name="rs1122" datasource="#session.dsn#">
		select isnull(sum(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.DLdebitos - saldoAnt.CLcreditos),0) Saldo
		from (
			select Cmayor, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
			from #rsSaldoMesAnt# sda
			where Cformato like '1122-0001-0002%'
			group by Cmayor
		) saldoAnt
	</cfquery>

	<cfquery name="rs2112" datasource="#session.dsn#">
		select isnull(sum(<cfif #form.mensAcum# eq 2> saldo.SLinicial + </cfif>saldo.DLdebitos - saldo.CLcreditos),0) Saldo
		from (
			select Cmayor, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
			from #rsSaldoMesAnt#
			where Cformato like '2112-0001-0002%'
			group by Cmayor
		) saldo
	</cfquery>

	<cfset difSaldo = rs1122.Saldo - rs2112.Saldo>

	<cfif difSaldo lt 0>
		<cfset saldo2112 = difSaldo - rs2112.Saldo>
	<cfelse>
		<cfset saldo1122 = difSaldo - rs1122.Saldo>
	</cfif>

</cfif>
<!--- fin neteo --->

<cfquery name="rsActivos" datasource="#session.dsn#">
	select
		ar.Cmayor, ar.EPCodigo, ar.EPGdescripcion, ar.Nivel, ar.Orden, ar.DescripcionCmayor,
		saldo.SLinicial/#varUnidad# SaldoInicial,
		isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.DLdebitos + saldoNeteo.saldoD,0)/#varUnidad# DLdebitos,
		isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.CLcreditos + saldoNeteo.saldoC,0)/#varUnidad# CLcreditos,
		saldo.SLinicial/#varUnidad# + isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.DLdebitos + saldoNeteo.saldoD,0)/#varUnidad#
			- isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.CLcreditos + saldoNeteo.saldoC,0)/#varUnidad# SaldoFinal,
		saldo.SLinicial/#varUnidad# + isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.DLdebitos + saldoNeteo.saldoD,0)/#varUnidad#
			- isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.CLcreditos + saldoNeteo.saldoC,0)/#varUnidad# - saldo.SLinicial/#varUnidad# Flujo
	from #rsArbol# ar
	left join (
		select Cmayor, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
		from #rsSaldoMes# sd
		group by Cmayor
	) saldo
		on ar.Cmayor = saldo.Cmayor
	left join (
		select Cmayor, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
		from #rsSaldoMesAnt# sda
		group by Cmayor
	) saldoAnt
		on ar.Cmayor = saldoAnt.Cmayor
	left join (
		select 1122 Cmayor, #saldo1122# saldoD, #saldo2112# saldoC
	) saldoNeteo
		on ar.Cmayor = saldoNeteo.Cmayor
</cfquery>

<cfquery name="rsTActivos" datasource="#session.dsn#">
	select
		isnull(sum(saldo.SLinicial),0)/#varUnidad# TSaldoInicial,
		isnull(sum(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.DLdebitos + saldoNeteo.saldoD),0)/#varUnidad#  TDLdebitos,
		isnull(sum(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.CLcreditos + saldoNeteo.saldoC),0)/#varUnidad#  TCLcreditos,
		isnull(sum(saldo.SLinicial + isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.DLdebitos,0)
			- isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.CLcreditos,0) + saldoNeteo.saldoD + saldoNeteo.saldoC),0)/#varUnidad#  TSaldoFinal,
		isnull(sum(saldo.SLinicial + isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.DLdebitos,0)
			- isnull(<cfif #form.mensAcum# eq 2> saldoAnt.SLinicial + </cfif>saldoAnt.CLcreditos,0) - saldo.SLinicial + saldoNeteo.saldoD + saldoNeteo.saldoC),0)/#varUnidad#  TFlujo
	from #rsArbol# ar
	left join (
		select Cmayor, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
		from #rsSaldoMes# sd
		group by Cmayor
	) saldo
		on ar.Cmayor = saldo.Cmayor
	left join (
		select Cmayor, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
		from #rsSaldoMesAnt# sda
		group by Cmayor
	) saldoAnt
		on ar.Cmayor = saldoAnt.Cmayor
	left join (
		select 1122 Cmayor, #saldo1122# saldoD, #saldo2112# saldoC
	) saldoNeteo
		on ar.Cmayor = saldoNeteo.Cmayor
</cfquery>

    <cfoutput>
        <cf_htmlreportsheaders
            title="#request.LvarTitle#"
            filename="#LvarFile#-#Session.Usucodigo#.xls"
            ira="#LvarIrA#">
        <cfif not isdefined("btnDownload")>
            <cf_templatecss>
        </cfif>
    </cfoutput>
    <cfflush interval="20">
    <cfoutput>
		<style type="text/css" >
            .corte {
                font-weight:bold;
            }
        </style>
        <table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
            <tr>
                <td style="font-size:16px" align="center" colspan="6">
                <strong>#rsNombreEmpresa.Edescripcion#</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" >
                    <strong>#MSG_SitucionFDet#</strong>
                </td>
            </tr>

            <tr>
                <td style="font-size:16px" align="center" nowrap="nowrap">
                	<strong>
					 Del #LabelFechaInicio# al #LabelFechaFin#
						<cfif #form.mensAcum# eq 1>
						   (Mensual)
						<cfelse>
							(Acumulado)
						</cfif>
					</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" ><strong>(#MSG_Cifras_en# #rsMoneda.Mnombre#)</strong></td>
            </tr>
        </table>
		<table width="100%" border="0">
			<tr>
            	<td valign="top">
					<table width="100%" border="0" cellspacing="0">
						<tr style="background-color:lightblue;">
						  <td width="40%" align="center"><strong>#LB_Concepto#</strong></td>
						  <td width="15%" align="center"><strong>Saldo Inicial</strong></td>
						  <td width="15%" align="center"><strong>Cargos del Periodo</strong></td>
						  <td width="15%" align="center"><strong>Abonos del Periodo</strong></td>
						  <td width="15%" align="center"><strong>Saldo Final</strong></td>
						  <td width="15%" align="center"><strong>Flujo del Periodo</strong></td>
					  	</tr>
			            <cfloop query="rsActivos">
							 <cfif #NIVEL# EQ 0>
							        <tr>
						            	<td align="left"><strong><cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#</strong></td>
						                <td colspan="2">&nbsp;</td>
						            </tr>
							  <cfelse>
							  	<cfif #Cmayor# EQ "">
							         <tr>
						            	<td align="left"
							            	<cfoutput>
								            	<cfset tdmargin = #NIVEL#*10>
												style="padding-left:#tdmargin#px"
											</cfoutput>
										>
							            	<cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#
										</td>
						                <td colspan="2">&nbsp;</td>
						            </tr>
						        <cfelse>
									<tr>
						            	<td align="left"
							            	<cfoutput>
								            	<cfset tdmargin = #NIVEL#*10>
												style="padding-left:#tdmargin#px"
											</cfoutput>
										>
							            	<cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#
										</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivos.SaldoInicial, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivos.DLdebitos, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivos.CLcreditos, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivos.SaldoFinal, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivos.Flujo, ',9.00')#</td>
						            </tr>
						        </cfif>
							 </cfif>
						</cfloop>
						<tr>
							<td align="center"><strong>#LB_Total#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TSaldoInicial, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TDLdebitos, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TCLcreditos, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TSaldoFinal, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TFlujo, ',9.00')#</strong></td>
						</tr>
			        </table>
				</td>
            </tr>

			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
		</table>
		<table width="100%" cellpadding="0" cellspacing="0" >
            <tr>
                <td style="font-size:16px" align="center" colspan="6">
					<cfset idFirma = 0>
					<cfif rsNumEst.ID_Firma NEQ "">
						<cfset idFirma=rsNumEst.ID_Firma>
	                	<cfinvoke component="sif.ep.componentes.EP_Firmas" method="RP_PieFirma">
								<cfinvokeargument name="IdFirma"	value="#idFirma#">
							    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
						</cfinvoke>
					</cfif>
				</td>
            </tr>
         </table>
    </cfoutput>
