<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 03-01-2013.
	Reporte Estado del Ejercicio del Presupuesto por Programa, Partida Genérica del Gasto, Actividad Institucional y Modalidad
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
<cfif isdefined("url.Modalidad") and not isdefined("form.Modalidad")>
	<cfparam name="form.Modalidad" default="#url.Modalidad#"></cfif>
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

<cfif isdefined('rsMensaje')>
	<cflocation url="EEPrPGGAIM.cfm?rsMensaje=#rsMensaje#">
</cfif>
</cfoutput>

<cfquery name="rsPrograma" datasource="#session.dsn#"> 
    select 
	d.PCCDvalor,
    case d.PCCDvalor
        when 'O001' then 'ACTIVIDADES DE APOYO A LA FUNCIÓN PÚBLICA Y BUEN GOBIERNO'
        when 'M001' then 'ACTIVIDADES DE APOYO ADMINISTRATIVO'
        when 'E527' then 'COMERCIALIZACIÓN DE PETRÓLEO CRUDO Y PRESTACIÓN DE SERVICIOS COMERCIALES Y ADMINISTRATIVOS'
        when 'J007' then 'COMERCIALIZACIÓN DE PETRÓLEO CRUDO Y PRESTACIÓN DE SERVICIOS COMERCIALES Y ADMINISTRATIVOS'
        when 'W001' then 'OPERACIONES AJENAS'
    end as descrip,
    case d.PCCDvalor
        when 'O001' then '001 FUNCIÓN PÚBLICA Y BUEN GOBIERNO'
        when 'M001' then '002 SERVICIOS DE APOYO ADMINISTRATIVO'
        when 'E527' then '526 EXCEDENTES DE PETRÓLEO CRUDO PARA EL COMERCIO EXTERIOR Y PRESTACIÓN DE SERVICIOS COMERCIALES Y ADMINISTRATIVOS DE CALIDAD'
        when 'J007' then '527  PAGO DE PENSIONES Y JUBILACIONES AL PERSONAL DE P.M.I.'
        when 'W001' then '002  SERVICIOS DE APOYO ADMINISTRATIVO'
    end as descAct,
    d.PCCDclaid from PCClasificacionD d
    where d.PCCDclaid = '#form.Modalidad#'
</cfquery>

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

<cfinvoke key="MSG_ReporteAnalitico" default="Estado del Ejercicio del Presupuesto por Programa, Partida Gen&eacute;rica del Gasto, Actividad Institucional y Modalidad"	returnvariable="MSG_ReporteAnalitico"	
component="sif.Componentes.Translate" method="Translate"/>
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
<cfinvoke key="LB_Concepto" 	default="Partida gen&eacute;rica del gasto"	 				returnvariable="LB_Concepto"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejercicio" 	default="Ejercicio del presupuesto (Momentos contables)"	returnvariable="LB_Ejercicio"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Desc"		default="Descripci&oacute;n" returnvariable="LB_Desc"	component="sif.Componentes.Translate" method="Translate"/>
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

<cfset LvarIrA  = 'EEPrPGGAIM.cfm'>
<cfset LvarFile = 'EEPrPGGAIM'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
    <cf_dbtempcol name="ID_Estr"  		type="int">
    <cf_dbtempcol name="Seccion"  		type="int">
    <cf_dbtempcol name="CtpGsto"  		type="int">
	<cf_dbtempcol name="CGEPDescrip"  	type="varchar(180)">
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

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    
	select distinct rep.ID_Estr, 
    case left(epv.EPCPcodigo,4)
        when '1000' then 10 
        when '2000' then 20 
        when '3000' then 30 
        when '3900' then 40
        when '5000' then 50
        when '4500' then 80
        when '7200' then 90
        else 1
	end as orden,
    
    left(pcd.PCDvalor,3) as agrup,
    
    <!---pcd.PCDdescripcion--->'',
    'A' as TipoCta,#varMcodigo# as Mcodigo, 0 as Campo8211, 0 as Campo8231A, 0 as Campo8231C, 0 as Campo8240, 0 as Campo8241, 0 as Campo8251, 0 as Campo8261, 0 as Campo8271
    from CGReEstrProg rep 
    inner join CGEstrProgVal epv
    on rep.ID_Estr= epv.ID_Estr
    inner join dbo.CGDEstrProgVal epd
    on epv.ID_EstrCtaVal=epd.ID_EstrCtaVal 
    inner join PCECatalogo pce
    on epv.PCEcatid = pce.PCEcatid
    inner join PCDCatalogo pcd
    on pcd.PCDcatid = epd.PCDcatid  
    where rep.SPcodigo='#session.menues.SPCODIGO#' and pce.PCEcodigo='TIPO 20120'
    order by rep.ID_Estr,orden,agrup,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241,Campo8251,Campo8261,Campo8271
</cfquery>

<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion,CtpGsto">---> 
 
<cfquery name="rsNumEst" datasource="#session.dsn#">
	select r.ID_Estr from CGReEstrProg r where r.SPcodigo='#session.menues.SPCODIGO#'
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(#rsNumEst.ID_Estr#,20,'226','','A',#varMcodigo#,0,0,0,0,0,0,0,0)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(#rsNumEst.ID_Estr#,50,'566','','A',#varMcodigo#,0,0,0,0,0,0,0,0)
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

<!---<cf_dumptofile select="select * from #rsEPQuery#">--->

<!----Actualizar saldos ----->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by Seccion
</cfquery>
<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">--->
<cfloop query="SC">
    <cfquery datasource="#session.DSN#" name="Cmp_8211">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresAprob#' and r.ClasCatCon = #form.Modalidad# 
        and left(r.PCDvalor,3) = '#SC.CtpGsto#'
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

<!---    <cfdump var="CAMPO_8211">
    <cfdump var="#SLinicial_8211#">
    <cfdump var="#SOinicial_8211#">
    <cfdump var="#CLcreditos_8211#">
    <cfdump var="#DLdebitos_8211#">
    <cfdump var="#COcreditos_8211#">
    <cfdump var="#DOdebitos_8211#">
--->    
  	<cfquery datasource="#session.DSN#" name="Cmp_8231">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaModPresExtr#' and r.ClasCatCon = #form.Modalidad# 
        and left(r.PCDvalor,3) = '#SC.CtpGsto#'
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
		where r.Cmayor = '#CtaPresRes#' and r.ClasCatCon = #form.Modalidad# 
        and left(r.PCDvalor,3) = '#SC.CtpGsto#'
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
<!---    <cfdump var="CAMPO_8240">
    <cfdump var="#SLinicial_8240#">
    <cfdump var="#SOinicial_8240#">
    <cfdump var="#CLcreditos_8240#">
    <cfdump var="#DLdebitos_8240#">
    <cfdump var="#COcreditos_8240#">
    <cfdump var="#DOdebitos_8240#">
--->    
    <cfquery datasource="#session.DSN#" name="Cmp_8241">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresCompr#' and r.ClasCatCon = #form.Modalidad# 
        and left(r.PCDvalor,3) = '#SC.CtpGsto#'
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
<!---    <cfdump var="CAMPO_8241">
    <cfdump var="#SLinicial_8241#">
    <cfdump var="#SOinicial_8241#">
    <cfdump var="#CLcreditos_8241#">
    <cfdump var="#DLdebitos_8241#">
    <cfdump var="#COcreditos_8241#">
    <cfdump var="#DOdebitos_8241#">
--->
    <cfquery datasource="#session.DSN#" name="Cmp_8251">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresEjec#' and r.ClasCatCon = #form.Modalidad# 
        and left(r.PCDvalor,3) = '#SC.CtpGsto#'
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
<!---    <cfdump var="CAMPO_8251">
    <cfdump var="#SLinicial_8251#">
    <cfdump var="#SOinicial_8251#">
    <cfdump var="#CLcreditos_8251#">
    <cfdump var="#DLdebitos_8251#">
    <cfdump var="#COcreditos_8251#">
    <cfdump var="#DOdebitos_8251#">
--->    
    <cfquery datasource="#session.DSN#" name="Cmp_8261">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresEjer#' and r.ClasCatCon = #form.Modalidad# 
        and left(r.PCDvalor,3) = '#SC.CtpGsto#'
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
<!---    <cfdump var="CAMPO_8261">
    <cfdump var="#SLinicial_8261#">
    <cfdump var="#SOinicial_8261#">
    <cfdump var="#CLcreditos_8261#">
    <cfdump var="#DLdebitos_8261#">
    <cfdump var="#COcreditos_8261#">
    <cfdump var="#DOdebitos_8261#">
--->    
    <cfquery datasource="#session.DSN#" name="Cmp_8271">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #rsEPQuery# r
		where r.Cmayor = '#CtaPresPag#' and r.ClasCatCon = #form.Modalidad# 
        and left(r.PCDvalor,3) = '#SC.CtpGsto#'
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
    CGEPDescrip =
    <cfif form.formato EQ "HTML"> 
    case CtpGsto
        when '113' then 'Sueldos base al personal permanente'
        when '131' then 'Prima de antig&uuml;edad'
        when '132' then 'Prima de vacaciones y dominical'
        when '133' then 'Remuneraciones por horas extraordinarias'
        when '141' then 'Aportaciones de seguridad social'
        when '142' then 'Aportaciones a fondos de vivienda'
        when '143' then 'Aportaciones al sistema para el retiro'
        when '144' then 'Aportaciones para seguros'
        when '151' then 'Cuotas para el fondo de ahorro y fondo de trabajo'
        when '152' then 'Indemnizaciones'
        when '153' then 'Prestaciones y haberes de retiro'
        when '154' then 'Prestaciones contractuales'
        when '155' then 'Apoyos a la capacitaci&oacute;n de servidores p&uacute;blicos'
        when '159' then 'Otras prestaciones'
        when '161' then 'Previsiones de caracter laboral, econ&oacute;mica y de seguridad social'
        when '211' then 'Materiales, &uacute;tiles y equipos menores de oficina'
        when '214' then 'Materiales, &uacute;tiles y equipos menores de tecnolog&iacute;as de informaci&oacute;n y comunicaciones'
        when '215' then 'Material impreso e informaci&oacute;n digital'
        when '216' then 'Material de limpieza'
        when '221' then 'Productos alimenticios para el personal'
        when '223' then 'Utensilios para el servicio de alimentaci&oacute;n'
        when '226' then 'Combustibles, lubricantes y aditivos'
        when '246' then 'Material el&eacute;ctrico y electr&oacute;nico'
        when '248' then 'Materiales complementarios'
        when '249' then 'Otros materiales y art&iacute;culos de construcci&oacute;n y reparaci&oacute;n'
        when '261' then 'Combustibles, lubricantes y aditivos'
        when '271' then 'Vestuarios y uniformes'
        when '272' then 'Prendas de seguridad y protecci&oacute;n personal'
        when '291' then 'Herramientas menores'
        when '294' then 'Refacciones y accesorios menores de equipo de c&oacute;mputo y tecnolog&iacute;as de la informaci&oacute;n'
        when '299' then 'Refacciones y accesorios menores otros bienes muebles'
        when '314' then 'Servicio telef&oacute;nico convencional'
        when '315' then 'Telefon&iacute;a celular'
        when '316' then 'Servicios de telecomunicaciones'
        when '317' then 'Servicios de acceso a internet, redes y procesamiento de informaci&oacute;n'
        when '318' then 'Servicios postales y telegr&aacute;ficos'
        when '322' then 'Arrendamiento de edificios'
        when '323' then 'Arrendamiento de mobiliario y equipo de administraci&oacute;n'
        when '325' then 'Arrendamiento de equipo de transporte'
        when '326' then 'Arrendamiento de maquinaria, otros equipos y herramientas'
        when '327' then 'Arrendamiento de activos intangibles'
        when '331' then 'Servicios legales, de contabilidad, auditoria y relacionados'
        when '333' then 'Servicios de consultor&iacute;a administrativa, procesos, t&eacute;cnica  y en tecnolog&iacute;as de la informaci&oacute;n'
        when '334' then 'Servicios de capacitaci&oacute;n'
        when '336' then 'Servicios de apoyo administrativo, traducci&oacute;n, fotocopiado e impresi&oacute;n'
        when '339' then 'Servicios profesionales, cient&iacute;ficos y t&eacute;cnicos integrales'
        when '344' then 'Seguros de responsabilidad patrimonial y fianzas'
        when '345' then 'Seguros de bienes patrimoniales'
        when '351' then 'Conservaci&oacute;n y mantenimiento menor de inmuebles'
        when '352' then 'Instalaci&oacute;n, reparaci&oacute;n y mantenimiento de mobiliario y equipo de administraci&oacute;n'
        when '353' then 'Instalaci&oacute;n, reparaci&oacute;n y mantenimiento de equipo de c&oacute;mputo y tecnolog&iacute;a de la informaci&oacute;n'
        when '355' then 'Reparaci&oacute;n y mantenimiento de equipo de transporte'
        when '371' then 'Pasajes a&eacute;reos'
        when '372' then 'Pasajes terrestres'
        when '375' then 'Vi&aacute;ticos en el pa&iacute;s'
        when '376' then 'Vi&aacute;ticos en el extranjero'
        when '382' then 'Gastos de orden social'
        when '383' then 'Congresos y convenciones'
        when '385' then 'Gastos de representaci&oacute;n'
        when '398' then 'Impuesto sobre n&oacute;minas'
        when '391' then 'Servicios funerarios y de cementerios'
        when '392' then 'Impuestos y derechos'
        when '395' then 'Penas, multas, accesorios y actualizaciones'
        when '397' then 'Utilidades'
        when '398' then 'Impuesto sobre n&oacute;minas y otros que se deriven de una relaci&oacute;n laboral'
        when '511' then 'Mobiliario de oficina'
        when '515' then 'Equipo de c&oacute;mputo y de tecnolog&iacute;as de informaci&oacute;n'
        when '519' then 'Otros mobiliarios y equipo de administraci&oacute;n'
        when '541' then 'Veh&iacute;culos y equipo terrestres'
        when '565' then 'Equipos de comunicaci&oacute;n y telecomunicaci&oacute;n'
        when '566' then 'Equipo de generaci&oacute;n el&eacute;ctrica, aparatos y accesorios el&eacute;ctricos'
        when '567' then 'Herramientas y m&aacute;quinas herramienta'
        when '591' then 'Software'
        when '452' then 'Pensiones y Jubilaciones'
        when '399' then 'Erogaciones por Operaciones Ajenas'
        when '724' then 'Retenciones por Operaciones Ajenas'
    end
    <cfelse>
    case CtpGsto
        when '113' then 'Sueldos base al personal permanente'
        when '131' then 'Prima de antiguedad'
        when '132' then 'Prima de vacaciones y dominical'
        when '133' then 'Remuneraciones por horas extraordinarias'
        when '141' then 'Aportaciones de seguridad social'
        when '142' then 'Aportaciones a fondos de vivienda'
        when '143' then 'Aportaciones al sistema para el retiro'
        when '144' then 'Aportaciones para seguros'
        when '151' then 'Cuotas para el fondo de ahorro y fondo de trabajo'
        when '152' then 'Indemnizaciones'
        when '153' then 'Prestaciones y haberes de retiro'
        when '154' then 'Prestaciones contractuales'
        when '155' then 'Apoyos a la capacitación de servidores públicos'
        when '159' then 'Otras prestaciones'
        when '161' then 'Previsiones de caracter laboral, económica y de seguridad social'
        when '211' then 'Materiales, útiles y equipos menores de oficina'
        when '214' then 'Materiales, útiles y equipos menores de tecnologías de información y comunicaciones'
        when '215' then 'Material impreso e información digital'
        when '216' then 'Material de limpieza'
        when '221' then 'Productos alimenticios para el personal'
        when '223' then 'Utensilios para el servicio de alimentación'
        when '246' then 'Material eléctrico y electrónico'
        when '248' then 'Materiales complementarios'
        when '249' then 'Otros materiales y artículos de construcción y reparación'
        when '261' then 'Combustibles, lubricantes y aditivos'
        when '271' then 'Vestuarios y uniformes'
        when '272' then 'Prendas de seguridad y protección personal'
        when '291' then 'Herramientas menores'
        when '294' then 'Refacciones y accesorios menores de equipo de cómputo y tecnologías de la información'
        when '299' then 'Refacciones y accesorios menores otros bienes muebles'
        when '314' then 'Servicio telefónico convencional'
        when '315' then 'Telefonía celular'
        when '316' then 'Servicios de telecomunicaciones'
        when '317' then 'Servicios  de acceso a internet, redes y procesamiento de información'
        when '318' then 'Servicios postales y telegráficos'
        when '322' then 'Arrendamiento de edificios'
        when '323' then 'Arrendamiento de mobiliario y equipo de administración'
        when '325' then 'Arrendamiento de equipo de transporte'
        when '326' then 'Arrendamiento de maquinaria, otros equipos y herramientas'
        when '327' then 'Arrendamiento de activos intangibles'
        when '331' then 'Servicios legales, de contabilidad, auditoria y relacionados'
        when '333' then 'Servicios de consultoría administrativa, procesos, técnica  y en tecnologías de la información'
        when '334' then 'Servicios de capacitación'
        when '336' then 'Servicios de apoyo administrativo, traducción, fotocopiado e impresión'
        when '339' then 'Servicios profesionales, científicos y técnicos integrales'
        when '344' then 'Seguros de responsabilidad patrimonial y fianzas'
        when '345' then 'Seguros de bienes patrimoniales'
        when '351' then 'Conservación y mantenimiento menor de inmuebles'
        when '352' then 'Instalación, reparación y mantenimiento de mobiliario y equipo de administración'
        when '353' then 'Instalación, reparación y mantenimiento de equipo de cómputo y tecnología de la información'
        when '355' then 'Reparación y mantenimiento de equipo de transporte'
        when '371' then 'Pasajes aéreos'
        when '372' then 'Pasajes terrestres'
        when '375' then 'Viáticos en el país'
        when '376' then 'Viáticos en el extranjero'
        when '382' then 'Gastos de orden social'
        when '383' then 'Congresos y convenciones'
        when '385' then 'Gastos de representación'
        when '398' then 'Impuesto sobre nóminas'
        when '391' then 'Servicios funerarios y de cementerios'
        when '392' then 'Impuestos y derechos'
        when '395' then 'Penas, multas, accesorios y actualizaciones'
        when '397' then 'Utilidades'
        when '398' then 'Impuesto sobre nóminas y otros que se deriven de una relación laboral'
        when '511' then 'Mobiliario de oficina'
        when '515' then 'Equipo de cómputo y de tecnologías de información'
        when '519' then 'Otros mobiliarios y equipo de administración'
        when '541' then 'Vehículos y equipo terrestres'
        when '565' then 'Equipos de comunicación y telecomunicación'
        when '566' then 'Equipo de generación eléctrica, aparatos y accesorios eléctricos'
        when '567' then 'Herramientas y máquinas herramienta'
        when '591' then 'Software'
        when '452' then 'Pensiones y Jubilaciones'
        when '399' then 'Erogaciones por Operaciones Ajenas'
        when '724' then 'Retenciones por Operaciones Ajenas'
    end
    </cfif>
    ,
    Campo8211 = (-1) * (
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
    </cfif>),
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
    #saldoscuenta#.CtpGsto = #SC.CtpGsto#
    </cfquery>
</cfloop>
<!---<cf_dump var="SALDOS">--->
<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">
--->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by CtpGsto
</cfquery>

<cfset subSerPer8211 	= 0>
<cfset subSerPer8231A 	= 0>
<cfset subSerPer8231C 	= 0>
<cfset subSerPer8240 	= 0>
<cfset subSerPer8241 	= 0>
<cfset subSerPer8251 	= 0>
<cfset subSerPer8261 	= 0>
<cfset subSerPer8271 	= 0>

<cfset subMyS8211 	= 0>
<cfset subMyS8231A 	= 0>
<cfset subMyS8231C 	= 0>
<cfset subMyS8240 	= 0>
<cfset subMyS8241 	= 0>
<cfset subMyS8251 	= 0>
<cfset subMyS8261 	= 0>
<cfset subMyS8271 	= 0>

<cfset subSG8211 	= 0>
<cfset subSG8231A 	= 0>
<cfset subSG8231C 	= 0>
<cfset subSG8240 	= 0>
<cfset subSG8241 	= 0>
<cfset subSG8251 	= 0>
<cfset subSG8261 	= 0>
<cfset subSG8271 	= 0>

<cfset subOC8211 	= 0>
<cfset subOC8231A 	= 0>
<cfset subOC8231C 	= 0>
<cfset subOC8240 	= 0>
<cfset subOC8241 	= 0>
<cfset subOC8251 	= 0>
<cfset subOC8261 	= 0>
<cfset subOC8271 	= 0>

<cfset subBien8211 	= 0>
<cfset subBien8231A = 0>
<cfset subBien8231C = 0>
<cfset subBien8240 	= 0>
<cfset subBien8241 	= 0>
<cfset subBien8251 	= 0>
<cfset subBien8261 	= 0>
<cfset subBien8271 	= 0>

<cfset subPen8211 	= 0>
<cfset subPen8231A = 0>
<cfset subPen8231C = 0>
<cfset subPen8240 	= 0>
<cfset subPen8241 	= 0>
<cfset subPen8251 	= 0>
<cfset subPen8261 	= 0>
<cfset subPen8271 	= 0>

<cfset subOperAj8211 	= 0>
<cfset subOperAj8231A 	= 0>
<cfset subOperAj8231C 	= 0>
<cfset subOperAj8240 	= 0>
<cfset subOperAj8241 	= 0>
<cfset subOperAj8251 	= 0>
<cfset subOperAj8261 	= 0>
<cfset subOperAj8271 	= 0>

<cfloop query="SC">
	<cfif SC.Seccion eq '10'>
		<cfset subSerPer8211 	= #subSerPer8211#  + #SC.Campo8211#>
        <cfset subSerPer8231A 	= #subSerPer8231A# + #SC.Campo8231A#>
        <cfset subSerPer8231C 	= #subSerPer8231C# + #SC.Campo8231C#>
        <cfset subSerPer8240 	= #subSerPer8240#  + #SC.Campo8240#>
        <cfset subSerPer8241 	= #subSerPer8241#  + #SC.Campo8241#>
        <cfset subSerPer8251 	= #subSerPer8251#  + #SC.Campo8251#>
        <cfset subSerPer8261 	= #subSerPer8261#  + #SC.Campo8261#>
        <cfset subSerPer8271 	= #subSerPer8271#  + #SC.Campo8271#>    
    </cfif>

	<cfif SC.Seccion eq '20'>
		<cfset subMyS8211 	= #subMyS8211#  + #SC.Campo8211#>
        <cfset subMyS8231A 	= #subMyS8231A# + #SC.Campo8231A#>
        <cfset subMyS8231C 	= #subMyS8231C# + #SC.Campo8231C#>
        <cfset subMyS8240 	= #subMyS8240#  + #SC.Campo8240#>
        <cfset subMyS8241 	= #subMyS8241#  + #SC.Campo8241#>
        <cfset subMyS8251 	= #subMyS8251#  + #SC.Campo8251#>
        <cfset subMyS8261 	= #subMyS8261#  + #SC.Campo8261#>
        <cfset subMyS8271 	= #subMyS8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.Seccion eq '30'>
		<cfset subSG8211 	= #subSG8211#  + #SC.Campo8211#>
        <cfset subSG8231A 	= #subSG8231A# + #SC.Campo8231A#>
        <cfset subSG8231C 	= #subSG8231C# + #SC.Campo8231C#>
        <cfset subSG8240 	= #subSG8240#  + #SC.Campo8240#>
        <cfset subSG8241 	= #subSG8241#  + #SC.Campo8241#>
        <cfset subSG8251 	= #subSG8251#  + #SC.Campo8251#>
        <cfset subSG8261 	= #subSG8261#  + #SC.Campo8261#>
        <cfset subSG8271 	= #subSG8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.Seccion eq '40'>
		<cfset subOC8211 	= #subOC8211#  + #SC.Campo8211#>
        <cfset subOC8231A 	= #subOC8231A# + #SC.Campo8231A#>
        <cfset subOC8231C 	= #subOC8231C# + #SC.Campo8231C#>
        <cfset subOC8240 	= #subOC8240#  + #SC.Campo8240#>
        <cfset subOC8241 	= #subOC8241#  + #SC.Campo8241#>
        <cfset subOC8251 	= #subOC8251#  + #SC.Campo8251#>
        <cfset subOC8261 	= #subOC8261#  + #SC.Campo8261#>
        <cfset subOC8271 	= #subOC8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.Seccion eq '50'>
		<cfset subBien8211 	= #subBien8211#  + #SC.Campo8211#>
        <cfset subBien8231A = #subBien8231A# + #SC.Campo8231A#>
        <cfset subBien8231C = #subBien8231C# + #SC.Campo8231C#>
        <cfset subBien8240 	= #subBien8240#  + #SC.Campo8240#>
        <cfset subBien8241 	= #subBien8241#  + #SC.Campo8241#>
        <cfset subBien8251 	= #subBien8251#  + #SC.Campo8251#>
        <cfset subBien8261 	= #subBien8261#  + #SC.Campo8261#>
        <cfset subBien8271 	= #subBien8271#  + #SC.Campo8271#>    
    </cfif>
	<cfif SC.Seccion eq '80'>
		<cfset subPen8211 	= #subPen8211#  + #SC.Campo8211#>
        <cfset subPen8231A 	= #subPen8231A# + #SC.Campo8231A#>
        <cfset subPen8231C 	= #subPen8231C# + #SC.Campo8231C#>
        <cfset subPen8240 	= #subPen8240#  + #SC.Campo8240#>
        <cfset subPen8241 	= #subPen8241#  + #SC.Campo8241#>
        <cfset subPen8251 	= #subPen8251#  + #SC.Campo8251#>
        <cfset subPen8261 	= #subPen8261#  + #SC.Campo8261#>
        <cfset subPen8271 	= #subPen8271#  + #SC.Campo8271#>    
    </cfif>
	<cfif SC.Seccion eq '90'>
		<cfset subOperAj8211 	= #subOperAj8211#  + #SC.Campo8211#>
        <cfset subOperAj8231A 	= #subOperAj8231A# + #SC.Campo8231A#>
        <cfset subOperAj8231C 	= #subOperAj8231C# + #SC.Campo8231C#>
        <cfset subOperAj8240 	= #subOperAj8240#  + #SC.Campo8240#>
        <cfset subOperAj8241 	= #subOperAj8241#  + #SC.Campo8241#>
        <cfset subOperAj8251 	= #subOperAj8251#  + #SC.Campo8251#>
        <cfset subOperAj8261 	= #subOperAj8261#  + #SC.Campo8261#>
        <cfset subOperAj8271 	= #subOperAj8271#  + #SC.Campo8271#>    
    </cfif>
</cfloop>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,15,'','SUBTOTAL SERVICIOS PERSONALES','A',#varMcodigo#, #subSerPer8211#, #subSerPer8231A#, #subSerPer8231C#, #subSerPer8240#, #subSerPer8241#, #subSerPer8251#, #subSerPer8261#, #subSerPer8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,25,'','SUBTOTAL MATERIALES Y SUMINISTROS','A',#varMcodigo#, #subMyS8211#, #subMyS8231A#, #subMyS8231C#, #subMyS8240#, #subMyS8241#, #subMyS8251#, #subMyS8261#, #subMyS8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,35,'','SUBTOTAL SERVICIOS GENERALES','A',#varMcodigo#, #subSG8211#, #subSG8231A#, #subSG8231C#, #subSG8240#, #subSG8241#, #subSG8251#, #subSG8261#, #subSG8271#)
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,36,'','SUMA GASTOS DE OPERACIÓN','A',#varMcodigo#,
    #subSG8211# + #subMyS8211#, 
    #subSG8231A#+ #subMyS8231A#, 
    #subSG8231C#+ #subMyS8231C#, 
    #subSG8240# + #subMyS8240#, 
    #subSG8241# + #subMyS8241#, 
    #subSG8251# + #subMyS8251#, 
    #subSG8261# + #subMyS8261#, 
    #subSG8271# + #subMyS8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,45,'','SUBTOTAL OTROS DE CORRIENTE','A',#varMcodigo#, #subOC8211#, #subOC8231A#, #subOC8231C#, #subOC8240#, #subOC8241#, #subOC8251#, #subOC8261#, #subOC8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,46,'','SUMA GASTO CORRIENTE','A',#varMcodigo#, 
	#subSerPer8211#  + #subSG8211# + #subMyS8211# +#subOC8211#, 
    #subSerPer8231A# + #subSG8231A#+ #subMyS8231A#+#subOC8231A#, 
    #subSerPer8231C# + #subSG8231C#+ #subMyS8231C#+#subOC8231C#, 
    #subSerPer8240#  + #subSG8240# + #subMyS8240# +#subOC8240#, 
    #subSerPer8241#  + #subSG8241# + #subMyS8241# +#subOC8241#, 
    #subSerPer8251#  + #subSG8251# + #subMyS8251# +#subOC8251#, 
    #subSerPer8261#  + #subSG8261# + #subMyS8261# +#subOC8261#, 
    #subSerPer8271#  + #subSG8271# + #subMyS8271# +#subOC8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,85,'','SUBTOTAL PENSIONES Y JUBILACIONES','A',#varMcodigo#, #subPen8211#, #subPen8231A#, #subPen8231C#, #subPen8240#, #subPen8241#, #subSerPer8251#, #subPen8261#, #subPen8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,86,'','TOTAL PENSIONES Y JUBILACIONES','A',#varMcodigo#, #subPen8211#, #subPen8231A#, #subPen8231C#, #subPen8240#, #subPen8241#, #subSerPer8251#, #subPen8261#, #subPen8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,95,'','SUBTOTAL OPERACIONES AJENAS','A',#varMcodigo#, #subOperAj8211#, #subOperAj8231A#, #subOperAj8231C#, #subOperAj8240#, #subOperAj8241#, #subOperAj8251#, #subOperAj8261#, #subOperAj8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,96,'','TOTAL OPERACIONES AJENAS','A',#varMcodigo#, #subOperAj8211#, #subOperAj8231A#, #subOperAj8231C#, #subOperAj8240#, #subOperAj8241#, #subOperAj8251#, #subOperAj8261#, #subOperAj8271#)
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,55,'','SUBTOTAL BIENES MUEBLES, INMUEBLES E INTANGIBLES','A',#varMcodigo#, #subBien8211#, #subBien8231A#, #subBien8231C#, #subBien8240#, #subBien8241#, #subBien8251#, #subBien8261#, #subBien8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,56,'','SUMA GASTO DE INVERSIÓN','A',#varMcodigo#, #subBien8211#, #subBien8231A#, #subBien8231C#, #subBien8240#, #subBien8241#, #subBien8251#, #subBien8261#, #subBien8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,60,'','TOTAL GASTO PROGRAMABLE','A',#varMcodigo#, 
    #subSerPer8211# + (#subSG8211#  + #subMyS8211#)  +#subOC8211#  + #subBien8211#, 
    #subSerPer8231A#+ (#subSG8231A# + #subMyS8231A#) +#subOC8231A# + #subBien8231A#, 
    #subSerPer8231C#+ (#subSG8231C# + #subMyS8231C#) +#subOC8231C# + #subBien8231C#, 
    #subSerPer8240# + (#subSG8240#  + #subMyS8240#)  +#subOC8240#  + #subBien8240#, 
    #subSerPer8241# + (#subSG8241#  + #subMyS8241#)  +#subOC8241#  + #subBien8241#, 
    #subSerPer8251# + (#subSG8251#  + #subMyS8251#)  +#subOC8251#  + #subBien8251#, 
    #subSerPer8261# + (#subSG8261#  + #subMyS8261#)  +#subOC8261#  + #subBien8261#, 
    #subSerPer8271# + (#subSG8271#  + #subMyS8271#)  +#subOC8271#  + #subBien8271#)
</cfquery>

<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">--->

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select s.Seccion,
    case s.Seccion
    	when 15 then ''
    	when 25 then ''
    	when 35 then ''
    	when 36 then ''
    	when 45 then ''
        when 46 then ''
        when 55 then ''
        when 56 then ''
    	when 60 then ''
        when 85 then ''
    	when 86 then ''
        when 95 then ''
    	when 96 then ''
        else s.CtpGsto
    end as CtpGsto,
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
    where left(CtpGsto,3)<>'395'
    <cfif rsPrograma.PCCDvalor eq 'O001'> <!---O001--->
    and s.Seccion not in (50,55,56,80,85,86,90,95,96)
    <cfelseif rsPrograma.PCCDvalor eq 'J007'> <!---J007--->
    and s.Seccion in (80,85,86)
    <cfelseif rsPrograma.PCCDvalor eq 'E527'> <!---E527--->
    and s.Seccion not in (80,85,86,90,95,96)
    <cfelseif rsPrograma.PCCDvalor eq 'M001'> <!---M001--->
    and s.Seccion not in (80,85,86,90,95,96)
    <cfelseif rsPrograma.PCCDvalor eq 'W001'> <!---W001--->
    and s.Seccion in (90,95,96)
    </cfif>
    <cfif form.chkCeros eq '0'>
     	and s.Campo8211 <> 0 or
    	 s.Campo8231A <> 0 or
         s.Campo8231C <> 0 or
         s.Campo8240 <> 0 or
         s.Campo8241 <> 0 or
         s.Campo8251 <> 0 or
         s.Campo8261 <> 0 or
         s.Campo8271 <> 0
    </cfif> 
      
    <cfif rsPrograma.PCCDvalor neq 'J007' and rsPrograma.PCCDvalor neq 'W001'>
 	union
 	select min(s.Seccion) as Seccion,
	min(CtpGsto) as CtpGsto, 'PENAS, MULTAS, ACCESORIOS Y ACTUALIZACIONES' as CGEPDescrip,
    min(Mcodigo),
    sum(Campo8211)/#varUnidad# 	as Column8211,
    sum(Campo8231A)/#varUnidad#	as Column8231A,
    sum(Campo8231C)/#varUnidad# 	as Column8231C,
    sum(Campo8240)/#varUnidad# 	as Column8240,
    sum(Campo8241)/#varUnidad# 	as Column8241, 
    sum(Campo8251)/#varUnidad# 	as Column8251,
    sum(Campo8261)/#varUnidad# 	as Column8261,
    sum(Campo8271)/#varUnidad# 	as Column8271,
    
    (sum(Campo8211)+sum(Campo8231A)-sum(Campo8231C))/#varUnidad#   as ColumnPRVig,
    (sum(Campo8211)+sum(Campo8231A)-sum(Campo8231C)-sum(Campo8240)/#varUnidad#)   as ColumnPRVigSC,
    (sum(Campo8240)-sum(Campo8241))/#varUnidad#   as ColumnPRSC,
    ((sum(Campo8211)+sum(Campo8231A)-sum(Campo8231C))-sum(Campo8241))/#varUnidad# as ColumnPRDisp,
    (sum(Campo8241)-sum(Campo8251))/#varUnidad#	as ColumnCompSD,
    (sum(Campo8211)+sum(Campo8231A)-sum(Campo8231C)-sum(Campo8251))/#varUnidad# as ColumnPRVigSD,
    (sum(Campo8251)-sum(Campo8261))/#varUnidad#	as ColumnDevSE,
    (sum(Campo8261)-sum(Campo8271))/#varUnidad#	as ColumnEjerSP,
    (sum(Campo8251)-sum(Campo8271))/#varUnidad#	as ColumnCtasPP

    from #saldoscuenta# s
    where left(CtpGsto,3)='395'
    <cfif form.chkCeros eq '0'>
     	and s.Campo8211 <> 0 or
    	 s.Campo8231A <> 0 or
         s.Campo8231C <> 0 or
         s.Campo8240 <> 0 or
         s.Campo8241 <> 0 or
         s.Campo8251 <> 0 or
         s.Campo8261 <> 0 or
         s.Campo8271 <> 0
    </cfif>     
	</cfif>
    order by s.Seccion
</cfquery>

<!---<cf_dump var="#rsDetalle#">--->

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

<cfif form.formato NEQ "HTML">
	<cfif #form.mensAcum# eq 1>
       <cfset LabelFechaFin = #LabelFechaFin#&' Mensual'>
    <cfelse>
       <cfset LabelFechaFin = #LabelFechaFin#&' Acumulado'>
    </cfif>
    <cfreport format="#form.formato#" template= "EEPrPGGAIM.cfr" query="rsDetalle">
        <cfreportparam name="periodo_ini" 	value="#LabelFechaFin#">
        <cfreportparam name="moneda" 		value="#rsMoneda.Mnombre#">
        <cfreportparam name="cveMoneda" 	value="#rsNombreEmpresa.Mcodigo#">
        <cfreportparam name="Unidad"  		value="#varUnidad#">
        <cfreportparam name="Edescripcion"	value="#rsNombreEmpresa.Edescripcion#">
        <cfreportparam name="PrgValor"		value="#rsPrograma.PCCDvalor#"> 
        <cfreportparam name="PrgDescr"		value="#rsPrograma.descrip#">
        <cfreportparam name="PrgDescAct"	value="#rsPrograma.descAct#">	
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
                <td style="font-size:16px" align="center" colspan="7"nowrap="nowrap">
                    <strong>Programa presupuestario: #rsPrograma.PCCDvalor# #rsPrograma.descrip#</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="7"nowrap="nowrap">
                    <strong>Actividad Institucional: #rsPrograma.descAct#</strong>
                </td>
            </tr>            
            <tr>
                <td style="font-size:16px" align="center" colspan="7"nowrap="nowrap">
                    <strong>Modalidad: #left(rsPrograma.PCCDvalor,1)#</strong>
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
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td align="center" colspan="17" nowrap="nowrap"><strong>#LB_Ejercicio#</strong></td>
            </tr>
        	<tr>
                <td align="center" rowspan="5" valign="middle"><strong>#LB_Concepto#</strong></td>
                <td align="center" rowspan="5" valign="middle" nowrap="nowrap"><strong>#LB_Desc#</strong></td>
            </tr>
            <tr>
                <td align="left"   nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ampl#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Reduc#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Precom#</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Comprtd#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Precom#</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Dev#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Comprsin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Presup#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ejer#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Devsin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Pagdo#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ejersin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ctaspor#</strong></td>
            </tr>
             <tr>
                <td align="center" nowrap="nowrap"><strong>#LB_Aprob#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Vigen#</strong></td>
				<td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Vigensin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Sincomp#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Disp#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Devgr#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Vigensin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ejercer#</strong></td>
                <td align="center" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Pagar#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Pagar#</strong></td>
			</tr>            
           <tr>
                <td align="center" colspan="5" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Precomet#</strong></td>
                <td align="center" colspan="2" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Compr#</strong></td>
                <td align="center" colspan="2" nowrap="nowrap"><strong>&nbsp;</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Devgr#</strong></td>
			</tr>            
            <tr>
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
                     
            <cfloop query="rsDetalle">
				<tr>
                	<cfif rsDetalle.CtpGsto gt 0>
                		<td nowrap align="left">#UCase(left(rsDetalle.CtpGsto,3))#</td>
                    <cfelse>
                    	<td align="center" valign="top">&nbsp;</td>
                    </cfif>
					<td nowrap align="left">#rsDetalle.CGEPDescrip#</td>
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