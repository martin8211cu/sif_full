<!---
	Creado por Andres Lara
		Fecha: 17-06-2014.
	Situacion Estado de Actividades
 --->

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
<!--- <cfif isdefined("url.mensAcum") and not isdefined("form.mensAcum")>
	<cfparam name="form.mensAcum" default="#url.mensAcum#"></cfif> --->
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
<cfif form.periodo lt year(NOW())>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes lt month(NOW())>
        <cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>
<!---  <cf_dump var="#form#"> --->
<cfinvoke key="MSG_EdoADOP" default="Estado Analítico de la Deuda y Otros Pasivos" returnvariable="MSG_EdoADOP" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Nt" default="Nota" returnvariable="MSG_Nt" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Enc1" default="Saldos Inicial del Periodo" returnvariable="MSG_Enc1" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Enc2" default="Saldo Final del Periodo" returnvariable="MSG_Enc2" component="sif.Componentes.Translate" method="Translate"/>

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
<cfinvoke key="LB_Total" 		default="Total Deuda y Otros Pasivos"	returnvariable="LB_Total"				component="sif.Componentes.Translate" method="Translate"/>
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

<cfset LvarIrA = 'RepAnDyoP.cfm'>
<cfset LvarFile = 'RepAnDyoP'>
<cfset Request.LvarTitle = #MSG_EdoADOP#>

<!---<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>
--->
<cfset rsAnoMes = #form.periodo#&left("0"&#form.mes#,2)>
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
	<cflocation url="RepAnDyoP.cfm?rsMensaje=#rsMensaje#">
</cfif>

</cfoutput>

<cfquery name="rsNumEst" datasource="#session.dsn#">
	select top 1 r.ID_Estr, r.ID_Firma from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>
<!---

<cfdump var=#session.menues.SPCODIGO#>
 --->

<cfset permes = form.periodo>
<cfset periodoAnt = form.periodo -1>
<cfset permesAnt = (form.periodo - 1)>


<cfinvoke returnvariable="rsArbol" component="sif.ep.componentes.EP_EstrGruposCmayor" method="CG_EstructuraGrupo">
	<!--- <cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#"> --->
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
	<cfinvokeargument name="incluyeCuentas"	value="N">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke>

<!--- <cfinvoke returnvariable="rsSaldoMes" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#form.periodo#">
    <cfinvokeargument name="MesInicio" 	value="#form.mes#">
    <cfinvokeargument name="PerFin" 	value="#form.periodo#">
    <cfinvokeargument name="MesFin" 	value="#form.mes#">
    <cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke> --->

<cfinvoke returnvariable="arrsSaldoMes" component="sif.ep.componentes.EP_EstrSaldosMesesAnt" method="SaldosAnteriores">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#form.periodo#">
    <cfinvokeargument name="MesInicio" 	value="#form.mes#">
    <cfinvokeargument name="PerFin" 	value="#form.periodo#">
    <cfinvokeargument name="MesFin" 	value="#form.mes#">
    <cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
    <cfinvokeargument name="PerIniPP" 	value="#form.periodo#">
    <cfinvokeargument name="MesIniPP" 	value="#form.mes#">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
	<cfinvokeargument name="Mcodigo" 		value="#varMcodigo#">
	<!--- <cfinvokeargument name="PeriodoMesActual" value="N"> --->
</cfinvoke>

<!--- <cfquery name="a1" datasource="#session.dsn#">
	select * from #rsArbol#
</cfquery>

<cfdump var="#a1#"> --->

<!---     <cfquery name="a1" datasource="#session.dsn#">
	select * from #arrsSaldoMes[1]#
</cfquery>
 <cfdump var="#a1#"> --->


<cfinvoke returnvariable="rsSaldoMes" component="sif.ep.componentes.EP_EstrSaldosPr" method="CG_EstructuraSaldo">
 <cfinvokeargument name="IDEstrPro" value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio"  value="#form.periodo-1#">
    <cfinvokeargument name="MesInicio"  value="12">
    <cfinvokeargument name="PerFin"  value="#form.periodo#">
    <cfinvokeargument name="MesFin"  value="12">
    <cfinvokeargument name="MonedaLoc"  value="#varMonlocal#">
 <cfinvokeargument name="invertirSaldo"  value="true">
    <cfinvokeargument name="GvarConexion"  value="#session.dsn#">
 <cfinvokeargument name="PerIniPP"  value="#form.periodo#">
 <cfinvokeargument name="MesIniPP"  value="12">
</cfinvoke>


<!---
<cfinvoke returnvariable="rsSaldoMesAnt" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#periodoAnt#">
    <cfinvokeargument name="MesInicio" 	value="#form.mes#">
    <cfinvokeargument name="PerFin" 	value="#periodoAnt#">
    <cfinvokeargument name="MesFin" 	value="#form.mes#">
    <cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
</cfinvoke>
 --->



<cfquery name="rsMaxNivel" datasource="#session.dsn#">
	select max(Nivel) Nivel from #rsArbol#
</cfquery>
<cfquery name="rsMinNivel" datasource="#session.dsn#">
	select min(Nivel) Nivel from #rsArbol#
</cfquery>






 <cfquery name="rsActivosx" datasource="#session.dsn#">
	select ar.ClasCta, ar.EPCPnota, ar.EPCodigo, ar.EPGdescripcion, ar.Nivel, ar.Orden, ar.DescripcionCmayor,
  isnull(saldo.CPCpresupuestado/#varUnidad#,0.00) Saldo, sSaldoG.SaldoG,
  saldo2.DLdebitos, saldo2.CLcreditos, isnull(saldo2.DLdebitos - saldo2.CLcreditos,0)/#varUnidad# Saldo2,
  saldoAc.DLdebitos DLdebitosAnt, saldoAc.CLcreditos CLcreditosAnt,
  isnull(saldoAc.DLdebitos - saldoAc.CLcreditos + saldoAc.SLinicial,0)/#varUnidad# saldoAc, sSaldoG2.SaldoGAc2,
  isnull(saldoAc1.CPCpresupuestado2/#varUnidad#,0.00) SaldoAc1


 from #rsArbol# ar
  left join (
  select Cmayor, sum(DLdebitos - CLcreditos) CPCpresupuestado
  from #arrsSaldoMes[1]#
  group by Cmayor
 ) saldo
  on ar.Cmayor = saldo.Cmayor

 left join (
  select Cmayor, sum(DLdebitos - CLcreditos + SLinicial) CPCpresupuestado2
  from #arrsSaldoMes[2]#
  group by Cmayor
 ) saldoAc1
  on ar.Cmayor = saldoAc1.Cmayor

  left join (
  select EPCodigo, SaldoG from (
   select right(Orden,1) EPCodigo, sum(SaldoG) SaldoG from (
    select left(ar.Orden,3) Orden, sum(isnull(saldo.CPCpresupuestado/#varUnidad#,0.00)) SaldoG
    from #rsArbol# ar
    left join (
     select Cmayor, sum(DLdebitos - CLcreditos) CPCpresupuestado
     from #arrsSaldoMes[1]#
     group by Cmayor
    ) saldo
     on ar.Cmayor = saldo.Cmayor
    group by left(ar.Orden,3)
   ) sGrupo
   group by right(Orden,1)
  ) sSaldo
 ) sSaldoG
   on ar.EPCodigo = sSaldoG.EPCodigo

left join (
		select -ID_Grupo ID_Grupo, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
		from #arrsSaldoMes[1]# sd
		group by ID_Grupo
	) saldo2
		on ar.ID_Grupo = saldo2.ID_Grupo

left join (
		select -ID_Grupo ID_Grupo, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
		from #arrsSaldoMes[2]#
		group by ID_Grupo
	) saldoAc
		on ar.ID_Grupo = saldoAc.ID_Grupo

left join (
  select EPCodigo2, SaldoGAc2 from (
   select right(Orden,1) EPCodigo2, sum(SaldoGAc) SaldoGAc2 from (
    select ar2.Cmayor,left(ar2.Orden,3) Orden, sum(isnull(saldoAc2.CPCpresupuestado2/#varUnidad#,0.00)) SaldoGAc
    from #rsArbol# ar2
    left join (
     select Cmayor, sum(DLdebitos - CLcreditos + SLinicial) CPCpresupuestado2
     from #arrsSaldoMes[2]#
     group by Cmayor
    ) saldoAc2
     on ar2.Cmayor = saldoAc2.Cmayor
    group by left(ar2.Orden,3),ar2.Cmayor
   ) sGrupo2
   group by right(Orden,1)
  ) sSaldo2
 ) sSaldoG2
   on ar.EPCodigo = sSaldoG2.EPCodigo2

</cfquery>

<!--- SE SEPARAN LAS CUENTAS con cuenta de mayor que son seleccionadas--->
<cfquery name="rsActivosG1" dbtype="query">
 select * from rsActivosx where Orden not like '15%'
							and Orden not like '-1%'
							and Orden not like '-2%'
							and Orden not like '3%'
							and Orden not like '0/4%'
							and Orden not like '0/5%'
</cfquery>

<cfquery name="rsActivosG2" dbtype="query">
 select * from rsActivosx where Orden not like '15%'
							and Orden not like '-1%'
							and Orden not like '-2%'
							and Orden not like '3%'
							and Orden not like '0/1%'
							and Orden not like '0/2%'
</cfquery>

<cfquery name="rsActivosA" dbtype="query">
 select * from rsActivosx where Orden like '-1%'
							 or Orden like '-2%'
</cfquery>

<cfquery name="rsActivosB" dbtype="query">
 select * from rsActivosx where Orden like '3%'
</cfquery>

 <cfquery name="rsActivosC" dbtype="query">
 select * from rsActivosx where Orden like '15%'
</cfquery>


<!--- SUMA TOTAL A CORTO PLAZO --->
<cfquery name="rsSuma1" dbtype="query">
select  Saldo2,SaldoG, saldoAc, SaldoGAc2,EPCodigo
	  from rsActivosx where EPCodigo like '-1.1'
						or	EPCodigo like '-2.1'
						or	EPCodigo like '2'
						or	EPCodigo like '1'
</cfquery>
<cfquery name="rsSumaT1" dbtype="query">
select sum(Saldo2) a1, sum(SaldoG) a2, sum(saldoAc) b1, sum(SaldoGAc2) b2
	  from rsSuma1
</cfquery>

<cfset saldoST = rsSumaT1.a1 + rsSumaT1.a2 >
<cfset saldoTAc = rsSumaT1.b1 + rsSumaT1.b2>
<!--- ************************* --->

<!--- SUMA TOTAL A LARGO PLAZO --->
<cfquery name="rsSuma2" dbtype="query">
select  Saldo2,SaldoG, saldoAc, SaldoGAc2,EPCodigo
	  from rsActivosx where EPCodigo like '3.1'
						or	EPCodigo like '4'
						or	EPCodigo like '5'
</cfquery>

<cfquery name="rsSumaT2" dbtype="query">
select  sum(Saldo2) a1, sum(SaldoG) a2, sum(saldoAc) b1, sum(SaldoGAc2) b2
	  from rsSuma2
</cfquery>
<cfset saldoST2 = rsSumaT2.a1 + rsSumaT2.a2>
<cfset saldoTAc2 = rsSumaT2.b1 + rsSumaT2.b2>
<!--- ************************* --->


<!--- QUERY PARA LOS TOTALES --->

<cfquery name="rsTActivos" datasource="#session.dsn#">
	select isnull(sum(  saldo.DLdebitos - saldo.CLcreditos),0)/#varUnidad# Saldo,
		isnull(sum( saldoAc.DLdebitos - saldoAc.CLcreditos+ saldoAc.SLinicial),0)/#varUnidad#  saldoAc
	from #rsArbol# ar
	left join (
		select -ID_Grupo ID_Grupo, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
		from #arrsSaldoMes[1]# sd
		group by ID_Grupo
	) saldo
		on ar.ID_Grupo = saldo.ID_Grupo
	left join (
		select -ID_Grupo ID_Grupo, sum(DLdebitos) DLdebitos, sum(CLcreditos) CLcreditos, sum(SLinicial) SLinicial
		from #arrsSaldoMes[2]# sda
		group by ID_Grupo
	) saldoAc
		on ar.ID_Grupo = saldoAc.ID_Grupo
	where ar.Nivel < #rsMaxNivel.Nivel#
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

  <table width="100%" align="center" border="0" >
			<tr>
            	<td >
	  <table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
            <tr>
                <td style="font-size:16px" align="center" colspan="4">
                <strong>#rsNombreEmpresa.Edescripcion#</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="4">
                    <strong>#MSG_EdoADOP#</strong>
                </td>
            </tr>

            <tr>
                <td style="font-size:16px" align="center" nowrap="nowrap" colspan="4">
                	<strong> Al
						       #LabelFechaFin# (Acumulado)
					</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="4"><strong>(#MSG_Cifras_en# #rsMoneda.Mnombre#)</strong></td>
            </tr>
        </table>
	</td>
            </tr>

		</table>

		<table width="100%" align="right" border="0" >
			<tr>
            	<td width="100%" align="right" valign="top">
					<table width="100%" border="0" cellspacing="0">
						<tr style="background-color:lightblue;">
						  <td nowrap width="50%" align="center"><strong>&nbsp;</strong></td>
						  <td nowrap align="center"><strong>&nbsp;</strong></td>
						  <td nowrap align="center" colspan="2"><strong>&nbsp;</strong></td>
						</tr>
					  	<tr style="background-color:lightblue;">
						  <td nowrap width="50%" align="center"><strong>#LB_Concepto#</strong></td>
						  <td nowrap align="center"><strong>#MSG_Nt#</strong></td>
						  <td nowrap align="right"><strong>#MSG_Enc1#</strong></td>
						  <td nowrap align="right"><strong>#MSG_Enc2#</strong></td>
					  	</tr>

<!--- PRIMER LOOP --->
						<cfloop query="rsActivosA">
							 <cfif #NIVEL# EQ 1>
								        <tr>
						            	<td align="left"><strong><cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#</strong></td>
						                <td nowrap align="center">#rsActivosA.EPCPnota#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosA.Saldo2, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosA.saldoAc, ',9.00')#</td>
		                   				</tr>
							 </cfif>
						</cfloop>

<!--- SEGUNDO LOOP --->

					<cfloop query="rsActivosG1">
							 <cfif #NIVEL# EQ 1>
								        <tr>
						            	<td align="left"><strong><cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#</strong></td>
						            	<td nowrap align="center">#rsActivosG1.EPCPnota#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosG1.SaldoG, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosG1.SaldoGAc2, ',9.00')#</td>
		                   				</tr>
							  <cfelse>
								 <cfif #Nivel# EQ 2>
							         <tr>
						            	<td align="left"
							            	<cfoutput>
								            	<cfset tdmargin = #NIVEL#*10>
												style="padding-left:#tdmargin#px"
											</cfoutput>
										 >
							            	<cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#
										</td>
										<td nowrap align="center">#rsActivosG1.EPCPnota#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosG1.Saldo2, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosG1.saldoAc, ',9.00')#</td>
						             </tr>
						          </cfif>
								</cfif>
						</cfloop>
<!--- TOTAL DEL CORTO PLAZO --->
								<tr>
								<td>&nbsp;</td>
								</tr>
										<tr>
						            	<td align="left"><strong>SUBTOTAL A CORTO PLAZO</strong></td>
						            	<td nowrap align="center"><strong>&nbsp;</strong></td>
						                <td nowrap align="right"><strong>#LSNumberFormat(saldoST,',9.00')#</strong></td>
						                <td nowrap align="right"><strong>#LSNumberFormat(saldoTAc,',9.00')#</strong></td>
		                   				</tr>
		                   		<tr>
								<td>&nbsp;</td>
								</tr>
<!--- PRIMER LOOP --->
						<cfloop query="rsActivosB">
							 <cfif #NIVEL# EQ 1>
								        <tr>
						            	<td align="left"><strong><cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#</strong></td>
						            	<td nowrap align="center">#rsActivosB.EPCPnota#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosB.Saldo2, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosB.saldoAc, ',9.00')#</td>
		                   				</tr>
							 </cfif>
						</cfloop>
<!--- SEGUNDO LOOP --->

					<cfloop query="rsActivosG2">
							 <cfif #NIVEL# EQ 1>
								        <tr>
						            	<td align="left"><strong><cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#</strong></td>
						            	<td nowrap align="center">#rsActivosG2.EPCPnota#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosG2.SaldoG, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosG2.SaldoGAc2, ',9.00')#</td>
		                   				</tr>
							  <cfelse>
								 <cfif #Nivel# EQ 2>
							         <tr>
						            	<td align="left"
							            	<cfoutput>
								            	<cfset tdmargin = #NIVEL#*10>
												style="padding-left:#tdmargin#px"
											</cfoutput>
										 >
							            	<cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#
										</td>
										<td nowrap align="center">#rsActivosG2.EPCPnota#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosG2.Saldo2, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosG2.saldoAc, ',9.00')#</td>
						             </tr>
						          </cfif>
								</cfif>
						</cfloop>

<!--- TOTAL DEL CORTO PLAZO --->
								<tr>
								<td>&nbsp;</td>
								</tr>
										<tr>
						            	<td align="left"><strong>SUBTOTAL A LARGO PLAZO</strong></td>
						            	<td nowrap align="center"><strong>&nbsp;</strong></td>
						                <td nowrap align="right"><strong>#LSNumberFormat(saldoST2,',9.00')#</strong></td>
						                <td nowrap align="right"><strong>#LSNumberFormat(saldoTAc2,',9.00')#</strong></td>
		                   				</tr>
		                   		<tr>
								<td>&nbsp;</td>
								</tr>

<!--- ULTIMO LOOP --->
						<cfloop query="rsActivosC">
							 <cfif #NIVEL# EQ 1>
								        <tr>
						            	<td align="left"><strong><cfif form.chkCeros EQ "1">#EPCodigo#</cfif> #EPGdescripcion#</strong></td>
						                <td nowrap align="center">#rsActivosC.EPCPnota#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosC.Saldo2, ',9.00')#</td>
						                <td nowrap align="right">#LSNumberFormat(rsActivosC.saldoAc, ',9.00')#</td>
		                   				</tr>
							 </cfif>
						</cfloop>

						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td align="center"><strong>#LB_Total#</strong></td>
							<td nowrap align="right"><center>&nbsp;</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.Saldo, ',9.00')#</strong></td>
						    <td nowrap align="right"><strong>#LSNumberFormat(rsTActivos.saldoAc, ',9.00')#</strong></td>
						</tr>
			        </table>
				</td>
            </tr>

			<tr>
			    <td>&nbsp;</td>
			</tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="2">
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

		</table>

    </cfoutput>
