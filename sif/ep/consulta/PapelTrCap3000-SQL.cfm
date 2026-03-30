<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 18-06-2013.
	Reporte Papel de Trabajo Capitulo 3000
 --->
<!---<cf_dump var=#url#>--->

<cfparam name="form.mes" 	 default="#right(form.CPCanoMes,2)#">
<cfparam name="form.periodo" default="#left(form.CPCanoMes,4)#">

<cfif isdefined("form.chkCeros")>
	<cfparam name="form.chkCeros" default="1">
<cfelse>
   	<cfparam name="form.chkCeros" default="0">  
</cfif> 
<cfif isdefined("form.chkDetalle")>
	<cfparam name="form.chkDetalle" default="1">
<cfelse>
   	<cfparam name="form.chkDetalle" default="0">  
</cfif> 

<!---<cf_dump var=#form#>--->

<cfquery name="rsCPPid" datasource="#Session.DSN#">
	select CPPid,CPPanoMesDesde,Mcodigo from CPresupuestoPeriodo
    where Ecodigo=#Session.Ecodigo#
    	and #form.CPCanoMes# between CPPanoMesDesde and CPPanoMesHasta
</cfquery>

<cfoutput>
<cfif rsCPPid.RecordCount eq 0>
	<cfset rsMensaje = "No se encuentran parametrizadas las cuentas de la contabilidad presupuestaria para el periodo &#form.mes# mes &#form.periodo#">
<cfelse>
	<cfif isdefined("form.mcodigoopt") and form.mcodigoopt EQ "0">
        <cfset varMcodigo = form.Mcodigo>
        <cfset varMonlocal= "false">
    <cfelse>
        <cfset varMcodigo = #rsCPPid.Mcodigo#>
        <cfset varMonlocal= "true">
    </cfif>
	<cfif isdefined("form.mensAcum") and form.mensAcum eq 1>
        <cfparam name="form.mesIni" 	 default="#right(form.CPCanoMes,2)#">
        <cfparam name="form.periodoIni" default="#left(form.CPCanoMes,4)#">
    <cfelse>
        <cfparam name="form.mesIni" 	default="#right(rsCPPid.CPPanoMesDesde,2)#">
        <cfparam name="form.periodoIni" default="#left(rsCPPid.CPPanoMesDesde,4)#">
	</cfif>
</cfif>

<cfif isdefined('rsMensaje')>
	<cflocation url="PapelTrCap3000.cfm?rsMensaje=#rsMensaje#">
</cfif>
</cfoutput>

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
    select e.Edescripcion
    from Empresas e
    where e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfif form.periodo lt year(NOW())>
	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#,01)-1,"dd/mm/yyyy")#>
<cfelse>
	<cfif form.mes lt month(NOW())>
    	<cfset LabelFechaFin = #DateFormat(CreateDate(form.periodo,#form.mes#+1,01)-1,"dd/mm/yyyy")#>
    <cfelse>
        <cfset LabelFechaFin = #DateFormat(CreateDate(year(NOW()),month(NOW()),day(NOW())),"dd/mm/yyyy")#>
    </cfif>
</cfif>

<cfinvoke key="MSG_ReporteAnalitico" default="Papel de Trabajo Cap&iacute;tulo 3000"	returnvariable="MSG_ReporteAnalitico"	
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
<cfinvoke key="LB_Concepto" default="EJERCICIO DEL PRESUPUESTO"	returnvariable="LB_Concepto"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Capitulo" default="RUBRO DE GASTO"		returnvariable="LB_Capitulo"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Desc"		default="Descripci&oacute;n" returnvariable="LB_Desc"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Presup"	default="Presupuesto" 	 	 returnvariable="LB_Presup"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Egreso"	default="Egreso" 	 	 	 returnvariable="LB_Egreso"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Aprob"	default="Aprobado" 	 	 	 returnvariable="LB_Aprob"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ampl"		default="Ampliaciones" 	 	 returnvariable="LB_Ampl"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Reduc"	default="Reducciones" 	 	 returnvariable="LB_Reduc"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Modif"	default="Modificado" 	  	 returnvariable="LB_Modif"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Precom"	default="Precompromisos" 	 returnvariable="LB_Precom"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Vigensin"	default="Vigente sin" 	  	 returnvariable="LB_Vigensin"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Precomet"	default="Precomprometer" 	 returnvariable="LB_Precomet"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Comprtd"	default="Comprometido" 	  	 returnvariable="LB_Comprtd"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NoDeven"	default="no Devengado" 	 	 returnvariable="LB_NoDeven"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Disp"		default="Disponible para" 	 returnvariable="LB_Disp"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Compr"	default="Comprometer" 	  	 returnvariable="LB_Compr"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Dev"		default="Devengado" 	  	 returnvariable="LB_Dev"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Comprsin"	default="Compromiso sin" 	 returnvariable="LB_Comprsin"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Devgr"	default="Devengar" 	  	 	 returnvariable="LB_Devgr"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejer"		default="Ejercido" 	  	 	 returnvariable="LB_Ejer"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Egresin"	default="Egreso sin" 	 	 returnvariable="LB_Egresin"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejercer"	default="Ejercer" 	  	 	 returnvariable="LB_Ejercer"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pagdo"	default="Pagado" 	  	 	 returnvariable="LB_Pagdo"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ejersin"	default="Ejercido sin" 	  	 returnvariable="LB_Ejersin"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pagar"	default="Pagar (Deuda)" 	 returnvariable="LB_Pagar"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Ctaspor"	default="Cuentas por" 	  	 returnvariable="LB_Ctaspor"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Mensual"	default='Mensual' 			returnvariable="LB_Mensual"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Acumulado"	default='Acumulado' returnvariable="LB_Acumulado"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nota" 	default="Notas"			returnvariable="LB_Nota"	component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NotaPie"		default='Importante:  Las columnas de Egreso Aprobado y de Egreso Modificado corresponden al presupuesto anual autorizado.' 	returnvariable="LB_NotaPie"		component="sif.Componentes.Translate" method="Translate"/>


<cfset LvarIrA  = 'PapelTrCap3000.cfm'>
<cfset LvarFile = 'PapelTrCap3000'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
    <cf_dbtempcol name="ID_Estr"  		type="int">
    <cf_dbtempcol name="Seccion"  		type="int">
    <cf_dbtempcol name="ID_EstrCtaVal" 	type="numeric">
    <cf_dbtempcol name="PCDcatid" 		type="numeric">
    <cf_dbtempcol name="CtpGsto"  		type="int">
	<cf_dbtempcol name="CGEPDescrip"  	type="varchar(100)">
    <cf_dbtempcol name="Nota"  			type="int">
	<cf_dbtempcol name="ID_DEstrCtaVal" type="numeric">
    <cf_dbtempcol name="Mcodigo"  		type="integer"> 
    <cf_dbtempcol name="EgreApr"  		type="money">
    <cf_dbtempcol name="AmpRed"  		type="money">
    <cf_dbtempcol name="EgreMod"  		type="money">
    <cf_dbtempcol name="EgreComp"  		type="money">
    <cf_dbtempcol name="EgreDev"  		type="money">
    <cf_dbtempcol name="EgreEjer"  		type="money">
    <cf_dbtempcol name="EgrePag"  		type="money">
    <cf_dbtempcol name="ModificPer" 	type="money">        
    <cf_dbtempkey cols="ID_Estr,Seccion,ID_EstrCtaVal,PCDcatid,CtpGsto">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(ID_Estr,Seccion,ID_EstrCtaVal,PCDcatid,CtpGsto,CGEPDescrip,Nota,ID_DEstrCtaVal,Mcodigo,EgreApr,AmpRed,EgreMod,EgreComp, 
    EgreDev,EgreEjer,EgrePag,ModificPer)
	select rep.ID_Estr, 
    epv.ID_Grupo,
	 coalesce(epv.ID_EstrCtaVal, 0),  coalesce(p.PCDcatid, 0),
	left(epv.EPCPcodigo,4),epv.EPCPdescripcion,
    epv.EPCPcodigoref,coalesce(d.ID_DEstrCtaVal, 0) as ID_DEstrCtaVal,
    #varMcodigo#, 0, 0, 0, 0, 0, 0, 0, 0
from CGReEstrProg rep 
        inner join CGEstrProgVal epv
        on rep.ID_Estr= epv.ID_Estr
    left join dbo.CGDEstrProgVal d
    on d.ID_EstrCtaVal=epv.ID_EstrCtaVal
    left join PCDCatalogo p
       on d.PCDcatid=p.PCDcatid 
        
where rep.SPcodigo='#session.menues.SPCODIGO#'
 </cfquery>
<!---<cf_dumptofile select="select * from #saldoscuenta# order by CtpGsto">--->
 
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
    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">    
</cfinvoke>
<!---<cf_dumptofile select="select * from #rsEPQuery# order by ID_GpoCat,ID_EstrCtaVal">--->

<!----Actualizar saldos ----->
<cfquery datasource="#session.DSN#" name="SC">
	select * from #saldoscuenta#
    where ID_EstrCtaVal<>0
    order by PCDcatid
</cfquery>

<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">--->

<cfloop query="SC">
    <cfquery datasource="#session.DSN#" name="Saldos">
        select 
        <!---coalesce(sum(CPCpresupuestado), 0.00) as IngrEst,--->
        coalesce(sum(CPCpresup_Anual), 0.00) as IngrEst,
        
        coalesce(sum(CPCmodificado), 0.00) +  coalesce(sum(CPCmodificacion_Excesos), 0.00) + coalesce(sum(CPCtrasladado), 0.00) as Modific,
        coalesce(sum(CPCpresup_Anual), 0.00) + coalesce(sum(CPCmodificadoAnual), 0.00) <!---+  coalesce(sum(CPCmodif_ExcAnual), 0.00)---> + 						coalesce(sum(CPCtras_Anual), 0.00) + coalesce(sum(CPCtrasE_Anual), 0.00) as IngrMod,
        
<!---        coalesce(sum(CPCpresupuestado), 0.00) + coalesce(sum(CPCmodificadoAnual), 0.00) +  coalesce(sum(CPCmodif_ExcAnual), 0.00) + 						coalesce(sum(CPCtras_Anual), 0.00) as IngrMod,
--->        
        coalesce(sum(CPCpresupPeriodo), 0.00) + coalesce(sum(CPCmodificado), 0.00) +  coalesce(sum(CPCmodificacion_Excesos), 0.00) + coalesce(sum(CPCtrasladado), 0.00) <!---+ coalesce(sum(CPCtrasladadoE), 0.00)---> as ModificPer,  
              
        coalesce(sum(CPCejecutado), 0.00) as IngrDev,
        coalesce(sum(CPCcomprometido), 0.00) + coalesce(sum(CPCejecutado), 0.00) as EgreComp,
        coalesce(sum(CPCejercido), 0.00) <!---+ coalesce(sum(CPCpagado), 0.00)---> as EgreEjer,
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
    
	<cfquery datasource="#session.DSN#">
        update #saldoscuenta#
        set
        EgreApr  = <cfif #Signo.SaldoInv# eq 1> 0 - coalesce(#Saldos.IngrEst#, 0.00) <cfelse> coalesce(#Saldos.IngrEst#, 0.00) </cfif>,
       <!--- AmpRed   = <cfif #Signo.SaldoInv# eq 1> 0 - coalesce(#Saldos.Modific#, 0.00) <cfelse> coalesce(#Saldos.Modific#, 0.00) </cfif>,--->
       
		AmpRed   = <cfif #Signo.SaldoInv# eq 1> 0 - (coalesce(#Saldos.IngrMod#, 0.00)- coalesce(#Saldos.IngrEst#, 0.00))<cfelse> (coalesce(#Saldos.IngrMod#, 0.00)- coalesce(#Saldos.IngrEst#, 0.00)) </cfif>,
        
        EgreMod  = <cfif #Signo.SaldoInv# eq 1> 0 - coalesce(#Saldos.IngrMod#, 0.00) <cfelse> coalesce(#Saldos.IngrMod#, 0.00) </cfif>,
        EgreComp = <cfif #Signo.SaldoInv# eq 1> 0 - coalesce(#Saldos.EgreComp#, 0.00) <cfelse> coalesce(#Saldos.EgreComp#, 0.00) </cfif>,
        EgreDev  = <cfif #Signo.SaldoInv# eq 1> 0 - coalesce(#Saldos.IngrDev#, 0.00) <cfelse> coalesce(#Saldos.IngrDev#, 0.00) </cfif>,
        EgreEjer = <cfif #Signo.SaldoInv# eq 1> 0 - coalesce(#Saldos.EgreEjer#, 0.00) <cfelse> coalesce(#Saldos.EgreEjer#, 0.00) </cfif>,
        EgrePag  = <cfif #Signo.SaldoInv# eq 1> 0 - coalesce(#Saldos.IngrRec#, 0.00) <cfelse> coalesce(#Saldos.IngrRec#, 0.00) </cfif>,
        ModificPer = <cfif #Signo.SaldoInv# eq 1> 0 - coalesce(#Saldos.ModificPer#, 0.00) <cfelse> coalesce(#Saldos.ModificPer#, 0.00) </cfif>
        where #saldoscuenta#.PCDcatid = #SC.PCDcatid#
    </cfquery>
</cfloop>
<!---<cf_dumptofile select="select * from #saldoscuenta# order by Seccion">--->

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select CtpGsto,CGEPDescrip,Nota,
    sum(EgreApr)/#varUnidad# 	as EgreApr,
    sum(AmpRed)/#varUnidad# 	as AmpRed,
    sum(EgreMod)/#varUnidad# 	as EgreMod,
    sum(EgreComp)/#varUnidad# 	as EgreComp,
    <!---(sum(ModificPer)-sum(EgreComp))/#varUnidad# as DispComp,--->
    (sum(EgreMod)-sum(EgreComp))/#varUnidad# as DispComp,
    sum(EgreDev)/#varUnidad# 	as EgreDev,
    (sum(EgreComp)-sum(EgreDev))/#varUnidad# as CompND,
   <!--- (sum(ModificPer)-sum(EgreDev))/#varUnidad#  as EgreSD,--->
    (sum(EgreMod)-sum(EgreDev))/#varUnidad#  as EgreSD,
    sum(EgreEjer)/#varUnidad# 	as EgreEjer,
    sum(EgrePag)/#varUnidad# 	as EgrePag,
    (sum(EgreDev)-sum(EgrePag))/#varUnidad#  as CuentasPP
	from #saldoscuenta#
    <cfif form.chkCeros eq '0'>
    where EgreApr <> 0 or
    	 AmpRed   <> 0 or
         EgreMod  <> 0 or
         EgreComp <> 0 or
         EgreEjer <> 0 or
         EgrePag  <> 0 or
         EgreDev  <> 0
    </cfif>   
    group by CtpGsto,CGEPDescrip,Nota
    order by CtpGsto,CGEPDescrip
</cfquery>

<!---<cf_dump var="#rsDetalle#">--->

<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select Mnombre
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #varMcodigo#
</cfquery>
<cfset indice = 1>
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
<cfset NotasPie = ''>
<cfquery name="rsNotas" datasource="#Session.DSN#">
    select coalesce(EPCPcodigoref,'') as EPCPcodigoref , coalesce(EPCPnota,'') as EPCPnota
    from dbo.CGEstrProgVal
    where EPCPcodigoref <> '' and ID_Estr = #rsNumEst.ID_Estr#
    and EPCPcodigoref in (select distinct Nota from #saldoscuenta# 
    <cfif form.chkCeros eq '0'>
    where EgreApr <> 0 or
    	 AmpRed   <> 0 or
         EgreMod  <> 0 or
         EgreComp <> 0 or
         EgreEjer <> 0 or
         EgrePag  <> 0 or
         EgreDev  <> 0
    </cfif>   
)
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
	<cfset NotasPie = #NotasPie#&'  '&#rsNotas.EPCPcodigoref#&' '&#rsNotas.EPCPnota#>
</cfloop>

<cfif form.formato NEQ "HTML">
	<cfif #form.mensAcum# eq 1>
       <cfset LabelFechaFin = #LabelFechaFin#&' Mensual'>
    <cfelse>
       <cfset LabelFechaFin = #LabelFechaFin#&' Acumulado'>
    </cfif>
    <cfreport format="#form.formato#" template= "PapelTrCap3000.cfr" query="rsDetalle">
        <cfreportparam name="periodo_ini" 	value="#LabelFechaFin#">
        <cfreportparam name="moneda" 		value="#rsMoneda.Mnombre#">
        <cfreportparam name="cveMoneda" 	value="#varMcodigo#">
        <cfreportparam name="Unidad"  		value="#varUnidad#">
        <cfreportparam name="NotasPie"  	value="#NotasPie#">
        <cfreportparam name="Edescripcion"	value="#rsNombreEmpresa.Edescripcion#">	
        <cfreportparam name="LB_NotaPie" 	value="#LB_NotaPie#">  
        <cfreportparam name="LB_Nota" 	value="#LB_Nota#"> 
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
                	#LB_Mensual#
                <cfelse>
                	#LB_Acumulado#
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
            	<td align="center" colspan="2"><!---<strong>#LB_Concepto#</strong>---></td>
                <td></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Egreso#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ampl#/</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Egreso#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Egreso#</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Disp#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Egreso#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Comprtd#</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Egresin#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Egreso#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Egreso#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ctaspor#</strong></td>
            </tr>
             <tr>
            	<td align="left" colspan="2"><strong>#LB_Capitulo#</strong></td>
                <td nowrap align="center"><strong>#LB_Nota#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Aprob#</strong></td>
                <td align="center" nowrap="nowrap"><strong>(#LB_Reduc#)</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Modif#</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_Comprtd#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Compr#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Dev#</strong></td>
				<td align="center" nowrap="nowrap"><strong>#LB_NoDeven#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Devgr#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Ejer#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Pagdo#</strong></td>
                <td align="center" nowrap="nowrap"><strong>#LB_Pagar#</strong></td>
			</tr>    
             <tr>
            	<td align="left" colspan="2"></td>
                <td nowrap align="center"></td>
                <td align="center" nowrap="nowrap"><strong>1</strong></td>
                <td align="center" nowrap="nowrap"><strong>2</strong></td>
                <td align="center" nowrap="nowrap"><strong>3</strong></td>
				<td align="center" nowrap="nowrap"><strong>4</strong></td>
                <td align="center" nowrap="nowrap"><strong>5=(3-4)</strong></td>
                <td align="center" nowrap="nowrap"><strong>6</strong></td>
				<td align="center" nowrap="nowrap"><strong>7=(4-6)</strong></td>
                <td align="center" nowrap="nowrap"><strong>8=(3-6)</strong></td>
                <td align="center" nowrap="nowrap"><strong>9</strong></td>
                <td align="center" nowrap="nowrap"><strong>10</strong></td>
                <td align="center" nowrap="nowrap"><strong>11=(6-10)</strong></td>
			</tr>   
			<cfset TOTALEgreApr 	= 0>
            <cfset TOTALAmpRed 		= 0>
            <cfset TOTALEgreMod 	= 0>
            <cfset TOTALEgreComp 	= 0>
            <cfset TOTALDispComp 	= 0>
            <cfset TOTALEgreDev 	= 0>
            <cfset TOTALCompND 		= 0>
            <cfset TOTALEgreSD 		= 0>
            <cfset TOTALEgreEjer 	= 0>
            <cfset TOTALEgrePag 	= 0>
            <cfset TOTALCuentasPP 	= 0>
            
            <cfloop query="rsDetalle">
				<cfset TOTALEgreApr 	= #TOTALEgreApr#+#rsdetalle.EgreApr#>
                <cfset TOTALAmpRed 		= #TOTALAmpRed#+#rsdetalle.AmpRed#>
                <cfset TOTALEgreMod 	= #TOTALEgreMod#+#rsdetalle.EgreMod#>
                <cfset TOTALEgreComp 	= #TOTALEgreComp#+#rsdetalle.EgreComp#>
                <cfset TOTALDispComp 	= #TOTALDispComp#+#rsdetalle.DispComp#>
                <cfset TOTALEgreDev 	= #TOTALEgreDev#+#rsdetalle.EgreDev#>
                <cfset TOTALCompND 		= #TOTALCompND#+#rsdetalle.CompND#>
                <cfset TOTALEgreSD 		= #TOTALEgreSD#+#rsdetalle.EgreSD#>
                <cfset TOTALEgreEjer 	= #TOTALEgreEjer#+#rsdetalle.EgreEjer#>
                <cfset TOTALEgrePag 	= #TOTALEgrePag#+#rsdetalle.EgrePag#>
                <cfset TOTALCuentasPP 	= #TOTALCuentasPP#+#rsdetalle.CuentasPP#>
				<tr>
                	<td nowrap align="left">.<!---#(rsDetalle.CtpGsto)#---></td>
					<td nowrap align="left">#(rsDetalle.CGEPDescrip)#</td>
                    <td nowrap align="center"><cfif #rsdetalle.Nota# gt 0>#rsdetalle.Nota#</cfif></td>
<!---                    <cfif rsDetalle.CtpGsto lt '6000'>
--->                        
						<td nowrap align="right">#numberformat(rsdetalle.EgreApr, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.AmpRed, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.EgreMod, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.EgreComp, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.DispComp, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.EgreDev, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.CompND,",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.EgreSD, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.EgreEjer, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.EgrePag, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsdetalle.CuentasPP, ",9.00")#</td>
<!---                    <cfelse>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                        <td nowrap align="right">N/A</td>
                    </cfif>
--->            	
				</tr>
			</cfloop>
            <tr>
                <td nowrap align="right" colspan="2">TOTAL CAP&Iacute;TULO 3000:</td>
                <td></td>
                <td nowrap align="right">#numberformat(TOTALEgreApr, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALAmpRed, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALEgreMod, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALEgreComp, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALDispComp, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALEgreDev, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALCompND,",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALEgreSD, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALEgreEjer, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALEgrePag, ",9.00")#</td>
                <td nowrap align="right">#numberformat(TOTALCuentasPP, ",9.00")#</td>
            </tr>
            <tr>
            	<td align="left" colspan="11">Notas:</td>
            </tr>
            <cfloop query="rsNotas">
            	<tr>
                	<td align="left" colspan="11">#rsNotas.EPCPcodigoref# #rsNotas.EPCPnota#</td>
                </tr>
            </cfloop>
	<tr>
	    <td colspan="8">#LB_NotaPie#</td>
	</tr>
        </table>
    </cfoutput>
</cfif>