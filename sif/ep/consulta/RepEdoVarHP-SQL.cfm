<!---
	Creado por Martin S. Estevez
		Fecha: 09-06-2014.
	Situacion Financiera Detallada
 --->

<cfoutput>
<cfif isdefined("url.mes1") and not isdefined("form.mes1")>
	<cfparam name="form.mes1" default="#url.mes1#"></cfif>
<cfif isdefined("url.mes1") and not isdefined("form.mes1")>
	<cfparam name="form.mes1" default="#url.mes1#"></cfif>
<cfif isdefined("url.Unidad") and not isdefined("form.Unidad")>
	<cfparam name="form.Unidad" default="#url.Unidad#"></cfif>
<cfif isdefined("url.periodo1") and not isdefined("form.periodo1")>
	<cfparam name="form.periodo1" default="#url.periodo1#"></cfif>
<cfif isdefined("url.periodo1") and not isdefined("form.periodo1")>
	<cfparam name="form.periodo1" default="#url.periodo1#"></cfif>
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

<cfif form.periodo1 lt year(NOW())>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo1,#form.mes1#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes1 lt month(NOW())>
        <cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo1,#form.mes1#+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>

<cfinvoke key="MSG_SitucionFDet" default="Estado de Variaciones en la Hacienda Publica"	returnvariable="MSG_SitucionFDet"
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

<cfset LvarIrA = 'RepEdoVarHP.cfm'>
<cfset LvarFile = 'RepEdoVarHP'>
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
	<cflocation url="RepEdoVarHP.cfm?rsMensaje=#rsMensaje#">
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

<cfinvoke returnvariable="arrsSaldoMes" component="sif.ep.componentes.EP_EstrSaldosMesesAnt" method="SaldosAnteriores">
 <cfinvokeargument name="IDEstrPro" value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio"  value="#form.periodo1#">
    <cfinvokeargument name="MesInicio"  value="#form.mes1#">
    <cfinvokeargument name="PerFin"  value="#form.periodo1#">
    <cfinvokeargument name="MesFin"  value="#form.mes1#">
    <cfinvokeargument name="MonedaLoc"  value="#varMonlocal#">
    <cfinvokeargument name="PerIniPP"  value="#form.periodo1#">
    <cfinvokeargument name="MesIniPP"  value="#form.mes1#">
    <cfinvokeargument name="GvarConexion"  value="#session.dsn#">
 	<cfinvokeargument name="Mcodigo"   value="#varMcodigo#">
</cfinvoke>

<!--- todos lod datos --->
<cfquery name="rsDatos" datasource="#session.dsn#">
	select ar.EPCodigo,ar.EPGdescripcion,cast(ar.Orden as int) Orden, ag.[1]/#varUnidad# g1, ag.[2]/#varUnidad# g2, ag.[3]/#varUnidad# g3, ag.Total
		from #rsArbol# ar
		left join (
 			select cast(ID as varchar) ID, [1], [2], [3], isnull([1],0)+ isnull([2],0)+ isnull([3],0) as Total from (
 				SELECT cast(ID as int)ID,
				[1], [2], [3]
				FROM
				(
					select cast(cast(ID as int) as varchar) ID, Grupos, sum(saldo) saldo
					from (
						select right('00'+replace(left(Orden,2),'/',''),2)ID,right(replace(left(Orden,6),'/',''),1) Grupos,
							case
								when cast(right('00'+replace(left(Orden,2),'/',''),2) as int) = 1 then Saldo2
								when cast(right('00'+replace(left(Orden,2),'/',''),2) as int) in (2,3,4,5,6,7,8,9) then Saldo1
								else Saldo
							end saldo
						from (select ar.Orden, ar.Nivel, ar.Cmayor, isnull(sd.Saldo ,0) Saldo , isnull(sd1.Saldo ,0) Saldo1 , isnull(sd2.Saldo ,0) Saldo2
								from #rsArbol# ar
								left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[1]#) sd
									on ar.Cmayor = sd.Cmayor
								left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[2]#) sd1
									on ar.Cmayor = sd1.Cmayor
								left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[3]#) sd2
									on ar.Cmayor = sd2.Cmayor
							) a
 						where Nivel =2
 					) b
 					group by b.ID,b.Grupos
 				) AS SourceTable
				PIVOT
				(
					sum(saldo)
					FOR Grupos IN ([1], [2], [3])
				) AS PivotTable
			) a
		) ag
			on ar.EPCodigo = ag.ID
		where ar.Nivel = 0
	union all
	select EPCodigo,EPGdescripcion,cast(Orden as int) Orden,sum(g1) g1,sum(g2) g2,sum(g3) g3,sum(Total) Total from (
		select '110' EPCodigo,'Hacienda Publica/Patrimonio Neto Final del Ejercicio #form.periodo1 -1#' EPGdescripcion,'50' Orden, ag.[1]/#varUnidad# g1, ag.[2]/#varUnidad# g2, ag.[3]/#varUnidad# g3, ag.Total
			from #rsArbol# ar
			left join (
	 			select cast(ID as varchar) ID, [1], [2], [3], isnull([1],0)+ isnull([2],0)+ isnull([3],0) as Total from (
	 				SELECT cast(ID as int)ID,
					[1], [2], [3]
					FROM
					(
						select cast(cast(ID as int) as varchar) ID, Grupos, sum(saldo) saldo
						from (
							select right('00'+replace(left(Orden,2),'/',''),2)ID,right(replace(left(Orden,6),'/',''),1) Grupos,
								case
									when cast(right('00'+replace(left(Orden,2),'/',''),2) as int) = 1 then Saldo2
									when cast(right('00'+replace(left(Orden,2),'/',''),2) as int) in (2,3,4,5,6,7,8,9) then Saldo1
									else Saldo
								end saldo
							from (select ar.Orden, ar.Nivel, ar.Cmayor, isnull(sd.Saldo ,0) Saldo , isnull(sd1.Saldo ,0) Saldo1 , isnull(sd2.Saldo ,0) Saldo2
									from #rsArbol# ar
									left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[1]#) sd
										on ar.Cmayor = sd.Cmayor
									left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[2]#) sd1
										on ar.Cmayor = sd1.Cmayor
									left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[3]#) sd2
										on ar.Cmayor = sd2.Cmayor
								) a
	 						where Nivel =2
	 					) b
	 					group by b.ID,b.Grupos
	 				) AS SourceTable
					PIVOT
					(
						sum(saldo)
						FOR Grupos IN ([1], [2], [3])
					) AS PivotTable
				) a
			) ag
				on ar.EPCodigo = ag.ID
			where ar.Nivel = 0
				and ar.EPCodigo in ('1','2','3','4','5','6','7','8','9')
		) a
		group by EPCodigo,EPGdescripcion,Orden
		union all
		select EPCodigo,EPGdescripcion,cast(Orden as int) Orden,sum(g1) g1,sum(g2) g2,sum(g3) g3,sum(Total) Total from (
			select '200' EPCodigo,'Saldo Neto en la Hacienda Publica/Patrimonio #form.periodo1#' EPGdescripcion,'200' Orden, ag.[1]/#varUnidad# g1, ag.[2]/#varUnidad# g2, ag.[3]/#varUnidad# g3, ag.Total
				from #rsArbol# ar
				left join (
		 			select cast(ID as varchar) ID, [1], [2], [3], isnull([1],0)+ isnull([2],0)+ isnull([3],0) as Total from (
		 				SELECT cast(ID as int)ID,
						[1], [2], [3]
						FROM
						(
							select cast(cast(ID as int) as varchar) ID, Grupos, sum(saldo) saldo
							from (
								select right('00'+replace(left(Orden,2),'/',''),2)ID,right(replace(left(Orden,6),'/',''),1) Grupos,
									case
										when cast(right('00'+replace(left(Orden,2),'/',''),2) as int) = 1 then Saldo2
										when cast(right('00'+replace(left(Orden,2),'/',''),2) as int) in (2,3,4,5,6,7,8,9) then Saldo1
										else Saldo
									end saldo
								from (select ar.Orden, ar.Nivel, ar.Cmayor, isnull(sd.Saldo ,0) Saldo , isnull(sd1.Saldo ,0) Saldo1 , isnull(sd2.Saldo ,0) Saldo2
										from #rsArbol# ar
										left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[1]#) sd
											on ar.Cmayor = sd.Cmayor
										left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[2]#) sd1
											on ar.Cmayor = sd1.Cmayor
										left join (select Cmayor,DLdebitos - CLcreditos as Saldo from #arrsSaldoMes[3]#) sd2
											on ar.Cmayor = sd2.Cmayor
									) a
		 						where Nivel =2
		 					) b
		 					group by b.ID,b.Grupos
		 				) AS SourceTable
						PIVOT
						(
							sum(saldo)
							FOR Grupos IN ([1], [2], [3])
						) AS PivotTable
					) a
				) ag
					on ar.EPCodigo = ag.ID
				where ar.Nivel = 0
		) a
		group by EPCodigo,EPGdescripcion,Orden
		order by Orden
</cfquery>
<!--- <cf_dump var="#rsDatos#"> --->


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
					 AL #LabelFechaInicio#
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
						<tr style="background-color:lightgray;">
						  <td width="40%" align="left" valign="bottom"><strong>#LB_Concepto#</strong></td>
						  <td width="15%" align="left"><strong>Hacienda Publica / Patrimonio Contribuido</strong></td>
						  <td width="15%" align="left"><strong>Hacienda Publica / Patrimonio Generado de Ejercicios Anteriores</strong></td>
						  <td width="15%" align="left"><strong>Hacienda Publica / Patrimonio Generado del Ejercicio</strong></td>
						  <td width="15%" align="left"><strong>Ajustes por Cambio de Valor</strong></td>
						  <td width="15%" align="left"><strong>Total</strong></td>
					  	</tr>
			            <cfloop query="rsDatos">
							 <tr>
						    	<td align="left"><strong>#EPGdescripcion#</strong></td>
						        <td nowrap align="right">#LSNumberFormat(rsDatos.g1, ',9.00')#</td>
						        <td nowrap align="right">#LSNumberFormat(rsDatos.g2, ',9.00')#</td>
						        <td nowrap align="right">#LSNumberFormat(rsDatos.g3, ',9.00')#</td>
						        <td nowrap align="right">&nbsp;</td>
						        <td nowrap align="right">#LSNumberFormat(rsDatos.Total, ',9.00')#</td>
						     </tr>
						</cfloop>
						<!--- <tr>
							<td align="center"><strong>#LB_Total#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TSaldoInicial, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TDLdebitos, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TCLcreditos, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TSaldoFinal, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.TFlujo, ',9.00')#</strong></td>
						</tr> --->
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
