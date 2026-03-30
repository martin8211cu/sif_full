<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 15-02-2013.
	Reporte Estado del Ejercicio del Presupuesto por Clasificación Funcional
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
<cf_dump var ="cuentas">
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

<cfinvoke key="MSG_ReporteAnalitico" default="Estado del Ejercicio del Presupuesto por Clasificaci&oacute;n Funcional"	returnvariable="MSG_ReporteAnalitico"	
component="sif.Componentes.Translate" method="Translate"/>

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
<cfinvoke key="LB_CtaMayor" default="Cuenta de Mayor"			returnvariable="LB_CtaMayor"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejerc" 	default="Ejercicio del Presupuesto"	returnvariable="LB_Ejerc"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Momentos" default="(Momentos contables)"	returnvariable="LB_Momentos"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Finalidad" 	default="Finalidad"		returnvariable="LB_Finalidad"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Funcion" 		default="Funcion"		returnvariable="LB_Funcion"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SubFuncion" 	default="SubFuncion"	returnvariable="LB_SubFuncion"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total"		default="Total" 		returnvariable="LB_Total"	component="sif.Componentes.Translate" method="Translate"/>

<cfset LvarIrA 	= 'EEPreClsFunc.cfm'>
<cfset LvarFile = 'EEPreClsFunc'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
    <cf_dbtempcol name="ID_Estr"  		type="int">
    <cf_dbtempcol name="Seccion"  		type="int">
    <cf_dbtempcol name="CGEPCtaMayor"  	type="varchar(4)">
	<cf_dbtempcol name="CGEPDescrip"  	type="varchar(100)">
    <cf_dbtempcol name="TipoCta"  		type="varchar(1)">
    <cf_dbtempcol name="Mcodigo"  		type="integer">        
    <cf_dbtempcol name="Campo1000"  	type="money">
    <cf_dbtempcol name="Campo2000"  	type="money">
    <cf_dbtempkey cols="Seccion,CGEPCtaMayor,TipoCta">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
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
    ctm.CGEPCtaMayor,
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
    'A',#varMcodigo#,0 ,0
    from CGEstrProgCtaM ctm
        inner join CGReEstrProg r
        on ctm.ID_Estr= r.ID_Estr
            where r.SPcodigo='#session.menues.SPCODIGO#'
 </cfquery>
 <cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,10,'#CtaModPresExtr#','REDUCCIONES','C',#varMcodigo#,0 ,0)
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

<!---<cf_dumptofile select="select r.*, left(epv.EPCPcodigo,4) as EPCPcodigo, pcc.PCCDvalor from #rsEPQuery# r 
        inner join PCClasificacionD pcc
        on r.ClasCatCon = pcc.PCCDclaid
        inner join CGEstrProgVal epv
        on r.ID_EstrCtaVal= epv.ID_EstrCtaVal">--->
        
<!---where PCDvalor<>''--->

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
        inner join PCClasificacionD pcc
        on r.ClasCatCon = pcc.PCCDclaid
		where r.Cmayor = #SC.CGEPCtaMayor#
        and pcc.PCCDvalor='O001'
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
        inner join PCClasificacionD pcc
        on r.ClasCatCon = pcc.PCCDclaid
		where r.Cmayor = #SC.CGEPCtaMayor#
        and pcc.PCCDvalor in ('M001','J007','W001','E527')
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
    <cfif SC.CGEPCtaMayor neq '#CtaModPresExtr#'>
        <cfquery datasource="#session.DSN#">
        update #saldoscuenta#
        set
        Campo1000 =
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
        </cfif>,
        Campo2000 =
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
        </cfif>
        where 
        #saldoscuenta#.CGEPCtaMayor = #SC.CGEPCtaMayor#
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
        </cfif>
		
        where 
        #saldoscuenta#.CGEPCtaMayor = #SC.CGEPCtaMayor#
    	<cfif SC.CGEPCtaMayor eq '#CtaModPresExtr#'>
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

<cfset PrVigSC1000 = 0>
<cfset PrVigSC2000 = 0>

<cfset PreSC1000 = 0>
<cfset PreSC2000 = 0>

<cfset PreDisp1000 = 0>
<cfset PreDisp2000 = 0>

<cfset CompSD1000 = 0>
<cfset CompSD2000 = 0>

<cfset PrVigSD1000 = 0>
<cfset PrVigSD2000 = 0>

<cfset PreDevSE1000 = 0>
<cfset PreDevSE2000 = 0>

<cfset EjerSP1000 = 0>
<cfset EjerSP2000 = 0>

<cfset CtasPP1000 = 0>
<cfset CtasPP2000 = 0>

<cfloop query="SC">
	<cfif SC.CGEPCtaMayor eq '#CtaPresAprob#' or (SC.CGEPCtaMayor eq '#CtaModPresExtr#' and SC.TipoCta eq 'A')>
    	<cfset PrVig1000 = #PrVig1000# + #SC.Campo1000#>
    	<cfset PrVig2000 = #PrVig2000# + #SC.Campo2000#>
    </cfif> 
	<cfif SC.CGEPCtaMayor eq '#CtaModPresExtr#' and SC.TipoCta eq 'C'>
    	<cfset PrVig1000 = #PrVig1000# - #SC.Campo1000#>
    	<cfset PrVig2000 = #PrVig2000# - #SC.Campo2000#>
    </cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresRes#'>
    	<cfset PrVigSC1000 = #PrVigSC1000# + #SC.Campo1000#>
    	<cfset PrVigSC2000 = #PrVigSC2000# + #SC.Campo2000#>        
        
    	<cfset PreSC1000 = #PreSC1000# + #SC.Campo1000#>
    	<cfset PreSC2000 = #PreSC2000# + #SC.Campo2000#>
    </cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresCompr#'>
    	<cfset PreSC1000 = #PreSC1000# - #SC.Campo1000#>
    	<cfset PreSC2000 = #PreSC2000# - #SC.Campo2000#>
        
        <cfset PreDisp1000 = #PreDisp1000# + #SC.Campo1000#>
    	<cfset PreDisp2000 = #PreDisp2000# + #SC.Campo2000#>
        
        <cfset CompSD1000 = #CompSD1000# + #SC.Campo1000#>
    	<cfset CompSD2000 = #CompSD2000# + #SC.Campo2000#>
	</cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresEjec#'>
        <cfset PrVigSD1000 = #PrVig1000# - #SC.Campo1000#>
    	<cfset PrVigSD2000 = #PrVig2000# - #SC.Campo2000#>
        
        <cfset CompSD1000 = #CompSD1000# - #SC.Campo1000#>
    	<cfset CompSD2000 = #CompSD2000# - #SC.Campo2000#>
        
		<cfset PreDevSE1000 = #PreDevSE1000# + #SC.Campo1000#>
        <cfset PreDevSE2000 = #PreDevSE2000# + #SC.Campo2000#>
        
        <cfset CtasPP1000 = #CtasPP1000# + #SC.Campo1000#>
		<cfset CtasPP2000 = #CtasPP2000# + #SC.Campo2000#>
    </cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresEjer#'>
		<cfset PreDevSE1000 = #PreDevSE1000# - #SC.Campo1000#>
        <cfset PreDevSE2000 = #PreDevSE2000# - #SC.Campo2000#>
        
        <cfset EjerSP1000 = #EjerSP1000# + #SC.Campo1000#>
		<cfset EjerSP2000 = #EjerSP2000# + #SC.Campo2000#>

    </cfif>
	<cfif SC.CGEPCtaMayor eq '#CtaPresPag#'>
        <cfset EjerSP1000 = #EjerSP1000# - #SC.Campo1000#>
		<cfset EjerSP2000 = #EjerSP2000# - #SC.Campo2000#>
         
        <cfset CtasPP1000 = #CtasPP1000# - #SC.Campo1000#>
		<cfset CtasPP2000 = #CtasPP2000# - #SC.Campo2000#>
    </cfif>
</cfloop>

<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,11,'','PRESUPUESTO VIGENTE','A',#varMcodigo#,#PrVig1000#,#PrVig2000#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,21,'','PRESUPUESTO VIGENTE SIN PRECOMPROMETER','A',#varMcodigo#,
    #PrVig1000#-(#PrVigSC1000#),#PrVig2000#-(#PrVigSC2000#))
</cfquery>

<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,31,'','PRECOMPROMISOS SIN COMPROMETER','A',#varMcodigo#,#PreSC1000#,#PreSC2000#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,32,'','PRESUPUESTO DISPONIBLE PARA COMPROMETER','A',#varMcodigo#,
    #PreDisp1000#-(#PrVig1000#),#PreDisp2000#-(#PrVig2000#))
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,41,'','COMPROMISO SIN DEVENGAR','A',#varMcodigo#,#CompSD1000#,#CompSD2000#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,42,'','PRESUPUESTO VIGENTE SIN DEVENGAR','A',#varMcodigo#,#PrVigSD1000#,#PrVigSD2000#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,51,'','DEVENGADO SIN EJERCER','A',#varMcodigo#,#PreDevSE1000#,#PreDevSE2000#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,61,'','EJERCIDO SIN PAGAR','A',#varMcodigo#,#EjerSP1000#,#EjerSP2000#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000)
    values(4,71,'','CUENTAS POR PAGAR','A',#varMcodigo#,#CtasPP1000#,#CtasPP2000#)
</cfquery>
<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select Mnombre
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #varMcodigo#
</cfquery>

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select Seccion,s.CGEPCtaMayor,CGEPDescrip,Mcodigo,
    Campo1000/#varUnidad# as Campo1000,
    Campo2000/#varUnidad# as Campo2000,
    Campo1000+Campo2000   as Total
    from #saldoscuenta# s
    <cfif form.chkCeros eq '0'>
    where s.Campo1000 <> 0 or
    	  s.Campo2000 <> 0
    </cfif>   
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
    <cfreport format="#form.formato#" template= "EEPreClsFunc.cfr" query="rsDetalle">
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
                <td align="center" rowspan="3" valign="middle" nowrap="nowrap"><strong>#LB_CtaMayor#</strong></td>
                <td align="left"   rowspan="3" valign="middle" nowrap="nowrap"><strong>#LB_Ejerc# #LB_Momentos#</strong></td>
<!---                <td align="center"><strong>#LB_Finalidad#(1)</strong></td>
                <td align="center"><strong>#LB_Finalidad#(3)</strong></td>--->          
                <td align="center">&nbsp;</td> 
                <td align="center">&nbsp;</td>     
                <td align="center" rowspan="3" valign="middle" nowrap="nowrap"><strong>#LB_Total#</strong></td>
            </tr>
            <tr>
<!---                <td align="center"><strong>#LB_Funcion#(3)</strong></td>
                <td align="center"><strong>#LB_Funcion#(3)</strong></td>
--->       
                <td align="center">&nbsp;</td> 
                <td align="center">&nbsp;</td>     
			</tr>
            <tr>
<!---                <td align="center"><strong>#LB_SubFuncion#(4)</strong></td>
                <td align="center"><strong>#LB_SubFuncion#(2)</strong></td>
--->
                <td align="center">&nbsp;</td> 
                <td align="center">&nbsp;</td>     
			</tr>            
                     
            <cfloop query="rsDetalle">
				<tr>
                	<td nowrap align="left">#UCase(rsDetalle.CGEPCtaMayor)#</td>
					<td nowrap align="left">#UCase(rsDetalle.CGEPDescrip)#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo1000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo2000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Total, ",9.00")#</td>
            	</tr>
			</cfloop>
        </table>
    </cfoutput>
</cfif>