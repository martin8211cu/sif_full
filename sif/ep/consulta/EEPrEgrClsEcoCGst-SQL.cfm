<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 03-01-2013.
	Reporte Edo Ejerc Presupuesto Egresos por Clasif Económica y Cap del Gasto
 --->
<!---<cf_dump var=#url#>--->
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
<cfif isdefined("url.chkCeros")>
	<cfparam name="form.chkCeros" default="1">
<cfelse>
   	<cfparam name="form.chkCeros" default="0">  
</cfif>                   
</cfoutput>    
<cfset rsAnoMes = #form.periodo#&left("0"&#form.mes#,2)>
<cfquery name="rsCPPid" datasource="#Session.DSN#">
	select CPPid from CPresupuestoPeriodo
    where Ecodigo=#Session.Ecodigo#
    	and #rsAnoMes# between CPPanoMesDesde and CPPanoMesHasta
</cfquery>
<cfoutput>
<cfif rsCPPid.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuentas de la contabilidad presupuestaria para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
    <cfquery name="rsCuentas" datasource="#Session.DSN#"> 
        select distinct c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'E'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where Cmayor <> 'NULL' and c.CPTMtipoMov<>'D'
            order by c.Cmayor    
   	</cfquery>
     <cfloop query="rsCuentas">
<!---Verificación de las cuentas de mayor entre la estructura programática y la parametrización de la contabilidad presupuestaria--->
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

<cfquery name="rsCtaPres" datasource="#Session.DSN#"> 
    select Cmayor from  CPtipoMovContable c
    where c.Ecodigo = #Session.Ecodigo#
        and c.CPPid = #rsCPPid.CPPid#
        and c.CPCCtipo = 'E'
        and c.CPTMtipoMov = 'A'   
</cfquery>
<cfif rsCtaPres.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuenta Aprobación de Presupuesto Ordinario para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfset CtaPresAprob = #rsCtaPres.Cmayor#>
</cfif>
<cfquery name="rsCtaPres" datasource="#Session.DSN#"> 
    select Cmayor from  CPtipoMovContable c
    where c.Ecodigo = #Session.Ecodigo#
        and c.CPPid = #rsCPPid.CPPid#
        and c.CPCCtipo = 'E'
        and c.CPTMtipoMov = 'M'   
</cfquery>
<cfif rsCtaPres.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuenta Modificación de Presupuesto Extraordinario para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfset CtaModPresExtr = #rsCtaPres.Cmayor#>
</cfif>
<cfquery name="rsCtaPres" datasource="#Session.DSN#"> 
    select Cmayor from  CPtipoMovContable c
    where c.Ecodigo = #Session.Ecodigo#
        and c.CPPid = #rsCPPid.CPPid#
        and c.CPCCtipo = 'E'
        and c.CPTMtipoMov = 'CC'   
</cfquery>
<cfif rsCtaPres.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuenta Presupuesto Comprometido para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfset CtaPresCompr = #rsCtaPres.Cmayor#>
</cfif>
<cfquery name="rsCtaPres" datasource="#Session.DSN#"> 
    select Cmayor from  CPtipoMovContable c
    where c.Ecodigo = #Session.Ecodigo#
        and c.CPPid = #rsCPPid.CPPid#
        and c.CPCCtipo = 'E'
        and c.CPTMtipoMov = 'E'   
</cfquery>
<cfif rsCtaPres.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuenta Presupuesto Ejecutado para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfset CtaPresEjec = #rsCtaPres.Cmayor#>
</cfif>
<cfquery name="rsCtaPres" datasource="#Session.DSN#"> 
    select Cmayor from  CPtipoMovContable c
    where c.Ecodigo = #Session.Ecodigo#
        and c.CPPid = #rsCPPid.CPPid#
        and c.CPCCtipo = 'E'
        and c.CPTMtipoMov = 'RA'   
</cfquery>
<cfif rsCtaPres.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuenta Presupuesto Reservado para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfset CtaPresRes = #rsCtaPres.Cmayor#>
</cfif>
<cfquery name="rsCtaPres" datasource="#Session.DSN#"> 
    select Cmayor from  CPtipoMovContable c
    where c.Ecodigo = #Session.Ecodigo#
        and c.CPPid = #rsCPPid.CPPid#
        and c.CPCCtipo = 'E'
        and c.CPTMtipoMov = 'EJ'   
</cfquery>
<cfif rsCtaPres.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuenta Presupuesto Ejercido para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfset CtaPresEjer = #rsCtaPres.Cmayor#>
</cfif>
<cfquery name="rsCtaPres" datasource="#Session.DSN#"> 
    select Cmayor from  CPtipoMovContable c
    where c.Ecodigo = #Session.Ecodigo#
        and c.CPPid = #rsCPPid.CPPid#
        and c.CPCCtipo = 'E'
        and c.CPTMtipoMov = 'P'   
</cfquery>
<cfif rsCtaPres.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuenta Presupuesto Pagado para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfset CtaPresPag = #rsCtaPres.Cmayor#>
</cfif>

<!---<cfdump var ="#CtaPresAprob#">
<cfdump var ="#CtaModPresExtr#">
<cfdump var ="#CtaPresCompr#">
<cfdump var ="#CtaPresEjec#">
<cfdump var ="#CtaPresEjer#">
<cfdump var ="#CtaPresPag#">
<cfdump var ="#CtaPresRes#">
<c_dump var ="cuentas">
--->
<cfif isdefined('rsMensaje')>
	<cflocation url="EEPrClsEcoCGst.cfm?rsMensaje=#rsMensaje#">
</cfif>
</cfoutput>

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
    select e.Edescripcion,e.Mcodigo
    from Empresas e
    where e.Ecodigo = #session.Ecodigo#
</cfquery>
<cfif isdefined("form.mcodigoopt") and form.mcodigoopt EQ "0">
	<cfset varMcodigo = form.Mcodigo>
    <cfset varMonlocal= "false">
<cfelse>
	<cfset varMcodigo = #rsNombreEmpresa.Mcodigo#>
    <cfset varMonlocal= "true">
</cfif>

<cfif form.periodo lt year(NOW())>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes lt month(NOW())>
    	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>

<cfinvoke key="MSG_ReporteAnalitico" default="Estado del Ejercicio del Presupuesto de Egresos por Clasificaci&oacute;n Econ&oacute;mica y Cap&iacute;tulos del Gasto"	returnvariable="MSG_ReporteAnalitico"	
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
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en"					returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1>
<cfelseif #form.Unidad# eq 2>
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en miles de"		returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1000>
<cfelseif #form.Unidad# eq 3>
	<cfinvoke key="MSG_Cifras_en" 	default="Cifras en millones de"	returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 100000>
</cfif>
<cfinvoke key="LB_CtaMayor" 	default="Cuenta de Mayor"	returnvariable="LB_CtaMayor"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Clasific" 	default="Clasificaci&oacute;n Econ&oacute;mica"	returnvariable="LB_Clasific"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Capitulo" 		default="Cap&iacute;tulo del gasto"	returnvariable="LB_Capitulo"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejercicio" 	default="Ejercicio del presupuesto (Momentos"	returnvariable="LB_Ejercicio"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Conta" 		default="contables)"	returnvariable="LB_Conta"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Serv" 		default="Servicios"		returnvariable="LB_Serv"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pers" 		default="personales"	returnvariable="LB_Pers"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Mat" 		  	default="Materiales y"	returnvariable="LB_Mat"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Sumini"		default="suministros"	returnvariable="LB_Sumini"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_General"		default="generales"		returnvariable="LB_General"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Gastos"		default="Gastos de"		returnvariable="LB_Gastos"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Oper"			default="Operaci&oacute;n"		returnvariable="LB_Oper"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Otros"		default="Otros de corriente" returnvariable="LB_Otros"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pension"		default="Pensiones y" 	returnvariable="LB_Pension"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jubila"		default="Jubilaciones" 	returnvariable="LB_Jubila"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Corriente"	default="Gasto Corriente" 	returnvariable="LB_Corriente"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Bienes"		default="Bienes Muebles" 	returnvariable="LB_Bienes"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Inmuebles"	default="Inmuebles e" 	returnvariable="LB_Inmuebles"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Intang"		default="Intangibles" 	returnvariable="LB_Intang"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Otrosd"		default="Otros de" 		returnvariable="LB_Otrosd"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Inver"		default="Inversi&oacute;n" 	returnvariable="LB_Inver"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Gasto"		default="Gasto" 		returnvariable="LB_Gasto"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Progr"		default="Programable" 	returnvariable="LB_Progr"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_GastoC"		default="Gasto Corriente" 	returnvariable="LB_GastoC"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_GastoI"		default="Gasto de Inversi&oacute;n" 	returnvariable="LB_GastoI"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total"		default="Total" 		returnvariable="LB_Total"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Suma"			default="Suma" 		 	returnvariable="LB_Suma"	component="sif.Componentes.Translate" method="Translate"/>

<cfset LvarIrA = 'EEPrEgrClsEcoCGst.cfm'>
<cfset LvarFile = 'EEPrEgrClsEcoCGst'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
    <cf_dbtempcol name="ID_Estr"  		type="int">
    <cf_dbtempcol name="Seccion"  		type="int">
    <cf_dbtempcol name="CGEPCtaMayor"  	type="varchar(15)">
	<cf_dbtempcol name="CGEPDescrip"  	type="varchar(100)">
    <cf_dbtempcol name="TipoCta"  		type="varchar(1)">
    <cf_dbtempcol name="Mcodigo"  		type="integer">        
    <cf_dbtempcol name="Campo1000"  	type="money">
    <cf_dbtempcol name="Campo2000"  	type="money">
    <cf_dbtempcol name="Campo3000"  	type="money">
    <cf_dbtempcol name="Campo3900"  	type="money">
    <cf_dbtempcol name="Campo4000"  	type="money">
    <cf_dbtempcol name="Campo5000"  	type="money">
    <cf_dbtempcol name="Campo7200"  	type="money">
    <cf_dbtempkey cols="Seccion,CGEPCtaMayor,TipoCta">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    select ctm.ID_Estr,
    case ctm.CGEPCtaMayor
        when '#CtaPresAprob#' then 10 
        when '#CtaModPresExtr#' then 10
        when '#CtaPresRes#' then 20
        when '#CtaPresCompr#' then 30
        when '#CtaPresEjec#' then 40
        when '#CtaPresEjer#' then 50
        when '#CtaPresPag#' then 60
	end,
    case ctm.CGEPCtaMayor
    	when '#CtaModPresExtr#' then '#CtaModPresExtr# (Abono)'
    else
    	ctm.CGEPCtaMayor
    end,
    case ctm.CGEPCtaMayor
        when '#CtaPresAprob#' then 'PRESUPUESTO APROBADO'
        when '#CtaModPresExtr#' then 'AMPLIACIONES'
        when '#CtaPresRes#' then 'PRECOMPROMISOS'
        when '#CtaPresCompr#' then 'COMPROMETIDO'
        when '#CtaPresEjec#' then 'DEVENGADO'
        when '#CtaPresEjer#' then 'EJERCIDO'
        when '#CtaPresPag#' then 'PAGADO'
   else
        ctm.CGEPDescrip
    end,
    'A',#varMcodigo#,0 ,0 ,0 ,0 ,0,0,0
    from CGEstrProgCtaM ctm
        inner join CGReEstrProg r
        on ctm.ID_Estr= r.ID_Estr
            where r.SPcodigo='#session.menues.SPCODIGO#'
 </cfquery>
 <cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,10,'8231 (Cargo)','REDUCCIONES','C',#varMcodigo#,0 ,0 ,0 ,0 ,0,0,0)
 </cfquery>
 
<cfquery name="rsNumEst" datasource="#session.dsn#">
	select r.ID_Estr from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery> 

<cfinvoke returnvariable="rsEPQuery" component="sif.ep.componentes.EP_EstructuraRep" method="CG_EstructuraSaldo">
	<cfinvokeargument name="IDEstrPro"	value="#rsNumEst.ID_Estr#">
    <cfinvokeargument name="PerInicio" 	value="#form.periodo#">
    <cfinvokeargument name="MesInicio" 	value="#form.mes#">
    <cfinvokeargument name="PerFin" 	value="#form.periodo#">
    <cfinvokeargument name="MesFin" 	value="#form.mes#">
    <cfinvokeargument name="MonedaLoc" 	value="#varMonlocal#">
    <cfif not varMonlocal>
    	<cfinvokeargument name="Mcodigo" 	value="#varMcodigo#">
    </cfif>
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">    
</cfinvoke>
<!---<cf_dumptofile select="select * from #rsEPQuery# where PCDvalor<>''">--->

<!----Actualizar saldos ----->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by CGEPCtaMayor
</cfquery>
<cfloop query="SC">
    <cfquery datasource="#session.DSN#" name="Cmp_1000">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = #left(SC.CGEPCtaMayor,4)#
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='1000')
    </cfquery>
 	<cfif Cmp_1000.recordcount GT 0>
    	<cfset SLinicial_1000  = #Cmp_1000.SLinicial#>
        <cfset SOinicial_1000  = #Cmp_1000.SOinicial#>
        <cfset CLcreditos_1000 = #Cmp_1000.CLcreditos#>
        <cfset DLdebitos_1000  = #Cmp_1000.DLdebitos#>
        <cfset COcreditos_1000 = #Cmp_1000.COcreditos#>
        <cfset DOdebitos_1000  = #Cmp_1000.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_1000  = 0>
        <cfset SOinicial_1000  = 0>
        <cfset CLcreditos_1000 = 0>
        <cfset DLdebitos_1000  = 0>
        <cfset COcreditos_1000 = 0>
        <cfset DOdebitos_1000  = 0> 
    </cfif>
    <cfquery datasource="#session.DSN#" name="Cmp_2000">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = #left(SC.CGEPCtaMayor,4)#
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='2000')
    </cfquery>
 	<cfif Cmp_2000.recordcount GT 0>
    	<cfset SLinicial_2000  = #Cmp_2000.SLinicial#>
        <cfset SOinicial_2000  = #Cmp_2000.SOinicial#>
        <cfset CLcreditos_2000 = #Cmp_2000.CLcreditos#>
        <cfset DLdebitos_2000  = #Cmp_2000.DLdebitos#>
        <cfset COcreditos_2000 = #Cmp_2000.COcreditos#>
        <cfset DOdebitos_2000  = #Cmp_2000.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_2000  = 0>
        <cfset SOinicial_2000  = 0>
        <cfset CLcreditos_2000 = 0>
        <cfset DLdebitos_2000  = 0>
        <cfset COcreditos_2000 = 0>
        <cfset DOdebitos_2000  = 0> 
    </cfif>
    <cfquery datasource="#session.DSN#" name="Cmp_3000">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = #left(SC.CGEPCtaMayor,4)#
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='3000')
    </cfquery>
 	<cfif Cmp_3000.recordcount GT 0>
    	<cfset SLinicial_3000  = #Cmp_3000.SLinicial#>
        <cfset SOinicial_3000  = #Cmp_3000.SOinicial#>
        <cfset CLcreditos_3000 = #Cmp_3000.CLcreditos#>
        <cfset DLdebitos_3000  = #Cmp_3000.DLdebitos#>
        <cfset COcreditos_3000 = #Cmp_3000.COcreditos#>
        <cfset DOdebitos_3000  = #Cmp_3000.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_3000  = 0>
        <cfset SOinicial_3000  = 0>
        <cfset CLcreditos_3000 = 0>
        <cfset DLdebitos_3000  = 0>
        <cfset COcreditos_3000 = 0>
        <cfset DOdebitos_3000  = 0> 
    </cfif>
    <cfquery datasource="#session.DSN#" name="Cmp_3900">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = #left(SC.CGEPCtaMayor,4)#
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='3900')
    </cfquery>
 	<cfif Cmp_3900.recordcount GT 0>
    	<cfset SLinicial_3900  = #Cmp_3900.SLinicial#>
        <cfset SOinicial_3900  = #Cmp_3900.SOinicial#>
        <cfset CLcreditos_3900 = #Cmp_3900.CLcreditos#>
        <cfset DLdebitos_3900  = #Cmp_3900.DLdebitos#>
        <cfset COcreditos_3900 = #Cmp_3900.COcreditos#>
        <cfset DOdebitos_3900  = #Cmp_3900.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_3900  = 0>
        <cfset SOinicial_3900  = 0>
        <cfset CLcreditos_3900 = 0>
        <cfset DLdebitos_3900  = 0>
        <cfset COcreditos_3900 = 0>
        <cfset DOdebitos_3900  = 0> 
    </cfif>
    <cfquery datasource="#session.DSN#" name="Cmp_4000">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = #left(SC.CGEPCtaMayor,4)#
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='4000')
    </cfquery>
 	<cfif Cmp_4000.recordcount GT 0>
    	<cfset SLinicial_4000  = #Cmp_4000.SLinicial#>
        <cfset SOinicial_4000  = #Cmp_4000.SOinicial#>
        <cfset CLcreditos_4000 = #Cmp_4000.CLcreditos#>
        <cfset DLdebitos_4000  = #Cmp_4000.DLdebitos#>
        <cfset COcreditos_4000 = #Cmp_4000.COcreditos#>
        <cfset DOdebitos_4000  = #Cmp_4000.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_4000  = 0>
        <cfset SOinicial_4000  = 0>
        <cfset CLcreditos_4000 = 0>
        <cfset DLdebitos_4000  = 0>
        <cfset COcreditos_4000 = 0>
        <cfset DOdebitos_4000  = 0> 
    </cfif>
    <cfquery datasource="#session.DSN#" name="Cmp_5000">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = #left(SC.CGEPCtaMayor,4)#
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='5000')
    </cfquery>
 	<cfif Cmp_5000.recordcount GT 0>
    	<cfset SLinicial_5000  = #Cmp_5000.SLinicial#>
        <cfset SOinicial_5000  = #Cmp_5000.SOinicial#>
        <cfset CLcreditos_5000 = #Cmp_5000.CLcreditos#>
        <cfset DLdebitos_5000  = #Cmp_5000.DLdebitos#>
        <cfset COcreditos_5000 = #Cmp_5000.COcreditos#>
        <cfset DOdebitos_5000  = #Cmp_5000.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_5000  = 0>
        <cfset SOinicial_5000  = 0>
        <cfset CLcreditos_5000 = 0>
        <cfset DLdebitos_5000  = 0>
        <cfset COcreditos_5000 = 0>
        <cfset DOdebitos_5000  = 0> 
    </cfif>    
    
    <cfquery datasource="#session.DSN#" name="Cmp_7200">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = #left(SC.CGEPCtaMayor,4)#
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='7200')
    </cfquery>
 	<cfif Cmp_7200.recordcount GT 0>
    	<cfset SLinicial_7200  = #Cmp_7200.SLinicial#>
        <cfset SOinicial_7200  = #Cmp_7200.SOinicial#>
        <cfset CLcreditos_7200 = #Cmp_7200.CLcreditos#>
        <cfset DLdebitos_7200  = #Cmp_7200.DLdebitos#>
        <cfset COcreditos_7200 = #Cmp_7200.COcreditos#>
        <cfset DOdebitos_7200  = #Cmp_7200.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_7200  = 0>
        <cfset SOinicial_7200  = 0>
        <cfset CLcreditos_7200 = 0>
        <cfset DLdebitos_7200  = 0>
        <cfset COcreditos_7200 = 0>
        <cfset DOdebitos_7200  = 0> 
    </cfif>
    <cfif SC.CGEPCtaMayor neq '#CtaModPresExtr#'>
        <cfquery datasource="#session.DSN#">
        update #saldoscuenta#
        set
        Campo1000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_1000.DLdebitos#, 0.00)-coalesce(#Cmp_1000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_1000.DOdebitos#, 0.00)-coalesce(#Cmp_1000.COcreditos#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_1000.SLinicial#, 0.00)+coalesce(#Cmp_1000.DLdebitos#, 0.00)-coalesce(#Cmp_1000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_1000.SOinicial#, 0.00)+coalesce(#Cmp_1000.DOdebitos#, 0.00)-coalesce(#Cmp_1000.COcreditos#, 0.00)
            </cfif> 
        </cfif>),
        Campo2000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_2000.DLdebitos#, 0.00)-coalesce(#Cmp_2000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_2000.DOdebitos#, 0.00)-coalesce(#Cmp_2000.COcreditos#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_2000.SLinicial#, 0.00)+coalesce(#Cmp_2000.DLdebitos#, 0.00)-coalesce(#Cmp_2000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_2000.SOinicial#, 0.00)+coalesce(#Cmp_2000.DOdebitos#, 0.00)-coalesce(#Cmp_2000.COcreditos#, 0.00)
            </cfif> 
        </cfif>),
        Campo3000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_3000.DLdebitos#, 0.00)-coalesce(#Cmp_3000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_3000.DOdebitos#, 0.00)-coalesce(#Cmp_3000.COcreditos#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_3000.SLinicial#, 0.00)+coalesce(#Cmp_3000.DLdebitos#, 0.00)-coalesce(#Cmp_3000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_3000.SOinicial#, 0.00)+coalesce(#Cmp_3000.DOdebitos#, 0.00)-coalesce(#Cmp_3000.COcreditos#, 0.00)
            </cfif> 
        </cfif>),
        Campo3900 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_3900.DLdebitos#, 0.00)-coalesce(#Cmp_3900.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_3900.DOdebitos#, 0.00)-coalesce(#Cmp_3900.COcreditos#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_3900.SLinicial#, 0.00)+coalesce(#Cmp_3900.DLdebitos#, 0.00)-coalesce(#Cmp_3900.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_3900.SOinicial#, 0.00)+coalesce(#Cmp_3900.DOdebitos#, 0.00)-coalesce(#Cmp_3900.COcreditos#, 0.00)
            </cfif> 
        </cfif>),   
        Campo4000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_4000.DLdebitos#, 0.00)-coalesce(#Cmp_4000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_4000.DOdebitos#, 0.00)-coalesce(#Cmp_4000.COcreditos#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_4000.SLinicial#, 0.00)+coalesce(#Cmp_4000.DLdebitos#, 0.00)-coalesce(#Cmp_4000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_4000.SOinicial#, 0.00)+coalesce(#Cmp_4000.DOdebitos#, 0.00)-coalesce(#Cmp_4000.COcreditos#, 0.00)
            </cfif> 
        </cfif>),    
        Campo5000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_5000.DLdebitos#, 0.00)-coalesce(#Cmp_5000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_5000.DOdebitos#, 0.00)-coalesce(#Cmp_5000.COcreditos#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_5000.SLinicial#, 0.00)+coalesce(#Cmp_5000.DLdebitos#, 0.00)-coalesce(#Cmp_5000.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_5000.SOinicial#, 0.00)+coalesce(#Cmp_5000.DOdebitos#, 0.00)-coalesce(#Cmp_5000.COcreditos#, 0.00)
            </cfif> 
        </cfif>),    
        Campo7200 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_7200.DLdebitos#, 0.00)-coalesce(#Cmp_7200.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_7200.DOdebitos#, 0.00)-coalesce(#Cmp_7200.COcreditos#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#Cmp_7200.SLinicial#, 0.00)+coalesce(#Cmp_7200.DLdebitos#, 0.00)-coalesce(#Cmp_7200.CLcreditos#, 0.00)
            <cfelse>
                coalesce(#Cmp_7200.SOinicial#, 0.00)+coalesce(#Cmp_7200.DOdebitos#, 0.00)-coalesce(#Cmp_7200.COcreditos#, 0.00)
            </cfif> 
        </cfif>)
        where 
        left(#saldoscuenta#.CGEPCtaMayor,4) = #left(SC.CGEPCtaMayor,4)#
        </cfquery>
    <cfelse>
        <cfquery datasource="#session.DSN#">
        update #saldoscuenta#
        set
        Campo1000 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_1000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_1000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_1000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_1000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_1000.SLinicial#, 0.00)-coalesce(#Cmp_1000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_1000.SLinicial#, 0.00)+coalesce(#Cmp_1000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_1000.SOinicial#, 0.00)-coalesce(#Cmp_1000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_1000.SOinicial#, 0.00)+coalesce(#Cmp_1000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo2000 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_2000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_2000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_1000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_1000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_2000.SLinicial#, 0.00)-coalesce(#Cmp_2000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_2000.SLinicial#, 0.00)+coalesce(#Cmp_2000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_2000.SOinicial#, 0.00)-coalesce(#Cmp_2000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_2000.SOinicial#, 0.00)+coalesce(#Cmp_2000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo3000 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_3000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_3000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_3000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_3000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_3000.SLinicial#, 0.00)-coalesce(#Cmp_3000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_3000.SLinicial#, 0.00)+coalesce(#Cmp_3000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_3000.SOinicial#, 0.00)-coalesce(#Cmp_3000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_3000.SOinicial#, 0.00)+coalesce(#Cmp_3000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo3900 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_3900.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_3900.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_3900.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_3900.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_3900.SLinicial#, 0.00)-coalesce(#Cmp_3900.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_3900.SLinicial#, 0.00)+coalesce(#Cmp_3900.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_3900.SOinicial#, 0.00)-coalesce(#Cmp_3900.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_3900.SOinicial#, 0.00)+coalesce(#Cmp_3900.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo4000 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_4000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_4000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_4000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_4000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_4000.SLinicial#, 0.00)-coalesce(#Cmp_4000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_4000.SLinicial#, 0.00)+coalesce(#Cmp_4000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_4000.SOinicial#, 0.00)-coalesce(#Cmp_4000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_4000.SOinicial#, 0.00)+coalesce(#Cmp_4000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo5000 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_5000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_5000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_5000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_5000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_5000.SLinicial#, 0.00)-coalesce(#Cmp_5000.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_5000.SLinicial#, 0.00)+coalesce(#Cmp_5000.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_5000.SOinicial#, 0.00)-coalesce(#Cmp_5000.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_5000.SOinicial#, 0.00)+coalesce(#Cmp_5000.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo7200 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_7200.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_7200.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_7200.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_7200.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_7200.SLinicial#, 0.00)-coalesce(#Cmp_7200.CLcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_7200.SLinicial#, 0.00)+coalesce(#Cmp_7200.DLdebitos#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#Cmp_7200.SOinicial#, 0.00)-coalesce(#Cmp_7200.COcreditos#, 0.00)
				<cfelse>
                	coalesce(#Cmp_7200.SOinicial#, 0.00)+coalesce(#Cmp_7200.DOdebitos#, 0.00)
                </cfif>
            </cfif> 
        </cfif>
        where 
        left(#saldoscuenta#.CGEPCtaMayor,4) = #left(SC.CGEPCtaMayor,4)#
    	<cfif left(SC.CGEPCtaMayor,4) eq '#CtaModPresExtr#'>
        	and #saldoscuenta#.TipoCta = '#SC.TipoCta#'
        </cfif>
        </cfquery>
    </cfif>
</cfloop>

<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by Seccion
</cfquery>

<cfset PrVig1000 = 0>
<cfset PrVig2000 = 0>
<cfset PrVig3000 = 0>
<cfset PrVig3900 = 0>
<cfset PrVig4000 = 0>
<cfset PrVig5000 = 0>
<cfset PrVig7200 = 0>

<cfset PrVigSC1000 = 0>
<cfset PrVigSC2000 = 0>
<cfset PrVigSC3000 = 0>
<cfset PrVigSC3900 = 0>
<cfset PrVigSC4000 = 0>
<cfset PrVigSC5000 = 0>
<cfset PrVigSC7200 = 0>

<cfset PreSC1000 = 0>
<cfset PreSC2000 = 0>
<cfset PreSC3000 = 0>
<cfset PreSC3900 = 0>
<cfset PreSC4000 = 0>
<cfset PreSC5000 = 0>
<cfset PreSC7200 = 0>

<cfset PreDisp1000 = 0>
<cfset PreDisp2000 = 0>
<cfset PreDisp3000 = 0>
<cfset PreDisp3900 = 0>
<cfset PreDisp4000 = 0>
<cfset PreDisp5000 = 0>
<cfset PreDisp7200 = 0>

<cfset CompSD1000 = 0>
<cfset CompSD2000 = 0>
<cfset CompSD3000 = 0>
<cfset CompSD3900 = 0>
<cfset CompSD4000 = 0>
<cfset CompSD5000 = 0>
<cfset CompSD7200 = 0>

<cfset PrVigSD1000 = 0>
<cfset PrVigSD2000 = 0>
<cfset PrVigSD3000 = 0>
<cfset PrVigSD3900 = 0>
<cfset PrVigSD4000 = 0>
<cfset PrVigSD5000 = 0>
<cfset PrVigSD7200 = 0>

<cfset PreDevSE1000 = 0>
<cfset PreDevSE2000 = 0>
<cfset PreDevSE3000 = 0>
<cfset PreDevSE3900 = 0>
<cfset PreDevSE4000 = 0>
<cfset PreDevSE5000 = 0>
<cfset PreDevSE7200 = 0>

<cfset EjerSP1000 = 0>
<cfset EjerSP2000 = 0>
<cfset EjerSP3000 = 0>
<cfset EjerSP3900 = 0>
<cfset EjerSP4000 = 0>
<cfset EjerSP5000 = 0>
<cfset EjerSP7200 = 0>

<cfset CtasPP1000 = 0>
<cfset CtasPP2000 = 0>
<cfset CtasPP3000 = 0>
<cfset CtasPP3900 = 0>
<cfset CtasPP4000 = 0>
<cfset CtasPP5000 = 0>
<cfset CtasPP7200 = 0>
<cfloop query="SC">
	<cfif SC.CGEPCtaMayor eq '#CtaPresAprob#' or (SC.CGEPCtaMayor eq '#CtaModPresExtr#' and SC.TipoCta eq 'A')>
    	<cfset PrVig1000 = #PrVig1000# + #SC.Campo1000#>
    	<cfset PrVig2000 = #PrVig2000# + #SC.Campo2000#>
        <cfset PrVig3000 = #PrVig3000# + #SC.Campo3000#>
        <cfset PrVig3900 = #PrVig3900# + #SC.Campo3900#>
        <cfset PrVig4000 = #PrVig4000# + #SC.Campo4000#>
        <cfset PrVig5000 = #PrVig5000# + #SC.Campo5000#>
        <cfset PrVig7200 = #PrVig7200# + #SC.Campo7200#>
    </cfif> 
	<cfif SC.CGEPCtaMayor eq '#CtaModPresExtr#' and SC.TipoCta eq 'C'>
    	<cfset PrVig1000 = #PrVig1000# - #SC.Campo1000#>
    	<cfset PrVig2000 = #PrVig2000# - #SC.Campo2000#>
        <cfset PrVig3000 = #PrVig3000# - #SC.Campo3000#>
        <cfset PrVig3900 = #PrVig3900# - #SC.Campo3900#>
        <cfset PrVig4000 = #PrVig4000# - #SC.Campo4000#>
        <cfset PrVig5000 = #PrVig5000# - #SC.Campo5000#>
        <cfset PrVig7200 = #PrVig7200# - #SC.Campo7200#>
    </cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresRes#'>
    	<cfset PrVigSC1000 = #PrVigSC1000# + #SC.Campo1000#>
    	<cfset PrVigSC2000 = #PrVigSC2000# + #SC.Campo2000#>
        <cfset PrVigSC3000 = #PrVigSC3000# + #SC.Campo3000#>
        <cfset PrVigSC3900 = #PrVigSC3900# + #SC.Campo3900#>
        <cfset PrVigSC4000 = #PrVigSC4000# + #SC.Campo4000#>
        <cfset PrVigSC5000 = #PrVigSC5000# + #SC.Campo5000#>
        <cfset PrVigSC7200 = #PrVigSC7200# + #SC.Campo7200#>
        
        
    	<cfset PreSC1000 = #PreSC1000# + #SC.Campo1000#>
    	<cfset PreSC2000 = #PreSC2000# + #SC.Campo2000#>
        <cfset PreSC3000 = #PreSC3000# + #SC.Campo3000#>
        <cfset PreSC3900 = #PreSC3900# + #SC.Campo3900#>
        <cfset PreSC4000 = #PreSC4000# + #SC.Campo4000#>
        <cfset PreSC5000 = #PreSC5000# + #SC.Campo5000#>
        <cfset PreSC7200 = #PreSC7200# + #SC.Campo7200#>
        
    </cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresCompr#'>
    	<cfset PreSC1000 = #PreSC1000# - #SC.Campo1000#>
    	<cfset PreSC2000 = #PreSC2000# - #SC.Campo2000#>
        <cfset PreSC3000 = #PreSC3000# - #SC.Campo3000#>
        <cfset PreSC3900 = #PreSC3900# - #SC.Campo3900#>
        <cfset PreSC4000 = #PreSC4000# - #SC.Campo4000#>
        <cfset PreSC5000 = #PreSC5000# - #SC.Campo5000#>
        <cfset PreSC7200 = #PreSC7200# - #SC.Campo7200#>
        
        <cfset PreDisp1000 = #PreDisp1000# + #SC.Campo1000#>
    	<cfset PreDisp2000 = #PreDisp2000# + #SC.Campo2000#>
        <cfset PreDisp3000 = #PreDisp3000# + #SC.Campo3000#>
        <cfset PreDisp3900 = #PreDisp3900# + #SC.Campo3900#>
        <cfset PreDisp4000 = #PreDisp4000# + #SC.Campo4000#>
        <cfset PreDisp5000 = #PreDisp5000# + #SC.Campo5000#>
        <cfset PreDisp7200 = #PreDisp7200# + #SC.Campo7200#>
        
        <cfset CompSD1000 = #CompSD1000# + #SC.Campo1000#>
    	<cfset CompSD2000 = #CompSD2000# + #SC.Campo2000#>
        <cfset CompSD3000 = #CompSD3000# + #SC.Campo3000#>
        <cfset CompSD3900 = #CompSD3900# + #SC.Campo3900#>
        <cfset CompSD4000 = #CompSD4000# + #SC.Campo4000#>
        <cfset CompSD5000 = #CompSD5000# + #SC.Campo5000#>
        <cfset CompSD7200 = #CompSD7200# + #SC.Campo7200#>
	</cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresEjec#'>
        <cfset PrVigSD1000 = #PrVig1000# - #SC.Campo1000#>
    	<cfset PrVigSD2000 = #PrVig2000# - #SC.Campo2000#>
        <cfset PrVigSD3000 = #PrVig3000# - #SC.Campo3000#>
        <cfset PrVigSD3900 = #PrVig3900# - #SC.Campo3900#>
        <cfset PreDisp4000 = #PrVig4000# - #SC.Campo4000#>
        <cfset PrVigSD5000 = #PrVig5000# - #SC.Campo5000#>
        <cfset PrVigSD7200 = #PrVig7200# - #SC.Campo7200#>
        
        <cfset CompSD1000 = #CompSD1000# - #SC.Campo1000#>
    	<cfset CompSD2000 = #CompSD2000# - #SC.Campo2000#>
        <cfset CompSD3000 = #CompSD3000# - #SC.Campo3000#>
        <cfset CompSD3900 = #CompSD3900# - #SC.Campo3900#>
        <cfset CompSD4000 = #CompSD4000# - #SC.Campo4000#>
        <cfset CompSD5000 = #CompSD5000# - #SC.Campo5000#>
        <cfset CompSD7200 = #CompSD7200# - #SC.Campo7200#>
        
		<cfset PreDevSE1000 = #PreDevSE1000# + #SC.Campo1000#>
        <cfset PreDevSE2000 = #PreDevSE2000# + #SC.Campo2000#>
        <cfset PreDevSE3000 = #PreDevSE3000# + #SC.Campo3000#>
        <cfset PreDevSE3900 = #PreDevSE3900# + #SC.Campo3900#>
        <cfset PreDevSE4000 = #PreDevSE4000# + #SC.Campo4000#>
        <cfset PreDevSE5000 = #PreDevSE5000# + #SC.Campo5000#>
        <cfset PreDevSE7200 = #PreDevSE7200# + #SC.Campo7200#>
        
        <cfset CtasPP1000 = #CtasPP1000# + #SC.Campo1000#>
		<cfset CtasPP2000 = #CtasPP2000# + #SC.Campo2000#>
        <cfset CtasPP3000 = #CtasPP3000# + #SC.Campo3000#>
        <cfset CtasPP3900 = #CtasPP3900# + #SC.Campo3900#>
        <cfset CtasPP4000 = #CtasPP4000# + #SC.Campo4000#>
        <cfset CtasPP5000 = #CtasPP5000# + #SC.Campo5000#>
        <cfset CtasPP7200 = #CtasPP7200# + #SC.Campo7200#>
    </cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresEjer#'>
		<cfset PreDevSE1000 = #PreDevSE1000# - #SC.Campo1000#>
        <cfset PreDevSE2000 = #PreDevSE2000# - #SC.Campo2000#>
        <cfset PreDevSE3000 = #PreDevSE3000# - #SC.Campo3000#>
        <cfset PreDevSE3900 = #PreDevSE3900# - #SC.Campo3900#>
        <cfset PreDevSE4000 = #PreDevSE4000# - #SC.Campo4000#>
        <cfset PreDevSE5000 = #PreDevSE5000# - #SC.Campo5000#>
        <cfset PreDevSE7200 = #PreDevSE7200# - #SC.Campo7200#>
        
        <cfset EjerSP1000 = #EjerSP1000# + #SC.Campo1000#>
		<cfset EjerSP2000 = #EjerSP2000# + #SC.Campo2000#>
        <cfset EjerSP3000 = #EjerSP3000# + #SC.Campo3000#>
        <cfset EjerSP3900 = #EjerSP3900# + #SC.Campo3900#>
        <cfset EjerSP4000 = #EjerSP4000# + #SC.Campo4000#>
        <cfset EjerSP5000 = #EjerSP5000# + #SC.Campo5000#>
        <cfset EjerSP7200 = #EjerSP7200# + #SC.Campo7200#>

    </cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresPag#'>
        <cfset EjerSP1000 = #EjerSP1000# - #SC.Campo1000#>
		<cfset EjerSP2000 = #EjerSP2000# - #SC.Campo2000#>
        <cfset EjerSP3000 = #EjerSP3000# - #SC.Campo3000#>
        <cfset EjerSP3900 = #EjerSP3900# - #SC.Campo3900#>
        <cfset EjerSP4000 = #EjerSP4000# - #SC.Campo4000#>
        <cfset EjerSP5000 = #EjerSP5000# - #SC.Campo5000#>
        <cfset EjerSP7200 = #EjerSP7200# - #SC.Campo7200#> 
         
        <cfset CtasPP1000 = #CtasPP1000# - #SC.Campo1000#>
		<cfset CtasPP2000 = #CtasPP2000# - #SC.Campo2000#>
        <cfset CtasPP3000 = #CtasPP3000# - #SC.Campo3000#>
        <cfset CtasPP3900 = #CtasPP3900# - #SC.Campo3900#>
        <cfset CtasPP4000 = #CtasPP4000# - #SC.Campo4000#>
        <cfset CtasPP5000 = #CtasPP5000# - #SC.Campo5000#>
        <cfset CtasPP7200 = #CtasPP7200# - #SC.Campo7200#>
    </cfif>
</cfloop>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,11,'','PRESUPUESTO VIGENTE','A',#varMcodigo#,#PrVig1000#,#PrVig2000#,#PrVig3000#,#PrVig3900#,#PrVig4000#,
    #PrVig5000#,#PrVig7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,21,'','PRESUPUESTO VIGENTE SIN PRECOMPROMETER','A',#varMcodigo#,
    #PrVig1000#-(#PrVigSC1000#),#PrVig2000#-(#PrVigSC2000#),
    #PrVig3000#-(#PrVigSC3000#),#PrVig3900#-(#PrVigSC3900#),
    #PrVig4000#-(#PrVigSC4000#),#PrVig5000#-(#PrVigSC5000#),
    #PrVig7200#-(#PrVigSC7200#))
</cfquery>

<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,31,'','PRECOMPROMISOS SIN COMPROMETER','A',#varMcodigo#,#PreSC1000#,#PreSC2000#,#PreSC3000#,#PreSC3900#,#PreSC4000#,
    #PreSC5000#,#PreSC7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,32,'','PRESUPUESTO DISPONIBLE PARA COMPROMETER','A',#varMcodigo#,
    #PreDisp1000#-(#PrVig1000#),#PreDisp2000#-(#PrVig2000#),
    #PreDisp3000#-(#PrVig3000#),#PreDisp3900#-(#PrVig3900#),
    #PreDisp4000#-(#PrVig4000#),#PreDisp5000#-(#PrVig5000#),
    #PreDisp7200#-(#PrVig7200#))
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,41,'','COMPROMISO SIN DEVENGAR','A',#varMcodigo#,#CompSD1000#,#CompSD2000#,#CompSD3000#,#CompSD3900#,#CompSD4000#,
    #CompSD5000#,#CompSD7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,42,'','PRESUPUESTO VIGENTE SIN DEVENGAR','A',#varMcodigo#,#PrVigSD1000#,#PrVigSD2000#,#PrVigSD3000#,#PrVigSD3900#,#PrVigSD4000#,
    #PrVigSD5000#,#PrVigSD7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,51,'','DEVENGADO SIN EJERCER','A',#varMcodigo#,#PreDevSE1000#,#PreDevSE2000#,#PreDevSE3000#,#PreDevSE3900#,#PreDevSE4000#,
    #PreDevSE5000#,#PreDevSE7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,61,'','EJERCIDO SIN PAGAR','A',#varMcodigo#,#EjerSP1000#,#EjerSP2000#,#EjerSP3000#,#EjerSP3900#,#EjerSP4000#,
    #EjerSP5000#,#EjerSP7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,71,'','CUENTAS POR PAGAR','A',#varMcodigo#,#CtasPP1000#,#CtasPP2000#,#CtasPP3000#,#CtasPP3900#,#CtasPP4000#,
    #CtasPP5000#,#CtasPP7200#)
</cfquery>
<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select
        case Mnombre
        when 'Mexico, Peso' then 'Pesos'
        else Mnombre
	end as Mnombre  
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #varMcodigo#
</cfquery>

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select Seccion,s.CGEPCtaMayor,CGEPDescrip,Mcodigo,
    Campo1000/#varUnidad# as Campo1000,
    Campo2000/#varUnidad# as Campo2000,
    Campo3000/#varUnidad# as Campo3000,
    Campo3900/#varUnidad# as Campo3900,
    Campo4000/#varUnidad# as Campo4000, 
    Campo5000/#varUnidad# as Campo5000,
    Campo7200/#varUnidad# as Campo7200,
    Campo2000+Campo3000   as SGOper,
    Campo1000+Campo2000+Campo3000+Campo3900+Campo4000 as SGCorr,
    Campo5000+Campo3900+Campo7200 as SGInv,
    Campo1000+Campo2000+Campo3000+Campo3900+Campo4000+Campo5000+Campo3900+Campo7200 as SGProg
    from #saldoscuenta# s
    <cfif form.chkCeros eq '0'>
    where s.Campo1000 <> 0 or
    	 s.Campo2000 <> 0 or
         s.Campo3000 <> 0 or
         s.Campo3900 <> 0 or
         s.Campo4000 <> 0 or
         s.Campo5000 <> 0 or
         s.Campo7200 <> 0
    </cfif>   
    
<!---    inner join CGEstrProgVal c
    on c.ID_EstrCtaVal=s.ID_EstrCtaVal
    inner join PCDCatalogo p
       on p.PCDcatid=s.PCDcatid
--->    
	order by s.Seccion
</cfquery>

<!---<cf_dump var= #rsDetalle#>--->

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
    select e.Edescripcion,e.Mcodigo
    from Empresas e
    where e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfif form.formato NEQ "HTML">
	<cfif #form.mensAcum# eq 1>
       <cfset LabelFechaFin = #LabelFechaFin#&' Mensual'>
    <cfelse>
       <cfset LabelFechaFin = #LabelFechaFin#&' Acumulado'>
    </cfif>
    <cfreport format="#form.formato#" template= "EEPrEgrClsEcoCGst.cfr" query="rsDetalle">
        <cfreportparam name="periodo_ini" 	value="#LabelFechaFin#">
        <cfreportparam name="moneda" 		value="#rsMoneda.Mnombre#">
        <cfreportparam name="cveMoneda" 	value="#rsNombreEmpresa.Mcodigo#">
        <cfreportparam name="Unidad"  		value="#varUnidad#">
        <cfreportparam name="Edescripcion"	value="#rsNombreEmpresa.Edescripcion#">	
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
                    <strong>#MSG_ReporteAnalitico#</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="7" nowrap="nowrap">
                <strong>Al&nbsp;#LabelFechaFin#&nbsp;
                <cfif #form.mensAcum# eq 1>
                	Mensual
                <cfelse>
                	Acumulado
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
                <td align="center" rowspan="5" valign="middle"><strong>#LB_CtaMayor#</strong></td>
                <td align="left"><strong>#LB_Clasific#</strong></td>
                <td align="center" colspan="7"><strong>#LB_GastoC#</strong></td>
                <td align="center" colspan="2"><strong>#LB_GastoI#</strong></td>
                <td>&nbsp;</td>
                <td align="center" rowspan="2" valign="middle"><strong>#LB_Total#</strong></td>
            </tr>
            <tr>
                <td align="left"><strong>#LB_Capitulo#</strong></td>
                <td align="center"><strong>1000</strong></td>
                <td align="center"><strong>2000</strong></td>
                <td align="center"><strong>3000</strong></td>
                <td align="center"><strong>#LB_Suma#</strong></td>
                <td align="center"><strong>3900</strong></td>
				<td align="center"><strong>4000</strong></td>
                <td align="center"><strong>#LB_Suma#</strong></td>
                <td align="center"><strong>5000</strong></td>
				<td align="center"><strong>3900 y 7200</strong></td>
                <td align="center"><strong>#LB_Suma#</strong></td>
            </tr>
            <tr>
                <td align="left"><strong>#LB_Ejercicio#</strong></td>
                <td align="center"><strong>#LB_Serv#</strong></td>
                <td align="center"><strong>#LB_Mat#</strong></td>
                <td align="center"><strong>#LB_Serv#</strong></td>
                <td align="center"><strong>#LB_Gastos#</strong></td>
                <td align="center"><strong>#LB_Otros#</strong></td>
				<td align="center"><strong>#LB_Pension#</strong></td>
                <td align="center"><strong>#LB_Corriente#</strong></td> 
                <td align="center"><strong>#LB_Bienes#</strong></td>
				<td align="center"><strong>#LB_Otrosd#</strong></td>
                <td align="center"><strong>#LB_Gastos#</strong></td>
                <td align="center"><strong>#LB_Gasto#</strong></td>
			</tr>            
            <tr>
                <td align="left"><strong>#LB_Conta#</strong></td>
                <td align="center"><strong>#LB_Pers#</strong></td>
                <td align="center"><strong>#LB_Sumini#</strong></td>
                <td align="center"><strong>#LB_General#</strong></td>
                <td align="center"><strong>#LB_Oper#</strong></td>
                <td align="center"><strong>&nbsp;</strong></td>
				<td align="center"><strong>#LB_Jubila#</strong></td>
                <td align="center"><strong>&nbsp;</strong></td>
                <td align="center"><strong>#LB_Inmuebles#</strong></td>
				<td align="center"><strong>#LB_Inver#</strong></td>
                <td align="center"><strong>#LB_Inver#</strong></td>
                <td align="center"><strong>#LB_Progr#</strong></td>
			</tr>            
            <tr>
                <td align="left">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
				<td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center"><strong>#LB_Intang#</strong></td>
				<td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
                <td align="center">&nbsp;</td>
			</tr>     
                     
            <cfloop query="rsDetalle">
				<tr>
                	<td nowrap align="left">#UCase(rsDetalle.CGEPCtaMayor)#</td>
					<td nowrap align="left">#UCase(rsDetalle.CGEPDescrip)#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo1000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo2000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo3000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo2000+rsdetalle.Campo3000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo3900, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo4000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo1000+rsdetalle.Campo2000+rsdetalle.Campo3000+rsdetalle.Campo3900+rsdetalle.Campo4000,",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo5000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo7200, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo5000+rsdetalle.Campo7200, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo1000+rsdetalle.Campo2000+rsdetalle.Campo3000+
                        rsdetalle.Campo3900+rsdetalle.Campo4000+rsdetalle.Campo5000+rsdetalle.Campo7200,",9.00")#
                    </td>
            	</tr>
			</cfloop>
        </table>
    </cfoutput>
</cfif>