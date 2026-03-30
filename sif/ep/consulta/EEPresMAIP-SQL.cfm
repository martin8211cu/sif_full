<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 03-01-2013.
	Reporte Estado del Ejercicio del Presupuesto por Modalidad, Actividad Institucional y Programa
 --->
<!---<cf_dump var=#url#>--->
<cfsetting requesttimeout="3600">
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
	<cflocation url="EEPresMAIP.cfm?rsMensaje=#rsMensaje#">
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

<cfinvoke key="MSG_ReporteAnalitico" default="Estado del Ejercicio del Presupuesto por Modalidad, Actividad Institucional y Programa"	returnvariable="MSG_ReporteAnalitico" component="sif.Componentes.Translate" method="Translate"/>

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
<cfinvoke key="LB_CtaMayor" 	default="Cuenta de Mayor"			returnvariable="LB_CtaMayor"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Modalidad" 	default="Modalidad"					returnvariable="LB_Modalidad"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Actividad" 	default="Actividad institucional"	returnvariable="LB_Actividad"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Programa" 	default="Programa"					returnvariable="LB_Programa"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ej" 		default="Ejercicio del  presupuesto (Momentos contables del gasto)"	returnvariable="LB_Ej"	component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_ActO" 		default="Actividades de apoyo a la funci&oacute;n p&uacute;blica y buen gobierno"		returnvariable="LB_ActO"	component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_ActM" 		default="Actividades de apoyo administrativo"	returnvariable="LB_ActM"	component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_Oper" 	  	default="Operaciones ajenas"	returnvariable="LB_Oper"		component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_Comer"		default="Comercializaci&oacute;n de petr&oacute;leo y prestaci&oacute;n de servicios comerciales y administrativos"	returnvariable="LB_Comer"	component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_Pago"			default="Pago de pensiones y jubilaciones en P.M.I."	returnvariable="LB_Pago"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total"		default="Total" 		returnvariable="LB_Total"	component="sif.Componentes.Translate" method="Translate"/>

<cfset LvarIrA = 'EEPresMAIP.cfm'>
<cfset LvarFile = 'EEPresMAIP'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
    <cf_dbtempcol name="ID_Estr"  		type="int">
    <cf_dbtempcol name="Seccion"  		type="int">
    <cf_dbtempcol name="CGEPCtaMayor"  	type="varchar(4)">
	<cf_dbtempcol name="CGEPDescrip"  	type="varchar(100)">
    <cf_dbtempcol name="TipoCta"  		type="varchar(1)">
    <cf_dbtempcol name="Mcodigo"  		type="integer">        
    <cf_dbtempcol name="Campo1000"  	type="money">  	<!---CAMPO 0--->
    <cf_dbtempcol name="Campo2000"  	type="money">  	<!---CAMPO M--->
    <cf_dbtempcol name="Campo3000"  	type="money">  	<!---CAMPO W--->
    <cf_dbtempcol name="Campo3900"  	type="money">  	<!---CAMPO E--->
    <cf_dbtempcol name="Campo4000"  	type="money">	<!---CAMPO J--->
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
        when '#CtaModPresExtr#' then 20
        when '#CtaPresRes#' then 30
        when '#CtaPresCompr#' then 40
        when '#CtaPresEjec#' then 50
        when '#CtaPresEjer#' then 60
        when '#CtaPresPag#' then 70
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
    'A',#varMcodigo#,0 ,0 ,0 ,0 ,0,0,0
    from CGEstrProgCtaM ctm
        inner join CGReEstrProg r
        on ctm.ID_Estr= r.ID_Estr
            where r.SPcodigo='#session.menues.SPCODIGO#'
 </cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,21,'8231','REDUCCIONES','C',#varMcodigo#,0 ,0 ,0 ,0 ,0,0,0)
</cfquery>
 
<!--- <cf_dumptofile select="select * from #saldoscuenta# order by CGEPCtaMayor"> --->
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

<!---<cf_dumptofile select="select r.Cmayor,r.ClasCatCon,	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                        coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                        coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                        coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                        coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                        coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
                from #rsEPQuery# r
                where r.Cmayor = 8211
                and r.ClasCatCon = 4
                group by r.Cmayor,r.ClasCatCon">--->



<!---<cf_dumptofile select="select Cmayor,ClasCatCon,
coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
coalesce(sum(SOinicial), 0.00) 		as SOInicial,
coalesce(sum(CLcreditos), 0.00) 	as CLcreditos, 
coalesce(sum(DLdebitos), 0.00) 	as DLdebitos,
coalesce(sum(COcreditos), 0.00) 	as COcreditos, 
coalesce(sum(DOdebitos), 0.00) 	as DOdebitos
from #rsEPQuery# 
where PCDvalor<>''
group by Cmayor,ClasCatCon
order by Cmayor,ClasCatCon">--->

<!----Actualizar saldos ----->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by CGEPCtaMayor
</cfquery>

<cfquery name="rsPrograma" datasource="#session.dsn#">
    select 
    case d.PCCDvalor
        when 'O001' then 1
        when 'M001' then 2
        when 'E527' then 3
        when 'J007' then 4
        when 'W001' then 5
    end as orden,
    
<!---    case d.PCCDvalor
        when 'O001' then 'ACTIVIDADES DE APOYO A LA FUNCION PUBLICA Y BUEN GOBIERNO'
        when 'M001' then 'ACTIVIDADES DE APOYO ADMINISTRATIVO'
        when 'E527' then 'COMERCIALIZACION DE PETROLEO Y PRESTACION DE SERVICIOS COMERCIALES Y ADMINISTRATIVOS'
        when 'J007' then 'PAGO DE PENSIONES Y JUBILACIONES EN P.M.I.'
        when 'W001' then 'OPERACIONES AJENAS'
    end as descrip,
--->    
	d.PCCDvalor,d.PCCDclaid from PCClasificacionD d
    inner join PCClasificacionE e
    on d.PCCEclaid=e.PCCEclaid
    where e.PCCEcodigo = 'PROGRAMA'
    order by d.PCCDclaid
</cfquery>

<cfloop query="SC">
	<cfset SLinicial_1000  = 0>
    <cfset SOinicial_1000  = 0>
    <cfset CLcreditos_1000 = 0>
    <cfset DLdebitos_1000  = 0>
    <cfset COcreditos_1000 = 0>
    <cfset DOdebitos_1000  = 0> 
	<cfset SLinicial_2000  = 0>
    <cfset SOinicial_2000  = 0>
    <cfset CLcreditos_2000 = 0>
    <cfset DLdebitos_2000  = 0>
    <cfset COcreditos_2000 = 0>
    <cfset DOdebitos_2000  = 0>
    <cfset SLinicial_3000  = 0>
    <cfset SOinicial_3000  = 0>
    <cfset CLcreditos_3000 = 0>
    <cfset DLdebitos_3000  = 0>
    <cfset COcreditos_3000 = 0>
    <cfset DOdebitos_3000  = 0> 
    <cfset SLinicial_3900  = 0>
    <cfset SOinicial_3900  = 0>
    <cfset CLcreditos_3900 = 0>
    <cfset DLdebitos_3900  = 0>
    <cfset COcreditos_3900 = 0>
    <cfset DOdebitos_3900  = 0> 
    <cfset SLinicial_4000  = 0>
    <cfset SOinicial_4000  = 0>
    <cfset CLcreditos_4000 = 0>
    <cfset DLdebitos_4000  = 0>
    <cfset COcreditos_4000 = 0>
    <cfset DOdebitos_4000  = 0> 
<!---    <cfdump var ='Cmayor '>
    <cfdump var ='#SC.CGEPCtaMayor#'>
--->	
	<cfloop query="rsPrograma">
<!---    	<cfdump var ='#rsPrograma.PCCDclaid#'>
--->        
    	<cfif rsPrograma.orden eq 1>
            <cfquery datasource="#session.DSN#" name="Cmp_1000">		<!---CAMPO 0--->
                select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                        coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                        coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                        coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                        coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                        coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
                from #rsEPQuery# r
                where r.Cmayor = #SC.CGEPCtaMayor#
                and r.ClasCatCon = '#rsPrograma.PCCDclaid#'
                
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
<!---    <cfdump var ='CAMPO 0'>
	<cfdump var ='#SLinicial_1000#'>
    <cfdump var ='#SOinicial_1000#'>
    <cfdump var ='#CLcreditos_1000#'>
    <cfdump var ='#DLdebitos_1000#'>
    <cfdump var ='#COcreditos_1000#'>
    <cfdump var ='#DOdebitos_1000#'> 
--->    
     	</cfif>    
    	<cfif rsPrograma.orden eq 2>
            <cfquery datasource="#session.DSN#" name="Cmp_2000">	<!---CAMPO M--->
                select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                        coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                        coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                        coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                        coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                        coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
                from #rsEPQuery# r
                where r.Cmayor = #SC.CGEPCtaMayor#
                and r.ClasCatCon = '#rsPrograma.PCCDclaid#'
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
<!---    <cfdump var ='CAMPO M'>
	<cfdump var ='#SLinicial_2000#'>
    <cfdump var ='#SOinicial_2000#'>
    <cfdump var ='#CLcreditos_2000#'>
    <cfdump var ='#DLdebitos_2000#'>
    <cfdump var ='#COcreditos_2000#'>
    <cfdump var ='#DOdebitos_2000#'>
--->    
        </cfif>
    	<cfif rsPrograma.orden eq 5>
            <cfquery datasource="#session.DSN#" name="Cmp_3000">	<!---CAMPO W--->
                select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                        coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                        coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                        coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                        coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                        coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
                from #rsEPQuery# r
                where r.Cmayor = #SC.CGEPCtaMayor#
                and r.ClasCatCon = '#rsPrograma.PCCDclaid#'
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
<!---    <cfdump var ='CAMPO W'>
    <cfdump var ='#SLinicial_3000#'>
    <cfdump var ='#SOinicial_3000#'>
    <cfdump var ='#CLcreditos_3000#'>
    <cfdump var ='#DLdebitos_3000#'>
    <cfdump var ='#COcreditos_3000#'>
    <cfdump var ='#DOdebitos_3000#'> 
--->    
        </cfif>
    	<cfif rsPrograma.orden eq 3>
            <cfquery datasource="#session.DSN#" name="Cmp_3900">	<!---CAMPO E--->
                select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                        coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                        coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                        coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                        coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                        coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
                from #rsEPQuery# r
                where r.Cmayor = #SC.CGEPCtaMayor#
                and r.ClasCatCon = '#rsPrograma.PCCDclaid#'
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
<!---    <cfdump var ='CAMPO E'>
    <cfdump var ='#SLinicial_3900#'>
    <cfdump var ='#SOinicial_3900#'>
    <cfdump var ='#CLcreditos_3900#'>
    <cfdump var ='#DLdebitos_3900#'>
    <cfdump var ='#COcreditos_3900#'>
    <cfdump var ='#DOdebitos_3900#'> 
--->    
        </cfif>
    	<cfif rsPrograma.orden eq 4>
            <cfquery datasource="#session.DSN#" name="Cmp_4000">	<!---CAMPO J--->
                select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                        coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                        coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                        coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                        coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                        coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
                from #rsEPQuery# r
                where r.Cmayor = #SC.CGEPCtaMayor#
                and r.ClasCatCon = '#rsPrograma.PCCDclaid#'
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
<!---    <cfdump var ='CAMPO J'>
    <cfdump var ='#SLinicial_4000#'>
    <cfdump var ='#SOinicial_4000#'>
    <cfdump var ='#CLcreditos_4000#'>
    <cfdump var ='#DLdebitos_4000#'>
    <cfdump var ='#COcreditos_4000#'>
    <cfdump var ='#DOdebitos_4000#'>
--->    
    	</cfif>
	</cfloop> 
    <cfif SC.CGEPCtaMayor neq '#CtaModPresExtr#'>
        <cfquery datasource="#session.DSN#">
        update #saldoscuenta#
        set
        Campo1000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#DLdebitos_1000#, 0.00) - coalesce(#CLcreditos_1000#, 0.00)
            <cfelse>
                coalesce(#DOdebitos_1000#, 0.00) - coalesce(#COcreditos_1000#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#SLinicial_1000#, 0.00) + coalesce(#DLdebitos_1000#, 0.00) - coalesce(#CLcreditos_1000#, 0.00)
            <cfelse>
                coalesce(#SOinicial_1000#, 0.00)+coalesce(#DOdebitos_1000#, 0.00)-coalesce(#COcredito_1000s#, 0.00)
            </cfif> 
        </cfif>
        ),
        Campo2000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#DLdebitos_2000#, 0.00)-coalesce(#CLcreditos_2000#, 0.00)
            <cfelse>
                coalesce(#DOdebitos_2000#, 0.00)-coalesce(#COcreditos_2000#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#SLinicial_2000#, 0.00)+coalesce(#DLdebitos_2000#, 0.00)-coalesce(#CLcreditos_2000#, 0.00)
            <cfelse>
                coalesce(#SOinicial_2000#, 0.00)+coalesce(#DOdebitos_2000#, 0.00)-coalesce(#COcreditos_2000#, 0.00)
            </cfif> 
        </cfif>
        ),
        Campo3000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#DLdebitos_3000#, 0.00)-coalesce(#CLcreditos_3000#, 0.00)
            <cfelse>
                coalesce(#DOdebitos_3000#, 0.00)-coalesce(#COcredito_3000s#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#SLinicial_3000#, 0.00)+coalesce(#DLdebitos_3000#, 0.00)-coalesce(#CLcreditos_3000#, 0.00)
            <cfelse>
                coalesce(#SOinicial_3000#, 0.00)+coalesce(#DOdebitos_3000#, 0.00)-coalesce(#COcreditos_3000#, 0.00)
            </cfif> 
        </cfif>
        ),
        Campo3900 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#DLdebitos_3900#, 0.00)-coalesce(#CLcreditos_3900#, 0.00)
            <cfelse>
                coalesce(#DOdebitos_3900#, 0.00)-coalesce(#COcreditos_3900#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#SLinicial_3900#, 0.00)+coalesce(#DLdebitos_3900#, 0.00)-coalesce(#CLcreditos_3900#, 0.00)
            <cfelse>
                coalesce(#SOinicial_3900#, 0.00)+coalesce(#DOdebitos_3900#, 0.00)-coalesce(#COcreditos_3900#, 0.00)
            </cfif>
        </cfif>
        ),   
        Campo4000 = <cfif SC.CGEPCtaMayor eq '#CtaPresAprob#'>(-1) * </cfif>
        (
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#DLdebitos_4000#, 0.00)-coalesce(#CLcreditos_4000#, 0.00)
            <cfelse>
                coalesce(#DOdebitos_4000#, 0.00)-coalesce(#COcreditos_4000#, 0.00)
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
                coalesce(#SLinicial_4000#, 0.00)+coalesce(#DLdebitos_4000#, 0.00)-coalesce(#CLcreditos_4000#, 0.00)
            <cfelse>
                coalesce(#SOinicial_4000#, 0.00)+coalesce(#DOdebitos_4000#, 0.00)-coalesce(#COcreditos_4000#, 0.00)
            </cfif> 
        </cfif> 
        )      
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
                	coalesce(#CLcreditos_1000#, 0.00)
				<cfelse>
                	coalesce(#DLdebitos_1000#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#COcreditos_1000#, 0.00)
				<cfelse>
                	coalesce(#DOdebitos_1000#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SLinicial_1000#, 0.00)-coalesce(#CLcreditos_1000#, 0.00)
				<cfelse>
                	coalesce(#SLinicial_1000#, 0.00)+coalesce(#DLdebitos_1000#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SOinicial_1000#, 0.00)-coalesce(#COcreditos_1000#, 0.00)
				<cfelse>
                	coalesce(#SOinicial_1000#, 0.00)+coalesce(#DOdebitos_1000#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo2000 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#CLcreditos_2000#, 0.00)
				<cfelse>
                	coalesce(#DLdebitos_2000#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#COcreditos_2000#, 0.00)
				<cfelse>
                	coalesce(#DOdebitos_2000#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SLinicial_2000#, 0.00)-coalesce(#CLcreditos_2000#, 0.00)
				<cfelse>
                	coalesce(#SLinicial_2000#, 0.00)+coalesce(#DLdebitos_2000#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SOinicial_2000#, 0.00)-coalesce(#COcreditos_2000#, 0.00)
				<cfelse>
                	coalesce(#SOinicial_2000#, 0.00)+coalesce(#DOdebitos_2000#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo3000 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#CLcreditos_3000#, 0.00)
				<cfelse>
                	coalesce(#DLdebitos_3000#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#COcreditos_3000#, 0.00)
				<cfelse>
                	coalesce(#DOdebitos_3000#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SLinicial_3000#, 0.00)-coalesce(#CLcreditos_3000#, 0.00)
				<cfelse>
                	coalesce(#SLinicial_3000#, 0.00)+coalesce(#DLdebitos_3000#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SOinicial_3000#, 0.00)-coalesce(#COcreditos_3000#, 0.00)
				<cfelse>
                	coalesce(#SOinicial_3000#, 0.00)+coalesce(#DOdebitos_3000#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo3900 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#CLcreditos_3900#, 0.00)
				<cfelse>
                	coalesce(#DLdebitos_3900#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#COcreditos_3900#, 0.00)
				<cfelse>
                	coalesce(#DOdebitos_3900#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SLinicial_3900#, 0.00)-coalesce(#CLcreditos_3900#, 0.00)
				<cfelse>
                	coalesce(#SLinicial_3900#, 0.00)+coalesce(#DLdebitos_3900#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SOinicial_3900#, 0.00)-coalesce(#COcreditos_3900#, 0.00)
				<cfelse>
                	coalesce(#SOinicial_3900#, 0.00)+coalesce(#DOdebitos_3900#, 0.00)
                </cfif>
            </cfif> 
        </cfif>,
        Campo4000 =
        <cfif #form.mensAcum# eq 1>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#CLcreditos_4000#, 0.00)
				<cfelse>
                	coalesce(#DLdebitos_4000#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#COcreditos_4000#, 0.00)
				<cfelse>
                	coalesce(#DOdebitos_4000#, 0.00)
                </cfif>
            </cfif> 
        <cfelse>
            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SLinicial_4000#, 0.00)-coalesce(#CLcreditos_4000#, 0.00)
				<cfelse>
                	coalesce(#SLinicial_4000#, 0.00)+coalesce(#DLdebitos_4000#, 0.00)
                </cfif>
            <cfelse>
            	<cfif SC.TipoCta eq 'C'>
                	coalesce(#SOinicial_4000#, 0.00)-coalesce(#COcreditos_4000#, 0.00)
				<cfelse>
                	coalesce(#SOinicial_4000#, 0.00)+coalesce(#DOdebitos_4000#, 0.00)
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
<!---<cf_dump var='Cuentas'>--->

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
    values(4,22,'','PRESUPUESTO VIGENTE','A',#varMcodigo#,#PrVig1000#,#PrVig2000#,#PrVig3000#,#PrVig3900#,#PrVig4000#,
    #PrVig5000#,#PrVig7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,31,'','PRESUPUESTO VIGENTE SIN PRECOMPROMETER','A',#varMcodigo#,
    #PrVig1000#-(#PrVigSC1000#),#PrVig2000#-(#PrVigSC2000#),
    #PrVig3000#-(#PrVigSC3000#),#PrVig3900#-(#PrVigSC3900#),
    #PrVig4000#-(#PrVigSC4000#),#PrVig5000#-(#PrVigSC5000#),
    #PrVig7200#-(#PrVigSC7200#))
</cfquery>

<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,41,'','PRECOMPROMISOS SIN COMPROMETER','A',#varMcodigo#,#PreSC1000#,#PreSC2000#,#PreSC3000#,#PreSC3900#,#PreSC4000#,
    #PreSC5000#,#PreSC7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,42,'','PRESUPUESTO DISPONIBLE PARA COMPROMETER','A',#varMcodigo#,
    #PreDisp1000#-(#PrVig1000#),#PreDisp2000#-(#PrVig2000#),
    #PreDisp3000#-(#PrVig3000#),#PreDisp3900#-(#PrVig3900#),
    #PreDisp4000#-(#PrVig4000#),#PreDisp5000#-(#PrVig5000#),
    #PreDisp7200#-(#PrVig7200#))
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,51,'','COMPROMISO SIN DEVENGAR','A',#varMcodigo#,#CompSD1000#,#CompSD2000#,#CompSD3000#,#CompSD3900#,#CompSD4000#,
    #CompSD5000#,#CompSD7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,52,'','PRESUPUESTO VIGENTE SIN DEVENGAR','A',#varMcodigo#,#PrVigSD1000#,#PrVigSD2000#,#PrVigSD3000#,#PrVigSD3900#,#PrVigSD4000#,
    #PrVigSD5000#,#PrVigSD7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,61,'','DEVENGADO SIN EJERCER','A',#varMcodigo#,#PreDevSE1000#,#PreDevSE2000#,#PreDevSE3000#,#PreDevSE3900#,#PreDevSE4000#,
    #PreDevSE5000#,#PreDevSE7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,71,'','EJERCIDO SIN PAGAR','A',#varMcodigo#,#EjerSP1000#,#EjerSP2000#,#EjerSP3000#,#EjerSP3900#,#EjerSP4000#,
    #EjerSP5000#,#EjerSP7200#)
</cfquery>
<cfquery datasource="#session.dsn#">
    insert into #saldoscuenta#(ID_Estr,Seccion,CGEPCtaMayor,CGEPDescrip,TipoCta,Mcodigo,Campo1000,Campo2000,Campo3000,Campo3900,Campo4000, 
    Campo5000,Campo7200)
    values(4,81,'','CUENTAS POR PAGAR','A',#varMcodigo#,#CtasPP1000#,#CtasPP2000#,#CtasPP3000#,#CtasPP3900#,#CtasPP4000#,
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
         s.Campo4000 <> 0 
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
    <cfreport format="#form.formato#" template= "EEPresMAIP.cfr" query="rsDetalle">
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
                <td align="center" rowspan="4" valign="middle"><strong>#LB_CtaMayor#</strong></td>
                <td align="left"><strong>#LB_Modalidad#</strong></td>             
                <td align="center"><strong>O</strong></td>
                <td align="center"><strong>M</strong></td>
                <td align="center"><strong>W</strong></td>
                <td align="center"><strong>E</strong></td>
                <td align="center"><strong>J</strong></td>
                <td align="center" rowspan="4" valign="middle"><strong>#LB_Total#</strong></td>
            </tr>
            
            <tr>
                <td align="left"><strong>#LB_Actividad#</strong></td>
                <td align="center"><strong>001</strong></td>
                <td align="center"><strong>002</strong></td>
                <td align="center"><strong>002</strong></td>
                <td align="center"><strong>526</strong></td>
                <td align="center"><strong>527</strong></td>
            </tr>
            <tr>
                <td align="left"><strong>#LB_Programa#</strong></td>
                <td align="center"><strong>O001</strong></td>
                <td align="center"><strong>M001</strong></td>
                <td align="center"><strong>W001</strong></td>
                <td align="center"><strong>E527</strong></td>
                <td align="center"><strong>J007</strong></td>
			</tr>            
            <tr>
                <td align="left"><strong>#LB_Ej#</strong></td>
                <td align="center"><strong>#LB_ActO#</strong></td>
                <td align="center"><strong>#LB_ActM#</strong></td>
                <td align="center"><strong>#LB_Oper#</strong></td>
                <td align="center"><strong>#LB_Comer#</strong></td>
				<td align="center"><strong>#LB_Pago#</strong></td>
			</tr>            
                     
            <cfloop query="rsDetalle">
				<tr>
                	<td nowrap align="left">#UCase(rsDetalle.CGEPCtaMayor)#</td>
					<td nowrap align="left">#UCase(rsDetalle.CGEPDescrip)#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo1000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo2000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo3000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo3900, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo4000, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Campo1000+rsdetalle.Campo2000+rsdetalle.Campo3000+
                        rsdetalle.Campo3900+rsdetalle.Campo4000,",9.00")#
                    </td>
            	</tr>
			</cfloop>
        </table>
    </cfoutput>
</cfif>