<!---
-----Script para determinar Constancias de Salario
-----Hecho por: Juan Carlos Gutiérrez
-----02/02/2005
--->

<!--- parametros fijos --->
<cfset pDEidentificacion = rsData.DEidentificacion >
<cfset pFecha 		 	 = rsData.fecha >
<cfset pRHEBEid 		 = rsData.RHEBEid >
<!--- --->

<cfif isdefined('pRHEBEid') and len(trim(pRHEBEid)) GT 0>
<cf_dbtemp name="datosBeca" returnvariable="datosBeca" datasource="#session.dsn#">
	<cf_dbtempcol name="DEid"					type="numeric"  		mandatory="no">
	<cf_dbtempcol name="nombre"					type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="identificacion"			type="varchar(25)"		mandatory="no">
	<cf_dbtempcol name="estadoCivil"			type="varchar(20)"		mandatory="no">
    <cf_dbtempcol name="direccion"				type="varchar(250)"		mandatory="no">
    <cf_dbtempcol name="ocupacion"				type="varchar(100)"  	mandatory="no">
    <cf_dbtempcol name="numeroContrato"				type="varchar(100)"  	mandatory="no">
    <cf_dbtempcol name="articulo"				type="varchar(60)"  	mandatory="no">
    <cf_dbtempcol name="sesion"					type="varchar(60)"  	mandatory="no">
    <cf_dbtempcol name="fechaCelebracion"		type="varchar(60)"  	mandatory="no">
	<cf_dbtempcol name="fecha"					type="varchar(100)"		mandatory="no">
	<cf_dbtempcol name="escuela"					type="varchar(100)"		mandatory="no">
</cf_dbtemp>

<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cfquery datasource="#session.DSN#">
	insert into #datosBeca# ( DEid, nombre , identificacion , estadoCivil , direccion)
	select 	DEid, 
    		DEnombre #_CAT# ' ' #_CAT# DEapellido1 #_CAT# ' ' #_CAT# DEapellido2,
            DEidentificacion, 
			case DEcivil 
                when 0 then 'Soltero(a)' 
                when 1 then 'Casado(a)' 
                when 2 then 'Divorciado(a)' 
                when 3 then 'Viudo(a)' 
                when 4 then 'Unión Libre' 
                when 5 then 'Separado(a)' 
                else '' 
            end, 
			DEdireccion
	from DatosEmpleado
	where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pDEidentificacion#"> <!--- parametro ver como hacer esto --->
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- parametro ver como hacer esto --->
</cfquery>

<cfquery name="rsBeca" datasource="#session.DSN#">
	select RHTBid, RHEBEsesionJef, RHEBEarticuloCom, RHEBEsesionCom, RHEBEfechaCom, RHEBEfecha
    from RHEBecasEmpleado
    where RHEBEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#pRHEBEid#"> 
      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Varibles Dinamicas--->
<cfquery name="rsVariablesDinamicas" datasource="#session.DSN#">
	select dcc.RHDCCBcodigo, dbe.RHDBEvalor
    from RHEConfigCertBecas ecc
    	inner join RHDConfigCertBecas dcc
        	on dcc.RHECCBid = ecc.RHECCBid and dcc.Ecodigo = ecc.Ecodigo
       	inner join RHDBecasEmpleado dbe
        	on dbe.RHTBDFid = dcc.RHTBDFid and dbe.RHEBEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#pRHEBEid#"> and dbe.RHDBEversion = 1
	where ecc.RHTBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBeca.RHTBid#">
		and ecc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsMontos" datasource="#session.DSN#">
	select RHDBEvalor, db.RHTBDFid, RHTBDFcapturaA, RHTBDFcapturaB
    from RHDBecasEmpleado db
    	inner join RHTipoBecaDFormatos dtb
        	on dtb.RHTBDFid = db.RHTBDFid
	where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pRHEBEid#"> 
      and RHDBEversion = 1
      and (RHTBDFcapturaA = 2 or RHTBDFcapturaB = 2)
</cfquery>
<cfset lvarMonto = 0>
<cfset lvarMcodigo = -1>
<cfloop query="rsMontos">
	<cfif rsMontos.RHTBDFcapturaA eq 2 and len(trim(rsMontos.RHTBDFcapturaB)) eq 0>
    	<cfset montoTemp = ListGetAt(rsMontos.RHDBEvalor,1,'|')>
    	<cfif isnumeric(montoTemp)>
        	<cfset lvarMonto = lvarMonto + montoTemp>
        </cfif>
        <cfif ListLen(rsMontos.RHDBEvalor,'|') gt 1>
        	<cfset lvarMcodigo = ListGetAt(rsMontos.RHDBEvalor,2,'|')>
        </cfif>
    <cfelseif rsMontos.RHTBDFcapturaA eq 2 and len(trim(rsMontos.RHTBDFcapturaB)) gt 0>
        <cfset lvarMontoC = ListGetAt(rsMontos.RHDBEvalor,1,'##')>
        <cfset montoTemp = ListGetAt(lvarMontoC,1,'|')>
    	<cfif isnumeric(montoTemp)>
        	<cfset lvarMonto = lvarMonto + montoTemp>
        </cfif>
        <cfif ListLen(lvarMontoC,'|') gt 1>
       	 	<cfset lvarMcodigo = ListGetAt(lvarMontoC,2,'|')>
        </cfif>
    <cfelseif rsMontos.RHTBDFcapturaA eq 5 and rsMontos.RHTBDFcapturaB eq 2>
    	<cfset montoTemp = ListGetAt(rsMontos.RHDBEvalor,1,'|')>
    	<cfif isnumeric(montoTemp)>
        	<cfset lvarMonto = lvarMonto + montoTemp>
        </cfif>
		<cfif ListLen(rsMontos.RHDBEvalor,'|') gt 1>
       		<cfset lvarMcodigo = ListGetAt(rsMontos.RHDBEvalor,2,'|')>
        </cfif>
    <cfelseif rsMontos.RHTBDFcapturaA neq 5 and rsMontos.RHTBDFcapturaB eq 2>
        <cfset lvarMontoC = ListGetAt(rsMontos.RHDBEvalor,2,'##')>
        <cfset montoTemp = ListGetAt(lvarMontoC,1,'|')>
    	<cfif isnumeric(montoTemp)>
        	<cfset lvarMonto = lvarMonto + montoTemp>
        </cfif>
        <cfif ListLen(lvarMontoC,'|') gt 1>
        	<cfset lvarMcodigo = ListGetAt(lvarMontoC,2,'|')>
        </cfif>
    </cfif>
</cfloop>

<cfquery name="rsMontosC" datasource="#session.DSN#">
	select RHDBEvalor
    from RHDBecasEmpleado db
    	inner join RHDConceptosBeca dc
        	on dc.RHDCBid = db.RHDCBid
	where RHEBEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#pRHEBEid#"> 
      and RHDBEversion = 1
      and RHDCBtipo = 2
      and RHTBDFid is null
</cfquery>
<cfloop query="rsMontosC">
	<cfset montoTemp = ListGetAt(rsMontosC.RHDBEvalor,1,'|')>
    <cfif isnumeric(montoTemp)>
		<cfset lvarMonto = lvarMonto + montoTemp>
    </cfif>
</cfloop>


<cfquery name="rsMoneda" datasource="#session.dsn#">
    select Mcodigo, Miso4217, Msimbolo, Mnombre
    from Monedas
    where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMcodigo#">
</cfquery>
<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="fechaCelebracion">
        <cfinvokeargument name="Fecha" value="#dateformat(rsBeca.RHEBEfechaCom,'dd/mm/yyyy')#"/>
</cfinvoke>

<cfset datosFiador1 = "">
<cfset datosFiador2 = "">
<cfset fiador1 = "">
<cfset fiador2 = "">
<cfquery name="rsFiadores" datasource="#session.dsn#">
    select coalesce(DEnombre,RHFnombre) #_CAT# ' ' #_CAT# coalesce(DEapellido1,RHFapellido1) #_CAT# ' ' #_CAT#  coalesce(DEapellido2,RHFapellido2) as nombre,
    	 	case DEcivil 
                when 0 then 'Soltero(a)' 
                when 1 then 'Casado(a)' 
                when 2 then 'Divorciado(a)' 
                when 3 then 'Viudo(a)' 
                when 4 then 'Unión Libre' 
                when 5 then 'Separado(a)' 
                else '' 
           	end as estadoCivil1,
       		case RHFestadoCivil 
                when 0 then 'Soltero(a)'
                when 1 then 'Casado(a)'
                when 2 then 'Divorciado(a)' 
                when 3 then 'Viudo(a)'
                when 4 then 'Unión Libre'
                when 5 then 'Separado(a)'
            end as estadoCivil2,
            (select min(e.RHPdescpuesto)
                    from LineaTiempo b, RHPlazas c, RHPuestos e
                    where b.DEid= fb.DEid
                      and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                      and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.LTdesde and b.LThasta )
                      and b.RHPid = c.RHPid
                      and e.RHPcodigo = c.RHPpuesto
                      and e.Ecodigo = c.Ecodigo ) as puesto,
           coalesce(DEdireccion, RHFprovincia #_CAT# ', ' #_CAT# RHFcanton)  as direccion,
           coalesce(DEidentificacion, RHFcedula) as indentificacion,
           case when d.DEid is null then RHFempresaLabora else '#session.Enombre#' end as empresa
    from RHFiadoresBecasEmpleado fb
    	left outer join DatosEmpleado d
        	on d.DEid = fb.DEid
        left outer join RHFiadores f
        	on f.RHFid = fb.RHFid
    where RHEBEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pRHEBEid#">
</cfquery>
<cfloop query="rsFiadores">
	<cfif rsFiadores.currentrow eq 1>
    	<cfset fiador1 = rsFiadores.nombre>
		<cfset datosFiador1 = " el señor(a) #rsFiadores.nombre#, mayor">
        <cfif len(trim(rsFiadores.estadoCivil1)) gt 0>
        	<cfset datosFiador1 = datosFiador1 & ', ' & rsFiadores.estadoCivil1 >
        <cfelse>
       		<cfset datosFiador1 = datosFiador1 & ', ' & rsFiadores.estadoCivil2 >
        </cfif>
        <cfif len(trim(rsFiadores.puesto)) gt 0>
        	<cfset datosFiador1 = datosFiador1 & ', ' & rsFiadores.puesto >
        </cfif>
         <cfset datosFiador1 = datosFiador1 & ', vecino(a) de #rsFiadores.direccion#, con cédula de identidad #rsFiadores.indentificacion#, funcionario de #rsFiadores.empresa#.'>
	<cfelseif  rsFiadores.currentrow eq 2>
    	<cfset fiador2 = rsFiadores.nombre>
		<cfset datosFiador2 = " el señor(a) #rsFiadores.nombre#, mayor">
        <cfif len(trim(rsFiadores.estadoCivil1)) gt 0>
        	<cfset datosFiador2 = datosFiador2 & ', ' & rsFiadores.estadoCivil1 >
        <cfelse>
       		<cfset datosFiador2 = datosFiador2 & ', ' & rsFiadores.estadoCivil2 >
        </cfif>
        <cfif len(trim(rsFiadores.puesto)) gt 0>
        	<cfset datosFiador2 = datosFiador2 & ', ' & rsFiadores.puesto >
        </cfif>
         <cfset datosFiador2 = datosFiador2 & ', vecino(a) de #rsFiadores.direccion#, con cédula de identidad #rsFiadores.indentificacion#, funcionario de #rsFiadores.empresa#.'>
	<cfelse>
    	<cfbreak>
    </cfif>
</cfloop>
<cfquery datasource="#session.DSN#">
    update #datosBeca# set
    
    ocupacion = ( 	select min(e.RHPdescpuesto)
                    from LineaTiempo b, RHPlazas c, RHPuestos e
                    where b.DEid=#datosBeca#.DEid
                      and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                      and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between b.LTdesde and b.LThasta )
                      and b.RHPid = c.RHPid
                      and e.RHPcodigo = c.RHPpuesto
                      and e.Ecodigo = c.Ecodigo ),
	escuela=(select min(c.CFdescripcion)
			from LineaTiempo a
			inner join RHPlazas b
				inner join CFuncional c
				on b.CFid=c.CFid
			on a.RHPid=b.RHPid
			 where a.DEid=#datosBeca#.DEid
                      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
                      and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.LTdesde and a.LThasta )),
    numeroContrato = '#rsBeca.RHEBEsesionJef#',
   	articulo = '#rsBeca.RHEBEsesionJef#',
   	sesion = '#rsBeca.RHEBEsesionCom#',
	fechaCelebracion = '#fechaCelebracion#'
                                    
</cfquery>
<cfquery name="rsProvincia" datasource="#session.dsn#">
	select RHEcol from RHEtiquetasEmpresa where RHEtiqueta like'%PROVINCIA%'
</cfquery>

<cfquery name="rsCanton" datasource="#session.dsn#">
	select RHEcol from RHEtiquetasEmpresa where RHEtiqueta like'%CANTON%'
</cfquery>

<cfquery name="rsDistrito" datasource="#session.dsn#">
	select RHEcol from RHEtiquetasEmpresa where RHEtiqueta like'%DISTRITO%'
</cfquery>

<cfif rsProvincia.RHEcol gt 0>
<cfquery name="rsEProv" datasource="#session.dsn#">
	select #rsProvincia.RHEcol# as prov from DatosEmpleado where DEid=(select min(DEid) from DatosEmpleado where DEidentificacion ='#pDEidentificacion#')
</cfquery>
</cfif>

<cfif rsCanton.RHEcol gt 0>
<cfquery name="rsECan" datasource="#session.dsn#">
	select #rsCanton.RHEcol# as canton from DatosEmpleado where DEid=(select min(DEid) from DatosEmpleado where DEidentificacion ='#pDEidentificacion#')
</cfquery>
</cfif>

<cfif rsDistrito.RHEcol gt 0>
<cfquery name="rsEDis" datasource="#session.dsn#">
	select #rsDistrito.RHEcol# as distrito from DatosEmpleado where DEid=(select min(DEid) from DatosEmpleado where DEidentificacion ='#pDEidentificacion#')
</cfquery>
</cfif>

<cfinvoke component="sif.Componentes.fechaEnLetras" method="fnFechaEnLetras" returnvariable="vFechaEnLetras">
        <cfinvokeargument name="Fecha" value="#dateformat(now(),'dd/mm/yyyy')#"/>
</cfinvoke>
<cfset fecha = ' #vFechaEnLetras#' >
<cfquery name="rsQuery" datasource="#session.DSN#">
	select 	DEid,
            nombre,
            identificacion,
            estadoCivil,
            direccion,
            ocupacion,
            numeroContrato,
            articulo,
            sesion,
			escuela,
            fechaCelebracion,
            '#fecha#' as fecha,
			<cfif rsEProv.recordcount gt 0>
			'#rsEProv.prov#' as provincia,
			</cfif>
			<cfif rsECan.recordcount gt 0>
			'#rsECan.canton#' as canton,
			</cfif>
			<cfif rsEDis.recordcount gt 0>
			'#rsEDis.distrito#' as distrito,
			</cfif>
            #lsdateformat(rsBeca.RHEBEfecha,'yyyy')# as agno,
            #lvarMonto# as  monto,
            '#rsMoneda.Msimbolo#' as  Msimbolo,
            '#rsMoneda.Mnombre#' as  Mnombre,
            '#datosFiador1#' as datosFiador1,
            '#datosFiador2#' as datosFiador2,
            '#fiador1#' as fiador1,
            '#fiador2#' as fiador2
            <cfloop query="rsVariablesDinamicas">
            	, '#rsVariablesDinamicas.RHDBEvalor#' as #rsVariablesDinamicas.RHDCCBcodigo#
            </cfloop>
	from #datosBeca#
</cfquery>
<cfelse>
	El empleado no tiene una beca asignada
</cfif>