<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 03-01-2013.
	Reporte Analítico del Activo
 --->
<!---<cf_dump var=#url#>--->
<cfinvoke key="MSG_ReporteAnalitico" default="REPORTE ANALITICO DEL ACTIVO"	returnvariable="MSG_ReporteAnalitico"	
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
<cfif #url.Unidad# eq 1>
	<cfinvoke key="MSG_Cifras_en" 	default=""					returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1>
<cfelseif #url.Unidad# eq 2>
	<cfinvoke key="MSG_Cifras_en" 	default="en miles de"		returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 1000>
<cfelseif #url.Unidad# eq 3>
	<cfinvoke key="MSG_Cifras_en" 	default="en diez miles de"	returnvariable="MSG_Cifras_en"	component="sif.Componentes.Translate" method="Translate"/>
    <cfset varUnidad= 10000>
</cfif>
<cfinvoke key="LB_Cuenta" 			default="Cuenta Contable"	returnvariable="LB_Cuenta"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_SaldoInicial" 	default="Saldo Inicial"		returnvariable="MSG_SaldoInicial"		component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Cargo" 			default="Cargos del"		returnvariable="MSG_Cargo"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Abono" 			default="Abonos del"		returnvariable="MSG_Abono"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Flujo" 			default="Flujo del"			returnvariable="MSG_Flujo"				component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_SaldoFinal" 		default="Saldo Final"		returnvariable="MSG_SaldoFinal"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_SI" 				default=""				returnvariable="MSG_SI"					component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Periodo" 		default="Periodo"			returnvariable="MSG_Periodo"			component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_SF" 				default=""				returnvariable="MSG_SF"					component="sif.Componentes.Translate" method="Translate"/>

<cfset LvarIrA = 'AnaliticoActivo.cfm'>
<cfset LvarFile = 'AnaliticoActivo'>
<cfset Request.LvarTitle = #MSG_ReporteAnalitico#>

<cfif not isdefined('form.formato') and isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>

<cf_dbtemp name="saldoscuenta" returnvariable="saldoscuenta" datasource="#session.dsn#">
		<cf_dbtempcol name="TipoActivo"  	type="numeric"  mandatory="yes">
		<cf_dbtempcol name="SubTipoActivo"  type="numeric"  mandatory="yes">
        <cf_dbtempcol name="Cmayor"  		type="numeric"  mandatory="yes">
        <cf_dbtempcol name="Cdescripcion"  	type="varchar(100)" mandatory="yes">
        <cf_dbtempcol name="Mcodigo"  		type="integer"  mandatory="yes">        
        <cf_dbtempcol name="SLinicial"  	type="money"    mandatory="yes">
        <cf_dbtempcol name="DLdebitos"  	type="money"    mandatory="yes">
        <cf_dbtempcol name="CLcreditos"  	type="money"    mandatory="yes">
        <cf_dbtempcol name="SOinicial"  	type="money"    mandatory="yes">
        <cf_dbtempcol name="DOdebitos"  	type="money"    mandatory="yes">
        <cf_dbtempcol name="COcreditos"  	type="money"    mandatory="yes">
        <cf_dbtempkey cols="TipoActivo,SubTipoActivo,Cmayor">
</cf_dbtemp>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select left(m.Cmayor,2) as TipoActivo,left(m.Cmayor,3) as SubTipoActivo,m.Cmayor,m.Cdescripcion,
    	   #url.Mcodigo#,0,0,0,0,0,0 from dbo.CtasMayor m
    where m.Ctipo='A'
    order by m.Cmayor
 </cfquery>
<!----Actualizar saldos ----->
<cfquery datasource="#session.DSN#">
	update #saldoscuenta#
    set 
    SLinicial = coalesce(
    (select sum(s.SLinicial)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
    
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato	
        and m.Cmayor  = #saldoscuenta#.Cmayor)
        
        , 0.00),
        
    DLdebitos = coalesce(
    (select sum(s.DLdebitos)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato	
        and m.Cmayor  = #saldoscuenta#.Cmayor), 0.00),
    CLcreditos = coalesce(
    (select sum(s.CLcreditos)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato	
        and m.Cmayor  = #saldoscuenta#.Cmayor), 0.00),
    SOinicial = coalesce(
    (select sum(s.SOinicial)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato	
        and m.Cmayor  = #saldoscuenta#.Cmayor), 0.00),
    DOdebitos = coalesce(
    (select sum(s.DOdebitos)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato	
        and m.Cmayor  = #saldoscuenta#.Cmayor), 0.00),
    COcreditos = coalesce(
    (select sum(s.COcreditos)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato	
        and m.Cmayor  = #saldoscuenta#.Cmayor), 0.00)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 10,100,1,'ACTIVO',#url.Mcodigo#,
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and m.Ctipo='A'
 </cfquery>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 11,110,11,'ACTIVO CIRCULANTE',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,2)='11'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 11,111,111,'Efectivo y Equivalentes',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='111'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 11,112,112,'Derechos a Recibir Efectivo o Equivalentes',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='112'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 11,113,113,'Derechos a Recibir Bienes o Servicios',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='113'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 11,114,114,'Inventarios',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='114'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 11,115,115,'Almacenes',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='115'
        and m.Ctipo='A'
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 11,116,116,'Estimacion por Perdida o Deterioro de Activos Circulantes',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='116'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 11,119,119,'Otros Activos Circulantes',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='119'
        and m.Ctipo='A'
</cfquery>

<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,120,12,'ACTIVO NO CIRCULANTE',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,2)='12'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,121,121,'Inversiones Financieras a Largo Plazo',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='121'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,122,122,'Derechos a Recibir Efectivo o Equivalentes a Largo Plazo',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='122'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,123,123,'Bienes Inmuebles, Infrestructura y Construcciones en Proceso',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='123'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,124,124,'Bienes Muebles',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='124'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,125,125,'Activos Intangibles',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='125'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,126,126,'Depreciacion, Deterioro y Amortizacion Acumulada de Bienes',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='126'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,127,127,'Activos Diferidos',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='127'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,128,128,'Estimacion por Perdida o Deterioro de Activos no Circulantes',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='128'
        and m.Ctipo='A'
</cfquery>
 
<cfquery datasource="#session.dsn#">
	insert into #saldoscuenta#(TipoActivo,SubTipoActivo,Cmayor,Cdescripcion,Mcodigo,SLinicial,DLdebitos,CLcreditos,SOinicial,DOdebitos,COcreditos)
    select 12,129,129,'Otros Activos no Circulantes',#url.Mcodigo#,   
	coalesce(sum(s.SLinicial), 0.00),coalesce(sum(s.DLdebitos), 0.00),coalesce(sum(s.CLcreditos), 0.00),
    coalesce(sum(s.SOinicial), 0.00),coalesce(sum(s.DOdebitos), 0.00),coalesce(sum(s.COcreditos), 0.00)
    from SaldosContables s
    inner join CContables c
    left join CtasMayor m
    on c.Ecodigo=m.Ecodigo and c.Cmayor=m.Cmayor
    on c.Ecodigo=s.Ecodigo and c.Ccuenta=s.Ccuenta
    where s.Ecodigo=#Session.Ecodigo#
        and s.Speriodo>=#url.periododes# and s.Speriodo<=#url.periodohas#
        and ((s.Speriodo * 12) + s.Smes >=  #url.periododes * 12 + url.mesdes#)
        and ((s.Speriodo * 12) + s.Smes <=  #url.periodohas * 12 + url.meshas#)
        <cfif isdefined('url.mcodigoopt') and url.mcodigoopt eq 0>
        	and s.Mcodigo = #url.Mcodigo#
        </cfif>
        and m.Cmayor  = c.Cformato
        and left(m.Cmayor,3)='129'
        and m.Ctipo='A'
</cfquery>
 
<cfoutput>
    <cfswitch expression="#url.mesdes#">
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
    <cfswitch expression="#url.meshas#">
        <cfcase value="1"><cfset strMesF = "#CMB_Enero#"></cfcase>
        <cfcase value="2"><cfset strMesF = "#CMB_Febrero#"></cfcase>
        <cfcase value="3"><cfset strMesF = "#CMB_Marzo#"></cfcase>
        <cfcase value="4"><cfset strMesF = "#CMB_Abril#"></cfcase>
        <cfcase value="5"><cfset strMesF = "#CMB_Mayo#"></cfcase>
        <cfcase value="6"><cfset strMesF = "#CMB_Junio#"></cfcase>
        <cfcase value="7"><cfset strMesF= "#CMB_Julio#"></cfcase>
        <cfcase value="8"><cfset strMesF = "#CMB_Agosto#"></cfcase>
        <cfcase value="9"><cfset strMesF = "#CMB_Setiembre#"></cfcase>
        <cfcase value="10"><cfset strMesF = "#CMB_Octubre#"></cfcase>
        <cfcase value="11"><cfset strMesF = "#CMB_Noviembre#"></cfcase>										
        <cfcase value="12"><cfset strMesF = "#CMB_Diciembre#"></cfcase>
    </cfswitch>
</cfoutput>

<cfquery name="rsMoneda" datasource="#Session.DSN#">
    select Mnombre
    from Monedas
    where Ecodigo = #Session.Ecodigo#
    and Mcodigo = #url.Mcodigo#
</cfquery>

<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select * from #saldoscuenta#
</cfquery>

<cfquery name="rsNombreEmpresa" datasource="#session.dsn#">
    select e.Edescripcion,e.Mcodigo
    from Empresas e
    where e.Ecodigo = #session.Ecodigo#
</cfquery>

<cfif url.formato NEQ "HTML">
    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	    <cfset typeRep = 1>
		<cfif url.formato EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#rsDetalle#" 
			isLink = False 
			typeReport = typeRep
			fileName = "cg.consultas.AnaliticoActivo"/>
	<cfelse>
        <cfreport format="#url.formato#" template= "AnaliticoActivo.cfr" query="rsDetalle">
            <cfreportparam name="Edescripcion"	value="#rsNombreEmpresa.Edescripcion#">
            <cfreportparam name="periodo_ini" 	value="#url.periododes#">
            <cfreportparam name="mes_ini" 	  	value="#strMesI#">	
            <cfreportparam name="periodo_fin" 	value="#url.periodohas#">
            <cfreportparam name="mes_fin" 	  	value="#strMesF#">	
            <cfreportparam name="moneda" 		value="#rsMoneda.Mnombre#">
            <cfreportparam name="cveMoneda" 	value="#rsNombreEmpresa.Mcodigo#">
            <cfreportparam name="Unidad"  		value="#varUnidad#">		
        </cfreport> 
    </cfif>
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
                <strong>De&nbsp;#strMesI#&nbsp;#url.periododes#&nbsp;al&nbsp;#strMesF#&nbsp;#url.periodohas#</strong>
                </td>
            </tr>
            <tr>
                <td style="font-size:16px" align="center" colspan="7"><strong>(#MSG_Cifras_en# #rsMoneda.Mnombre#)</strong></td>
            </tr>
        </table>
		<table width="100%">
        	<tr>
                <td nowrap align="center" colspan="2"><strong>#LB_Cuenta#</strong></td>
                <td nowrap align="center"><strong>#MSG_SaldoInicial#</strong></td>
                <td nowrap align="center"><strong>#MSG_Cargo#</strong></td>
                <td nowrap align="center"><strong>#MSG_Abono#</strong></td>
                <td nowrap align="center"><strong>#MSG_SaldoFinal#</strong></td>
                <td nowrap align="center"><strong>#MSG_Flujo#</strong></td>
            </tr>
        	<tr>
                <td nowrap align="center" colspan="3">&nbsp;</td>
                <td nowrap align="center"><strong>#MSG_Periodo#</strong></td>
                <td nowrap align="center"><strong>#MSG_Periodo#</strong></td>
                <td nowrap align="center"><strong>&nbsp;</strong></td>
                <td nowrap align="center"><strong>#MSG_Periodo#</strong></td>
            </tr>
            <cfloop query="rsDetalle">
            	<tr>
                	<td nowrap align="left">
                    	#Left(ToString(rsDetalle.Cmayor),1)#
                        #IIf(Len(rsDetalle.Cmayor) GT 1, '.'& mid(ToString(rsDetalle.Cmayor),2,1), '')#
                        #IIf(Len(rsDetalle.Cmayor) GT 2, '.'& mid(ToString(rsDetalle.Cmayor),3,1), '')# 
                        #IIf(Len(rsDetalle.Cmayor) GT 3, '.'& mid(ToString(rsDetalle.Cmayor),4,1), '')#
                    </td>
                    <td nowrap align="left">#UCase(rsDetalle.Cdescripcion)#</td>
                    <cfif rsNombreEmpresa.Mcodigo eq url.Mcodigo>
						<td nowrap align="right">#numberformat(rsDetalle.SLinicial/varUnidad, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsDetalle.DLdebitos/varUnidad, ",9.00")#</td>                        
                        <td nowrap align="right">#numberformat(rsDetalle.CLcreditos/varUnidad, ",9.00")#</td>                        
                        <td nowrap align="right">#numberformat((rsDetalle.SLinicial+rsDetalle.DLdebitos-rsDetalle.CLcreditos)/varUnidad, ",9.00")#</td>
                        <td nowrap align="right">#numberformat((rsDetalle.CLcreditos-rsDetalle.DLdebitos)/varUnidad, ",9.00")#</td>
                    <cfelse>
						<td nowrap align="right">#numberformat(rsDetalle.SOinicial/varUnidad, ",9.00")#</td>
                        <td nowrap align="right">#numberformat(rsDetalle.DOdebitos/varUnidad, ",9.00")#</td>                        
                        <td nowrap align="right">#numberformat(rsDetalle.COcreditos/varUnidad, ",9.00")#</td>                        
                        <td nowrap align="right">#numberformat((rsDetalle.SOinicial+rsDetalle.DOdebitos-rsDetalle.COcreditos)/varUnidad, ",9.00")#</td>
                        <td nowrap align="right">#numberformat((rsDetalle.COcreditos-rsDetalle.DOdebitos)/varUnidad, ",9.00")#</td>
                    </cfif>
                </tr>
            </cfloop>
        </table>
    </cfoutput>
</cfif>