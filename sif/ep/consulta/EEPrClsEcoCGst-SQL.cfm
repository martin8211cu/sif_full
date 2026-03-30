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
<c_dump var ="cuentas">--->

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

<cfinvoke key="MSG_ReporteAnalitico" default="Estado del Ejercicio del Presupuesto por Clasificaci&oacute;n Econ&oacute;mica y Conceptos del Gasto"	returnvariable="MSG_ReporteAnalitico"	
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
<cfinvoke key="LB_Concepto" 	default="Concepto de gasto"	returnvariable="LB_Concepto"				component="sif.Componentes.Translate" method="Translate"/>
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

<cfset LvarIrA  = 'EEPrClsEcoCGst.cfm'>
<cfset LvarFile = 'EEPrClsEcoCGst'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
    <cf_dbtempcol name="ID_Estr"  		type="int">
    <cf_dbtempcol name="Seccion"  		type="int">
    <cf_dbtempcol name="CtpGsto"  		type="int">
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

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
	select rep.ID_Estr, 
    case left(epv.EPCPcodigo,4)
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
    left(epv.EPCPcodigo,4),epv.EPCPdescripcion,    
    'A',#varMcodigo#, 0, 0, 0, 0, 0, 0, 0, 0
from CGReEstrProg rep 
        inner join CGEstrProgVal epv
        on rep.ID_Estr= epv.ID_Estr
where rep.SPcodigo='#session.menues.SPCODIGO#' and epv.EPCPcodigo<>'39002'
 </cfquery>
 
 <cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,330,'3900','EROGACIONES POR OPERACIONES AJENAS','C',#varMcodigo#, 0, 0, 0, 0, 0, 0, 0, 0)
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

<!---<cf_dumptofile select="select * from #rsEPQuery# order by Cmayor">--->

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
		where r.Cmayor = '#CtaPresAprob#'
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
    #saldoscuenta#.CtpGsto = #SC.CtpGsto# and #saldoscuenta#.Seccion = #SC.Seccion#
    </cfquery>
</cfloop>
<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">
--->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by Seccion
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

<cfset subPyJ8211 	= 0>
<cfset subPyJ8231A 	= 0>
<cfset subPyJ8231C 	= 0>
<cfset subPyJ8240 	= 0>
<cfset subPyJ8241 	= 0>
<cfset subPyJ8251 	= 0>
<cfset subPyJ8261 	= 0>
<cfset subPyJ8271 	= 0>

<cfset subBienes8211 	= 0>
<cfset subBienes8231A 	= 0>
<cfset subBienes8231C 	= 0>
<cfset subBienes8240 	= 0>
<cfset subBienes8241 	= 0>
<cfset subBienes8251 	= 0>
<cfset subBienes8261 	= 0>
<cfset subBienes8271 	= 0>

<cfset subEA8211 	= 0>
<cfset subEA8231A 	= 0>
<cfset subEA8231C 	= 0>
<cfset subEA8240 	= 0>
<cfset subEA8241 	= 0>
<cfset subEA8251 	= 0>
<cfset subEA8261 	= 0>
<cfset subEA8271 	= 0>

<cfloop query="SC">
	<cfif SC.CtpGsto eq '1100' or SC.CtpGsto eq '1300' or SC.CtpGsto eq '1400' or SC.CtpGsto eq '1500' or SC.CtpGsto eq '1600'or SC.CtpGsto eq '1700'>
		<cfset subSerPer8211 	= #subSerPer8211#  + #SC.Campo8211#>
        <cfset subSerPer8231A 	= #subSerPer8231A# + #SC.Campo8231A#>
        <cfset subSerPer8231C 	= #subSerPer8231C# + #SC.Campo8231C#>
        <cfset subSerPer8240 	= #subSerPer8240#  + #SC.Campo8240#>
        <cfset subSerPer8241 	= #subSerPer8241#  + #SC.Campo8241#>
        <cfset subSerPer8251 	= #subSerPer8251#  + #SC.Campo8251#>
        <cfset subSerPer8261 	= #subSerPer8261#  + #SC.Campo8261#>
        <cfset subSerPer8271 	= #subSerPer8271#  + #SC.Campo8271#>    
    </cfif>

	<cfif SC.CtpGsto eq '2100' or SC.CtpGsto eq '2200' or SC.CtpGsto eq '2400' or SC.CtpGsto eq '2900' or SC.CtpGsto eq '2600'or SC.CtpGsto eq '2700'>
		<cfset subMyS8211 	= #subMyS8211#  + #SC.Campo8211#>
        <cfset subMyS8231A 	= #subMyS8231A# + #SC.Campo8231A#>
        <cfset subMyS8231C 	= #subMyS8231C# + #SC.Campo8231C#>
        <cfset subMyS8240 	= #subMyS8240#  + #SC.Campo8240#>
        <cfset subMyS8241 	= #subMyS8241#  + #SC.Campo8241#>
        <cfset subMyS8251 	= #subMyS8251#  + #SC.Campo8251#>
        <cfset subMyS8261 	= #subMyS8261#  + #SC.Campo8261#>
        <cfset subMyS8271 	= #subMyS8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.CtpGsto eq '3100' or SC.CtpGsto eq '3200' or SC.CtpGsto eq '3400' or SC.CtpGsto eq '3300' or SC.CtpGsto eq '3500'or SC.CtpGsto eq '3700' or SC.CtpGsto eq '3800'>
		<cfset subSG8211 	= #subSG8211#  + #SC.Campo8211#>
        <cfset subSG8231A 	= #subSG8231A# + #SC.Campo8231A#>
        <cfset subSG8231C 	= #subSG8231C# + #SC.Campo8231C#>
        <cfset subSG8240 	= #subSG8240#  + #SC.Campo8240#>
        <cfset subSG8241 	= #subSG8241#  + #SC.Campo8241#>
        <cfset subSG8251 	= #subSG8251#  + #SC.Campo8251#>
        <cfset subSG8261 	= #subSG8261#  + #SC.Campo8261#>
        <cfset subSG8271 	= #subSG8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif left(SC.CtpGsto,4) eq '3900' and SC.Seccion eq 230>
		<cfset subOC8211 	= #subOC8211#  + #SC.Campo8211#>
        <cfset subOC8231A 	= #subOC8231A# + #SC.Campo8231A#>
        <cfset subOC8231C 	= #subOC8231C# + #SC.Campo8231C#>
        <cfset subOC8240 	= #subOC8240#  + #SC.Campo8240#>
        <cfset subOC8241 	= #subOC8241#  + #SC.Campo8241#>
        <cfset subOC8251 	= #subOC8251#  + #SC.Campo8251#>
        <cfset subOC8261 	= #subOC8261#  + #SC.Campo8261#>
        <cfset subOC8271 	= #subOC8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif SC.CtpGsto eq '4500'>
		<cfset subPyJ8211 	= #subPyJ8211#  + #SC.Campo8211#>
        <cfset subPyJ8231A 	= #subPyJ8231A# + #SC.Campo8231A#>
        <cfset subPyJ8231C 	= #subPyJ8231C# + #SC.Campo8231C#>
        <cfset subPyJ8240 	= #subPyJ8240#  + #SC.Campo8240#>
        <cfset subPyJ8241 	= #subPyJ8241#  + #SC.Campo8241#>
        <cfset subPyJ8251 	= #subPyJ8251#  + #SC.Campo8251#>
        <cfset subPyJ8261 	= #subPyJ8261#  + #SC.Campo8261#>
        <cfset subPyJ8271 	= #subPyJ8271#  + #SC.Campo8271#>    
    </cfif>

	<cfif SC.CtpGsto eq '5100' or SC.CtpGsto eq '5400' or SC.CtpGsto eq '5900' or SC.CtpGsto eq '5600'>
		<cfset subBienes8211 	= #subBienes8211#  + #SC.Campo8211#>
        <cfset subBienes8231A 	= #subBienes8231A# + #SC.Campo8231A#>
        <cfset subBienes8231C 	= #subBienes8231C# + #SC.Campo8231C#>
        <cfset subBienes8240 	= #subBienes8240#  + #SC.Campo8240#>
        <cfset subBienes8241 	= #subBienes8241#  + #SC.Campo8241#>
        <cfset subBienes8251 	= #subBienes8251#  + #SC.Campo8251#>
        <cfset subBienes8261 	= #subBienes8261#  + #SC.Campo8261#>
        <cfset subBienes8271 	= #subBienes8271#  + #SC.Campo8271#>    
    </cfif>
    
	<cfif left(SC.CtpGsto,4) eq '3900' and SC.Seccion eq 330 or (SC.CtpGsto eq '7200')>
		<cfset subEA8211 	= #subEA8211#  + #SC.Campo8211#>
        <cfset subEA8231A 	= #subEA8231A# + #SC.Campo8231A#>
        <cfset subEA8231C 	= #subEA8231C# + #SC.Campo8231C#>
        <cfset subEA8240 	= #subEA8240#  + #SC.Campo8240#>
        <cfset subEA8241 	= #subEA8241#  + #SC.Campo8241#>
        <cfset subEA8251 	= #subEA8251#  + #SC.Campo8251#>
        <cfset subEA8261 	= #subEA8261#  + #SC.Campo8261#>
        <cfset subEA8271 	= #subEA8271#  + #SC.Campo8271#>    
    </cfif>
    
</cfloop>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,60,'','SUBTOTAL SERVICIOS PERSONALES','A',#varMcodigo#, #subSerPer8211#, #subSerPer8231A#, #subSerPer8231C#, #subSerPer8240#, #subSerPer8241#, #subSerPer8251#, #subSerPer8261#, #subSerPer8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,130,'','SUBTOTAL MATERIALES Y SUMINISTROS','A',#varMcodigo#, #subMyS8211#, #subMyS8231A#, #subMyS8231C#, #subMyS8240#, #subMyS8241#, #subMyS8251#, #subMyS8261#, #subMyS8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,210,'','SUBTOTAL SERVICIOS GENERALES','A',#varMcodigo#, #subSG8211#, #subSG8231A#, #subSG8231C#, #subSG8240#, #subSG8241#, #subSG8251#, #subSG8261#, #subSG8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,220,'','SUMA GASTOS DE OPERACIÓN','A',#varMcodigo#,
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
    values(4,240,'','SUBTOTAL OTROS DE CORRIENTE','A',#varMcodigo#, #subOC8211#, #subOC8231A#, #subOC8231C#, #subOC8240#, #subOC8241#, #subOC8251#, #subOC8261#, #subOC8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,260,'','SUBTOTAL PENSIONES Y JUBILACIONES','A',#varMcodigo#, #subPyJ8211#, #subPyJ8231A#, #subPyJ8231C#, #subPyJ8240#, #subPyJ8241#, #subPyJ8251#, #subPyJ8261#, #subPyJ8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,270,'','SUMA GASTO CORRIENTE','A',#varMcodigo#, 
    #subSerPer8211# + (#subSG8211#  + #subMyS8211#)  +#subOC8211# +#subPyJ8211#, 
    #subSerPer8231A#+ (#subSG8231A# + #subMyS8231A#) +#subOC8231A#+#subPyJ8231A#, 
    #subSerPer8231C#+ (#subSG8231C# + #subMyS8231C#) +#subOC8231C#+#subPyJ8231C#, 
    #subSerPer8240# + (#subSG8240#  + #subMyS8240#)  +#subOC8240# +#subPyJ8240#, 
    #subSerPer8241# + (#subSG8241#  + #subMyS8241#)  +#subOC8241# +#subPyJ8241#, 
    #subSerPer8251# + (#subSG8251#  + #subMyS8251#)  +#subOC8251# +#subPyJ8251#, 
    #subSerPer8261# + (#subSG8261#  + #subMyS8261#)  +#subOC8261# +#subPyJ8261#, 
    #subSerPer8271# + (#subSG8271#  + #subMyS8271#)  +#subOC8271# +#subPyJ8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,320,'','SUBTOTAL BIENES MUEBLES, INMUEBLES E INTANGIBLES','A',#varMcodigo#, #subBienes8211#, #subBienes8231A#, #subBienes8231C#, #subBienes8240#, #subBienes8241#, #subBienes8251#, #subBienes8261#, #subBienes8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,350,'','SUBTOTAL OPERACIONES AJENAS','A',#varMcodigo#, #subEA8211#, #subEA8231A#, #subEA8231C#, #subEA8240#, #subEA8241#, #subEA8251#, #subEA8261#, #subEA8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,360,'','SUMA GASTO INVERSIÓN','A',#varMcodigo#, #subEA8211#+#subBienes8211#, #subEA8231A#+#subBienes8231A#, #subEA8231C#+#subBienes8231C#, #subEA8240#+#subBienes8240#, #subEA8241#+#subBienes8241#, #subEA8251#+#subBienes8251#, #subEA8261#+#subBienes8261#, #subEA8271#+#subBienes8271#)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,CtpGsto,CGEPDescrip,TipoCta,Mcodigo,Campo8211,Campo8231A,Campo8231C,Campo8240,Campo8241, 
    Campo8251,Campo8261,Campo8271)
    values(4,370,'','TOTAL GASTO PROGRAMABLE','A',#varMcodigo#, 
    #subEA8211#  + #subBienes8211#  + #subSerPer8211# + (#subSG8211#  + #subMyS8211#)  +#subOC8211# +#subPyJ8211#, 
    #subEA8231A# + #subBienes8231A# + #subSerPer8231A#+ (#subSG8231A# + #subMyS8231A#) +#subOC8231A#+#subPyJ8231A#, 
    #subEA8231C# + #subBienes8231C# + #subSerPer8231C#+ (#subSG8231C# + #subMyS8231C#) +#subOC8231C#+#subPyJ8231C#, 
    #subEA8240#  + #subBienes8240#  + #subSerPer8240# + (#subSG8240#  + #subMyS8240#)  +#subOC8240# +#subPyJ8240#, 
    #subEA8241#  + #subBienes8241#  + #subSerPer8241# + (#subSG8241#  + #subMyS8241#)  +#subOC8241# +#subPyJ8241#, 
    #subEA8251#  + #subBienes8251#  + #subSerPer8251# + (#subSG8251#  + #subMyS8251#)  +#subOC8251# +#subPyJ8251#, 
    #subEA8261#  + #subBienes8261#  + #subSerPer8261# + (#subSG8261#  + #subMyS8261#)  +#subOC8261# +#subPyJ8261#, 
    #subEA8271#  + #subBienes8271#  + #subSerPer8271# + (#subSG8271#  + #subMyS8271#)  +#subOC8271# +#subPyJ8271#)
</cfquery>

<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">--->

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select s.Seccion,
    case s.Seccion
    	when 370 then ''
    	when 360 then ''
    	when 350 then ''
    	when 320 then ''
    	when 260 then ''
    	when 240 then ''
    	when 220 then ''
    	when 210 then ''
    	when 130 then ''
    	when  60 then ''
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
    <cfif form.chkCeros eq '0'>
    where s.Campo8211 <> 0 or
    	 s.Campo8231A <> 0 or
         s.Campo8231C <> 0 or
         s.Campo8240 <> 0 or
         s.Campo8241 <> 0 or
         s.Campo8251 <> 0 or
         s.Campo8261 <> 0 or
         s.Campo8271 <> 0
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
    <cfreport format="#form.formato#" template= "EEPrClsEcoCGst.cfr" query="rsDetalle">
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
                		<td nowrap align="left">#UCase(rsDetalle.CtpGsto)#</td>
                    <cfelse>
                    	<td align="center" valign="top">&nbsp;</td>
                    </cfif>
					<td nowrap align="left">#UCase(rsDetalle.CGEPDescrip)#</td>
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