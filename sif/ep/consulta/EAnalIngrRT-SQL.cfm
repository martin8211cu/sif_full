<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 12-06-2013.
	Reporte Analítico del Activo por Rubro y Tipo
 --->

<cfparam name="form.mes" 	 default="#right(form.CPCanoMes,2)#">
<cfparam name="form.periodo" default="#left(form.CPCanoMes,4)#">

<cfif isdefined("form.chkCeros")>
	<cfparam name="form.chkCeros" default="1"> 
<cfelse>
   	<cfparam name="form.chkCeros" default="0">  
</cfif> 

<cfset form.chkDetalle = "1">

<!---<cfif isdefined("form.chkDetalle")>
	<cfparam name="form.chkDetalle" default="1">
<cfelse>
   	<cfparam name="form.chkDetalle" default="0">  
</cfif> 
--->
<cfif form.periodo lt year(NOW())>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes lt month(NOW())>
        <cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>
<!---<cfdump var= #form#>--->

<cfinvoke key="MSG_ReporteAnalitico" default="Estado de Ejecuci&oacute;n de Ingresos por Rubros"	returnvariable="MSG_ReporteAnalitico" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_RepAnyTipo" 		default="Estado Anal&iacutetico de Ingresos por Rubro y Tipo"											returnvariable="MSG_RepAnyTipo" 	  component="sif.Componentes.Translate" method="Translate"/>
	
<!---component="sif.Componentes.Translate" method="Translate"/>--->
<cfif #form.Unidad# eq 1>
	<cfinvoke key="MSG_Cifras_en" 	default=""					returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1>
<cfelseif #form.Unidad# eq 2>
	<cfinvoke key="MSG_Cifras_en" 	default="en miles de"		returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1000>
<cfelseif #form.Unidad# eq 3>
	<cfinvoke key="MSG_Cifras_en" 	default="en millones de"	returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 100000>
</cfif>

<cfinvoke key="LB_Rubro" 	 default="RUBROS DE LOS INGRESOS"	returnvariable="LB_Rubro"	  	component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="MSG_Ingresos" default="Ingresos"		returnvariable="MSG_Ingresos"	component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="MSG_Estimado" default="Estimado"		returnvariable="MSG_Estimado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Ampliaciones" 	default="Ampliaciones y"			returnvariable="MSG_Ampliaciones"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Reduciones" 	default="Reducciones + ó (-)"	returnvariable="MSG_Reduciones"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Modificado" 	default="Modificado"	returnvariable="MSG_Modificado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Periodo" 	default="Periodo"		returnvariable="MSG_Periodo"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Devengado" 	default="Devengado"		returnvariable="MSG_Devengado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Recaudado" 	default="Recaudado"		returnvariable="MSG_Recaudado"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Avance" 		default="% de Avance"		returnvariable="MSG_Avance"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_dela" 		default="de la"			returnvariable="MSG_dela"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_RecaudM" 		default="Recaudaci&oacute;n"	returnvariable="MSG_RecaudM"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_recaud" 		default="recaudaci&oacute;n"	returnvariable="MSG_recaud"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG__Modif" 		default="Modificado"	returnvariable="MSG__Modif"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_IngrPor" 	default="Ingreso por"	returnvariable="MSG_IngrPor"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Recaudar" 	default="Recaudar"		returnvariable="MSG_Recaudar"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Menos" 		default="menos"			returnvariable="MSG_Menos"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nota" 		default="Notas"			returnvariable="LB_Nota"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Mensual"		default='Mensual' 	returnvariable="LB_Mensual"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NotaPie"		default='Importante:  Las columnas de Ingresos estimado y de Ingresos Modificado corresponden al presupuesto anual autorizado.' 	returnvariable="LB_NotaPie"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Acumulado"	default='Acumulado' returnvariable="LB_Acumulado"	component="sif.Componentes.Translate" method="Translate"/>

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
    select e.Edescripcion
    from Empresas e
    where e.Ecodigo = #session.Ecodigo#
</cfquery>

<!---<cfset varMcodigo = #rsNombreEmpresa.Mcodigo#>
<cfset varMonlocal= "true">
--->
<cfset LvarIrA  = 'EAnalIngrRT.cfm'>
<cfset LvarFile = 'EAnalIngrRT'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cfquery name="rsCPPid" datasource="#Session.DSN#">
	select CPPid,CPPanoMesDesde,Mcodigo from CPresupuestoPeriodo
    where Ecodigo=#Session.Ecodigo#
    	and #form.CPCanoMes# between CPPanoMesDesde and CPPanoMesHasta
</cfquery>

<cfif isdefined("form.mcodigoopt") and form.mcodigoopt EQ "0">
	<cfset varMcodigo = form.Mcodigo>
    <cfset varMonlocal= "false">
<cfelse>
	<cfset varMcodigo = #rsCPPid.Mcodigo#>
    <cfset varMonlocal= "true">
</cfif>

<cfoutput>
<cfif rsCPPid.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuentas de la contabilidad presupuestaria para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfif isdefined("form.mensAcum") and form.mensAcum eq 1>
        <cfparam name="form.mesIni" 	 default="#right(form.CPCanoMes,2)#">
        <cfparam name="form.periodoIni" default="#left(form.CPCanoMes,4)#">
    <cfelse>
        <cfparam name="form.mesIni" 	default="#right(rsCPPid.CPPanoMesDesde,2)#">
        <cfparam name="form.periodoIni" default="#left(rsCPPid.CPPanoMesDesde,4)#">
	</cfif>
    <cfquery name="rsCuentas" datasource="#Session.DSN#"> 
        select c.Cmayor from CtasMayor c
        inner join CPresupuesto p on p.Cmayor = c.Cmayor
        where c.Ctipo='I' and c.Ecodigo = #Session.Ecodigo#
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
    </cfloop>
</cfif>

<cfif isdefined('rsMensaje')>
	<cflocation url="EAnalIngrRT.cfm?rsMensaje=#rsMensaje#">
</cfif>

</cfoutput>
<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
	<cf_dbtempcol name="ID_GrupoCat"  type="int">
	<cf_dbtempcol name="ID_EstrCtaVal"  type="int">
	<cf_dbtempcol name="EPCPcodigo"  	type="varchar(20)">
    <cf_dbtempcol name="Descripcion"  	type="varchar(200)">
    <cf_dbtempcol name="Nota"  			type="varchar(5)">	
	<cf_dbtempcol name="ID_DEstrCtaVal" type="numeric">
    <cf_dbtempcol name="PCDcatid" 		type="numeric">
    <cf_dbtempcol name="Mcodigo"  		type="integer">        
    <cf_dbtempcol name="IngrEst"  		type="money">
    <cf_dbtempcol name="Modific"  		type="money">
    <cf_dbtempcol name="IngrMod"  		type="money">
    <cf_dbtempcol name="IngrDev"  		type="money">
    <cf_dbtempcol name="IngrRec"  		type="money">
    <cf_dbtempcol name="ModificPer" 	type="money">
    <cf_dbtempkey cols="ID_EstrCtaVal,EPCPcodigo,ID_DEstrCtaVal">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_GrupoCat, ID_EstrCtaVal, EPCPcodigo, Descripcion,Nota,ID_DEstrCtaVal, PCDcatid, Mcodigo, IngrEst, Modific, IngrMod, IngrDev, IngrRec, ModificPer)
	select c.ID_Grupo, 0, c.EPGcodigo, c.EPGdescripcion, 
	c.EPCPcodigoref,
	0, 0, #varMcodigo#, 0 ,0 ,0 ,0 ,0, 0
    from CGGrupoCtasMayor c
    inner join CGReEstrProg r
    on c.ID_Estr= r.ID_Estr
    where r.SPcodigo='#session.menues.SPCODIGO#'
    order by r.SPcodigo,c.ID_Grupo    
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_GrupoCat, ID_EstrCtaVal, EPCPcodigo, Descripcion,Nota, ID_DEstrCtaVal, PCDcatid, Mcodigo, IngrEst, Modific, IngrMod, IngrDev, IngrRec, ModificPer)
    select c.ID_Grupo,c.ID_EstrCtaVal ,c.EPCPcodigo,c.EPCPdescripcion,c.EPCPcodigoref, d.ID_DEstrCtaVal,p.PCDcatid,#varMcodigo#,0 ,0 ,0 ,0, 0, 0
    from CGEstrProgVal c
    inner join CGReEstrProg r
    on c.ID_Estr= r.ID_Estr
    inner join dbo.CGDEstrProgVal d
    on d.ID_EstrCtaVal=c.ID_EstrCtaVal
    left join PCDCatalogo p
       on d.PCDcatid=p.PCDcatid 
    where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>

<!--- <cf_dumptofile select="select * from #saldoscuenta# order by ID_GrupoCat,ID_DEstrCtaVal">
---> 
<cfquery name="rsNumEst" datasource="#session.dsn#">
	select r.ID_Estr from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>
 
 <cfinvoke returnvariable="rsEPQuery" component="sif.ep.componentes.EP_EstrSaldosPr" method="CG_EstructuraSaldo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#form.periodoIni#">
    <cfinvokeargument name="MesInicio" 	value="#form.mesIni#">
    <cfinvokeargument name="PerFin" 	value="#form.periodo#">
    <cfinvokeargument name="MesFin" 	value="#form.mes#">
    <cfinvokeargument name="PerIniPP" 	value="#left(rsCPPid.CPPanoMesDesde,4)#">
    <cfinvokeargument name="MesIniPP" 	value="#right(rsCPPid.CPPanoMesDesde,2)#">
   	<cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
<!---     <cfif not varMonlocal>
    	<cfinvokeargument name="Mcodigo" 	value="#varMcodigo#">
    </cfif>
--->    
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">    
</cfinvoke>
<!---<cf_dumptofile select="select * from #rsEPQuery#">
--->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    where ID_EstrCtaVal<>0
    order by PCDcatid
</cfquery>

<!----Actualizar saldos ----->
<cfloop query="SC">
    <cfquery datasource="#session.DSN#" name="Saldos">
        select 
        coalesce(sum(CPCpresup_Anual), 0.00) as IngrEst,
        coalesce(sum(CPCmodificado), 0.00) +  coalesce(sum(CPCmodificacion_Excesos), 0.00) + coalesce(sum(CPCtrasladado), 0.00) as Modific,

        coalesce(sum(CPCpresup_Anual), 0.00) + coalesce(sum(CPCmodificadoAnual), 0.00) <!---+  coalesce(sum(CPCmodif_ExcAnual), 0.00)---> + coalesce(sum(CPCtras_Anual), 0.00) + coalesce(sum(CPCtrasE_Anual), 0.00) as IngrMod,
        
        coalesce(sum(CPCpresupPeriodo), 0.00) + coalesce(sum(CPCmodificado), 0.00) +  coalesce(sum(CPCmodificacion_Excesos), 0.00) + coalesce(sum(CPCtrasladado), 0.00)  <!--- + coalesce(sum(CPCtrasladadoE), 0.00)---> as ModificPer,

        coalesce(sum(CPCejecutado), 0.00) as IngrDev,
        coalesce(sum(CPCpagado), 0.00) as IngrRec
        from #saldoscuenta# s
        inner join #rsEPQuery# r
        on s.PCDcatid = r.PCDcatid
		where r.PCDcatid = #SC.PCDcatid#
    </cfquery>
    
    <cfquery datasource="#session.DSN#" name="Signo">
    	select coalesce(SaldoInv,0) as SaldoInv 
        from CGDEstrProgVal        
        where PCDcatid = #SC.PCDcatid#
        and ID_DEstrCtaVal= #SC.ID_DEstrCtaVal#
    </cfquery>
    
	<cfquery datasource="#session.DSN#" result="Raul">
        update #saldoscuenta#
        set
        IngrEst = <cfif #Signo.SaldoInv#> 0 - coalesce(#Saldos.IngrEst#, 0.00) <cfelse> coalesce(#Saldos.IngrEst#, 0.00) </cfif>,
        Modific = <cfif #Signo.SaldoInv#> 0 - coalesce(#Saldos.Modific#, 0.00) <cfelse> coalesce(#Saldos.Modific#, 0.00) </cfif>,
        IngrMod = <cfif #Signo.SaldoInv#> 0 - coalesce(#Saldos.IngrMod#, 0.00) <cfelse> coalesce(#Saldos.IngrMod#, 0.00) </cfif>,
        IngrDev = <cfif #Signo.SaldoInv#> 0 - coalesce(#Saldos.IngrDev#, 0.00) <cfelse> coalesce(#Saldos.IngrDev#, 0.00) </cfif>,
        IngrRec = <cfif #Signo.SaldoInv#> 0 - coalesce(#Saldos.IngrRec#, 0.00) <cfelse> coalesce(#Saldos.IngrRec#, 0.00) </cfif>,
        ModificPer = <cfif #Signo.SaldoInv#> 0 - coalesce(#Saldos.ModificPer#, 0.00) <cfelse> coalesce(#Saldos.ModificPer#, 0.00) </cfif>
        where #saldoscuenta#.PCDcatid = #SC.PCDcatid#
    </cfquery>
</cfloop>

<!---<cf_dumptofile select="select * from #saldoscuenta#
    order by PCDcatid">
---> 
<!---<cf_dumptofile select="select * from #saldoscuenta#
    where ID_EstrCtaVal<>0
    order by PCDcatid">
--->
<!---<cf_dump var ="TOTALES">--->

<cfquery datasource="#session.DSN#" name="SC">
	select ID_GrupoCat,EPCPcodigo from #saldoscuenta#
    where ID_EstrCtaVal=0
    order by PCDcatid
</cfquery>
<cfloop query="SC">
	<cfquery datasource="#session.DSN#">
    update #saldoscuenta#
    set
    IngrEst = (select coalesce(sum(IngrEst), 0.00) from #saldoscuenta# where #saldoscuenta#.ID_GrupoCat = #SC.ID_GrupoCat# and #saldoscuenta#.ID_EstrCtaVal<>0),
    Modific = (select coalesce(sum(Modific), 0.00) from #saldoscuenta# where #saldoscuenta#.ID_GrupoCat = #SC.ID_GrupoCat# and #saldoscuenta#.ID_EstrCtaVal<>0),
    IngrMod = (select coalesce(sum(IngrMod), 0.00) from #saldoscuenta# where #saldoscuenta#.ID_GrupoCat = #SC.ID_GrupoCat# and #saldoscuenta#.ID_EstrCtaVal<>0),
    IngrDev = (select coalesce(sum(IngrDev), 0.00) from #saldoscuenta# where #saldoscuenta#.ID_GrupoCat = #SC.ID_GrupoCat# and #saldoscuenta#.ID_EstrCtaVal<>0),
    IngrRec = (select coalesce(sum(IngrRec), 0.00) from #saldoscuenta# where #saldoscuenta#.ID_GrupoCat = #SC.ID_GrupoCat# and #saldoscuenta#.ID_EstrCtaVal<>0),
    ModificPer = (select coalesce(sum(ModificPer), 0.00) from #saldoscuenta# where #saldoscuenta#.ID_GrupoCat = #SC.ID_GrupoCat# and #saldoscuenta#.ID_EstrCtaVal<>0)
    where #saldoscuenta#.ID_GrupoCat = #SC.ID_GrupoCat# and #saldoscuenta#.ID_EstrCtaVal=0
    </cfquery>
</cfloop>

<cfquery datasource="#session.DSN#" name="SC">
	select distinct left(EPCPcodigo,1) as EPCPcodigo from #saldoscuenta#
    where ID_EstrCtaVal=0
</cfquery>
<cfloop query="SC">    
	<cfquery datasource="#session.DSN#">
		insert into #saldoscuenta#(ID_GrupoCat, ID_EstrCtaVal, EPCPcodigo, Descripcion, ID_DEstrCtaVal, PCDcatid, Mcodigo, IngrEst, Modific, IngrMod, IngrDev, IngrRec, ModificPer)
		select 0, 0,min(left(EPCPcodigo,1)), 
        case min(left(EPCPcodigo,1))
        when '7' then 'INGRESOS POR VENTA DE BIENES Y SERVICIOS'
        when '8' then 'APORTACIONES'
        when '9' then 'TRANSFERENCIAS, ASIGNACIONES, SUBSIDIOS Y SUBVENCIONES RECIBIDOS'
        else ''
        end,
        0,0,#varMcodigo#,
        coalesce(sum(IngrEst), 0.00),coalesce(sum(Modific), 0.00),coalesce(sum(IngrMod), 0.00),coalesce(sum(IngrDev), 0.00),coalesce(sum(IngrRec), 0.00),coalesce(sum(ModificPer), 0.00)
        from #saldoscuenta# where #saldoscuenta#.ID_EstrCtaVal=0 and left(#saldoscuenta#.EPCPcodigo,1)= #SC.EPCPcodigo#
        
    </cfquery>
</cfloop>

<!---<cf_dumptofile select="select * from #saldoscuenta# order by EPCPcodigo">
--->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select Mnombre
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #varMcodigo#
</cfquery>

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select ID_GrupoCat,EPCPcodigo, Descripcion, Nota,
    coalesce(sum(IngrEst),0.00)/#varUnidad#  as IngrEst, 
    coalesce(sum(Modific),0.00)/#varUnidad#  as Modific, 
    coalesce(sum(IngrMod),0.00)/#varUnidad#  as IngrMod, 
    coalesce(sum(IngrDev),0.00)/#varUnidad#  as IngrDev, 
    coalesce(sum(IngrRec),0.00)/#varUnidad#  as IngrRec,
    coalesce(sum(ModificPer),0.00)/#varUnidad#  as ModificPer,
    case coalesce(sum(IngrMod),0.00)
        when 0 then 0
        else coalesce(sum(IngrRec),0.00)*100/(coalesce(sum(IngrMod),0.00))
	end as Avance  
    from #saldoscuenta#
	<cfif form.chkDetalle EQ "0">
    	where ID_GrupoCat = 0
    </cfif>        
	group by ID_GrupoCat,EPCPcodigo, Descripcion,Nota
    order by EPCPcodigo
</cfquery>
<!---<cf_dump var= #rsDetalle#>--->
<!---<cf_dumptofile select="select EPCPcodigo, Descripcion, coalesce(sum(IngrEst),0.00) ,coalesce(sum(Modific),0.00), coalesce(sum(IngrMod),0.00) ,coalesce(sum(IngrDev),0.00), coalesce(sum(IngrRec),0.00)
    from #saldoscuenta#
	group by EPCPcodigo, Descripcion
    order by EPCPcodigo">
--->


<cfset NotasPie1 = ''>
<cfset NotasPie2 = ''>
<cfset NotasPie3 = ''>
<cfset NotasPie4 = ''>
<cfset NotasPie5 = ''>
<cfset NotasPie6 = ''>
<cfset NotasPie7 = ''>
<cfset NotasPie8 = ''>
<cfset NotasPie9 = ''>
<cfset NotasPie10 = ''>
<cfset NotasPie11 = ''>
<cfset NotasPie12 = ''>
<cfset indice = 1>
<cfif form.chkDetalle neq "0">
    <cfquery name="rsNotas" datasource="#Session.DSN#">
        select coalesce(EPCPcodigoref,'') as EPCPcodigoref , coalesce(EPCPnota,'') as EPCPnota
        from dbo.CGEstrProgVal
        where EPCPcodigoref <> '' and ID_Estr = #rsNumEst.ID_Estr#
        and EPCPcodigoref in (select distinct Nota from #saldoscuenta#)
        union
        select coalesce(EPCPcodigoref,'') as EPCPcodigoref , coalesce(EPCPnota,'') as EPCPnota
        from dbo.CGGrupoCtasMayor
        where EPCPcodigoref <> '' and ID_Estr = #rsNumEst.ID_Estr#
        and EPCPcodigoref in (select distinct Nota from #saldoscuenta#)
        order by EPCPcodigoref
    </cfquery>
    <cfloop query="rsNotas">
		<cfswitch expression="#indice#">  
          	<cfcase value="1">
    			<cfset NotasPie1 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="2">
    			<cfset NotasPie2 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="3">
    			<cfset NotasPie3 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="4">
    			<cfset NotasPie4 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="5">
    			<cfset NotasPie5 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="6">
    			<cfset NotasPie6 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="7">
    			<cfset NotasPie7 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="8">
    			<cfset NotasPie8 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="9">
    			<cfset NotasPie9 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="10">
    			<cfset NotasPie10 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="11">
    			<cfset NotasPie11 = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
          	<cfcase value="12">
    			<cfset NotasPie12= #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
            </cfcase>
    	</cfswitch>
        <cfset indice = #indice# + 1>

<!---   <cfset NotasPie = #rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
		<cfset Codigo 	= #rsNotas.EPCPcodigoref# & RepeatString(' ',5)>
    	<cfset Linea 	= #rsNotas.EPCPnota# & RepeatString(' ',255)>
        <cfset NotasPie = #NotasPie#&#Left(Codigo,5)#&' '&#Left(Linea,255)#>
--->    
	</cfloop>
<cfelse>
	<cfset NotasPie = ''>
</cfif>

<cfif form.formato NEQ "HTML">
	<cfif #form.mensAcum# eq 1>
       <cfset LabelFechaFin = #LabelFechaFin#&' Mensual'>
    <cfelse>
       <cfset LabelFechaFin = #LabelFechaFin#&' Acumulado'>
    </cfif>
    <cfset vRubro = 0>
	<cfset TotalCampoA  = 0>
    <cfset TotalCampoB  = 0>
    <cfset TotalCampoC  = 0>
    <cfset TotalCampoD  = 0>
    <cfset TotalCampoE  = 0>
    <cfset TotalCampoF  = 0>

    <cfloop query="rsDetalle">
		<cfif rsdetalle.ID_GrupoCat eq 0>
            <cfset TotalCampoA = #TotalCampoA# + #rsdetalle.IngrEst#>
            <cfset TotalCampoB = #TotalCampoB# + #rsdetalle.Modific#>
            <cfset TotalCampoC = #TotalCampoC# + #rsdetalle.IngrMod#>
            <cfset TotalCampoD = #TotalCampoD# + #rsdetalle.IngrDev#>
            <cfset TotalCampoE = #TotalCampoE# + #rsdetalle.IngrRec#>
            <cfset TotalCampoF = #TotalCampoF# + #rsdetalle.ModificPer#>
        </cfif>
	</cfloop>
    <cfif (TotalCampoC) eq 0>
    	<cfset TotalAvance = 0> 
    <cfelse>
    	<cfset TotalAvance = TotalCampoE*100/(TotalCampoC)> 
    </cfif>
    <cfset TotalAvance = Abs(TotalAvance)>
 
    <cfreport format="#form.formato#" template= "EAnalIngrRT.cfr" query="rsDetalle">
    	<cfreportparam name="Edescripcion"	value="#rsNombreEmpresa.Edescripcion#">
        <cfreportparam name="periodo_ini" 	value="#LabelFechaFin#">
        <cfreportparam name="moneda" 		value="#rsMoneda.Mnombre#">
        <cfreportparam name="cveMoneda" 	value="#varMcodigo#">
        <cfreportparam name="Unidad"  		value="#varUnidad#">
        <cfreportparam name="TotalCampoA" 	value="#TotalCampoA#">
        <cfreportparam name="TotalCampoB" 	value="#TotalCampoB#">
        <cfreportparam name="TotalCampoC" 	value="#TotalCampoC#">
        <cfreportparam name="TotalCampoD" 	value="#TotalCampoD#">
        <cfreportparam name="TotalCampoE" 	value="#TotalCampoE#">
        <cfreportparam name="TotalAvance" 	value="#TotalAvance#">
        <cfreportparam name="TotalCampoF" 	value="#TotalCampoF#">
        <cfreportparam name="ChqDetalle" 	value="#form.chkDetalle#">
        <cfreportparam name="LB_NotaPie" 	value="#LB_NotaPie#">  
        <cfreportparam name="NotasPie1" 		value="#NotasPie1#"> 
        <cfreportparam name="NotasPie2" 		value="#NotasPie2#"> 
        <cfreportparam name="NotasPie3" 		value="#NotasPie3#"> 
        <cfreportparam name="NotasPie4" 		value="#NotasPie4#">
        <cfreportparam name="NotasPie5" 		value="#NotasPie5#"> 
        <cfreportparam name="NotasPie6" 		value="#NotasPie6#"> 
        <cfreportparam name="NotasPie7" 		value="#NotasPie7#"> 
        <cfreportparam name="NotasPie8" 		value="#NotasPie8#"> 
        <cfreportparam name="NotasPie9" 		value="#NotasPie9#"> 
        <cfreportparam name="NotasPie10" 		value="#NotasPie10#"> 
        <cfreportparam name="NotasPie11" 		value="#NotasPie11#"> 
        <cfreportparam name="NotasPie12" 		value="#NotasPie12#"> 
        <cfreportparam name="LB_Nota" 		value="#LB_Nota#">
    </cfreport> 
<cfelse>
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
                <td style="font-size:16px" align="center" colspan="7">
                <strong>#rsNombreEmpresa.Edescripcion#</strong>	
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="7">
                    <strong><cfif form.chkDetalle EQ "1">#MSG_RepAnyTipo#<cfelse>#MSG_ReporteAnalitico#</cfif></strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="7" nowrap="nowrap">
                <strong>Al #LabelFechaFin#&nbsp;
                <cfif #form.mensAcum# eq 1>
                	#LB_Mensual#
                <cfelse>
                	#LB_Acumulado#
                </cfif>
                </strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="7"><strong>(#MSG_Cifras_en# #rsMoneda.Mnombre#)</strong></td>
            </tr>
        </table>
		<table width="100%">
        	<tr>
                <td nowrap align="center"><strong>#LB_Rubro#</strong></td>
                <td nowrap align="center"><strong>#LB_Nota#</strong></td>
                <td nowrap align="center"><strong>#MSG_Ingresos#</strong></td>
                <td nowrap align="center"><strong>#MSG_Ampliaciones#</strong></td>
                <td nowrap align="center"><strong>#MSG_Ingresos#</strong></td>
                <td nowrap align="center"><strong>#MSG_Ingresos#</strong></td>
                <td nowrap align="center"><strong>#MSG_Ingresos#</strong></td>
                <td nowrap align="center"><strong>#MSG_Avance#</strong></td>
                <td nowrap align="center"><strong>#MSG_IngrPor#</strong></td>
            </tr>
            <tr>
            	<td nowrap align="center"><strong><!---#MSG_Ingresos#---></strong></td>
                <td></td>
                <td nowrap align="center"><strong>#MSG_Estimado#</strong></td>
                <td nowrap align="center"><strong>#MSG_Reduciones#</strong></td>
                <td nowrap align="center"><strong>#MSG_Modificado#</strong></td>
                <td nowrap align="center"><strong>#MSG_Devengado#</strong></td>
                <td nowrap align="center"><strong>#MSG_Recaudado#</strong></td>
                <td nowrap align="center"><strong>#MSG_dela#</strong></td>
                <td nowrap align="center"><strong>#MSG_Recaudar#</strong></td>                                
            </tr>
            <tr>
            	<td colspan="7">&nbsp;</td>
                <td nowrap align="center"><strong>#MSG_recaud#:</strong></td>
                <td nowrap align="center"><strong>#MSG_Modificado#</strong></td>
            </tr>
            <tr>
            	<td colspan="7">&nbsp;</td>
                <td nowrap align="center"><strong>#MSG_RecaudM# /</strong></td>
            	<td nowrap align="center"><strong>#MSG_Menos#</strong></td>
            </tr>
            <tr>
            	<td colspan="7">&nbsp;</td>
                <td nowrap align="center"><strong>#MSG__Modif#</strong></td>
            	<td nowrap align="center"><strong>#MSG_Recaudado#</strong></td>
            </tr>
            <cfset vRubro = 0>
            
	    <cfset TotalCampoA = 0>
            <cfset TotalCampoB = 0>
            <cfset TotalCampoC = 0>
            <cfset TotalCampoD = 0>
            <cfset TotalCampoE = 0>
            <cfset TotalCampoG = 0>
            <cfset TotIngModPer = 0>
            <cfloop query="rsDetalle">
<!---				<cfif vRubro neq rsDetalle.EPCPcodigo>
                	<cfset vRubro= #rsDetalle.EPCPcodigo#>
                    <tr>
                        <td nowrap align="left"><strong>#UCase(rsDetalle.EPCPcodigo)#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#UCase(rsDetalle.Descripcion)#</strong></td>
                    </tr>    
				</cfif>
--->                
				<tr>
                	<td>
                    	<table>
                        	<tr>
                            <strong>
                            <cfif len(rsDetalle.EPCPcodigo) lt 4>
                            	<td nowrap align="left">#UCase(rsDetalle.EPCPcodigo)#</td>
                            <cfelse>
                            	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </cfif>
							<td align="left">#rsDetalle.Descripcion#</td>
                            </strong>
                    		</tr>	
                    	</table>
                    </td>
                    <td nowrap align="center"><cfif #rsdetalle.Nota# gt 0>#rsdetalle.Nota#</cfif></td>
                    <cfif rsDetalle.EPCPcodigo eq '7.2' or left(rsDetalle.EPCPcodigo,1) eq '8' or left(rsDetalle.EPCPcodigo,1) eq '9'>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                    <cfelse>
                        <td nowrap align="right">#numberformat(rsdetalle.IngrEst, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.Modific, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.IngrMod, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.IngrDev, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.IngrRec, ",9.00")#</td>
                        <td nowrap align="right">
                            <cfif (rsdetalle.IngrMod) eq 0>
                                <cfset CampoF = 0>
                            <cfelse>
                                <cfset CampoF = #rsdetalle.IngrRec#/(#rsdetalle.IngrMod#)>
                                <cfset CampoF = CampoF * 100>
                            </cfif>
                            #numberformat(CampoF, ",9.00")#
                        </td>
                        <td nowrap align="right">#numberformat(rsdetalle.ModificPer - rsdetalle.IngrRec, ",9.00")#</td>                     
                    </cfif>
                </tr>
                <cfif rsdetalle.ID_GrupoCat eq 0>
					<cfset TotalCampoA = #TotalCampoA# + #rsdetalle.IngrEst#>
                    <cfset TotalCampoB = #TotalCampoB# + #rsdetalle.Modific#>
                    <cfset TotalCampoC = #TotalCampoC# + #rsdetalle.IngrMod#>
                    <cfset TotalCampoD = #TotalCampoD# + #rsdetalle.IngrDev#>
                    <cfset TotalCampoE = #TotalCampoE# + #rsdetalle.IngrRec#>
                    <cfset TotalCampoG = #TotalCampoG# + #rsdetalle.ModificPer# - #rsdetalle.IngrRec#>
                    <cfset TotIngModPer = #TotIngModPer# + #rsdetalle.ModificPer#>
                </cfif>
			</cfloop>
			<tr>
                <td align="right"><strong>TOTAL</strong></td>
                <td></td>
                <td nowrap align="right">#numberformat(TotalCampoA, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalCampoB, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalCampoC, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalCampoD, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalCampoE, ",9.00")#</td>
                <td nowrap align="right">
					<cfif (TotalCampoC) eq 0>
                        <cfset CampoF = 0>
                    <cfelse>
                        <cfset CampoF = #TotalCampoE#/(#TotalCampoC#)>
                        <cfset CampoF = CampoF * 100>
                    </cfif>
                    #numberformat(CampoF, ",9.00")#
                </td>   
                <td nowrap align="right">#numberformat(TotalCampoG, ",9.00")#</td>
            </tr>
			<cfif form.chkDetalle neq "0">
                <tr>
                    <td align="left" colspan="11">Notas:</td>
                </tr>
                <cfloop query="rsNotas">
                    <tr>
                        <td align="left" colspan="11">#rsNotas.EPCPcodigoref# #rsNotas.EPCPnota#</td>
                    </tr>
                </cfloop>
                
               <!--- <tr>
                    <td colspan="6">#LB_NotaPie#</td>
                </tr>--->
            </cfif>      
			 <tr>
                    <td colspan="6">#LB_NotaPie#</td>
                </tr>    
        </table>
    </cfoutput>
</cfif>