<!---
	Creado por Martin S. Estevez
		Fecha: 09-06-2014.
	Situacion Financiera Detallada
 --->

<cfinvoke key="MSG_SitucionFDet"    default="Flujo de Efectivo por Actividades de Operaci&oacute;n (CONAC)"	returnvariable="MSG_SitucionFDet" component="sif.Componentes.Translate" method="Translate"/>
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

<cfinvoke key="LB_Concepto" 	default="Concepto"	returnvariable="LB_Concepto"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Caja" 		default="Caja"	returnvariable="LB_Caja"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_BAN" 		    default="Bancos Mexicanos"	returnvariable="LB_BAN"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ST" 		    default="SubTotal"	returnvariable="LB_ST"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_BAE" 		    default="Bancos Extranjeros"	returnvariable="LB_BAE"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_CHEQUEST"     default="Cheques en Transito"	returnvariable="LB_CHEQUEST"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SALDOINI" 	default="Saldo Inicial"	returnvariable="LB_SALDOINI"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SALDOFIN" 	default="Saldo Final"	returnvariable="LB_SALDOFIN"				component="sif.Componentes.Translate" method="Translate"/>
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

<cfoutput>
    <cfif isdefined("url.mes") and not isdefined("form.mes")>
        <cfparam name="form.mes" default="#url.mes#"></cfif>
    <cfif isdefined("url.Unidad") and not isdefined("form.Unidad")>
        <cfparam name="form.Unidad" default="#url.Unidad#"></cfif>
    <cfif isdefined("url.periodo") and not isdefined("form.periodo")>
        <cfparam name="form.periodo" default="#url.periodo#"></cfif>
    <cfif isdefined("url.mcodigoopt") and not isdefined("form.mcodigoopt")>
        <cfparam name="form.mcodigoopt" default="#url.mcodigoopt#"></cfif>
    <cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
        <cfparam name="form.Mcodigo" default="#url.Mcodigo#"></cfif>
    <cfif isdefined("url.formato") and not isdefined("form.formato")>
        <cfparam name="form.formato" default="#url.formato#"></cfif>
    <cfif isdefined("url.mensAcum") and not isdefined("form.mensAcum")>
        <cfparam name="form.mensAcum" default="#url.mensAcum#"></cfif>
    <cfif isdefined("url.disponibilidad") and not isdefined("form.disponibilidad")>
        <cfparam name="form.disponibilidad" default="#url.disponibilidad#"></cfif>
    <cfif isdefined("url.fluctuacion") and not isdefined("form.fluctuacion")>
        <cfparam name="form.fluctuacion" default="#url.fluctuacion#"></cfif>
    <cfif isdefined("url.cheque") and not isdefined("form.cheque")>
        <cfparam name="form.cheque" default="#url.cheque#"></cfif>
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

<cfif form.mensAcum EQ "2">
	<cfset LabelFechaFin = "Acumulado a " & Ucase(MonthAsString(form.mes,"Es")) & "-" & form.periodo>
<cfelse>
	<cfset LabelFechaFin = "Mensual " & Ucase(MonthAsString(form.mes,"Es")) & "-" & form.periodo>
</cfif>



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

<cfset LvarIrA = 'RepFlujoEfectivoActOpC.cfm'>
<cfset LvarFile = 'RepFlujoEfectivoActOpC'>
<cfset Request.LvarTitle = #MSG_SitucionFDet#>

<!---<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>
--->
<cfset rsAnoMes = #form.periodo#&"01">
<cfquery name="rsCPPid" datasource="#Session.DSN#">
	select CPPid from CPresupuestoPeriodo
    where Ecodigo=#Session.Ecodigo#
    	and #rsAnoMes# between CPPanoMesDesde and CPPanoMesHasta
</cfquery>
<cfif isdefined("form.botonsel") and len(trim(form.botonsel))>
    <cfoutput>
        <cfif rsCPPid.RecordCount eq 0>
            <cfset rsMensaje = "No se encuentran parametrizadas las cuentas de la contabilidad presupuestaria para el periodo &#form.mes# mes &#form.periodo#">
        </cfif>

        <cfif isdefined('rsMensaje')>
            <cflocation url="RepFlujoEfectivoActOpC.cfm?rsMensaje=#rsMensaje#">
        </cfif>

    </cfoutput>

    <cfquery name="rsNumEst" datasource="#session.dsn#">
	select top 1 r.ID_Estr, r.ID_Firma from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>



    <cfset permes = form.periodo>
    <cfset periodoAnt = form.periodo -1>
    <cfset permesAnt = (form.periodo - 1)>

    <cfset qBancosCaj = ArrayNew(1)>
    <cfset iniLoop = form.periodo/form.periodo>
    <cfset finLoop = form.periodo/form.periodo + 1>


        <cfinvoke returnvariable="rsArbol" component="sif.ep.componentes.EP_EstrGruposCmayor" method="CG_EstructuraGrupo">
                <cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
                <cfinvokeargument name="agrupaCmayor"	value="N">
                <cfinvokeargument name="incluyeCuentas"	value="S">
                <cfinvokeargument name="tipoCuenta"	value="presupuesto">
                <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
        </cfinvoke>


<cfquery name="rsUtilP" datasource="#session.dsn#">
	select * from #rsArbol#
	where upper(EPCPcodigoref) = upper('U')
</cfquery>
<!--- <cf_dump var="#rsUtilP#"> --->
<cfif rsUtilP.recordCount GT 0>
	<cfset ordenU = "#rsUtilP.Orden#/U">
	<cfquery name="insActivos" datasource="#session.dsn#">
		insert into #rsArbol#
		(EPGdescripcion,Nivel,Orden,Cuenta,ClasCta)
		Values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilP.EPGdescripcion#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilP.Nivel +1#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#ordenU#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#-100#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilP.ClasCta#"> )
	</cfquery>
</cfif>

<cfquery name="rsUtilP" datasource="#session.dsn#">
	select top 1 * from #rsArbol#
	where upper(EPCPcodigoref) = upper('CH')
</cfquery>
<cfset ordenU = "#rsUtilP.Orden#/CH">
<cfquery name="insActivos" datasource="#session.dsn#">
	insert into #rsArbol#
	(EPGdescripcion,Nivel,Orden,Cuenta,ClasCta)
	Values(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsUtilP.EPGdescripcion#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilP.Nivel +1#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ordenU#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#-200#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#rsUtilP.ClasCta#"> )
</cfquery>

<!--- <cfquery name="rsActivos" datasource="#session.dsn#">
	select * from #rsArbol#
</cfquery>
<cf_dump var="#rsActivos#"> --->



    <cfset qMeses = ArrayNew(1)>
    <cfset aCheques = ArrayNew(1)>
    <cfset menosPeriodo = 0>
	<cfloop from="#iniLoop#" to="#finLoop#" index="mesfin">
        <cfset mPeriodo = form.Periodo - menosPeriodo>
		<cfset idx = 1>
		<cfset cheque = "0">
		<cfloop from="1" to="#form.mes#" index="idxmes">
			<cfset fcheque = "ChequeI#idx#">
	        <cfset cheque=LSParseNumber(cheque) + LSParseNumber(form[fcheque])>
	        <cfset idx = idx + 1>
		</cfloop>
        <cfset arrayappend(aCheques ,LSParseNumber(cheque))>

            <cfinvoke returnvariable="rsSaldoMes" component="sif.ep.componentes.EP_EstrSaldosPr_FE" method="CG_EstructuraSaldo">
                    <cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
                    <cfinvokeargument name="PerInicio" 	value="#mPeriodo#">
                    <cfinvokeargument name="MesInicio" 	value="1">
                    <cfinvokeargument name="PerFin" 	value="#mPeriodo#">
                    <cfinvokeargument name="MesFin" 	value="#form.mes#">
                    <cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
                    <cfinvokeargument name="invertirSaldo" 	value="true">
                    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
                    <cfinvokeargument name="PerIniPP" 	value="#mPeriodo#">
                    <cfinvokeargument name="MesIniPP" 	value="1">
            </cfinvoke>

		<cfquery name="insUtilP" datasource="#session.dsn#">
			insert into #rsSaldoMes#
			(Ccuenta,CPCpagado)
			select -100, sum(UtilidadPerdida)
			from CGEstrProgFESaldos
			where Ecodigo = #session.Ecodigo#
				and EPSImes <= #form.mes#
				and EPSIano = #mPeriodo#
		</cfquery>

		<cfquery name="insUtilP" datasource="#session.dsn#">
			insert into #rsSaldoMes#
			(Ccuenta,CPCpagado)
			select -200, sum(ChequeTranIni - ChequeTranFin)
			from CGEstrProgFESaldos
			where Ecodigo = #session.Ecodigo#
				and EPSImes <= #form.mes#
				and EPSIano = #mPeriodo#
		</cfquery>

        <cfset menosPeriodo = menosPeriodo + 1>
		<cfset arrayappend(qMeses ,#rsSaldoMes#)>

    </cfloop>


    <cfsavecontent variable="content" >
        <cfoutput>
            select a.*,pcr.PCDvalor PCDvalorR, pcsr.PCDvalor PCDvalorSR,
			case
				when Nivel >= 3 then Orden
				when Nivel = 2 then Orden + '/A'
				when Nivel = 1 then Orden
				when Nivel = 0 then Orden + '/C'
				else Orden
			end OrdenInv
            from (
            select ar.ClasCta, ar.Cmayor, ar.Cuenta, ar.DescripcionCmayor,ar.EPGdescripcion, ar.EPCodigo,
            ar.Nivel,ar.EPCPcodigoref,ar.EPCPnota, ar.ID_Grupo,  ar.Orden,ar.PCDcatid,ar.PCDcatidH
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                ,saldo#i#.CPCpagado Saldo#i#
            </cfloop>
            from (select * from #rsArbol# where Nivel = 0) ar
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                left join (
                select left(ar.Orden,charindex('/',ar.Orden)-1)	 EPCodigo,
                sum(isnull(rs.CPCpagado/#varUnidad#,0.00)) CPCpagado
            from (select * from #rsArbol# where Nivel > 4) ar
            inner join #qMeses[i]# rs
            on ar.Cuenta = rs.Ccuenta
            group by left(ar.Orden,charindex('/',ar.Orden)-1)
            ) saldo#i#
                on ar.Orden = saldo#i#.EPCodigo
            </cfloop>
            union all
            select ar.ClasCta, ar.Cmayor, ar.Cuenta, ar.DescripcionCmayor,ar.EPGdescripcion, ar.EPCodigo,
            ar.Nivel,ar.EPCPcodigoref,ar.EPCPnota, ar.ID_Grupo,  ar.Orden,ar.PCDcatid,ar.PCDcatidH
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                ,saldo#i#.CPCpagado Saldo#i#
            </cfloop>
            from (select * from #rsArbol# where Nivel = 1) ar
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                left join (
                select left(ar.Orden,charindex('/',ar.Orden)+CHARINDEX('/',ar.Orden,(charindex('/',ar.Orden)+1))-charindex('/',ar.Orden)-1)	 EPCodigo,
                sum(isnull(rs.CPCpagado/#varUnidad#,0.00)) CPCpagado
            from (select * from #rsArbol# where Nivel > 4) ar
            inner join #qMeses[i]# rs
            on ar.Cuenta = rs.Ccuenta
            group by left(ar.Orden,charindex('/',ar.Orden)+CHARINDEX('/',ar.Orden,(charindex('/',ar.Orden)+1))-charindex('/',ar.Orden)-1)
            ) saldo#i#
                on ar.Orden = saldo#i#.EPCodigo
            </cfloop>
            union all
            select ar.ClasCta, ar.Cmayor, ar.Cuenta, ar.DescripcionCmayor,ar.EPGdescripcion, ar.EPCodigo,
            ar.Nivel,ar.EPCPcodigoref,ar.EPCPnota, ar.ID_Grupo,  ar.Orden,ar.PCDcatid,ar.PCDcatidH
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                <cfif form.mensAcum EQ "2" and i GT 1>
					,
                    <cfloop from="#i-1#" to="#1#" index="j" step="-1">
                        saldo#j#.CPCpagado +
                    </cfloop>
                    saldo#i#.CPCpagado
                <cfelse>
                    ,saldo#i#.CPCpagado
                </cfif>
                Saldo#i#
            </cfloop>
            from (select * from #rsArbol# where Nivel = 2) ar
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                left join (
                select substring(substring(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))),1,
                DATALENGTH(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))-CHARINDEX(REVERSE('/'),
                REVERSE(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden)))))),1,
                DATALENGTH(substring(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))),1,
                DATALENGTH(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))-CHARINDEX(REVERSE('/'),REVERSE(substring(ar.Orden,1,
                DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden)))))))-CHARINDEX(REVERSE('/'),REVERSE(substring(substring(ar.Orden,1,
                DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))),1,DATALENGTH(substring(ar.Orden,1,
                DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))-CHARINDEX(REVERSE('/'),REVERSE(substring(ar.Orden,1,
                DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))))))) EPCodigo,
                sum(isnull(rs.CPCpagado/#varUnidad#,0.00)) CPCpagado
            from (select * from #rsArbol# where Nivel > 4) ar
            inner join #qMeses[i]# rs
            on ar.Cuenta = rs.Ccuenta
            group by substring(substring(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))),1,
            DATALENGTH(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))-CHARINDEX(REVERSE('/'),
            REVERSE(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden)))))),1,
            DATALENGTH(substring(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))),1,
            DATALENGTH(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))-CHARINDEX(REVERSE('/'),REVERSE(substring(ar.Orden,1,
            DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden)))))))-CHARINDEX(REVERSE('/'),REVERSE(substring(substring(ar.Orden,1,
            DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))),1,DATALENGTH(substring(ar.Orden,1,
            DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))-CHARINDEX(REVERSE('/'),REVERSE(substring(ar.Orden,1,
            DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden)))))))))
            ) saldo#i#
                on ar.Orden = saldo#i#.EPCodigo
            </cfloop>
            union all
            select ar.ClasCta, ar.Cmayor, ar.Cuenta, ar.DescripcionCmayor,ar.EPGdescripcion, ar.EPCodigo,
            ar.Nivel,ar.EPCPcodigoref,ar.EPCPnota, ar.ID_Grupo,  ar.Orden,ar.PCDcatid,ar.PCDcatidH
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                ,  saldo#i#.CPCpagado Saldo#i#
            </cfloop>
            from (select * from #rsArbol# where Nivel = 3 and EPCPcodigoref <> 'X') ar
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                left join (
                select substring(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))),1,DATALENGTH(
                substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))-CHARINDEX(REVERSE('/'),REVERSE(substring(ar.Orden,1,DATALENGTH(
                ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden)))))) EPCodigo,sum(isnull(rs.CPCpagado/#varUnidad#,0.00)) CPCpagado
            from (select * from #rsArbol# where Nivel > 4) ar
            inner join #qMeses[i]# rs
            on ar.Cuenta = rs.Ccuenta
            group by substring(substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))),1,DATALENGTH(
            substring(ar.Orden,1,DATALENGTH(ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))-CHARINDEX(REVERSE('/'),REVERSE(substring(ar.Orden,1,DATALENGTH(
            ar.Orden)-CHARINDEX(REVERSE('/'),REVERSE(ar.Orden))))))
            ) saldo#i#
                on ar.Orden = saldo#i#.EPCodigo
            </cfloop>
            union all
            select ar.ClasCta, ar.Cmayor, ar.Cuenta, ar.DescripcionCmayor,ar.EPGdescripcion, ar.EPCodigo,
            ar.Nivel,ar.EPCPcodigoref,ar.EPCPnota, ar.ID_Grupo, ar.Orden,ar.PCDcatid,ar.PCDcatidH
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                ,saldo#i#.CPCpagado Saldo#i#
            </cfloop>
            from (select * from #rsArbol# where Nivel = 4 and EPCPcodigoref <> 'X') ar
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                left join (
                select ar.ClasCta,sum(isnull(rs.CPCpagado/#varUnidad#,0.00)) CPCpagado
            from (select * from #rsArbol# where Nivel > 4) ar
            inner join #qMeses[i]# rs
            on ar.Cuenta = rs.Ccuenta
            group by ar.ClasCta
            ) saldo#i#
                on ar.ClasCta = saldo#i#.ClasCta
            </cfloop>
            union all
            select ar.ClasCta, 0 Cmayor, 0 Cuenta, '' DescripcionCmayor,con.Cdescripcion as EPGdescripcion, min(ar.EPCodigo) EPCodigo,
            ar.Nivel,'' EPCPcodigoref,'' EPCPnota, 0 ID_Grupo, min(ar.Orden) Orden,ar.PCDcatid,ar.PCDcatidH
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                ,sum(saldo#i#.CPCpagado) Saldo#i#
            </cfloop>
            from (select * from #rsArbol# where Nivel > 4) ar
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                left join (
                select rs.Ccuenta,rs.PCDcatid,rs.PCDcatidH, rs.PCDdescripcionH,isnull(rs.CPCpagado/#varUnidad#,0.00) CPCpagado
            from #qMeses[i]# rs
            ) saldo#i#
                on ar.Cuenta = saldo#i#.Ccuenta
            </cfloop>
            left join PCDCatalogo pcr
            on ar.PCDcatid = pcr.PCDcatid
            left join PCDCatalogo pcsr
            on ar.PCDcatidH = pcsr.PCDcatid
            left join Conceptos con
            on con.Ccodigo = convert(varchar,coalesce(pcr.PCDvalor,'0')) + convert(varchar,coalesce(pcsr.PCDvalor,'0'))
            group by ar.ClasCta, ar.Nivel,con.Cdescripcion, ar.PCDcatid,ar.PCDcatidH
            ) a
            left join PCDCatalogo pcr
            on a.PCDcatid = pcr.PCDcatid
            left join PCDCatalogo pcsr
            on a.PCDcatidH = pcsr.PCDcatid
            left join Conceptos con
            on con.Ccodigo = convert(varchar,coalesce(pcr.PCDvalor,'0')) + convert(varchar,coalesce(pcsr.PCDvalor,'0'))
            order by OrdenInv, pcr.PCDvalor, pcsr.PCDvalor
        </cfoutput>
    </cfsavecontent>
<!--- a.Orden --->
    <cfquery name="rsActivos" datasource="#session.dsn#">
        <cfoutput>#preservesinglequotes(content)#</cfoutput>
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
                <table <cfif ArrayLen(qMeses) LT 4> width="70%" </cfif> align="center" cellpadding="0" cellspacing="0">
            <tr  bgcolor="##99CCFF">
    <td style="font-size:16px" align="center">
    <strong>#rsNombreEmpresa.Edescripcion#</strong>
    </td>
    </tr>
            <tr  bgcolor="##99CCFF">
    <td style="font-size:16px" align="center" >
    <strong>#MSG_SitucionFDet#</strong>
    </td>
    </tr>

            <tr  bgcolor="##99CCFF">
    <td style="font-size:16px" align="center" ><strong>(#MSG_Cifras_en# #rsMoneda.Mnombre#)</strong></td>
    </tr>
            <tr  bgcolor="##99CCFF">
    <td style="font-size:16px" align="center" ><strong>#LabelFechaFin#</strong></td>
    </tr>
    <tr>
    <td valign="top">
    <table border="0" width="100%" cellspacing="0">
    <tr>
    <td nowrap width="70%" align="left"><strong>#LB_Concepto#</strong></td>
        <cfset r = 0>
        <cfloop from="#iniLoop#" to="#finLoop#" index="i">
                <td nowrap align="center"><strong>#form.Periodo - r#</strong></td>
            <cfset r = 1>
        </cfloop>
        </tr>
        <tr>
                <td nowrap width="70%" align="center" colspan="#ArrayLen(qMeses) + 1#">
        <hr width="100%"/>
    </td>
    </tr>

        <cfset pintaL3 = true>
        <cfloop query="rsActivos">
            <cfif #NIVEL# LT 4>	<cfset pintaL3 = true> </cfif>
            <cfif (#NIVEL# LTE 4 and (#EPCPcodigoref# EQ 'N' or #EPCPcodigoref# EQ 'F')) or #NIVEL# GT 4>	<cfset pintaL3 = false> </cfif>
            <cfif #NIVEL# NEQ 5 or (#NIVEL# EQ 5 and #pintaL3#) or (form.chkCeros)>
                    <tr>
                            <td align="left" nowrap
                    <cfoutput>
                        <cfif #NIVEL# EQ 3 and #EPCPcodigoref# EQ 'N'>
                            <cfset tdmargin = (#NIVEL# + 1)*10>
                            <cfelse>
                            <cfset tdmargin = (#NIVEL#)*10>
                        </cfif>

                                style="padding-left:#tdmargin#px"
                    </cfoutput>
                    >
                    <cfif (#NIVEL# LT 3 and #ClasCta# LT 0) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S') ><strong></cfif>
                    <cfif form.chkCeros EQ "1" and #NIVEL# GT 2>#PCDvalorR#-#PCDvalorSR#</cfif>#EPGdescripcion#
                    <cfif (#NIVEL# LT 3 and #ClasCta# LT 0) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S')></strong></cfif>
                    </td>
                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                            <td nowrap align="right">
								<cfif (#NIVEL# NEQ 1 and #NIVEL# NEQ 3)>
		                            <cfset saldoMes= "Saldo#i#">
		                            <cfif (#NIVEL# LT 2) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S') ><strong></cfif>
		                            #LSNumberFormat(rsActivos[saldoMes][currentRow], '(),9.00')#
		                            <cfif (#NIVEL# LT 2) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S') ></strong></cfif>
		                        <cfelse>
		                        	&nbsp;
	                            </cfif>
							</td>
                    </cfloop>
                    </tr>
            </cfif>
        </cfloop>
            <tr >
                <td nowrap width="70%" align="left">&nbsp;</td>
                <td nowrap align="center">&nbsp;</td>
            </tr>
<!--- <tr>
 <td nowrap width="70%" align="center"><strong>Total Presupuesto de Egresos</strong></td>
 <td nowrap align="right"><strong>#LSNumberFormat(rsTPasivos.Saldo, ',9.00')#</strong></td>
</tr> --->

        </table>
        </td>
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
    <cfelse>
    <cfoutput>
        <form action="RepFlujoEfectivoActOpC.cfm" method="post" name="sql">
        <cfif isdefined("Form.periodo")>
                <input name="periodo" type="hidden" value="#Form.periodo#">
        </cfif>
        <cfif isdefined("Form.Unidad")>
                <input name="Unidad" type="hidden" value="#Form.Unidad#">
        </cfif>
        <cfif isdefined("Form.mes")>
                <input name="mes" type="hidden" value="#Form.mes#">
        </cfif>
        <cfif isdefined("Form.mensAcum")>
                <input name="mensAcum" type="hidden" value="#Form.mensAcum#">
        </cfif>
        </form>


        <html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
    </cfoutput>
</cfif>

<cffunction name="SumGrupos" returntype="numeric">
    <cfargument name="grupos" 	type="string" 	required="yes">
    <cfset result = 0>
    <cfquery name="rsSum" datasource="#session.dsn#">
			select isnull(sum(saldo.CPCpagado),0) Saldo
			from #rsArbol# ar
			left join (
				select ID_EstrCtaVal,isnull(CPCpagado/#varUnidad#,0.00) CPCpagado
				from #rsSaldoMes#
			) saldo
				on ar.ClasCta = saldo.ID_EstrCtaVal
			where ar.Nivel = 2
				and ar.EPCodigo in (#PreserveSingleQuotes(Arguments.grupos)#)
		</cfquery>
    <cfset result = rsSum.Saldo>
    <cfreturn result>
</cffunction>
