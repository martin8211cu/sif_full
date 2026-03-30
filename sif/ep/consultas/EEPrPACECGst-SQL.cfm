<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 03-01-2013.
	Reporte Estado del Ejercicio del Presupuesto por Programa, Actividad institucional, Clasificación económica y Capítulos del gasto
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
<c_dump var ="cuentas">--->

<cfif isdefined('rsMensaje')>
	<cflocation url="EEPrPACECGst.cfm?rsMensaje=#rsMensaje#">
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

<cfinvoke key="MSG_ReporteAnalitico" default="Estado del Ejercicio del Presupuesto  por Programa, Actividad institucional, Clasificaci&oacute;n Econ&oacute;mica y Conceptos del Gasto"	returnvariable="MSG_ReporteAnalitico"	
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

<cfinvoke key="LB_Concepto" default="Capitulo de gasto"	 returnvariable="LB_Concepto"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Programa" default="Programa"			 returnvariable="LB_Programa"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Presup"	default="Presupuesto" 	 	 returnvariable="LB_Presup"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Aprob"	default="Aprobado" 	 	 	 returnvariable="LB_Aprob"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ampl"		default="Ampliaciones" 	 	 returnvariable="LB_Ampl"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Reduc"	default="Reducciones" 	 	 returnvariable="LB_Reduc"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Vigen"	default="Vigente" 	 	 	 returnvariable="LB_Vigen"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Precom"	default="Precompromisos" 	 returnvariable="LB_Precom"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Vigensin"	default="Vigente sin" 	  	 returnvariable="LB_Vigensin"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Precomet"	default="Precomprometer" 	 returnvariable="LB_Precomet"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Comprtd"	default="Comprometido" 	  	 returnvariable="LB_Comprtd"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Sincomp"	default="sin Comprometer" 	 returnvariable="LB_Sincomp"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Disp"		default="Disponible para" 	 returnvariable="LB_Disp"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Compr"	default="Comprometer" 	  	 returnvariable="LB_Compr"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Dev"		default="Devengado" 	  	 returnvariable="LB_Dev"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Comprsin"	default="Compromiso sin" 	 returnvariable="LB_Comprsin"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Devgr"	default="Devengar" 	  	 	 returnvariable="LB_Devgr"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejer"		default="Ejercido" 	  	 	 returnvariable="LB_Ejer"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Devsin"	default="Devengado sin" 	 returnvariable="LB_Devsin"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejercer"	default="Ejercer" 	  	 	 returnvariable="LB_Ejercer"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pagdo"	default="Pagado" 	  	 	 returnvariable="LB_Pagdo"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejersin"	default="Ejercido sin" 	  	 returnvariable="LB_Ejersin"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pagar"	default="Pagar" 	  	 	 returnvariable="LB_Pagar"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ctaspor"	default="Cuentas por" 	  	 returnvariable="LB_Ctaspor"	component="sif.Componentes.Translate" method="Translate"/>

<cfset LvarIrA  = 'EEPrPACECGst.cfm'>
<cfset LvarFile = 'EEPrPACECGst'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
	<cf_dbtempcol name="ID_Estr"  		type="int">
	<cf_dbtempcol name="Seccion"  		type="int">
    <cf_dbtempcol name="CtpGsto"  		type="int">
    <cf_dbtempcol name="PCCDclaid"  	type="int">
	<cf_dbtempcol name="CGEPDescrip"  	type="varchar(100)">
    <cf_dbtempcol name="TipoCta"  		type="varchar(1)">
    <cf_dbtempcol name="Mcodigo"  		type="integer"> 
    <cf_dbtempcol name="Campo8211"  	type="money">
    <cf_dbtempcol name="Campo8231A"  	type="money">
    <cf_dbtempcol name="Campo8231C"  	type="money">
    <cf_dbtempcol name="Campo8240"  	type="money">
    <cf_dbtempcol name="Campo8241"  	type="money">
    <cf_dbtempcol name="Campo8251"  	type="money">
    <cf_dbtempcol name="Campo8261"  	type="money">
    <cf_dbtempcol name="Campo8271"  	type="money">
    <cf_dbtempkey cols="ID_Estr,Seccion,CtpGsto">
</cf_dbtemp>

<cfquery name="rsPrograma" datasource="#session.dsn#">
    select 
    case d.PCCDvalor
        when 'O001' then 1
        when 'M001' then 2
        when 'E527' then 3
        when 'J007' then 4
        when 'W001' then 5
    end as orden,
    case d.PCCDvalor
        when 'O001' then 'ACTIVIDADES DE APOYO A LA FUNCION PUBLICA Y BUEN GOBIERNO'
        when 'M001' then 'ACTIVIDADES DE APOYO ADMINISTRATIVO'
        when 'E527' then 'COMERCIALIZACION DE PETROLEO Y PRESTACION DE SERVICIOS COMERCIALES Y ADMINISTRATIVOS'
        when 'J007' then 'PAGO DE PENSIONES Y JUBILACIONES EN P.M.I.'
        when 'W001' then 'OPERACIONES AJENAS'
    end as descrip,
    d.PCCDvalor,d.PCCDclaid from PCClasificacionD d
    inner join PCClasificacionE e
    on d.PCCEclaid=e.PCCEclaid
    where e.PCCEcodigo = 'PROGRAMA'
    order by orden
</cfquery>

<!---<cf_dumptofile select="    select 
    case d.PCCDvalor
        when 'O001' then 1
        when 'M001' then 2
        when 'E527' then 3
        when 'J007' then 4
        when 'W001' then 5
    end as orden,
    case d.PCCDvalor
        when 'O001' then 'ACTIVIDADES DE APOYO A LA FUNCION PUBLICA Y BUEN GOBIERNO'
        when 'M001' then 'ACTIVIDADES DE APOYO ADMINISTRATIVO'
        when 'E527' then 'COMERCIALIZACION DE PETROLEO Y PRESTACION DE SERVICIOS COMERCIALES Y ADMINISTRATIVOS'
        when 'J007' then 'PAGO DE PENSIONES Y JUBILACIONES EN P.M.I.'
        when 'W001' then 'OPERACIONES AJENAS'
    end as descrip,
    d.PCCDvalor,d.PCCDclaid from PCClasificacionD d
    inner join PCClasificacionE e
    on d.PCCEclaid=e.PCCEclaid
    where e.PCCEcodigo = 'PROGRAMA'
    order by orden">--->

<cfloop query="rsPrograma">
    <cfquery datasource="#session.dsn#">
        insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
        select 
        	rep.ID_Estr,
        	#rsPrograma.orden#,
<!---        case left(epv.EPCPcodigo,4)
            when '1100' then 10 
            when '1300' then 10
            when '1400' then 20
            when '1500' then 30
            when '1600' then 40
            when '1700' then 50
            when '2100' then 70
            
            when '2200' then 80 
            when '2400' then 90 
            when '2600' then 100 
            when '2700' then 110 
            when '2900' then 120 
            
            when '3100' then 140 
            when '3200' then 150 
            when '3300' then 160 
            when '3400' then 170 
            when '3500' then 180 
            when '3700' then 190 
            when '3800' then 200
            
            when '3900' then 230
             
            when '4500' then 250 
            when '5100' then 280 
            when '5400' then 290 
            when '5600' then 300 
            when '5900' then 310 
            
            when '7200' then 340 
            else 1
        end,
--->        
        left(epv.EPCPcodigo,4),#rsPrograma.PCCDclaid#,epv.EPCPdescripcion,    
        'A',#varMcodigo#, 0, 0, 0, 0, 0, 0, 0, 0
    from CGReEstrProg rep 
            inner join CGEstrProgVal epv
            on rep.ID_Estr= epv.ID_Estr
    where rep.SPcodigo='#session.menues.SPCODIGO#'
     </cfquery>
 </cfloop>
 
<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion,CtpGsto">--->
 
<!--- <cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,330,'3900','EROGACIONES POR OPERACIONES AJENAS','C',#varMcodigo#, 0, 0, 0, 0, 0, 0, 0, 0)
 </cfquery>
---> 

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

<!---<cf_dumptofile select="select distinct r.*, left(epv.EPCPcodigo,4) as EPCPcodigo, pcc.PCCDvalor from #rsEPQuery# r 
        inner join PCClasificacionD pcc
        on r.ClasCatCon = pcc.PCCDclaid        
        inner join CGEstrProgVal epv
        on r.ID_EstrCtaVal= epv.ID_EstrCtaVal
        where epv.ID_Estr=#rsNumEst.ID_Estr#">--->

<!---<cf_dumptofile select="select Cmayor,ID_EstrCtaVal,
				coalesce(SLinicial, 0.00) 	as SLInicial, 
                coalesce(SOinicial, 0.00) 	as SOInicial,
                coalesce(CLcreditos, 0.00) 	as CLcreditos, 
                coalesce(DLdebitos, 0.00) 	as DLdebitos,
                coalesce(COcreditos, 0.00) 	as COcreditos, 
                coalesce(DOdebitos, 0.00) 	as DOdebitos from #rsEPQuery# where Cmayor<>'' and ID_EstrCtaVal<>''">
--->
<!----Actualizar saldos ----->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    where CtpGsto <> 1
    order by Seccion
</cfquery>

<!---<cf_dumptofile select="select * from #saldoscuenta# where CtpGsto <> 1 order by Seccion">
--->
<cfloop query="SC">
    <cfquery datasource="#session.DSN#" name="Cmp_8211">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresAprob#'
        and r.ClasCatCon = '#SC.PCCDclaid#'
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='#SC.CtpGsto#')
    </cfquery>
    
 	<cfif Cmp_8211.recordcount GT 0>
    	<cfset SLinicial_8211  = #Cmp_8211.SLinicial#>
        <cfset SOinicial_8211  = #Cmp_8211.SOinicial#>
        <cfset CLcreditos_8211 = #Cmp_8211.CLcreditos#>
        <cfset DLdebitos_8211  = #Cmp_8211.DLdebitos#>
        <cfset COcreditos_8211 = #Cmp_8211.COcreditos#>
        <cfset DOdebitos_8211  = #Cmp_8211.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_8211  = 0>
        <cfset SOinicial_8211  = 0>
        <cfset CLcreditos_8211 = 0>
        <cfset DLdebitos_8211  = 0>
        <cfset COcreditos_8211 = 0>
        <cfset DOdebitos_8211  = 0> 
    </cfif>  

   	<cfquery datasource="#session.DSN#" name="Cmp_8231">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaModPresExtr#'
        and r.ClasCatCon = '#SC.PCCDclaid#'
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='#SC.CtpGsto#')
    </cfquery>
 	<cfif Cmp_8231.recordcount GT 0>
    	<cfset SLinicial_8231  = #Cmp_8231.SLinicial#>
        <cfset SOinicial_8231  = #Cmp_8231.SOinicial#>
        <cfset CLcreditos_8231 = #Cmp_8231.CLcreditos#>
        <cfset DLdebitos_8231  = #Cmp_8231.DLdebitos#>
        <cfset COcreditos_8231 = #Cmp_8231.COcreditos#>
        <cfset DOdebitos_8231  = #Cmp_8231.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_8231  = 0>
        <cfset SOinicial_8231  = 0>
        <cfset CLcreditos_8231 = 0>
        <cfset DLdebitos_8231  = 0>
        <cfset COcreditos_8231 = 0>
        <cfset DOdebitos_8231  = 0> 
    </cfif>
    <cfquery datasource="#session.DSN#" name="Cmp_8240">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresRes#'
        and r.ClasCatCon = '#SC.PCCDclaid#'
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='#SC.CtpGsto#')
    </cfquery>
 	<cfif Cmp_8240.recordcount GT 0>
    	<cfset SLinicial_8240  = #Cmp_8240.SLinicial#>
        <cfset SOinicial_8240  = #Cmp_8240.SOinicial#>
        <cfset CLcreditos_8240 = #Cmp_8240.CLcreditos#>
        <cfset DLdebitos_8240  = #Cmp_8240.DLdebitos#>
        <cfset COcreditos_8240 = #Cmp_8240.COcreditos#>
        <cfset DOdebitos_8240  = #Cmp_8240.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_8240  = 0>
        <cfset SOinicial_8240  = 0>
        <cfset CLcreditos_8240 = 0>
        <cfset DLdebitos_8240  = 0>
        <cfset COcreditos_8240 = 0>
        <cfset DOdebitos_8240  = 0> 
    </cfif>
    <cfquery datasource="#session.DSN#" name="Cmp_8241">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresCompr#'
        and r.ClasCatCon = '#SC.PCCDclaid#'
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='#SC.CtpGsto#')
    </cfquery>
 	<cfif Cmp_8241.recordcount GT 0>
    	<cfset SLinicial_8241  = #Cmp_8241.SLinicial#>
        <cfset SOinicial_8241  = #Cmp_8241.SOinicial#>
        <cfset CLcreditos_8241 = #Cmp_8241.CLcreditos#>
        <cfset DLdebitos_8241  = #Cmp_8241.DLdebitos#>
        <cfset COcreditos_8241 = #Cmp_8241.COcreditos#>
        <cfset DOdebitos_8241  = #Cmp_8241.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_8241  = 0>
        <cfset SOinicial_8241  = 0>
        <cfset CLcreditos_8241 = 0>
        <cfset DLdebitos_8241  = 0>
        <cfset COcreditos_8241 = 0>
        <cfset DOdebitos_8241  = 0> 
    </cfif>
    
    <cfquery datasource="#session.DSN#" name="Cmp_8251">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresEjec#'
        and r.ClasCatCon = '#SC.PCCDclaid#'
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='#SC.CtpGsto#')
    </cfquery>
 	<cfif Cmp_8251.recordcount GT 0>
    	<cfset SLinicial_8251  = #Cmp_8251.SLinicial#>
        <cfset SOinicial_8251  = #Cmp_8251.SOinicial#>
        <cfset CLcreditos_8251 = #Cmp_8251.CLcreditos#>
        <cfset DLdebitos_8251  = #Cmp_8251.DLdebitos#>
        <cfset COcreditos_8251 = #Cmp_8251.COcreditos#>
        <cfset DOdebitos_8251  = #Cmp_8251.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_8251  = 0>
        <cfset SOinicial_8251  = 0>
        <cfset CLcreditos_8251 = 0>
        <cfset DLdebitos_8251  = 0>
        <cfset COcreditos_8251 = 0>
        <cfset DOdebitos_8251  = 0> 
    </cfif>
    <cfquery datasource="#session.DSN#" name="Cmp_8261">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresEjer#'
        and r.ClasCatCon = '#SC.PCCDclaid#'
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='#SC.CtpGsto#')
    </cfquery>
 	<cfif Cmp_8261.recordcount GT 0>
    	<cfset SLinicial_8261  = #Cmp_8261.SLinicial#>
        <cfset SOinicial_8261  = #Cmp_8261.SOinicial#>
        <cfset CLcreditos_8261 = #Cmp_8261.CLcreditos#>
        <cfset DLdebitos_8261  = #Cmp_8261.DLdebitos#>
        <cfset COcreditos_8261 = #Cmp_8261.COcreditos#>
        <cfset DOdebitos_8261  = #Cmp_8261.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_8261  = 0>
        <cfset SOinicial_8261  = 0>
        <cfset CLcreditos_8261 = 0>
        <cfset DLdebitos_8261  = 0>
        <cfset COcreditos_8261 = 0>
        <cfset DOdebitos_8261  = 0> 
    </cfif>  
    <cfquery datasource="#session.DSN#" name="Cmp_8271">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresPag#'
        and r.ClasCatCon = '#SC.PCCDclaid#'
        and r.ID_EstrCtaVal = (select ID_EstrCtaVal from CGEstrProgVal c
        						inner join CGReEstrProg re
        						on c.ID_Estr= re.ID_Estr
            					where re.SPcodigo='#session.menues.SPCODIGO#'
        						and EPCPcodigo='#SC.CtpGsto#')
    </cfquery>
 	<cfif Cmp_8271.recordcount GT 0>
    	<cfset SLinicial_8271  = #Cmp_8271.SLinicial#>
        <cfset SOinicial_8271  = #Cmp_8271.SOinicial#>
        <cfset CLcreditos_8271 = #Cmp_8271.CLcreditos#>
        <cfset DLdebitos_8271  = #Cmp_8271.DLdebitos#>
        <cfset COcreditos_8271 = #Cmp_8271.COcreditos#>
        <cfset DOdebitos_8271  = #Cmp_8271.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_8271  = 0>
        <cfset SOinicial_8271  = 0>
        <cfset CLcreditos_8271 = 0>
        <cfset DLdebitos_8271  = 0>
        <cfset COcreditos_8271 = 0>
        <cfset DOdebitos_8271  = 0> 
    </cfif>
      
    <cfquery datasource="#session.DSN#">
    update #saldoscuenta#
    set
    Campo8211 =
    <cfif #form.mensAcum# eq 1>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#DLdebitos_8211#, 0.00)-coalesce(#CLcreditos_8211#, 0.00)
        <cfelse>
            coalesce(#DOdebitos_8211#, 0.00)-coalesce(#COcreditos_8211#, 0.00)
        </cfif> 
    <cfelse>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#SLinicial_8211#, 0.00)+coalesce(#DLdebitos_8211#, 0.00)-coalesce(#CLcreditos_8211#, 0.00)
        <cfelse>
            coalesce(#SOinicial_8211#, 0.00)+coalesce(#DOdebitos_8211#, 0.00)-coalesce(#COcreditos_8211#, 0.00)
        </cfif> 
    </cfif>,
    Campo8231A =
    <cfif #form.mensAcum# eq 1>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#DLdebitos_8231#, 0.00)
        <cfelse>
            coalesce(#DOdebitos_8231#, 0.00)
        </cfif> 
    <cfelse>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#SLinicial_8231#, 0.00)+coalesce(#DLdebitos_8231#, 0.00)
        <cfelse>
            coalesce(#SOinicial_8231#, 0.00)+coalesce(#DOdebitos_8231#, 0.00)
        </cfif> 
    </cfif>,
    Campo8231C =
    <cfif #form.mensAcum# eq 1>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#CLcreditos_8231#, 0.00)
        <cfelse>
            coalesce(#COcreditos_8231#, 0.00)
        </cfif> 
    <cfelse>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#SLinicial_8231#, 0.00)-coalesce(#CLcreditos_8231#, 0.00)
        <cfelse>
            coalesce(#SOinicial_8231#, 0.00)-coalesce(#COcreditos_8231#, 0.00)
        </cfif> 
    </cfif>,
    Campo8240 =
    <cfif #form.mensAcum# eq 1>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#DLdebitos_8240#, 0.00)-coalesce(#CLcreditos_8240#, 0.00)
        <cfelse>
            coalesce(#DOdebitos_8240#, 0.00)-coalesce(#COcreditos_8240#, 0.00)
        </cfif> 
    <cfelse>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#SLinicial_8240#, 0.00)+coalesce(#DLdebitos_8240#, 0.00)-coalesce(#CLcreditos_8240#, 0.00)
        <cfelse>
            coalesce(#SOinicial_8240#, 0.00)+coalesce(#DOdebitos_8240#, 0.00)-coalesce(#COcreditos_8240#, 0.00)
        </cfif> 
    </cfif>,
    Campo8241 =
    <cfif #form.mensAcum# eq 1>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#DLdebitos_8241#, 0.00)-coalesce(#CLcreditos_8241#, 0.00)
        <cfelse>
            coalesce(#DOdebitos_8241#, 0.00)-coalesce(#COcreditos_8241#, 0.00)
        </cfif> 
    <cfelse>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#SLinicial_8241#, 0.00)+coalesce(#DLdebitos_8241#, 0.00)-coalesce(#CLcreditos_8241#, 0.00)
        <cfelse>
            coalesce(#SOinicial_8241#, 0.00)+coalesce(#DOdebitos_8241#, 0.00)-coalesce(#COcreditos_8241#, 0.00)
        </cfif> 
    </cfif>,
    Campo8251 =
    <cfif #form.mensAcum# eq 1>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#DLdebitos_8251#, 0.00)-coalesce(#CLcreditos_8251#, 0.00)
        <cfelse>
            coalesce(#DOdebitos_8251#, 0.00)-coalesce(#COcreditos_8251#, 0.00)
        </cfif> 
    <cfelse>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#SLinicial_8251#, 0.00)+coalesce(#DLdebitos_8251#, 0.00)-coalesce(#CLcreditos_8251#, 0.00)
        <cfelse>
            coalesce(#SOinicial_8251#, 0.00)+coalesce(#DOdebitos_8251#, 0.00)-coalesce(#COcreditos_8251#, 0.00)
        </cfif> 
    </cfif>,
    Campo8261 =
    <cfif #form.mensAcum# eq 1>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#DLdebitos_8261#, 0.00)-coalesce(#CLcreditos_8261#, 0.00)
        <cfelse>
            coalesce(#DOdebitos_8261#, 0.00)-coalesce(#COcreditos_8261#, 0.00)
        </cfif> 
    <cfelse>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#SLinicial_8261#, 0.00)+coalesce(#DLdebitos_8261#, 0.00)-coalesce(#CLcreditos_8261#, 0.00)
        <cfelse>
            coalesce(#SOinicial_8261#, 0.00)+coalesce(#DOdebitos_8261#, 0.00)-coalesce(#COcreditos_8261#, 0.00)
        </cfif> 
    </cfif>,
    Campo8271 =
    <cfif #form.mensAcum# eq 1>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#DLdebitos_8271#, 0.00)-coalesce(#CLcreditos_8271#, 0.00)
        <cfelse>
            coalesce(#DOdebitos_8271#, 0.00)-coalesce(#COcreditos_8271#, 0.00)
        </cfif> 
    <cfelse>
        <cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
            coalesce(#SLinicial_8271#, 0.00)+coalesce(#DLdebitos_8271#, 0.00)-coalesce(#CLcreditos_8271#, 0.00)
        <cfelse>
            coalesce(#SOinicial_8271#, 0.00)+coalesce(#DOdebitos_8271#, 0.00)-coalesce(#COcreditos_8271#, 0.00)
        </cfif> 
    </cfif>    
    where 
    #saldoscuenta#.CtpGsto = #SC.CtpGsto# and #saldoscuenta#.Seccion = #SC.Seccion#
    </cfquery>
</cfloop>
<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">--->

<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by Seccion
</cfquery>

<cfset GstoCorrO8211 	= 0>
<cfset GstoCorrO8231A 	= 0>
<cfset GstoCorrO8231C 	= 0>
<cfset GstoCorrO8240 	= 0>
<cfset GstoCorrO8241 	= 0>
<cfset GstoCorrO8251 	= 0>
<cfset GstoCorrO8261 	= 0>
<cfset GstoCorrO8271 	= 0>

<cfset GstoCorrM8211 	= 0>
<cfset GstoCorrM8231A 	= 0>
<cfset GstoCorrM8231C 	= 0>
<cfset GstoCorrM8240 	= 0>
<cfset GstoCorrM8241 	= 0>
<cfset GstoCorrM8251 	= 0>
<cfset GstoCorrM8261 	= 0>
<cfset GstoCorrM8271 	= 0>

<cfset GstoTotM8211 	= 0>
<cfset GstoTotM8231A 	= 0>
<cfset GstoTotM8231C 	= 0>
<cfset GstoTotM8240 	= 0>
<cfset GstoTotM8241 	= 0>
<cfset GstoTotM8251 	= 0>
<cfset GstoTotM8261 	= 0>
<cfset GstoTotM8271 	= 0>

<cfset GstoCapM8211 	= 0>
<cfset GstoCapM8231A 	= 0>
<cfset GstoCapM8231C 	= 0>
<cfset GstoCapM8240 	= 0>
<cfset GstoCapM8241 	= 0>
<cfset GstoCapM8251 	= 0>
<cfset GstoCapM8261 	= 0>
<cfset GstoCapM8271 	= 0>

<cfset GstoCapE8211 	= 0>
<cfset GstoCapE8231A 	= 0>
<cfset GstoCapE8231C 	= 0>
<cfset GstoCapE8240 	= 0>
<cfset GstoCapE8241 	= 0>
<cfset GstoCapE8251 	= 0>
<cfset GstoCapE8261 	= 0>
<cfset GstoCapE8271 	= 0>

<cfset GstoCorrE8211 	= 0>
<cfset GstoCorrE8231A 	= 0>
<cfset GstoCorrE8231C 	= 0>
<cfset GstoCorrE8240 	= 0>
<cfset GstoCorrE8241 	= 0>
<cfset GstoCorrE8251 	= 0>
<cfset GstoCorrE8261 	= 0>
<cfset GstoCorrE8271 	= 0>

<cfset GstoTotE8211 	= 0>
<cfset GstoTotE8231A 	= 0>
<cfset GstoTotE8231C 	= 0>
<cfset GstoTotE8240 	= 0>
<cfset GstoTotE8241 	= 0>
<cfset GstoTotE8251 	= 0>
<cfset GstoTotE8261 	= 0>
<cfset GstoTotE8271 	= 0>

<cfset GstoCorrJ8211 	= 0>
<cfset GstoCorrJ8231A 	= 0>
<cfset GstoCorrJ8231C 	= 0>
<cfset GstoCorrJ8240 	= 0>
<cfset GstoCorrJ8241 	= 0>
<cfset GstoCorrJ8251 	= 0>
<cfset GstoCorrJ8261 	= 0>
<cfset GstoCorrJ8271 	= 0>

<cfset GstoCorrW8211 	= 0>
<cfset GstoCorrW8231A 	= 0>
<cfset GstoCorrW8231C 	= 0>
<cfset GstoCorrW8240 	= 0>
<cfset GstoCorrW8241 	= 0>
<cfset GstoCorrW8251 	= 0>
<cfset GstoCorrW8261 	= 0>
<cfset GstoCorrW8271 	= 0>

<cfloop query="SC">
	<cfif SC.Seccion eq 1 and (SC.CtpGsto eq '1000' or SC.CtpGsto eq '2000' or SC.CtpGsto eq '3000' or SC.CtpGsto eq '3900')>
		<cfset GstoCorrO8211 	= #GstoCorrO8211#  + #SC.Campo8211#>
        <cfset GstoCorrO8231A 	= #GstoCorrO8231A# + #SC.Campo8231A#>
    	<cfset GstoCorrO8231C 	= #GstoCorrO8231C# + #SC.Campo8231C#>
        <cfset GstoCorrO8240 	= #GstoCorrO8240#  + #SC.Campo8240#>
        <cfset GstoCorrO8241 	= #GstoCorrO8241#  + #SC.Campo8241#>
        <cfset GstoCorrO8251 	= #GstoCorrO8251#  + #SC.Campo8251#>
        <cfset GstoCorrO8261 	= #GstoCorrO8261#  + #SC.Campo8261#>
        <cfset GstoCorrO8271 	= #GstoCorrO8271#  + #SC.Campo8271#>    
    </cfif>
    
    <cfif SC.Seccion eq 2 and (SC.CtpGsto eq '1000' or SC.CtpGsto eq '2000' or SC.CtpGsto eq '3000' or SC.CtpGsto eq '3900' or SC.CtpGsto eq '5000')>
		<cfset GstoTotM8211 	= #GstoTotM8211#  + #SC.Campo8211#>
        <cfset GstoTotM8231A 	= #GstoTotM8231A# + #SC.Campo8231A#>
        <cfset GstoTotM8231C 	= #GstoTotM8231C# + #SC.Campo8231C#>
        <cfset GstoTotM8240 	= #GstoTotM8240#  + #SC.Campo8240#>
        <cfset GstoTotM8241 	= #GstoTotM8241#  + #SC.Campo8241#>
        <cfset GstoTotM8251 	= #GstoTotM8251#  + #SC.Campo8251#>
        <cfset GstoTotM8261 	= #GstoTotM8261#  + #SC.Campo8261#>
        <cfset GstoTotM8271 	= #GstoTotM8271#  + #SC.Campo8271#>    
    </cfif>

	<cfif SC.Seccion eq 2 and (SC.CtpGsto eq '1000' or SC.CtpGsto eq '2000' or SC.CtpGsto eq '3000' or SC.CtpGsto eq '3900')>
		<cfset GstoCorrM8211 	= #GstoCorrM8211#  + #SC.Campo8211#>
        <cfset GstoCorrM8231A 	= #GstoCorrM8231A# + #SC.Campo8231A#>
        <cfset GstoCorrM8231C 	= #GstoCorrM8231C# + #SC.Campo8231C#>
        <cfset GstoCorrM8240 	= #GstoCorrM8240#  + #SC.Campo8240#>
        <cfset GstoCorrM8241 	= #GstoCorrM8241#  + #SC.Campo8241#>
        <cfset GstoCorrM8251 	= #GstoCorrM8251#  + #SC.Campo8251#>
        <cfset GstoCorrM8261 	= #GstoCorrM8261#  + #SC.Campo8261#>
        <cfset GstoCorrM8271 	= #GstoCorrM8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.Seccion eq 2 and (SC.CtpGsto eq '5000')>
		<cfset GstoCapM8211 	= #GstoCapM8211#  + #SC.Campo8211#>
        <cfset GstoCapM8231A 	= #GstoCapM8231A# + #SC.Campo8231A#>
        <cfset GstoCaptM8231C 	= #GstoCapM8231C# + #SC.Campo8231C#>
        <cfset GstoCapM8240 	= #GstoCapM8240#  + #SC.Campo8240#>
        <cfset GstoCapM8241 	= #GstoCapM8241#  + #SC.Campo8241#>
        <cfset GstoCapM8251 	= #GstoCapM8251#  + #SC.Campo8251#>
        <cfset GstoCapM8261 	= #GstoCapM8261#  + #SC.Campo8261#>
        <cfset GstoCapM8271 	= #GstoCapM8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.Seccion eq 3 and (SC.CtpGsto eq '1000' or SC.CtpGsto eq '2000' or SC.CtpGsto eq '3000' or SC.CtpGsto eq '3900')>
		<cfset GstoCorrE8211 	= #GstoCorrE8211#  + #SC.Campo8211#>
        <cfset GstoCorrE8231A 	= #GstoCorrE8231A# + #SC.Campo8231A#>
        <cfset GstoCorrE8231C 	= #GstoCorrE8231C# + #SC.Campo8231C#>
        <cfset GstoCorrE8240 	= #GstoCorrE8240#  + #SC.Campo8240#>
        <cfset GstoCorrE8241 	= #GstoCorrE8241#  + #SC.Campo8241#>
        <cfset GstoCorrE8251 	= #GstoCorrE8251#  + #SC.Campo8251#>
        <cfset GstoCorrE8261 	= #GstoCorrE8261#  + #SC.Campo8261#>
        <cfset GstoCorrE8271 	= #GstoCorrE8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.Seccion eq 3 and (SC.CtpGsto eq '5000')>
		<cfset GstoCapE8211 	= #GstoCapE8211#  + #SC.Campo8211#>
        <cfset GstoCapE8231A 	= #GstoCapE8231A# + #SC.Campo8231A#>
        <cfset GstoCaptE8231C 	= #GstoCapE8231C# + #SC.Campo8231C#>
        <cfset GstoCapE8240 	= #GstoCapE8240#  + #SC.Campo8240#>
        <cfset GstoCapE8241 	= #GstoCapE8241#  + #SC.Campo8241#>
        <cfset GstoCapE8251 	= #GstoCapE8251#  + #SC.Campo8251#>
        <cfset GstoCapE8261 	= #GstoCapE8261#  + #SC.Campo8261#>
        <cfset GstoCapE8271 	= #GstoCapE8271#  + #SC.Campo8271#>    
    </cfif>
    
    
	<cfif SC.Seccion eq 3 and (SC.CtpGsto eq '1000' or SC.CtpGsto eq '2000' or SC.CtpGsto eq '3000' or SC.CtpGsto eq '3900' or SC.CtpGsto eq '5000')>
		<cfset GstoTotE8211 	= #GstoTotE8211#  + #SC.Campo8211#>
        <cfset GstoTotE8231A 	= #GstoTotE8231A# + #SC.Campo8231A#>
        <cfset GstoTotE8231C 	= #GstoTotE8231C# + #SC.Campo8231C#>
        <cfset GstoTotE8240 	= #GstoTotE8240#  + #SC.Campo8240#>
        <cfset GstoTotE8241 	= #GstoTotE8241#  + #SC.Campo8241#>
        <cfset GstoTotE8251 	= #GstoTotE8251#  + #SC.Campo8251#>
        <cfset GstoTotE8261 	= #GstoTotE8261#  + #SC.Campo8261#>
        <cfset GstoTotE8271 	= #GstoTotE8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.Seccion eq 4 and (SC.CtpGsto eq '4000')>
		<cfset GstoCorrJ8211 	= #GstoCorrJ8211#  + #SC.Campo8211#>
        <cfset GstoCorrJ8231A 	= #GstoCorrJ8231A# + #SC.Campo8231A#>
        <cfset GstoCorrJ8231C 	= #GstoCorrJ8231C# + #SC.Campo8231C#>
        <cfset GstoCorrJ8240 	= #GstoCorrJ8240#  + #SC.Campo8240#>
        <cfset GstoCorrJ8241 	= #GstoCorrJ8241#  + #SC.Campo8241#>
        <cfset GstoCorrJ8251 	= #GstoCorrJ8251#  + #SC.Campo8251#>
        <cfset GstoCorrJ8261 	= #GstoCorrJ8261#  + #SC.Campo8261#>
        <cfset GstoCorrJ8271 	= #GstoCorrJ8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.Seccion eq 5 and (SC.CtpGsto eq '7200')>
		<cfset GstoCorrW8211 	= #GstoCorrW8211#  + #SC.Campo8211#>
        <cfset GstoCorrW8231A 	= #GstoCorrW8231A# + #SC.Campo8231A#>
        <cfset GstoCorrW8231C 	= #GstoCorrW8231C# + #SC.Campo8231C#>
        <cfset GstoCorrW8240 	= #GstoCorrW8240#  + #SC.Campo8240#>
        <cfset GstoCorrW8241 	= #GstoCorrW8241#  + #SC.Campo8241#>
        <cfset GstoCorrW8251 	= #GstoCorrW8251#  + #SC.Campo8251#>
        <cfset GstoCorrW8261 	= #GstoCorrW8261#  + #SC.Campo8261#>
        <cfset GstoCorrW8271 	= #GstoCorrW8271#  + #SC.Campo8271#>    
    </cfif>
</cfloop>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,1,9000,'','GASTO CORRIENTE PROGRAMA O001','A',#varMcodigo#, #GstoCorrO8211#, #GstoCorrO8231A#, #GstoCorrO8231C#, #GstoCorrO8240#, #GstoCorrO8241#, #GstoCorrO8251#, #GstoCorrO8261#, #GstoCorrO8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,1,9300,'','GASTOS TOTAL PROGRAMA O001','A',#varMcodigo#, #GstoCorrO8211#, #GstoCorrO8231A#, #GstoCorrO8231C#, #GstoCorrO8240#, #GstoCorrO8241#, #GstoCorrO8251#, #GstoCorrO8261#, #GstoCorrO8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,2,4300,'','GASTOS CORRIENTE PROGRAMA M001','A',#varMcodigo#, #GstoCorrM8211#, #GstoCorrM8231A#, #GstoCorrM8231C#, #GstoCorrM8240#, #GstoCorrM8241#, #GstoCorrM8251#, #GstoCorrM8261#, #GstoCorrM8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,2,9000,'','GASTO DE CAPITAL PROGRAMA M001','A',#varMcodigo#, #GstoCapM8211#, #GstoCapM8231A#, #GstoCapM8231C#, #GstoCapM8240#, #GstoCapM8241#, #GstoCapM8251#, #GstoCapM8261#, #GstoCapM8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,2,9100,'','GASTOS TOTAL PROGRAMA M001','A',#varMcodigo#, #GstoTotM8211#, #GstoTotM8231A#, #GstoTotM8231C#, #GstoTotM8240#, #GstoTotM8241#, #GstoTotM8251#, #GstoTotM8261#, #GstoTotM8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,3,4300,'','GASTO CORRIENTE PROGRAMA E527','A',#varMcodigo#, #GstoCorrE8211#, #GstoCorrE8231A#, #GstoCorrE8231C#, #GstoCorrE8240#, #GstoCorrE8241#, #GstoCorrE8251#, #GstoCorrE8261#, #GstoCorrE8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,3,9000,'','GASTO DE CAPITAL PROGRAMA E527','A',#varMcodigo#, #GstoCapE8211#, #GstoCapE8231A#, #GstoCapE8231C#, #GstoCapE8240#, #GstoCapE8241#, #GstoCapE8251#, #GstoCapE8261#, #GstoCapE8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,3,9100,'','GASTOS TOTAL PROGRAMA E527','A',#varMcodigo#, #GstoTotE8211#, #GstoTotE8231A#, #GstoTotE8231C#, #GstoTotE8240#, #GstoTotE8241#, #GstoTotE8251#, #GstoTotE8261#, #GstoTotE8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,4,4300,'','GASTO CORRIENTE PROGRAMA J007','A',#varMcodigo#, #GstoCorrJ8211#, #GstoCorrJ8231A#, #GstoCorrJ8231C#, #GstoCorrJ8240#, #GstoCorrE8241#, #GstoCorrJ8251#, #GstoCorrJ8261#, #GstoCorrJ8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,4,9100,'','GASTOS TOTAL PROGRAMA J007','A',#varMcodigo#, #GstoCorrJ8211#, #GstoCorrJ8231A#, #GstoCorrJ8231C#, #GstoCorrJ8240#, #GstoCorrJ8241#, #GstoCorrJ8251#, #GstoCorrJ8261#, #GstoCorrJ8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,5,9000,'','GASTO DE CAPITAL PROGRAMA W001','A',#varMcodigo#, #GstoCorrW8211#, #GstoCorrW8231A#, #GstoCorrW8231C#, #GstoCorrW8240#, #GstoCorrW8241#, #GstoCorrW8251#, #GstoCorrW8261#, #GstoCorrW8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,5,9100,'','GASTOS TOTAL PROGRAMA W001','A',#varMcodigo#, #GstoCorrW8211#, #GstoCorrW8231A#, #GstoCorrW8231C#, #GstoCorrW8240#, #GstoCorrW8241#, #GstoCorrW8251#, #GstoCorrW8261#, #GstoCorrW8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,PCCDclaid,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C, Campo8240,Campo8241,Campo8251,Campo8261,Campo8271)
    values(8,5,9900,'','TOTAL GASTO PROGRAMABLE','A',#varMcodigo#, 
    #GstoCorrO8211#+#GstoTotM8211#+#GstoTotE8211#+#GstoCorrJ8211#+#GstoCorrW8211#, 
    #GstoCorrO8231A#+#GstoTotM8231A#+#GstoTotE8231A#+#GstoCorrJ8231A#+#GstoCorrW8231A#, 
    #GstoCorrO8231C#+#GstoTotM8231C#+#GstoTotE8231C#+#GstoCorrJ8231C#+#GstoCorrW8231C#, 
    #GstoCorrO8240#+#GstoTotM8240#+#GstoTotE8240#+#GstoCorrJ8240#+#GstoCorrW8240#, 
    #GstoCorrO8241#+#GstoTotM8241#+#GstoTotE8241#+#GstoCorrJ8241#+#GstoCorrW8241#, 
    #GstoCorrO8251#+#GstoTotM8251#+#GstoTotE8251#+#GstoCorrJ8251#+#GstoCorrW8251#, 
    #GstoCorrO8261#+#GstoTotM8261#+#GstoTotE8261#+#GstoCorrJ8261#+#GstoCorrW8261#, 
    #GstoCorrO8271#+#GstoTotM8271#+#GstoTotE8271#+#GstoCorrJ8271#+#GstoCorrW8271#)
</cfquery>
<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">--->

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select 
    s.Seccion,
    case s.Seccion
        when 1 then 'ACTIVIDADES DE APOYO A LA FUNCION PUBLICA Y BUEN GOBIERNO'
        when 2 then 'ACTIVIDADES DE APOYO ADMINISTRATIVO'
        when 3 then 'COMERCIALIZACION DE PETROLEO Y PRESTACION DE SERVICIOS COMERCIALES Y ADMINISTRATIVOS'
        when 4 then 'PAGO DE PENSIONES Y JUBILACIONES EN P.M.I.'
        when 5 then 'OPERACIONES AJENAS'
    end as descrip,
    s.CtpGsto,
    case s.Seccion
        when 1 then 'O001'
        when 2 then 'M001'
        when 3 then 'E527'
        when 4 then 'J007'
        when 5 then 'W001'
    end as programa,
    s.CGEPDescrip,Mcodigo,
    Campo8211/#varUnidad# 	as Column8211,
    Campo8231A/#varUnidad#	as Column8231A,
    Campo8231C/#varUnidad# 	as Column8231C,
    Campo8240/#varUnidad# 	as Column8240,
    Campo8241/#varUnidad# 	as Column8241, 
    Campo8251/#varUnidad# 	as Column8251,
    Campo8261/#varUnidad# 	as Column8261,
    Campo8271/#varUnidad# 	as Column8271,
    
    (Campo8211+Campo8231A-Campo8231C)/#varUnidad#   as ColumnPRVig,
    (Campo8211+Campo8231A-Campo8231C-Campo8240/#varUnidad#)   as ColumnPRVigSC,
    (Campo8240-Campo8241)/#varUnidad#   as ColumnPRSC,
    ((Campo8211+Campo8231A-Campo8231C)-Campo8241)/#varUnidad# as ColumnPRDisp,
    (Campo8241-Campo8251)/#varUnidad#	as ColumnCompSD,
    (Campo8211+Campo8231A-Campo8231C-Campo8251)/#varUnidad# as ColumnPRVigSD,
    (Campo8251-Campo8261)/#varUnidad#	as ColumnDevSE,
    (Campo8261-Campo8271)/#varUnidad#	as ColumnEjerSP,
    (Campo8251-Campo8271)/#varUnidad#	as ColumnCtasPP

    from #saldoscuenta# s
    where 
        (s.Seccion = 1 and s.CtpGsto in ('1000','2000','3000','3900','9000','9300'))
     or (s.Seccion = 2 and s.CtpGsto in ('1000','2000','3000','3900','4300','5000','9000','9100')) 
     or (s.Seccion = 3 and s.CtpGsto in ('1000','2000','3000','3900','4300','5000','9000','9100'))
     or (s.Seccion = 4 and s.CtpGsto in ('4000','4300','9100')) 
     or (s.Seccion = 5 and s.CtpGsto in ('7200','9000','9100','9900')) 
    <cfif form.chkCeros eq '0'>
    and( s.Campo8211 <> 0 or
    	 s.Campo8231A <> 0 or
         s.Campo8231C <> 0 or
         s.Campo8240 <> 0 or
         s.Campo8241 <> 0 or
         s.Campo8251 <> 0 or
         s.Campo8261 <> 0 or
         s.Campo8271 <> 0)
    </cfif>   
	order by s.Seccion,s.CtpGsto
</cfquery>

<!---<cf_dump var="#rsDetalle#">--->

<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select Mnombre
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #varMcodigo#
</cfquery>

<cfif form.formato NEQ "HTML">
	<cfif #form.mensAcum# eq 1>
       <cfset LabelFechaFin = #LabelFechaFin#&' Mensual'>
    <cfelse>
       <cfset LabelFechaFin = #LabelFechaFin#&' Acumulado'>
    </cfif>
    <cfreport format="#form.formato#" template= "EEPrPACECGst.cfr" query="rsDetalle">
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
                <td style="font-size:16px" align="center" colspan="7" nowrap="nowrap">
                <strong>#rsNombreEmpresa.Edescripcion#</strong>	
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="7"nowrap="nowrap">
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
                <td style="font-size:16px" align="center" colspan="7" nowrap="nowrap"><strong>(#MSG_Cifras_en# #rsMoneda.Mnombre#)</strong></td>
            </tr>
        </table>
		<table width="100%">
            <tr>
            	<td align="left"   nowrap="nowrap"><strong>#LB_Programa#</strong></td>
                <td align="left"   nowrap="nowrap" colspan="2"><strong>#LB_Concepto#</strong></td>
                <td align="center"   nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>                
                <td align="center" nowrap="nowrap"><strong>#LB_Presup#</strong></td>
				<td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Precom#</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Comprsin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Devsin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ejersin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ctaspor#</strong></td>
            </tr>
             <tr>
             	<td align="center" colspan="3"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Aprob#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ampl#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Reduc#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Vigen#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Precom#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Vigensin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Comprtd#</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Sincomp#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Disp#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Dev#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Devgr#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Vigensin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ejer#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ejercer#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Pagdo#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Pagar#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Pagar#</strong></td>
			</tr>            
           <tr>
                <td align="center" colspan="8" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Precomet#</strong></td>
                <td align="center" colspan="2" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Compr#</strong></td>
                <td align="center" colspan="2" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Devgr#</strong></td>
			</tr>            
            <tr>
               	<td align="center" colspan="3"><strong>&nbsp;</strong></td>
                <td align="center" valign="top"><strong>8211</strong></td>
                <td align="center" valign="top"><strong>8231 (abono)</strong></td>
                <td align="center" valign="top"><strong>8231 (cargo)</strong></td>
                <td align="center" valign="top">&nbsp;</td>
                <td align="center" valign="top"><strong>8240</strong></td>
				<td align="center" valign="top">&nbsp;</td>
                <td align="center" valign="top"><strong>8241</strong></td>
				<td align="center" valign="top">&nbsp;</td>
                <td align="center" valign="top">&nbsp;</td>
                <td align="center" valign="top"><strong>8251</strong></td>
				<td align="center" valign="top">&nbsp;</td>
                <td align="center" valign="top">&nbsp;</td>
                <td align="center" valign="top"><strong>8261</strong></td>
                <td align="center" valign="top">&nbsp;</td>
                <td align="center" valign="top"><strong>8271</strong></td>
			</tr>     
            <cfset prgma = ''>         
            <cfloop query="rsDetalle">
				<tr>
                	<cfif prgma neq rsDetalle.programa>
                    	<cfset prgma = '#rsDetalle.programa#'>
                        <td align="left" valign="middle" rowspan="3">#UCase(rsDetalle.programa)# #UCase(rsDetalle.Descrip)#</td>
                        <cfset ln = 1>
                    <cfelse>
                    	<cfif ln gte 3>
                    		<td>&nbsp;</td>
                        <cfelse>
                        	<cfset ln = #ln# + 1>
                        </cfif>    
                    </cfif> 
                     
                    <td align="left" nowrap="nowrap">#UCase(rsDetalle.CGEPDescrip)#</td>
                    <cfif left(rsDetalle.CGEPDescrip,5) neq 'GASTO' and  left(rsDetalle.CGEPDescrip,5) neq 'TOTAL'>
                    	<cfif rsDetalle.CtpGsto eq '7200'>
                        	<td align="center" nowrap="nowrap">3900 y #rsDetalle.CtpGsto#</td>
                        <cfelse>
                    		<td align="center">#rsDetalle.CtpGsto#</td>
                        </cfif>
                    <cfelse>
                    	<td>&nbsp;</td>
                    </cfif>    
                    <td nowrap align="right">#numberformat(rsdetalle.Column8211, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Column8231A, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Column8231C, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnPRVig, ",9.00")#</td>
                    
                    <td nowrap align="right">#numberformat(rsdetalle.Column8240, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnPRVigSC, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Column8241,",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnPRSC, ",9.00")#</td>
                    
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnPRDisp, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Column8251, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnCompSD,",9.00")#</td>
                    
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnPRVigSD,",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Column8261, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnDevSE,",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.Column8271, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnEjerSP,",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.ColumnCtasPP,",9.00")#</td>
            	</tr>
			</cfloop>
        </table>
    </cfoutput>
</cfif>