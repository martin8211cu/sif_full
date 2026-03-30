<!---
	Creado por Martin S. Estevez
		Fecha: 09-06-2014.
	Situacion Financiera Detallada
 --->

<cfinvoke key="MSG_SitucionFDet"    default="Flujo de Efectivo Acumulado"	returnvariable="MSG_SitucionFDet" component="sif.Componentes.Translate" method="Translate"/>
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
<cfinvoke key="LB_CHEQUEST"     default="Cheques en Tr&aacute;nsito"	returnvariable="LB_CHEQUEST"				component="sif.Componentes.Translate" method="Translate"/>
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
<!--- <cfif isdefined("url.chkCeros")>
	<cfparam name="form.chkCeros" default="1">
<cfelse>
   	<cfparam name="form.chkCeros" default="0">
</cfif> --->
<cfif isdefined("url.PrIngAprob") and not isdefined("form.PrIngAprob")>
	<cfparam name="form.PrIngAprob" type="numeric" default="#url.PrIngAprob#"></cfif>
<cfif isdefined("url.PrIngModif") and not isdefined("form.PrIngModif")>
	<cfparam name="form.PrIngModif" type="numeric" default="#url.PrIngModif#"></cfif>
</cfoutput>

<!--- <cf_dump var="#form#">--->
<cfset LabelFechaFin = Ucase(MonthAsString(form.mes,"Es")) & "-" & form.periodo>


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

<cfset LvarIrA = 'RepFlujoEfectivoAcum.cfm'>
<cfset LvarFile = 'RepFlujoEfectivoAcum'>
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
	<cflocation url="RepFlujoEfectivoAcum.cfm?rsMensaje=#rsMensaje#">
</cfif>

</cfoutput>

<cfquery name="rsNumEst" datasource="#session.dsn#">
	select top 1 r.ID_Estr, r.ID_Firma from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>



<cfset permes = form.periodo>
<cfset periodoAnt = form.periodo -1>
<cfset permesAnt = (form.periodo - 1)>

<cfset qBancosCaj = ArrayNew(1)>
<cfset iniLoop = form.mes>
<cfset finLoop = form.mes>
<cfif form.mensAcum EQ "2">
    <cfset iniLoop = 1>
</cfif>

<!---    Saldos Iniciales de Bancos y Caja--->
<cfloop from="#iniLoop#" to="#finLoop#" index="mesfin">
    <cfquery name="rsBanosCaj" datasource="#session.dsn#">
            select Bancos.Speriodo,Bancos.Smes,Bancos.SaldoBn/#varUnidad# SaldoBn,Bancos.SaldoBe/#varUnidad# SaldoBe,Caja.SaldoCaja/#varUnidad# SaldoCaja
            from (
                select #form.periodo# AS Speriodo, #mesfin# as Smes, [1] as SaldoBn,[2] as SaldoBe
                from (
						select 1 Mcodigo, sum(c.SLinicial) Saldo
						from SaldosContables c
						inner join CContables con
							on con.Ccuenta = c.Ccuenta
							and c.Speriodo = #form.periodo#
							and c.Smes = #mesfin#
							and (con.Cformato like '1112-0001'  --<!-- Paraetrizar Cuenta Banco Nacionales -->
								or con.Cformato like '1112-0002-0002-0002' -- <!-- Incluyendo Bancomer -->
								or con.Cformato like '1114-0001') -- <!-- Incluyendo Inversiones Temporales -->
						union all
						select 2 Mcodigo, sum(c.SLinicial) - (
																select sum(c.SLinicial)
																from SaldosContables c
																inner join CContables con
																	on con.Ccuenta = c.Ccuenta
																	and c.Speriodo = #form.periodo#
																	and c.Smes = #mesfin#
																	and con.Cformato = '1112-0002-0002-0002' -- <!-- Excluyendo Bancomer -->
															)
						from SaldosContables c
						inner join CContables con
							on con.Ccuenta = c.Ccuenta
							and c.Speriodo = #form.periodo#
							and c.Smes = #mesfin#
							and ((con.Cformato like '1112-0002'  --<!-- Paraetrizar Cuenta Banco Extranjeros -->
								and con.Cformato <> '1112-0002-0002-0002') -- <!-- Excluyendo Bancomer -->
								or con.Cformato like '1114-0002-0002') -- <!-- Incluyendo Inversiones Moneda Extranjera corto plazo -->
				) AS SourceTable
                PIVOT
                (
                Sum(Saldo)
                FOR Mcodigo IN ([0], [1], [2], [3], [4])
                ) AS PivotTable
            ) Bancos
            inner join (
                select c.Speriodo,c.Smes,sum(isnull(c.SLinicial,0)) SaldoCaja
                from CFinanciera cf
                inner join SaldosContables c
                    on c.Ccuenta = cf.Ccuenta
                where c.Speriodo = #form.periodo#
                    and c.Smes = #mesfin#
                    and cf.CFformato like '1115-0002%' --<!--- Parametrizar Cajas --->
                group by c.Speriodo,c.Smes
            ) Caja
                on Bancos.Speriodo = Caja.Speriodo
                and Bancos.Smes = Caja.Smes
    </cfquery>
	<cfif rsBanosCaj.RecordCount EQ 0>
		<cfset temp = QueryAddRow(rsBanosCaj)>
		<cfset Temp = QuerySetCell(rsBanosCaj, "Speriodo", form.periodo)>
		<cfset Temp = QuerySetCell(rsBanosCaj, "Smes", mesfin)>
		<cfset Temp = QuerySetCell(rsBanosCaj, "SaldoBn", 0)>
		<cfset Temp = QuerySetCell(rsBanosCaj, "SaldoBe", 0)>
		<cfset Temp = QuerySetCell(rsBanosCaj, "SaldoCaja", 0)>

	</cfif>
	<cfset arrayappend(qBancosCaj ,#rsBanosCaj#)>
</cfloop>

<cfset qBancosCajF = ArrayNew(1)>
<!---    Saldos Finales de Bancos y Caja--->
<cfloop from="#iniLoop#" to="#finLoop#" index="mesfin">
    <cfquery name="rsBanosCajF" datasource="#session.dsn#">
            select Bancos.Speriodo,Bancos.Smes,Bancos.SaldoBn/#varUnidad# SaldoBn,Bancos.SaldoBe/#varUnidad# SaldoBe,Caja.SaldoCaja/#varUnidad# SaldoCaja
            from (
                select #form.periodo# AS Speriodo, #mesfin# as Smes, [1] as SaldoBn,[2] as SaldoBe
                from (
						select 1 Mcodigo, sum(isnull(c.SLinicial,0)+isnull(c.DLdebitos,0)-isnull(c.CLcreditos,0)) Saldo
						from SaldosContables c
						inner join CContables con
							on con.Ccuenta = c.Ccuenta
							and c.Speriodo = #form.periodo#
							and c.Smes = #mesfin#
							and (con.Cformato like '1112-0001'  --<!-- Paraetrizar Cuenta Banco Nacionales -->
								or con.Cformato like '1112-0002-0002-0002' -- <!-- Incluyendo Bancomer -->
								or con.Cformato like '1114-0001') -- <!-- Incluyendo Inversiones Temporales -->
						union all
						select 2 Mcodigo, sum(isnull(c.SLinicial,0)+isnull(c.DLdebitos,0)-isnull(c.CLcreditos,0)) - (
																select sum(isnull(c.SLinicial,0)+isnull(c.DLdebitos,0)-isnull(c.CLcreditos,0))
																from SaldosContables c
																inner join CContables con
																	on con.Ccuenta = c.Ccuenta
																	and c.Speriodo = #form.periodo#
																	and c.Smes = #mesfin#
																	and con.Cformato = '1112-0002-0002-0002' -- <!-- Excluyendo Bancomer -->
															)
						from SaldosContables c
						inner join CContables con
							on con.Ccuenta = c.Ccuenta
							and c.Speriodo = #form.periodo#
							and c.Smes = #mesfin#
							and ((con.Cformato like '1112-0002'  --<!-- Paraetrizar Cuenta Banco Extranjeros -->
								and con.Cformato <> '1112-0002-0002-0002') -- <!-- Excluyendo Bancomer -->
								or con.Cformato like '1114-0002-0002') -- <!-- Incluyendo Inversiones Moneda Extranjera corto plazo -->
				) AS SourceTable
                PIVOT
                (
                Sum(Saldo)
                FOR Mcodigo IN ([0], [1], [2], [3], [4])
                ) AS PivotTable
            ) Bancos
            inner join (
                select c.Speriodo,c.Smes,sum(isnull(c.SLinicial,0)+isnull(c.DLdebitos,0)-isnull(c.CLcreditos,0)) SaldoCaja
                from CFinanciera cf
                inner join SaldosContables c
                    on c.Ccuenta = cf.Ccuenta
                where c.Speriodo = #form.periodo#
                    and c.Smes = #mesfin#
                    and cf.CFformato like '1115-0002%' <!--- Parametrizar Cajas --->
                group by c.Speriodo,c.Smes
            ) Caja
                on Bancos.Speriodo = Caja.Speriodo
                and Bancos.Smes = Caja.Smes
    </cfquery>
	<cfif rsBanosCajF.RecordCount EQ 0>
		<cfset temp = QueryAddRow(rsBanosCajF)>
		<cfset Temp = QuerySetCell(rsBanosCajF, "Speriodo", form.periodo)>
		<cfset Temp = QuerySetCell(rsBanosCajF, "Smes", mesfin)>
		<cfset Temp = QuerySetCell(rsBanosCajF, "SaldoBn", 0)>
		<cfset Temp = QuerySetCell(rsBanosCajF, "SaldoBe", 0)>
		<cfset Temp = QuerySetCell(rsBanosCajF, "SaldoCaja", 0)>

	</cfif>
	<cfset arrayappend(qBancosCajF ,#rsBanosCajF#)>
</cfloop>

<cfinvoke returnvariable="rsArbol" component="sif.ep.componentes.EP_EstrGruposCmayor" method="CG_EstructuraGrupo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
	<cfinvokeargument name="agrupaCmayor"	value="N">
	<cfinvokeargument name="incluyeCuentas"	value="S">
	<cfinvokeargument name="tipoCuenta"	value="presupuesto">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke>

<cfquery name="rsUtilP" datasource="#session.dsn#">
	select top 1 * from #rsArbol#
	where upper(EPCPcodigoref) = upper('U')
</cfquery>
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

<!--- <cfquery name="rsActivos" datasource="#session.dsn#">
	select * from #rsArbol#
	--where upper(EPCPcodigoref) = upper('U')
</cfquery>
<cf_dump var="#rsActivos#"> --->

<!---<cfset mesfin = 12>--->
<cfset iniLoop = form.mes>
<cfset finLoop = form.mes>
<cfif form.mensAcum EQ "2">
    <cfset iniLoop = 1>
</cfif>


<cfset qMeses = ArrayNew(1)>
<cfset idx = 1>
<cfloop from="#iniLoop#" to="#finLoop#" index="mesfin">
    <cfinvoke returnvariable="rsSaldoMes" component="sif.ep.componentes.EP_EstrSaldosPr_FE" method="CG_EstructuraSaldo">
        <cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
        <cfinvokeargument name="PerInicio" 	value="#form.periodo#">
        <cfinvokeargument name="MesInicio" 	value="#mesfin#">
        <cfinvokeargument name="PerFin" 	value="#form.periodo#">
        <cfinvokeargument name="MesFin" 	value="#mesfin#">
        <cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
        <cfinvokeargument name="invertirSaldo" 	value="true">
        <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
        <cfinvokeargument name="PerIniPP" 	value="#form.periodo#">
        <cfinvokeargument name="MesIniPP" 	value="#mesfin#">
    </cfinvoke>
    <cfset utilP= "UtilPer#idx#">
	<cfquery name="insUtilP" datasource="#session.dsn#">
		insert into #rsSaldoMes#
		(Ccuenta,CPCpagado)
		Values(
			<cfqueryparam cfsqltype="cf_sql_integer" value="-100">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(form[utilP])#"> )
	</cfquery>

	<cfset arrayappend(qMeses ,#rsSaldoMes#)>
	<cfset idx = idx + 1>
</cfloop>

<cfsavecontent variable="content" >
    <cfoutput>
        select a.*,pcr.PCDvalor PCDvalorR, pcsr.PCDvalor PCDvalorSR
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
            from (select * from #rsArbol# where Nivel > 2) ar
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
            from (select * from #rsArbol# where Nivel > 2) ar
            inner join #qMeses[i]# rs
            on ar.Cuenta = rs.Ccuenta
            group by left(ar.Orden,charindex('/',ar.Orden)+CHARINDEX('/',ar.Orden,(charindex('/',ar.Orden)+1))-charindex('/',ar.Orden)-1)
            ) saldo#i#
                on ar.Orden = saldo#i#.EPCodigo
			</cfloop>
            where (ar.EPCPcodigoref <> 'X')
			union all
            select ar.ClasCta, ar.Cmayor, ar.Cuenta, ar.DescripcionCmayor,ar.EPGdescripcion, ar.EPCodigo,
                ar.Nivel,ar.EPCPcodigoref,ar.EPCPnota, ar.ID_Grupo, ar.Orden,ar.PCDcatid,ar.PCDcatidH
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                <!--- ,sum( --->,saldo#i#.CPCpagado<!--- ) ---> Saldo#i#
            </cfloop>
            from #rsArbol# ar
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
            left join (
                select ar.ClasCta,sum(isnull(rs.CPCpagado/#varUnidad#,0.00)) CPCpagado
                from (select * from #rsArbol# where Nivel > 2) ar
				inner join #qMeses[i]# rs
					on ar.Cuenta = rs.Ccuenta
				group by ar.ClasCta
            ) saldo#i#
                on ar.ClasCta = saldo#i#.ClasCta
            </cfloop>
            where ar.Nivel = 2 and (ar.EPCPcodigoref <> 'X')
            <!--- group by ar.ClasCta, ar.Cmayor, ar.Cuenta, ar.DescripcionCmayor,ar.EPGdescripcion, ar.EPCodigo,
                ar.Nivel,ar.EPCPcodigoref,ar.EPCPnota, ar.ID_Grupo, ar.Orden,ar.PCDcatid,ar.PCDcatidH --->
            union all
            select ar.ClasCta, 0 Cmayor, 0 Cuenta, '' DescripcionCmayor,isnull(con.Cdescripcion, ar.EPGdescripcion) as EPGdescripcion, min(ar.EPCodigo) EPCodigo,
                ar.Nivel,'' EPCPcodigoref,'' EPCPnota, 0 ID_Grupo, min(ar.Orden) Orden,ar.PCDcatid,ar.PCDcatidH
            <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                ,sum(saldo#i#.CPCpagado) Saldo#i#
            </cfloop>
            from (select * from #rsArbol# where Nivel > 2) ar
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
            group by ar.ClasCta, ar.Nivel,isnull(con.Cdescripcion, ar.EPGdescripcion), ar.PCDcatid,ar.PCDcatidH
        ) a
        left join PCDCatalogo pcr
            on a.PCDcatid = pcr.PCDcatid
        left join PCDCatalogo pcsr
            on a.PCDcatidH = pcsr.PCDcatid
        left join Conceptos con
            on con.Ccodigo = convert(varchar,coalesce(pcr.PCDvalor,'0')) + convert(varchar,coalesce(pcsr.PCDvalor,'0'))
        order by a.Orden, pcr.PCDvalor, pcsr.PCDvalor
    </cfoutput>
</cfsavecontent>

<cfquery name="rsActivos" datasource="#session.dsn#">
    <cfoutput>#preservesinglequotes(content)#</cfoutput>
</cfquery>

<!---
<cf_dump var="#rsActivos#">
 --->

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
		<cfset sumCol = 1>
		<cfif form.mensAcum EQ "2">
		    <cfset sumCol = 2>
		</cfif>

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
                                <cfloop from="#iniLoop#" to="#finLoop#" index="i">
                                  <td nowrap align="center"><strong>#Ucase(MonthAsString(i,"Es"))#</strong></td>
                                </cfloop>
								<cfif form.mensAcum EQ "2">
								    <td nowrap align="center"><strong>Acumulado</strong></td>
								</cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="center" colspan="#ArrayLen(qMeses) + sumCol#">
                                        <hr width="100%"/>
                                    </td>
                                </tr>
<!---    inicial--->
                                <tr>
                                        <td nowrap width="70%" align="left"><strong>#LB_Caja#</strong></td>
                                <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                        <td nowrap align="right">#LSNumberFormat(qBancosCaj[i].SaldoCaja, '(),9.00')#</td>
                                </cfloop>
								<cfif form.mensAcum EQ "2">
								    <td nowrap align="right">#LSNumberFormat(qBancosCaj[1].SaldoCaja, '(),9.00')#</td>
								</cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_BAN#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCaj[i].SaldoBn, '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat(qBancosCaj[1].SaldoBn, '(),9.00')#</td>
									</cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_BAE#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCaj[i].SaldoBe, '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat(qBancosCaj[1].SaldoBe, '(),9.00')#</td>
									</cfif>
                                </tr>
								<!-- <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_CHEQUEST#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
											<cfset chequeI ="chequeI#i#">
											<td nowrap align="right">#LSNumberFormat(LSParseNumber(form[chequeI])*-1, '(),9.00')#</td>
                                    </cfloop>
                                </tr> -->
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_ST#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
											<cfset chequeI ="chequeI#i#">
		                                    <td nowrap align="right">#LSNumberFormat((qBancosCaj[i].SaldoCaja + qBancosCaj[i].SaldoBn + qBancosCaj[i].SaldoBe), '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat((qBancosCaj[1].SaldoCaja + qBancosCaj[1].SaldoBn + qBancosCaj[1].SaldoBe), '(),9.00')#</td>
									</cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_CHEQUEST#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
											<cfset chequeI ="chequeI#i#">
		                                    <td nowrap align="right">#LSNumberFormat(LSParseNumber(form[chequeI]), '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat(LSParseNumber(form.chequeI1), '(),9.00')#</td>
									</cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_SALDOINI#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
										<cfset chequeI ="chequeI#i#">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCaj[i].SaldoCaja + qBancosCaj[i].SaldoBn + qBancosCaj[i].SaldoBe + LSParseNumber(form[chequeI]), '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat(qBancosCaj[1].SaldoCaja + qBancosCaj[1].SaldoBn + qBancosCaj[1].SaldoBe + LSParseNumber(form.chequeI1), '(),9.00')#</td>
									</cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="center" colspan="#ArrayLen(qMeses) + sumCol#">
                                       &nbsp;
                                    </td>
                                </tr>
<!---    final--->
                                <tr>
								<td nowrap width="70%" align="left"><strong>#LB_Caja#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCajF[i].SaldoCaja, '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat(qBancosCajF[ArrayLen(qMeses)].SaldoCaja, '(),9.00')#</td>
									</cfif>
                                    </tr>
                                    <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_BAN#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCajF[i].SaldoBn, '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat(qBancosCajF[ArrayLen(qMeses)].SaldoBn, '(),9.00')#</td>
									</cfif>
                                    </tr>
                                    <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_BAE#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCajF[i].SaldoBe, '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat(qBancosCajF[ArrayLen(qMeses)].SaldoBe, '(),9.00')#</td>
									</cfif>
                                    </tr>
									<!-- <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_CHEQUEST#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
											<cfset chequeF ="chequeF#i#">
		                                    <td nowrap align="right">#LSNumberFormat(LSParseNumber(form[chequeF])*-1, '(),9.00')#</td>
                                    </cfloop>
                                    </tr> -->
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_ST#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
										<cfset chequeF = "ChequeF#i#">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCajF[i].SaldoCaja + qBancosCajF[i].SaldoBn + qBancosCajF[i].SaldoBe, '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
										<cfset chequeF = "ChequeF#ArrayLen(qMeses)#">
									    <td nowrap align="right">#LSNumberFormat(qBancosCajF[ArrayLen(qMeses)].SaldoCaja + qBancosCajF[ArrayLen(qMeses)].SaldoBn + qBancosCajF[ArrayLen(qMeses)].SaldoBe, '(),9.00')#</td>
									</cfif>
                               </tr>
                               <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_CHEQUEST#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
											<cfset chequeF = "ChequeF#i#">
                                            <td nowrap align="right">#LSNumberFormat(LSParseNumber(form[chequeF]), '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
										<cfset chequeF = "ChequeF#ArrayLen(qMeses)#">
									    <td nowrap align="right">#LSNumberFormat(LSParseNumber(form[chequeF]), '(),9.00')#</td>
									</cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>#LB_SALDOFIN#</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
										<cfset chequeF ="chequeF#i#">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCajF[i].SaldoCaja + qBancosCajF[i].SaldoBn + qBancosCajF[i].SaldoBe + LSParseNumber(form[chequeF]), '(),9.00')#</td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <td nowrap align="right">#LSNumberFormat(qBancosCajF[ArrayLen(qMeses)].SaldoCaja + qBancosCajF[ArrayLen(qMeses)].SaldoBn + qBancosCajF[ArrayLen(qMeses)].SaldoBe + LSParseNumber(ArrayLen(qMeses)), '(),9.00')#</td>
									</cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="center" colspan="#ArrayLen(qMeses) + sumCol#">
                                        <hr width="100%"/>
                                    </td>
                                </tr>


								<tr>
                                    <td nowrap width="70%" align="left"><strong>CAMBIO EN BANCOS</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
										<cfset chequeI = "ChequeI#i#">
										<cfset chequeF = "ChequeF#i#">
                                            <td nowrap align="right"><b>#LSNumberFormat((qBancosCajF[i].SaldoCaja + qBancosCajF[i].SaldoBn + qBancosCajF[i].SaldoBe  + LSParseNumber(form[chequeF]))
																					- (qBancosCaj[i].SaldoCaja + qBancosCaj[i].SaldoBn + qBancosCaj[i].SaldoBe  + LSParseNumber(form[chequeI])) , '(),9.00')#</b></td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
									    <cfset chequeI = "ChequeI1">
										<cfset chequeF = "ChequeF#ArrayLen(qMeses)#">
                                            <td nowrap align="right"><b>#LSNumberFormat((qBancosCajF[ArrayLen(qMeses)].SaldoCaja + qBancosCajF[ArrayLen(qMeses)].SaldoBn + qBancosCajF[ArrayLen(qMeses)].SaldoBe  + LSParseNumber(ArrayLen(qMeses)))
																					- (qBancosCaj[1].SaldoCaja + qBancosCaj[1].SaldoBn + qBancosCaj[1].SaldoBe  + LSParseNumber(form.chequeI1)) , '(),9.00')#</b></td>
									</cfif>
                               </tr>
								<tr>
                                    <td nowrap width="70%" align="center" colspan="#ArrayLen(qMeses) + sumCol#">&nbsp;</td>
                                </tr>
                            <cfset pintaL3 = true>
							<cfset total = 0>
                            <cfloop query="rsActivos">
                                <cfif #NIVEL# EQ 1>
									<cfset pintaL3 = true>
								</cfif>
                                <cfif #NIVEL# EQ 2 and (#EPCPcodigoref# EQ 'N' or #EPCPcodigoref# EQ 'U')>
                                	<cfset pintaL3 = false>
								<cfelseif #NIVEL# EQ 2 and (#EPCPcodigoref# EQ 'X' or #EPCPcodigoref# EQ 'S')>
                                	<cfset pintaL3 = true>
                                </cfif>
                                <cfif #NIVEL# NEQ 3 or (#NIVEL# EQ 3 and #pintaL3#) or isdefined("form.chkCeros")>
                                    <tr>
                                        <td align="left" nowrap
                                            <cfoutput>
                                                <cfif #NIVEL# EQ 2 and (#EPCPcodigoref# EQ 'N' or #EPCPcodigoref# EQ 'U') and not isdefined("form.chkCeros")>
                                                    <cfset tdmargin = (#NIVEL# + 1)*10>
                                                <cfelse>
                                                    <cfset tdmargin = (#NIVEL#)*10>
                                                </cfif>

                                                style="padding-left:#tdmargin#px"
                                            </cfoutput>
                                        >
                                           <cfset descripcion =Replace(EPGdescripcion, '"', '',"ALL")>
                                            <cfif (#NIVEL# LT 3 and #ClasCta# LT 0) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S') >
												<strong>
											<cfelse>
												<!--- <cfset descripcion = rereplace(lcase(descripcion),"(\b\w)","\u\1","ALL")> --->
											</cfif>
                                                <cfif isdefined("form.chkCeros") and #NIVEL# GT 2>#PCDvalorR#-#PCDvalorSR#</cfif> #descripcion#
                                            <cfif (#NIVEL# LT 3 and #ClasCta# LT 0) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S')></strong></cfif>
                                        </td>
                                        <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                                <td nowrap align="right">
                                                <cfset saldoMes= "Saldo#i#">
                                                <cfif (#NIVEL# LT 2) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S') ><strong></cfif>
												#LSNumberFormat(rsActivos[saldoMes][currentRow], '(),9.00')#
                                                <cfif (#NIVEL# LT 2) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S') ></strong></cfif></td>
                                        </cfloop>
										<cfif form.mensAcum EQ "2">
										    <td nowrap align="right">
											    <cfset saldoAcum = 0>
											    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                                	<cfset saldoMes= "Saldo#i#">
													<cfif len(trim(rsActivos[saldoMes][currentRow])) and rsActivos[saldoMes][currentRow] neq "">
														<cfset saldoAcum = saldoAcum + rsActivos[saldoMes][currentRow]>
													</cfif>
												</cfloop>
                                                <cfif (#NIVEL# LT 2) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S') ><strong></cfif>
												#LSNumberFormat(saldoAcum, '(),9.00')#
                                                <cfif (#NIVEL# LT 2) or (#NIVEL# EQ 2 and #EPCPcodigoref# EQ 'S') ></strong></cfif></td>
										</cfif>
                                    </tr>
                                </cfif>
                            </cfloop>
                            <tr >
                              <td nowrap width="70%" align="left">&nbsp;</td>
                              <td nowrap align="center">&nbsp;</td>
                            </tr>
							<!--- Saldos finales --->
							<cfset arrSuerAVit = ArrayNew(1)>
							<tr>
                               <td nowrap width="70%" align="left"><strong>SUPERAVIT/(DEFICIT)</strong></td>
                                <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
									<cfset saldoMes= "Saldo#i#">
									<cfquery name="rsTotal" dbtype="query">
										select sum(Saldo#i#) Saldo
										from rsActivos
										where NIVEL = 0
									</cfquery>
									<cfset arrayappend(arrSuerAVit ,#rsTotal.Saldo#)>
									<td nowrap align="right"><b>#LSNumberFormat(rsTotal.Saldo, '(),9.00')#</b></td>
                                </cfloop>
								<cfif form.mensAcum EQ "2">
									<cfset supAvitAcum = 0>
								    <cfloop from="1" to="#ArrayLen(arrSuerAVit)#" index="i">
										<cfset supAvitAcum = supAvitAcum + arrSuerAVit[i]>
									</cfloop>
									<td nowrap align="right"><b>#LSNumberFormat(supAvitAcum, '(),9.00')#</b></td>
								</cfif>
                                </tr>
                                <!--- <tr>
                                    <td nowrap width="70%" align="left"><strong>VENTA DE DIVISAS</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                            <td nowrap align="right"><!--- #LSNumberFormat(qBancosCajF[i].SaldoBn, '(),9.00')# ---></td>
                                    </cfloop>
                                </tr> --->
                                <!--- <tr>
                                    <td nowrap width="70%" align="left"><strong>CAMBIO EN BANCOS</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
                                            <td nowrap align="right">#LSNumberFormat(qBancosCajF[i].SaldoBe, '(),9.00')#</td>
                                    </cfloop>
                                </tr> --->
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>SALDO SIN CHEQUES EN TR&Aacute;NSITO</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
										<cfset chequeI = "ChequeI#i#">
										<cfset chequeF = "ChequeF#ArrayLen(qMeses)#">
                                        <td nowrap align="right"><b>#LSNumberFormat((qBancosCaj[i].SaldoCaja + qBancosCaj[i].SaldoBn + qBancosCaj[i].SaldoBe)  + arrSuerAVit[i], '(),9.00')#</b></td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
										<cfset chequeI = "ChequeI1">
										<cfset chequeF = "ChequeF#ArrayLen(qMeses)#">
										<td nowrap align="right"><b>#LSNumberFormat((qBancosCaj[1].SaldoCaja + qBancosCaj[1].SaldoBn + qBancosCaj[1].SaldoBe)  + supAvitAcum, '(),9.00')#</b></td>
		                           </cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>CHEQUES EN TR&Aacute;NSITO</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
										<cfset chequeI = "ChequeI#i#">
										<cfset chequeF = "ChequeF#i#">
                                            <td nowrap align="right"><b>#LSNumberFormat(LSParseNumber(form[chequeI]) - LSParseNumber(form[chequeF]), '(),9.00')#</b></td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
										<cfset chequeI = "ChequeI1">
										<cfset chequeF = "ChequeF#ArrayLen(qMeses)#">
										<td nowrap align="right"><b>#LSNumberFormat(LSParseNumber(form[chequeI]) - LSParseNumber(form[chequeF]), '(),9.00')#</b></td>
		                            </cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="left"><strong>SALDO FINAL EN CAJA Y BANCOS</strong></td>
                                    <cfloop from="1" to="#ArrayLen(qMeses)#" index="i">
										<cfset chequeI = "ChequeI#i#">
										<cfset chequeF = "ChequeF#i#">
                                            <td nowrap align="right"><b>#LSNumberFormat((qBancosCaj[i].SaldoCaja + qBancosCaj[i].SaldoBn + qBancosCaj[i].SaldoBe) + arrSuerAVit[i] + (LSParseNumber(form[chequeI]) - LSParseNumber(form[chequeF])), '(),9.00')#</b></td>
                                    </cfloop>
									<cfif form.mensAcum EQ "2">
										<cfset chequeI = "ChequeI1">
										<cfset chequeF = "ChequeF#ArrayLen(qMeses)#">
										<td nowrap align="right"><b>#LSNumberFormat((qBancosCaj[1].SaldoCaja + qBancosCaj[1].SaldoBn + qBancosCaj[1].SaldoBe) + supAvitAcum + (LSParseNumber(form[chequeI]) - LSParseNumber(form[chequeF])), '(),9.00')#</b></td>
		                            </cfif>
                                </tr>
                                <tr>
                                    <td nowrap width="70%" align="center" colspan="#ArrayLen(qMeses) + 1#">
                                       &nbsp;
                                    </td>
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
        <form action="RepFlujoEfectivoAcum.cfm" method="post" name="sql">
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
