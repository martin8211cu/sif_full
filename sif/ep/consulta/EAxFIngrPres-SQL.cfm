<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 03-01-2013.
	Reporte Estado Analítico por Fuente de Ingresos Presupuestales
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
	<cfparam name="form.PrIngAprob" default="#url.PrIngAprob#"></cfif>  
<cfif isdefined("url.PrIngModif") and not isdefined("form.PrIngModif")>
	<cfparam name="form.PrIngModif" default="#url.PrIngModif#"></cfif>         
</cfoutput> 
<!---<cf_dump var="#form.chkCeros#">--->  
<cfif form.periodo lt year(NOW())>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes lt month(NOW())>
        <cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>
<cfinvoke key="MSG_ReporteAnalitico" default="Estado Anal&iacute;tico por Fuente de Ingresos Presupuestales"	returnvariable="MSG_ReporteAnalitico"	
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
<cfset LvarIrA = 'EAxFIngrPres.cfm'>
<cfset LvarFile = 'EAxFIngrPres'>
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
	<cflocation url="EAxFIngrPRes.cfm?rsMensaje=#rsMensaje#">
</cfif>

</cfoutput>
<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
	<cf_dbtempcol name="ID_EstrCtaVal"  type="int">
	<cf_dbtempcol name="EPCPcodigo"  	type="varchar(200)">
	<cf_dbtempcol name="ID_DEstrCtaVal" type="numeric">
    <cf_dbtempcol name="PCDcatid" 		type="numeric">
    <cf_dbtempcol name="PCDvalor" 		type="numeric">
    <cf_dbtempcol name="PCDcatidOrig"	type="numeric">
    <cf_dbtempcol name="SubRubro"		type="varchar(20)">
    <cf_dbtempcol name="Mcodigo"  		type="integer">        
    <cf_dbtempcol name="CampoA"  		type="money">
    <cf_dbtempcol name="CampoB"  		type="money">
    <cf_dbtempcol name="CampoC"  		type="money">
    <cf_dbtempcol name="CampoD"  		type="money">
    <cf_dbtempcol name="CampoE"  		type="money">
    <cf_dbtempkey cols="ID_EstrCtaVal,EPCPcodigo,ID_DEstrCtaVal,PCDcatid">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_EstrCtaVal,EPCPcodigo,ID_DEstrCtaVal,PCDcatid,PCDvalor,PCDcatidOrig,SubRubro,Mcodigo,CampoA,CampoB,CampoC,CampoD,CampoE)
    select c.ID_EstrCtaVal,c.EPCPcodigo,d.ID_DEstrCtaVal,pcd.PCDcatid,p.PCDvalor,p.PCDcatid,pcd.PCDvalor,#varMcodigo#,0 ,0 ,0 ,0 ,0
    from CGEstrProgVal c
    inner join CGReEstrProg r
    on c.ID_Estr= r.ID_Estr
    inner join dbo.CGDEstrProgVal d
    on d.ID_EstrCtaVal=c.ID_EstrCtaVal
    left join PCDCatalogo p
       on d.PCDcatid=p.PCDcatid 
    left join PCDCatalogo pcd
       on pcd.PCEcatid=p.PCEcatidref 
    where r.SPcodigo='#session.menues.SPCODIGO#'
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
<!---<cf_dumptofile select="select * from #rsEPQuery#" order by PCDcatid>--->

<!--- <cf_dumptofile select="select * from #saldoscuenta# s
         inner join #rsEPQuery# r
        on s.PCDcatidOrig = r.PCDcatid
        and substring(r.Cformato,12,3) = s.SubRubro 
">--->


<!----Actualizar saldos ----->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    order by PCDcatid
</cfquery>


<cfloop query="SC">
    <cfquery datasource="#session.DSN#" name="Cmp_A">
        select 	r.PCDcatid, r.Cformato as SubRubro,
        		coalesce(sum(SLinicial), 0.00) 		as SLInicial, 
                coalesce(sum(SOinicial), 0.00) 		as SOInicial,
                coalesce(sum(r.CLcreditos), 0.00) 	as CLcreditos, 
                coalesce(sum(r.DLdebitos), 0.00) 	as DLdebitos,
                coalesce(sum(r.COcreditos), 0.00) 	as COcreditos, 
                coalesce(sum(r.DOdebitos), 0.00) 	as DOdebitos
        from #saldoscuenta# s
        inner join #rsEPQuery# r
        on s.PCDcatidOrig = r.PCDcatid
        and substring(r.Cformato,12,3) = s.SubRubro 
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='A' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatidOrig#
       	and substring(r.Cformato,12,3) = #SC.SubRubro#
        group by r.PCDcatid, r.Cformato
    </cfquery>
    <cfif Cmp_A.recordcount GT 0>
    	<cfset SLinicial_A  = #Cmp_A.SLinicial#>
        <cfset SOinicial_A  = #Cmp_A.SOinicial#>
        <cfset CLcreditos_A = #Cmp_A.CLcreditos#>
        <cfset DLdebitos_A  = #Cmp_A.DLdebitos#>
        <cfset COcreditos_A = #Cmp_A.COcreditos#>
        <cfset DOdebitos_A  = #Cmp_A.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_A  = 0>
        <cfset SOinicial_A  = 0>
        <cfset CLcreditos_A = 0>
        <cfset DLdebitos_A  = 0>
        <cfset COcreditos_A = 0>
        <cfset DOdebitos_A  = 0> 
    </cfif>
<!---    <cfdump var="CAMPO_A">
    <cfdump var="#SC.PCDcatidOrig#">
    <cfdump var="#Cmp_A.SubRubro#">
    <cfdump var="#SC.SubRubro#">
    
    <cfdump var="#Cmp_A.CLcreditos#">
    <cfdump var="#Cmp_A.DLdebitos#">
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
        on s.PCDcatidOrig = r.PCDcatid
        and substring(r.Cformato,12,3) = s.SubRubro 
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='D' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatidOrig#
        and substring(r.Cformato,12,3) = #SC.SubRubro#
    </cfquery>
    <cfif Cmp_B.recordcount GT 0>
    	<cfset SLinicial_B  = #Cmp_B.SLinicial#>
        <cfset SOinicial_B  = #Cmp_B.SOinicial#>
        <cfset CLcreditos_B = #Cmp_B.CLcreditos#>
        <cfset DLdebitos_B  = #Cmp_B.DLdebitos#>
        <cfset COcreditos_B = #Cmp_B.COcreditos#>
        <cfset DOdebitos_B  = #Cmp_B.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_B  = 0>
        <cfset SOinicial_B  = 0>
        <cfset CLcreditos_B = 0>
        <cfset DLdebitos_B  = 0>
        <cfset COcreditos_B = 0>
        <cfset DOdebitos_B  = 0> 
    </cfif>
    
<!---    <cfdump var="CAMPO_B">
    <cfdump var="#Cmp_B.CLcreditos#">
    <cfdump var="#Cmp_B.DLdebitos#">
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
        on s.PCDcatidOrig = r.PCDcatid
        and substring(r.Cformato,12,3) = s.SubRubro 
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='M' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatidOrig#
        and substring(r.Cformato,12,3) = #SC.SubRubro#
    </cfquery>
    <cfif Cmp_C.recordcount GT 0>
    	<cfset SLinicial_C  = #Cmp_C.SLinicial#>
        <cfset SOinicial_C  = #Cmp_C.SOinicial#>
        <cfset CLcreditos_C = #Cmp_C.CLcreditos#>
        <cfset DLdebitos_C  = #Cmp_C.DLdebitos#>
        <cfset COcreditos_C = #Cmp_C.COcreditos#>
        <cfset DOdebitos_C  = #Cmp_C.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_C  = 0>
        <cfset SOinicial_C  = 0>
        <cfset CLcreditos_C = 0>
        <cfset DLdebitos_C  = 0>
        <cfset COcreditos_C = 0>
        <cfset DOdebitos_C  = 0> 
    </cfif>
    
<!---    <cfdump var="CAMPO_C">
    <cfdump var="#Cmp_C.CLcreditos#">
    <cfdump var="#Cmp_C.DLdebitos#">
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
        on s.PCDcatidOrig = r.PCDcatid
        and substring(r.Cformato,12,3) = s.SubRubro 
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='E' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatidOrig#
        and substring(r.Cformato,12,3) = #SC.SubRubro#
    </cfquery>
    <cfif Cmp_D.recordcount GT 0>
    	<cfset SLinicial_D  = #Cmp_D.SLinicial#>
        <cfset SOinicial_D  = #Cmp_D.SOinicial#>
        <cfset CLcreditos_D = #Cmp_D.CLcreditos#>
        <cfset DLdebitos_D  = #Cmp_D.DLdebitos#>
        <cfset COcreditos_D = #Cmp_D.COcreditos#>
        <cfset DOdebitos_D  = #Cmp_D.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_D  = 0>
        <cfset SOinicial_D  = 0>
        <cfset CLcreditos_D = 0>
        <cfset DLdebitos_D  = 0>
        <cfset COcreditos_D = 0>
        <cfset DOdebitos_D  = 0> 
    </cfif>
    
<!---    <cfdump var="CAMPO_D">
    <cfdump var="#Cmp_D.CLcreditos#">
    <cfdump var="#Cmp_D.DLdebitos#">    
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
        on s.PCDcatidOrig = r.PCDcatid
        and substring(r.Cformato,12,3) = s.SubRubro 
		where 
            r.Cmayor = (select c.Cmayor
            from CPtipoMov m
            left join CPtipoMovContable c
                on c.Ecodigo = #Session.Ecodigo#
                and c.CPPid = #rsCPPid.CPPid#
                and c.CPCCtipo = 'I'
                and c.CPTMtipoMov = m.CPTMtipoMov
            where m.CPTMtipoMov ='P' and Cmayor <> 'NULL')
 		and r.PCDcatid = #SC.PCDcatidOrig#
        and substring(r.Cformato,12,3) = #SC.SubRubro#
    </cfquery>
    <cfif Cmp_E.recordcount GT 0>
    	<cfset SLinicial_E  = #Cmp_E.SLinicial#>
        <cfset SOinicial_E  = #Cmp_E.SOinicial#>
        <cfset CLcreditos_E = #Cmp_E.CLcreditos#>
        <cfset DLdebitos_E  = #Cmp_E.DLdebitos#>
        <cfset COcreditos_E = #Cmp_E.COcreditos#>
        <cfset DOdebitos_E  = #Cmp_E.DOdebitos#> 
    <cfelse>
    	<cfset SLinicial_E  = 0>
        <cfset SOinicial_E  = 0>
        <cfset CLcreditos_E = 0>
        <cfset DLdebitos_E  = 0>
        <cfset COcreditos_E = 0>
        <cfset DOdebitos_E  = 0> 
    </cfif>
    
<!---    <cfdump var="CAMPO_E">
    <cfdump var="#Cmp_E.CLcreditos#">
    <cfdump var="#Cmp_E.DLdebitos#">     
--->    

	
	<cfquery datasource="#session.DSN#">
	update #saldoscuenta#
    set
	CampoA =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#DLdebitos_A#, 0.00)-coalesce(#CLcreditos_A#, 0.00)
        <cfelse>
        	coalesce(#DOdebitos_A#, 0.00)-coalesce(#COcreditos_A#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#SLinicial_A#, 0.00)+coalesce(#DLdebitos_A#, 0.00)-coalesce(#CLcreditos_A#, 0.00)
        <cfelse>
        	coalesce(#SOinicial_A#, 0.00)+coalesce(#DOdebitos_A#, 0.00)-coalesce(#COcreditos_A#, 0.00)
        </cfif> 
    </cfif>,
	CampoB =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#DLdebitos_B#, 0.00)-coalesce(#CLcreditos_B#, 0.00)
        <cfelse>
        	coalesce(#DOdebitos_B#, 0.00)-coalesce(#COcreditos_B#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#SLinicial_B#, 0.00)+coalesce(#DLdebitos_B#, 0.00)-coalesce(#CLcreditos_B#, 0.00)
        <cfelse>
        	coalesce(#SOinicial_B#, 0.00)+coalesce(#DOdebitos_B#, 0.00)-coalesce(#COcreditos_B#, 0.00)
        </cfif> 
    </cfif>,
	CampoC =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#DLdebitos_C#, 0.00)-coalesce(#CLcreditos_C#, 0.00)
        <cfelse>
        	coalesce(#DOdebitos_C#, 0.00)-coalesce(#COcreditos_C#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#SLinicial_C#, 0.00)+coalesce(#DLdebitos_C#, 0.00)-coalesce(#CLcreditos_C#, 0.00)
        <cfelse>
        	coalesce(#SOinicial_C#, 0.00)+coalesce(#DOdebitos_C#, 0.00)-coalesce(#COcreditos_C#, 0.00)
        </cfif> 
    </cfif>,
	CampoD =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#DLdebitos_D#, 0.00)-coalesce(#CLcreditos_D#, 0.00)
        <cfelse>
        	coalesce(#DOdebitos_D#, 0.00)-coalesce(#COcreditos_D#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#SLinicial_D#, 0.00)+coalesce(#DLdebitos_D#, 0.00)-coalesce(#CLcreditos_D#, 0.00)
        <cfelse>
        	coalesce(#SOinicial_D#, 0.00)+coalesce(#DOdebitos_D#, 0.00)-coalesce(#COcreditos_D#, 0.00)
        </cfif> 
    </cfif>,
	CampoE =
    <cfif #form.mensAcum# eq 1>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#DLdebitos_E#, 0.00)-coalesce(#CLcreditos_E#, 0.00)
        <cfelse>
        	coalesce(#DOdebitos_E#, 0.00)-coalesce(#COcreditos_E#, 0.00)
        </cfif> 
    <cfelse>
    	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt NEQ "0">
        	coalesce(#SLinicial_E#, 0.00)+coalesce(#DLdebitos_E#, 0.00)-coalesce(#CLcreditos_E#, 0.00)
        <cfelse>
        	coalesce(#SOinicial_E#, 0.00)+coalesce(#DOdebitos_E#, 0.00)-coalesce(#COcreditos_E#, 0.00)
        </cfif> 
    </cfif>
    where 
    #saldoscuenta#.PCDcatid = #SC.PCDcatid#
    and #saldoscuenta#.SubRubro = #SC.SubRubro#
    </cfquery>
</cfloop>
<!---<cf_dump var='TOTALES'>--->
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
	select c.EPCPdescripcion,p.PCDvalor as PCDvalor,s.PCDvalor as Rubro,p.PCDdescripcion,
    case s.PCDvalor
    	when '72110' then 'VENTAS EN EL EXTERIOR'
		when '72210' then 'SERVICIOS COMERCIALES Y ADMINISTRATIVOS'
        when '72120' then 'DEMORAS'
        when '72220' then 'GUARDA Y MANEJO'
        when '72310' then 'INTERESES GANADOS EN INVERSIONES'
        when '72320' then 'INTERESES MORATORIOS'
        when '72600' then 'RECUPERACIÓN DE GASTOS'
        when '72900' then 'OTROS INGRESOS'
        when '01000' then 'OTROS INGRESOS DERIVADOS DE FINANCIAMIENTOS'
        when '81010' then 'COSTO DE VENTAS CRUDO'
        when '82010' then 'DEMORAS CRUDO'
        when '82090' then 'INSPECCIONES CRUDO'
        when '82160' then 'ÁNALISIS DE MUESTRAS'
        when '82260' then 'FLETES DE CRUDO'
        when '82270' then 'SEGUROS DE CRUDO'
        when '83010' then 'GUARDA Y MANEJO'
        when '84010' then 'INTERESES PAGADOS'
        when '84050' then 'COMISIONES POR MANEJO DE CUENTA'
        when '84070' then 'INTERESES OVERNIGHT'
        when '85040' then 'IMPUESTOS'
		else po.PCDdescripcion 
    end as DescRubro,
    case c.EPCPdescripcion
        when 'INGRESOS' then 	'TOTAL DE INGRESOS'
        else 		  			'TOTAL DE COSTO DE VENTAS Y OTRAS EROGACIONES'
	end as DescTotal,
    s.ID_EstrCtaVal, s.EPCPcodigo, s.PCDcatid,
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
    
<!---    CampoA/#varUnidad# as CampoA,
    CampoB/#varUnidad# as CampoB,
    CampoC/#varUnidad# as CampoC,
    CampoD/#varUnidad# as CampoD,
    CampoE/#varUnidad# as CampoE,
--->    
    case CampoA
        when 0 then 0
        else CampoE/CampoA
	end as Avance
    from #saldoscuenta# s
    inner join CGEstrProgVal c
    on c.ID_EstrCtaVal=s.ID_EstrCtaVal
    inner join PCDCatalogo p
       on p.PCDcatid=s.PCDcatid
    inner join PCDCatalogo po
       on po.PCDcatid=s.PCDcatidOrig
    where (
    	(s.PCDvalor = '72110' and s.SubRubro  in ('001','002','003','004')) or   <!---p.PCDvalor--->
    	(s.PCDvalor = '72210' and s.SubRubro in ('001','006','007','008','009','011','012','013','027','029','030')) or
        (s.PCDvalor = '72120' and s.SubRubro in ('001','002','003','004')) or
        (s.PCDvalor = '72220' and s.SubRubro in ('001','002')) or
        (s.PCDvalor = '72310' and s.SubRubro in ('001','002','003','005','006','007','008','009','010','011','012','013','015','016','017','018','020','021','022','023')) or
        (s.PCDvalor = '72320' and s.SubRubro in ('001','002','003')) or
        (s.PCDvalor = '72600' and s.SubRubro in ('001','002','003','004','006','007')) or
        (s.PCDvalor = '72900' and s.SubRubro in ('001','002','003','004','006','007','008','009','011','012','013','014','015','016')) or
        (s.PCDvalor = '01000' and s.SubRubro in ('001','002')) or
    	(s.PCDvalor = '81010' and s.SubRubro in ('001','002','003','004')) or
        (s.PCDvalor = '82010' and s.SubRubro in ('001','002','003','004')) or
        (s.PCDvalor = '82090' and s.SubRubro in ('001','002','003','004')) or
        (s.PCDvalor = '82160' and s.SubRubro in ('001','002','003','004')) or
        (s.PCDvalor = '82260' and s.SubRubro in ('001','002','003','004')) or
        (s.PCDvalor = '82270' and s.SubRubro in ('001','002','003','004')) or
        (s.PCDvalor = '83010' and s.SubRubro in ('001','002')) or
        (s.PCDvalor = '84010' and s.SubRubro in ('001')) or
        (s.PCDvalor = '85010' and s.SubRubro in ('001')) or
        (s.PCDvalor = '87010' and s.SubRubro in ('001')) or
        (s.PCDvalor = '84050' and s.SubRubro in ('001')) or
        (s.PCDvalor = '84070' and s.SubRubro in ('001')) or
        (s.PCDvalor = '85040' and s.SubRubro in ('001','002','003','004','006','008','009','010','013'))
        )
    <cfif form.chkCeros eq 0>
    	 and (s.CampoA <> 0 or
    	 s.CampoB <> 0 or
         s.CampoC <> 0 or
         s.CampoD <> 0 or
         s.CampoE <> 0)
    </cfif>   
    order by c.EPCPcodigo,c.ID_EstrCtaVal
</cfquery>

<!---<cf_dump var= #rsDetalle#>
--->
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
        <cfif Trim(rsDetalle.Rubro) eq '72110' or Trim(rsDetalle.Rubro) eq '72120'>
             <cfset VtaNetaCrA = #VtaNetaCrA# + #rsdetalle.CampoA#>
             <cfset VtaNetaCrB = #VtaNetaCrB# + #rsdetalle.CampoB#>
             <cfset VtaNetaCrC = #VtaNetaCrC# + #rsdetalle.CampoC#>
             <cfset VtaNetaCrD = #VtaNetaCrD# + #rsdetalle.CampoD#>
             <cfset VtaNetaCrE = #VtaNetaCrE# + #rsdetalle.CampoE#>
        <cfelseif Trim(rsDetalle.Rubro) eq '81010' or Trim(rsDetalle.Rubro) eq '82010' or Trim(rsDetalle.Rubro) eq '82090' or Trim(rsDetalle.Rubro) eq '82160' or Trim(rsDetalle.Rubro) eq '82260' or Trim(rsDetalle.Rubro) eq '85040'>
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
	<cfset TotalICampoA = #TotalICampoA# - #TotalCampoA#>
    <cfset TotalICampoB = #TotalICampoB# - #TotalCampoB#>
    <cfset TotalICampoC = #TotalICampoC# - #TotalCampoC#>
    <cfset TotalICampoD = #TotalICampoD# - #TotalCampoD#>
    <cfset TotalICampoE = #TotalICampoE# - #TotalCampoE#>
    <cfif VtaNetaCrA eq 0>
    	<cfset VtaAvance = 0> 
    <cfelse>
    	<cfset VtaAvance = VtaNetaCrE/VtaNetaCrA> 
    </cfif>
    <cfif TotalICampoA eq 0>
    	<cfset TotalIAvance = 0> 
    <cfelse>
    	<cfset TotalIAvance = TotalICampoE/TotalICampoA> 
    </cfif>
    <cfreport format="#form.formato#" template= "EAnxFIngrPres.cfr" query="rsDetalle">
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
                <td nowrap align="center" width="10%"><strong>#MSG_Descripcion#</strong></td>
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
            <cfset vRubro1 = 0>
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
            
            <cfset TotalRCampoA = 0>
            <cfset TotalRCampoB = 0>
            <cfset TotalRCampoC = 0>
            <cfset TotalRCampoD = 0>
            <cfset TotalRCampoE = 0>
            
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
				<cfif Trim(rsDetalle.Rubro) eq '72110' or Trim(rsDetalle.Rubro) eq '72120'>
                     <cfset VtaNetaCrA = #VtaNetaCrA# + #rsdetalle.CampoA#>
                     <cfset VtaNetaCrB = #VtaNetaCrB# + #rsdetalle.CampoB#>
                     <cfset VtaNetaCrC = #VtaNetaCrC# + #rsdetalle.CampoC#>
                     <cfset VtaNetaCrD = #VtaNetaCrD# + #rsdetalle.CampoD#>
                     <cfset VtaNetaCrE = #VtaNetaCrE# + #rsdetalle.CampoE#>
                <cfelseif Trim(rsDetalle.Rubro) eq '81010' or Trim(rsDetalle.Rubro) eq '82010' or Trim(rsDetalle.Rubro) eq '82090' or Trim(rsDetalle.Rubro) eq '82160' or Trim(rsDetalle.Rubro) eq '82260' or Trim(rsDetalle.Rubro) eq '85040'>
                     <cfset VtaNetaCrA = #VtaNetaCrA# - #rsdetalle.CampoA#>
                     <cfset VtaNetaCrB = #VtaNetaCrB# - #rsdetalle.CampoB#>
                     <cfset VtaNetaCrC = #VtaNetaCrC# - #rsdetalle.CampoC#>
                     <cfset VtaNetaCrD = #VtaNetaCrD# - #rsdetalle.CampoD#>
                     <cfset VtaNetaCrE = #VtaNetaCrE# - #rsdetalle.CampoE#>
                </cfif>
            
            	<cfif vRubro1 eq 0>
                	<cfset vRubro1  = #rsDetalle.Rubro#>
                    <cfset vdRubro1 = #rsDetalle.DescRubro#>
                </cfif>
                <cfif vRubro1 neq rsDetalle.Rubro>
                    <tr>
                    	<td>&nbsp;</td>
                        <td align="left" width="10%">SUBTOTAL #vdRubro1#</td>
                        <td nowrap align="right">#numberformat(TotalRCampoA, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(TotalRCampoB, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(TotalRCampoC, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(TotalRCampoD, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(TotalRCampoE, ",9.00")#</td>  
                        <td nowrap align="right">
                            <cfif TotalRCampoA eq 0>
                                <cfset CampoF = 0>
                                N/A
                            <cfelse>
                                <cfset CampoF = #TotalRCampoE#/#TotalRCampoA#>
                                #numberformat(CampoF, ",9.0000")#
                            </cfif>
                        </td> 
                    </tr>
                	<cfset vRubro1 	= #rsDetalle.Rubro#>
                    <cfset vdRubro1 = #rsDetalle.DescRubro#>
                    <cfset TotalRCampoA = 0>
					<cfset TotalRCampoB = 0>
                    <cfset TotalRCampoC = 0>
                    <cfset TotalRCampoD = 0>
                    <cfset TotalRCampoE = 0>
                </cfif>
                
            	<cfif vRubro neq rsDetalle.EPCPcodigo>                
                    <cfif vRubro neq 0>
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
                                N/A
                            <cfelse>
                                <cfset CampoF = #TotalCampoE#/#TotalCampoA#>
                                #numberformat(CampoF, ",9.0000")#
                            </cfif>
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
                	<td nowrap align="left">#rsDetalle.Rubro#-#UCase(rsDetalle.PCDvalor)#</td>
					<td nowrap align="left" width="10%">#UCase(rsDetalle.PCDdescripcion)#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoA, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoB, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoC, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoD, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(rsdetalle.CampoE, ",9.00")#</td>
                    <td nowrap align="right">
                    	<cfif rsdetalle.CampoA eq 0>
                       		<cfset CampoF = 0>
                            N/A
                        <cfelse>
                        	<cfset CampoF = #rsdetalle.CampoE#/#rsdetalle.CampoA#>
                            #numberformat(CampoF, ",9.0000")#
                        </cfif>
                    </td>
                </tr>
				<cfset TotalCampoA = #TotalCampoA# + #rsdetalle.CampoA#>
                <cfset TotalCampoB = #TotalCampoB# + #rsdetalle.CampoB#>
                <cfset TotalCampoC = #TotalCampoC# + #rsdetalle.CampoC#>
                <cfset TotalCampoD = #TotalCampoD# + #rsdetalle.CampoD#>
                <cfset TotalCampoE = #TotalCampoE# + #rsdetalle.CampoE#>
                
				<cfset TotalRCampoA = #TotalRCampoA# + #rsdetalle.CampoA#>
                <cfset TotalRCampoB = #TotalRCampoB# + #rsdetalle.CampoB#>
                <cfset TotalRCampoC = #TotalRCampoC# + #rsdetalle.CampoC#>
                <cfset TotalRCampoD = #TotalRCampoD# + #rsdetalle.CampoD#>
                <cfset TotalRCampoE = #TotalRCampoE# + #rsdetalle.CampoE#>
			</cfloop>
            <!---<cfif form.chkCeros eq '1'>--->
                <tr>
                    <td>&nbsp;</td>
                    <td align="left" width="10%">SUBTOTAL #vdRubro1#</td>
                    <td nowrap align="right">#numberformat(TotalRCampoA, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(TotalRCampoB, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(TotalRCampoC, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(TotalRCampoD, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(TotalRCampoE, ",9.00")#</td>  
                    <td nowrap align="right">
                        <cfif TotalRCampoA eq 0>
                            <cfset CampoF = 0>
                            N/A
                        <cfelse>
                            <cfset CampoF = #TotalRCampoE#/#TotalRCampoA#>
                            #numberformat(CampoF, ",9.0000")#
                        </cfif>
                    </td> 
                </tr>

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
                            N/A
                        <cfelse>
                            <cfset CampoF = #TotalCampoE#/#TotalCampoA#>
                            #numberformat(CampoF, ",9.0000")#
                        </cfif>
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
                            N/A
                        <cfelse>
                            <cfset CampoF = #VtaNetaCrE#/#VtaNetaCrA#>
                            #numberformat(CampoF, ",9.0000")#
                        </cfif>
                    </td>                                
                </tr>
                <tr>
					<cfset TotalICampoA = #TotalICampoA# - #TotalCampoA#>
                    <cfset TotalICampoB = #TotalICampoB# - #TotalCampoB#>
                    <cfset TotalICampoC = #TotalICampoC# - #TotalCampoC#>
                    <cfset TotalICampoD = #TotalICampoD# - #TotalCampoD#>
                    <cfset TotalICampoE = #TotalICampoE# - #TotalCampoE#>
                    <td>&nbsp;</td>
                    <td align="left" width="10%">TOTAL INGRESOS</td>
                    <td nowrap align="right">#numberformat(TotalICampoA, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(TotalICampoB, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(TotalICampoC, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(TotalICampoD, ",9.00")#</td>
                    <td nowrap align="right">#numberformat(TotalICampoE, ",9.00")#</td>
                    <td nowrap align="right">
                        <cfif TotalICampoA eq 0>
                            <cfset CampoF = 0>
                            N/A
                        <cfelse>
                            <cfset CampoF = #TotalICampoE#/#TotalICampoA#>
                            #numberformat(CampoF, ",9.0000")#
                        </cfif>
                    </td>                                
                </tr>
            <!---</cfif>--->
        </table>
    </cfoutput>
</cfif>