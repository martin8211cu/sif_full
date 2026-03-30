<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 03-01-2013.
	Reporte Analítico del Activo
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

<cfinvoke key="MSG_ReporteAnalitico" default="Estado Anal&iacute;tico de Ingresos Presupuestales"	returnvariable="MSG_ReporteAnalitico"	
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
	<cfinvoke key="MSG_Cifras_en" 	default=""					returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1>
<cfelseif #form.Unidad# eq 2>
	<cfinvoke key="MSG_Cifras_en" 	default="en miles de"		returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1000>
<cfelseif #form.Unidad# eq 3>
	<cfinvoke key="MSG_Cifras_en" 	default="en millones de"	returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 100000>
</cfif>

<cfinvoke key="LB_Rubro" 		default="Rubro/SubRubro"	returnvariable="LB_Rubro"				component="sif.Componentes.Translate" method="Translate"/>
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

<cfset LvarIrA = 'EAnalIngrPres.cfm'>
<cfset LvarFile = 'EAnalIngrPres'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

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
<cfelse>
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
    </cfloop>
</cfif>

<cfif isdefined('rsMensaje')>
	<cflocation url="EAnalIngrPRes.cfm?rsMensaje=#rsMensaje#">
</cfif>

</cfoutput>
<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
	<cf_dbtempcol name="ID_EstrCtaVal"  type="int">
	<cf_dbtempcol name="EPCPcodigo"  	type="varchar(200)">
	<cf_dbtempcol name="ID_DEstrCtaVal" type="numeric">
    <cf_dbtempcol name="PCDcatid" 		type="numeric">
    <cf_dbtempcol name="Mcodigo"  		type="integer">        
    <cf_dbtempcol name="CampoA"  		type="money">
    <cf_dbtempcol name="CampoB"  		type="money">
    <cf_dbtempcol name="CampoC"  		type="money">
    <cf_dbtempcol name="CampoD"  		type="money">
    <cf_dbtempcol name="CampoE"  		type="money">
    <cf_dbtempkey cols="ID_EstrCtaVal,EPCPcodigo,ID_DEstrCtaVal">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_EstrCtaVal,EPCPcodigo,ID_DEstrCtaVal,PCDcatid,Mcodigo,CampoA,CampoB,CampoC,CampoD,CampoE)
    select c.ID_EstrCtaVal ,c.EPCPcodigo, d.ID_DEstrCtaVal,p.PCDcatid,#varMcodigo#,0 ,0 ,0 ,0 ,0
    from CGEstrProgVal c
    inner join CGReEstrProg r
    on c.ID_Estr= r.ID_Estr
    inner join dbo.CGDEstrProgVal d
    on d.ID_EstrCtaVal=c.ID_EstrCtaVal
    left join PCDCatalogo p
       on d.PCDcatid=p.PCDcatid 
    where r.SPcodigo='#session.menues.SPCODIGO#'
 </cfquery>
 <!---<cf_dumptofile select="select * from #saldoscuenta#">--->
 
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
<!---<cf_dumptofile select="select * from #rsEPQuery#">--->

<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by PCDcatid
</cfquery>

<!----Actualizar saldos ----->
<cfloop query="SC">
    <cfquery datasource="#session.DSN#" name="Cmp_A">
        select 	coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #saldoscuenta# s
        inner join #rsEPQuery# r
        on s.PCDcatid = r.PCDcatid
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='A' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatid#
    </cfquery>
<!---    <cfdump var="CAMPO_A">
    <cfdump var="#Cmp_A.CLCreditos#">
    <cfdump var="#Cmp_A.DLDebitos#">
--->    
     <cfquery datasource="#session.DSN#" name="Cmp_B">
        select coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos 
        from #saldoscuenta# s
        inner join #rsEPQuery# r
        on s.PCDcatid = r.PCDcatid
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='D' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatid#
    </cfquery>
<!---    <cfdump var="CAMPO_B">
    <cfdump var="#Cmp_B.LCreditos#">
    <cfdump var="#Cmp_B.LDebitos#">
--->   
     <cfquery datasource="#session.DSN#" name="Cmp_C">
        select coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos 
        from #saldoscuenta# s
        inner join #rsEPQuery# r
        on s.PCDcatid = r.PCDcatid
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='M' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatid#
    </cfquery>
<!---    <cfdump var="CAMPO_C">
    <cfdump var="#Cmp_C.LCreditos#">
    <cfdump var="#Cmp_C.LDebitos#">
--->    
     <cfquery datasource="#session.DSN#" name="Cmp_D">
        select coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #saldoscuenta# s
        inner join #rsEPQuery# r
        on s.PCDcatid = r.PCDcatid
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='E' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatid#
    </cfquery>
<!---    <cfdump var="CAMPO_D">
    <cfdump var="#Cmp_D.LCreditos#">
    <cfdump var="#Cmp_D.LDebitos#">    
--->    
     <cfquery datasource="#session.DSN#" name="Cmp_E">
        select coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos 
        from #saldoscuenta# s
        inner join #rsEPQuery# r
        on s.PCDcatid = r.PCDcatid
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='P' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatid#
    </cfquery>
<!---    <cfdump var="CAMPO_E">
    <cfdump var="#Cmp_E.LCreditos#">
    <cfdump var="#Cmp_E.LDebitos#">     
--->    
	<cfquery datasource="#session.DSN#">
	update #saldoscuenta#
    set
	CampoA =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_A.DLdebitos#, 0.00)-coalesce(#Cmp_A.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_A.DOdebitos#, 0.00)-coalesce(#Cmp_A.COcreditos#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_A.SLinicial#, 0.00)+coalesce(#Cmp_A.DLdebitos#, 0.00)-coalesce(#Cmp_A.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_A.SOinicial#, 0.00)+coalesce(#Cmp_A.DOdebitos#, 0.00)-coalesce(#Cmp_A.COcreditos#, 0.00)
        </cfif> 
    </cfif>,
	CampoB =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_B.DLdebitos#, 0.00)-coalesce(#Cmp_B.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_B.DOdebitos#, 0.00)-coalesce(#Cmp_B.COcreditos#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_B.SLinicial#, 0.00)+coalesce(#Cmp_B.DLdebitos#, 0.00)-coalesce(#Cmp_B.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_B.SOinicial#, 0.00)+coalesce(#Cmp_B.DOdebitos#, 0.00)-coalesce(#Cmp_B.COcreditos#, 0.00)
        </cfif> 
    </cfif>,
	CampoC =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_C.DLdebitos#, 0.00)-coalesce(#Cmp_C.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_C.DOdebitos#, 0.00)-coalesce(#Cmp_C.COcreditos#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_C.SLinicial#, 0.00)+coalesce(#Cmp_C.DLdebitos#, 0.00)-coalesce(#Cmp_C.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_C.SOinicial#, 0.00)+coalesce(#Cmp_C.DOdebitos#, 0.00)-coalesce(#Cmp_C.COcreditos#, 0.00)
        </cfif> 
    </cfif>,
	CampoD =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_D.DLdebitos#, 0.00)-coalesce(#Cmp_D.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_D.DOdebitos#, 0.00)-coalesce(#Cmp_D.COcreditos#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_D.SLinicial#, 0.00)+coalesce(#Cmp_D.DLdebitos#, 0.00)-coalesce(#Cmp_D.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_D.SOinicial#, 0.00)+coalesce(#Cmp_D.DOdebitos#, 0.00)-coalesce(#Cmp_D.COcreditos#, 0.00)
        </cfif> 
    </cfif>,
	CampoE =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_E.DLdebitos#, 0.00)-coalesce(#Cmp_E.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_E.DOdebitos#, 0.00)-coalesce(#Cmp_E.COcreditos#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#Cmp_E.SLinicial#, 0.00)+coalesce(#Cmp_E.DLdebitos#, 0.00)-coalesce(#Cmp_E.CLcreditos#, 0.00)
        <cfelse>
        	coalesce(#Cmp_E.SOinicial#, 0.00)+coalesce(#Cmp_E.DOdebitos#, 0.00)-coalesce(#Cmp_E.COcreditos#, 0.00)
        </cfif> 
    </cfif>
    where 
    #saldoscuenta#.PCDcatid = #SC.PCDcatid#
     
    </cfquery>
</cfloop>
<!---<cf_dump var ="TOTALES">--->
<!---<cf_dumptofile select="select * from #saldoscuenta#">--->
<cfoutput>
    <cfswitch expression="#form.mes#">
        <cfcase value="1"><cfset strMesI = "#CMB_Enero#"></cfcase>
        <cfcase value="2"><cfset strMesI = "#CMB_Febrero#"></cfcase>
        <cfcase value="3"><cfset strMesI = "#CMB_Marzo#"></cfcase>
        <cfcase value="4"><cfset strMesI = "#CMB_Abril#"></cfcase>
        <cfcase value="5"><cfset strMesI = "#CMB_Mayo#"></cfcase>
        <cfcase value="6"><cfset strMesI = "#CMB_Junio#"></cfcase>
        <cfcase value="7"><cfset strMesI = "#CMB_Julio#"></cfcase>
        <cfcase value="8"><cfset strMesI = "#CMB_Agosto#"></cfcase>
        <cfcase value="9"><cfset strMesI = "#CMB_Setiembre#"></cfcase>
        <cfcase value="10"><cfset strMesI = "#CMB_Octubre#"></cfcase>
        <cfcase value="11"><cfset strMesI = "#CMB_Noviembre#"></cfcase>										
        <cfcase value="12"><cfset strMesI = "#CMB_Diciembre#"></cfcase>
    </cfswitch>
</cfoutput>

<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select Mnombre
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #varMcodigo#
</cfquery>

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select c.EPCPdescripcion,p.PCDvalor,p.PCDdescripcion,s.ID_EstrCtaVal,s.EPCPcodigo,s.PCDcatid,
    case c.EPCPdescripcion
        when 'INGRESOS' then 	CampoA/#varUnidad#
        else 		  			CampoA*(-1)/#varUnidad#
	end as CampoA,
    case c.EPCPdescripcion
        when 'INGRESOS' then 	CampoB*(-1)/#varUnidad#
        else 		  			CampoB/#varUnidad#
	end as CampoB,
    case c.EPCPdescripcion
        when 'INGRESOS' then 	CampoC*(-1)/#varUnidad#
        else 		  			CampoC/#varUnidad#
	end as CampoC,
    case c.EPCPdescripcion
        when 'INGRESOS' then 	CampoD*(-1)/#varUnidad#
        else 		  			CampoD/#varUnidad#
	end as CampoD,
    case c.EPCPdescripcion
        when 'INGRESOS' then 	CampoE*(-1)/#varUnidad#
        else 		  			CampoE/#varUnidad#
	end as CampoE,
    case c.EPCPdescripcion
        when 'INGRESOS' then 	'TOTAL DE INGRESOS'
        else 		  			'TOTAL DE COSTO DE VENTAS Y OTRAS EROGACIONES'
	end as DescTotal,
    case CampoA
        when 0 then 0
        else CampoE/CampoA
	end as Avance
    from #saldoscuenta# s
    inner join CGEstrProgVal c
    on c.ID_EstrCtaVal=s.ID_EstrCtaVal
    inner join PCDCatalogo p
       on p.PCDcatid=s.PCDcatid
    <cfif form.chkCeros eq '0'>
    where s.CampoA <> 0 or
    	 s.CampoB <> 0 or
         s.CampoC <> 0 or
         s.CampoD <> 0 or
         s.CampoE <> 0 
    </cfif>   
    order by c.EPCPcodigo
</cfquery>

<!---<cf_dump var= #rsDetalle#>--->

<cfif form.formato NEQ "HTML">
	<cfif #form.mensAcum# eq 1>
       <cfset LabelFechaFin = #LabelFechaFin#&' Mensual'>
    <cfelse>
       <cfset LabelFechaFin = #LabelFechaFin#&' Acumulado'>
    </cfif>
    <cfset vRubro = 0>
	<cfset TotalCampoA = 0>
    <cfset TotalCampoB = 0>
    <cfset TotalCampoC = 0>
    <cfset TotalCampoD = 0>
    <cfset TotalCampoE = 0>
	<cfset TotalICampoA = #form.PrIngAprob#>
    <cfset TotalICampoB = 0>
    <cfset TotalICampoC = #form.PrIngModif#>
    <cfset TotalICampoD = 0>
    <cfset TotalICampoE = 0>  
    <cfset VtaNetaCrA   = 0>
    <cfset VtaNetaCrB   = 0>
    <cfset VtaNetaCrC   = 0>
    <cfset VtaNetaCrD   = 0>
    <cfset VtaNetaCrE   = 0>
           
    <cfloop query="rsDetalle">
        <cfif Trim(rsDetalle.PCDvalor) eq '72110'>
             <cfset VtaNetaCrA = #VtaNetaCrA# + #rsdetalle.CampoA#>
             <cfset VtaNetaCrB = #VtaNetaCrB# + #rsdetalle.CampoB#>
             <cfset VtaNetaCrC = #VtaNetaCrC# + #rsdetalle.CampoC#>
             <cfset VtaNetaCrD = #VtaNetaCrD# + #rsdetalle.CampoD#>
             <cfset VtaNetaCrE = #VtaNetaCrE# + #rsdetalle.CampoE#>
        <cfelseif Trim(rsDetalle.PCDvalor) eq '81010' or Trim(rsDetalle.PCDvalor) eq '82010' or Trim(rsDetalle.PCDvalor) eq '82090' or Trim(rsDetalle.PCDvalor) eq '82160' or Trim(rsDetalle.PCDvalor) eq '82260' or Trim(rsDetalle.PCDvalor) eq '85040' or Trim(rsDetalle.PCDvalor) eq '82270'>
             <cfset VtaNetaCrA = #VtaNetaCrA# - #rsdetalle.CampoA#>
             <cfset VtaNetaCrB = #VtaNetaCrB# - #rsdetalle.CampoB#>
             <cfset VtaNetaCrC = #VtaNetaCrC# - #rsdetalle.CampoC#>
             <cfset VtaNetaCrD = #VtaNetaCrD# - #rsdetalle.CampoD#>
             <cfset VtaNetaCrE = #VtaNetaCrE# - #rsdetalle.CampoE#>
        </cfif>
        
       	<cfif vRubro neq rsDetalle.EPCPcodigo>
        	<cfif vRubro neq 0>
				<cfset TotalICampoA = #TotalICampoA# + #TotalCampoA#>
                <cfset TotalICampoB = #TotalICampoB# + #TotalCampoB#>
                <cfset TotalICampoC = #TotalICampoC# + #TotalCampoC#>
                <cfset TotalICampoD = #TotalICampoD# + #TotalCampoD#>
                <cfset TotalICampoE = #TotalICampoE# + #TotalCampoE#>
                <cfset TotalCampoA = 0>
                <cfset TotalCampoB = 0>
                <cfset TotalCampoC = 0>
                <cfset TotalCampoD = 0>
                <cfset TotalCampoE = 0>
 			</cfif>
            <cfset vRubro = #rsDetalle.EPCPcodigo#>
       	</cfif>
		<cfset TotalCampoA = #TotalCampoA# + #rsdetalle.CampoA#>
        <cfset TotalCampoB = #TotalCampoB# + #rsdetalle.CampoB#>
        <cfset TotalCampoC = #TotalCampoC# + #rsdetalle.CampoC#>
        <cfset TotalCampoD = #TotalCampoD# + #rsdetalle.CampoD#>
        <cfset TotalCampoE = #TotalCampoE# + #rsdetalle.CampoE#>
        
	</cfloop>
    <cfif VtaNetaCrA eq 0>
    	<cfset VtaAvance = 0> 
    <cfelse>
    	<cfset VtaAvance = VtaNetaCrE/VtaNetaCrA> 
    </cfif>
	<cfset TotalICampoA = #TotalICampoA# - #TotalCampoA#>
    <cfset TotalICampoB = #TotalICampoB# - #TotalCampoB#>
    <cfset TotalICampoC = #TotalICampoC# - #TotalCampoC#>
    <cfset TotalICampoD = #TotalICampoD# - #TotalCampoD#>
    <cfset TotalICampoE = #TotalICampoE# - #TotalCampoE#>
    <cfif TotalICampoA eq 0>
    	<cfset TotalIAvance = 0> 
    <cfelse>
    	<cfset TotalIAvance = TotalICampoE/TotalICampoA> 
    </cfif>
    
    <cfreport format="#form.formato#" template= "EAnalIngrPres.cfr" query="rsDetalle">
    	<cfreportparam name="Edescripcion"	value="#rsNombreEmpresa.Edescripcion#">
        <cfreportparam name="periodo_ini" 	value="#LabelFechaFin#">
        <cfreportparam name="mes_ini" 	  	value="#strMesI#">	
        <cfreportparam name="moneda" 		value="#rsMoneda.Mnombre#">
        <cfreportparam name="cveMoneda" 	value="#rsNombreEmpresa.Mcodigo#">
        <cfreportparam name="Unidad"  		value="#varUnidad#">
        <cfreportparam name="TotalICampoA" 	value="#TotalICampoA#">
        <cfreportparam name="TotalICampoB" 	value="#TotalICampoB#">
        <cfreportparam name="TotalICampoC" 	value="#TotalICampoC#">
        <cfreportparam name="TotalICampoD" 	value="#TotalICampoD#">
        <cfreportparam name="TotalICampoE" 	value="#TotalICampoE#">
        <cfreportparam name="TotalIAvance" 	value="#TotalIAvance#">
        
        <cfreportparam name="VtaNetaCrA" 	value="#VtaNetaCrA#">
        <cfreportparam name="VtaNetaCrB" 	value="#VtaNetaCrB#">
        <cfreportparam name="VtaNetaCrC" 	value="#VtaNetaCrC#">
        <cfreportparam name="VtaNetaCrD" 	value="#VtaNetaCrD#">
        <cfreportparam name="VtaNetaCrE" 	value="#VtaNetaCrE#">
        <cfreportparam name="VtaAvance" 	value="#VtaAvance#">
        <cfreportparam name="PrIngAprob" 	value="#form.PrIngAprob#">
        <cfreportparam name="PrIngModif" 	value="#form.PrIngModif#">
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
                <strong>Al #LabelFechaFin#&nbsp;
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
            	<td colspan="2">&nbsp;</td>
                <td colspan="6" align="center"><strong>#MSG_Momentos#</strong></td>
            </tr>
        	<tr>
                <td nowrap align="center"><strong>#LB_Rubro#</strong></td>
                <td nowrap align="center"><strong>#MSG_Descripcion#</strong></td>
                <td nowrap align="center"><strong>#MSG_Propuesto#</strong></td>
                <td nowrap align="center"><strong>#MSG_Propuesto#</strong></td>
                <td nowrap align="center"><strong>#MSG_Propuesto#</strong></td>
                <td nowrap align="center"><strong>#MSG_Propuesto#</strong></td>
                <td nowrap align="center"><strong>#MSG_Propuesto#</strong></td>
                <td nowrap align="center"><strong>#MSG_Avance#</strong></td>
            </tr>
            <tr>
            	<td colspan="2">&nbsp;</td>
                <td nowrap align="center"><strong>#MSG_Aprobado#</strong></td>
                <td nowrap align="center"><strong>#MSG_Recibir#</strong></td>
                <td nowrap align="center"><strong>#MSG_Modificado#</strong></td>
                <td nowrap align="center"><strong>#MSG_Devengado#</strong></td>
                <td nowrap align="center"><strong>#MSG_Cobrado#</strong></td>
                <td nowrap align="center"><strong>#MSG_CobrApr#</strong></td>
            </tr>
            <cfset vRubro = 0>
			<cfset TotalCampoA = 0>
            <cfset TotalCampoB = 0>
            <cfset TotalCampoC = 0>
            <cfset TotalCampoD = 0>
            <cfset TotalCampoE = 0>
            <cfset TotalICampoA = #form.PrIngAprob#>
            <cfset TotalICampoB = 0>
            <cfset TotalICampoC = #form.PrIngModif#>
            <cfset TotalICampoD = 0>
            <cfset TotalICampoE = 0>  
            <cfset VtaNetaCrA   = 0>
            <cfset VtaNetaCrB   = 0>
            <cfset VtaNetaCrC   = 0>
            <cfset VtaNetaCrD   = 0>
            <cfset VtaNetaCrE   = 0> 
           	<tr> 
            	<td>&nbsp;</td>
                <td align="left">#Ucase('Saldo contable de las disponibilidades y activos financieros')#</td> 
				<td nowrap align="right">#numberformat(form.PrIngAprob, ",9.00")#</td>
                <td>&nbsp;</td>
                <td nowrap align="right">#numberformat(form.PrIngModif, ",9.00")#</td> 			
            </tr>
            <cfloop query="rsDetalle">
            	<cfif Trim(rsDetalle.PCDvalor) eq '72110'>
                	 <cfset VtaNetaCrA = #VtaNetaCrA# + #rsdetalle.CampoA#>
                     <cfset VtaNetaCrB = #VtaNetaCrB# + #rsdetalle.CampoB#>
                     <cfset VtaNetaCrC = #VtaNetaCrC# + #rsdetalle.CampoC#>
                     <cfset VtaNetaCrD = #VtaNetaCrD# + #rsdetalle.CampoD#>
                     <cfset VtaNetaCrE = #VtaNetaCrE# + #rsdetalle.CampoE#>
                <cfelseif Trim(rsDetalle.PCDvalor) eq '81010' or Trim(rsDetalle.PCDvalor) eq '82010' or Trim(rsDetalle.PCDvalor) eq '82090' or Trim(rsDetalle.PCDvalor) eq '82160' or Trim(rsDetalle.PCDvalor) eq '82260' or Trim(rsDetalle.PCDvalor) eq '85040' or Trim(rsDetalle.PCDvalor) eq '82270'>
                	 <cfset VtaNetaCrA = #VtaNetaCrA# - #rsdetalle.CampoA#>
                     <cfset VtaNetaCrB = #VtaNetaCrB# - #rsdetalle.CampoB#>
                     <cfset VtaNetaCrC = #VtaNetaCrC# - #rsdetalle.CampoC#>
                     <cfset VtaNetaCrD = #VtaNetaCrD# - #rsdetalle.CampoD#>
                     <cfset VtaNetaCrE = #VtaNetaCrE# - #rsdetalle.CampoE#>
                </cfif>     
            	<cfif vRubro neq rsDetalle.EPCPcodigo>
                    <cfif vRubro neq 0>
                    <tr>
                    	<td>&nbsp;</td>
                        <td align="left">TOTAL #vdrubro#</td>
                        <td nowrap align="right">#numberformat(TotalCampoA, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(TotalCampoB, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(TotalCampoC, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(TotalCampoD, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(TotalCampoE, ",9.00")#</td>  
                        <td nowrap align="right">
                            <cfif TotalCampoA eq 0>
                                <cfset CampoF = 0>
                            <cfelse>
                                <cfset CampoF = #TotalCampoE#/#TotalCampoA#>
                            </cfif>
                            #numberformat(CampoF, ",9.00")#
                        </td> 
                    </tr>
					<cfset TotalICampoA = #TotalICampoA# + #TotalCampoA#>
                    <cfset TotalICampoB = #TotalICampoB# + #TotalCampoB#>
                    <cfset TotalICampoC = #TotalICampoC# + #TotalCampoC#>
                    <cfset TotalICampoD = #TotalICampoD# + #TotalCampoD#>
                    <cfset TotalICampoE = #TotalICampoE# + #TotalCampoE#>
					<cfset TotalCampoA = 0>
                    <cfset TotalCampoB = 0>
                    <cfset TotalCampoC = 0>
                    <cfset TotalCampoD = 0>
                    <cfset TotalCampoE = 0>
                    </cfif>
                    <tr>
                    	<td nowrap align="left">#rsDetalle.EPCPdescripcion#</td>
                    </tr>
                    <cfset vRubro = #rsDetalle.EPCPcodigo#>
                    <cfset vdrubro = #Ucase(rsDetalle.EPCPdescripcion)#>
                </cfif>
                <tr>
                	<td nowrap align="left">#UCase(rsDetalle.PCDvalor)#</td>
					<td nowrap align="left">#UCase(rsDetalle.PCDdescripcion)#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoA, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoB, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoC, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoD, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoE, ",9.00")#</td>
                    <td nowrap align="right">
                    	<cfif rsdetalle.CampoA eq 0>
                       		<cfset CampoF = 0>
                        <cfelse>
                        	<cfset CampoF = #rsdetalle.CampoE#/#rsdetalle.CampoA#>
                        </cfif>
                    	#numberformat(CampoF, ",9.00")#
                    </td>
                </tr>
				<cfset TotalCampoA = #TotalCampoA# + #rsdetalle.CampoA#>
                <cfset TotalCampoB = #TotalCampoB# + #rsdetalle.CampoB#>
                <cfset TotalCampoC = #TotalCampoC# + #rsdetalle.CampoC#>
                <cfset TotalCampoD = #TotalCampoD# + #rsdetalle.CampoD#>
                <cfset TotalCampoE = #TotalCampoE# + #rsdetalle.CampoE#>
			</cfloop>
<!---            <cfif form.chkCeros eq '1'>
--->            
			<tr>
                <td>&nbsp;</td>
                <cfif vdrubro eq 'INGRESOS'>
					<td align="left">TOTAL #vdrubro#</td>
                <cfelse>
                	<td align="left">TOTAL DE COSTO DE VENTAS Y OTRAS EROGACIONES</td>
                </cfif>
                <td nowrap align="right">#numberformat(TotalCampoA, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalCampoB, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalCampoC, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalCampoD, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalCampoE, ",9.00")#</td>
                <td nowrap align="right">
					<cfif TotalCampoA eq 0>
                        <cfset CampoF = 0>
                    <cfelse>
                        <cfset CampoF = #TotalCampoE#/#TotalCampoA#>
                    </cfif>
                    #numberformat(CampoF, ",9.00")#
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td align="left">VENTA NETA DE CRUDO</td>
                <td nowrap align="right">#numberformat(VtaNetaCrA, ",9.00")#</td>
                <td nowrap align="right">#numberformat(VtaNetaCrB, ",9.00")#</td>
                <td nowrap align="right">#numberformat(VtaNetaCrC, ",9.00")#</td>
                <td nowrap align="right">#numberformat(VtaNetaCrD, ",9.00")#</td>
                <td nowrap align="right">#numberformat(VtaNetaCrE, ",9.00")#</td>
                <td nowrap align="right">
					<cfif VtaNetaCrA eq 0>
                        <cfset CampoF = 0>
                    <cfelse>
                        <cfset CampoF = #VtaNetaCrE#/#VtaNetaCrA#>
                    </cfif>
                    #numberformat(CampoF, ",9.00")#
                </td>                                
            </tr>
            <tr>
				<cfset TotalICampoA = #TotalICampoA# - #TotalCampoA#>
                <cfset TotalICampoB = #TotalICampoB# - #TotalCampoB#>
                <cfset TotalICampoC = #TotalICampoC# - #TotalCampoC#>
                <cfset TotalICampoD = #TotalICampoD# - #TotalCampoD#>
                <cfset TotalICampoE = #TotalICampoE# - #TotalCampoE#>
                <td>&nbsp;</td>
                <td align="left">TOTAL INGRESOS</td>
                <td nowrap align="right">#numberformat(TotalICampoA, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalICampoB, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalICampoC, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalICampoD, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TotalICampoE, ",9.00")#</td>
                <td nowrap align="right">
					<cfif TotalICampoA eq 0>
                        <cfset CampoF = 0>
                    <cfelse>
                        <cfset CampoF = #TotalICampoE#/#TotalICampoA#>
                    </cfif>
                    #numberformat(CampoF, ",9.00")#
                </td>                                
            </tr>
<!---            </cfif>--->
        </table>
    </cfoutput>
</cfif>