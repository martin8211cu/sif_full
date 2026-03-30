
<!--- ljimenez parametrizacion para realiar corrida modo debug 

<cfset vDebugEmpleado = 0>  1 = activo el debug calculo segun los DEid's de la lista vDebugEmpleadoLista
<cfset vDebugEmpleadoLista = '498,454,458,470' > usar los deids  separado con coma 

modo de uso
<cfif vDebugEmpleado>
    and a.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vDebugEmpleadoLista#" list="true">)
</cfif>

--->

<cfset vDebug = "false">
<cfset vDebugEmpleado = 0>  
<cfset vDebugEmpleadoLista = '1011' >






<cf_templatecss>
<cfsetting requesttimeout="8600">
			 
<cfset t = createObject("component", "sif.Componentes.Translate")>

<cfset LvarBack 							= "GenerarEstimacionCesantiaFundatec.cfm">
<cfset LB_ReporteEstimacionCesantia 		= t.translate('LB_ReporteEstimacionCesantia','Reporte de Estimación de Cesantía')>
<cfset LB_CentroFuncional 		    		= t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>
<cfset LB_CFPadre 							= t.translate('LB_CFPadre','Centro funcional padre','/rh/generales.xml')>
<cfset LB_CFHijo 							= t.translate('LB_CFHijo','Centro funcional','/rh/generales.xml')>
<cfset LB_Identificacion 					= t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_Nombre 							= t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_FechaIngreso 						= t.translate('LB_FechaIngreso','Fecha de ingreso','/rh/generales.xml')>
<cfset LB_Antiguedad 						= t.translate('LB_Antiguedad','Antiguedad','/rh/generales.xml')>
<cfset LB_Meses 							= t.translate('LB_Meses','Meses','/rh/generales.xml')>
<cfset LB_Dias 								= t.translate('LB_Dias','Días','/rh/generales.xml')>
<cfset LB_TotalDiasPagar 					= t.translate('LB_TotalDiasPagar','Total días a pagar','/rh/generales.xml')>
<cfset LB_SalarioPromedioDiario 			= t.translate('LB_SalarioPromedioDiario','Salario <br> promedio <br> diario','/rh/generales.xml')>
<cfset LB_DiasLabPorCF 						= t.translate('LB_DiasLabPorCF','Días laborados <br> por CF','/rh/generales.xml')>
<cfset LB_PorcCesantiaPagarPorCF 			= t.translate('LB_PorcCesantiaPagarPorCF','Porcentaje <br> Cesantía pagar <br> por CF','/rh/generales.xml')>
<cfset LB_CesantiaPagarPorCF 				= t.translate('LB_CesantiaPagarPorCF','Cesantía pagar <br> por CF','/rh/generales.xml')>
<cfset LB_ProvCesantiaPorCF 				= t.translate('LB_ProvCesantiaPorCF','Provisión <br> cesantia por CF','/rh/generales.xml')>
<cfset LB_TrasladoASEFUDA 					= t.translate('LB_TrasladoASEFUDA','Traslado <br> ASEFUNDA','/rh/generales.xml')>
<cfset LB_AdelantoCesantia 					= t.translate('LB_AdelantoCesantia','Adelanto cesantía','/rh/generales.xml')>
<cfset LB_CesantiaNetaProvporCF 			= t.translate('LB_CesantiaNetaProvporCF','Cesantía neta <br> provisionada <br> por CF ','/rh/generales.xml')>
<cfset LB_CesantiaNetaPagarxCF 				= t.translate('LB_CesantiaNetaPagarxCF','Cesantia neta pagar<br> por CF','/rh/generales.xml')>
<cfset LB_SuficienciaInsuficiencias 		= t.translate('LB_SuficienciaInsuficiencias','Suficiencia / <br> Insuficiencias','/rh/generales.xml')>
<cfset LB_MontoTotalCesantiaPagarColones 	= t.translate('LB_MontoTotalCesantiaPagarColones','Monto total cesantía a pagar Colones','/rh/generales.xml')>
<cfset LB_AnosLaborados 					= t.translate('LB_AnosLaborados','Años','/rh/generales.xml')>
<cfset LB_FinDelReporte 					= t.translate('LB_FinDelReporte','Fin del Reporte','/rh/generales.xml')>
<cfset LB_NoExistenRegistrosQueMostrar 		= t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>
<cfset LB_NoExisteConceptoCesantiaConfig 	= t.Translate('LB_NoExisteConceptoCesantiaConfig','No existe concepto cesantía','/rh/generales.xml')>
<cfset LB_NoExisteFormulaConcepto 			= t.Translate('LB_NoExisteFormulaConcepto','No existe fórmula de cesantía','/rh/generales.xml')>
<cfset MSG_NoCesantia 						= t.translate('MSG_NoCesantia','No está definido el concepto para cesantía <br> verificar <br> Parámetros RH / Parámetros Generales / Formulación cáculos especiales')>

<cfset archivo = "ReporteEstimacionCesantia.xls" />

<cfif isDefined("form.FechaCorte") and LEN(TRIM(form.FechaCorte))>
	<cfset vFecha = LSParseDateTime(form.FechaCorte) >
</cfif>	
 
<cfif len(trim(form.CFid)) eq 0>
	<cfset form.CFid = 0 >
</cfif>

<cfif not isdefined('form.dependencias')>
	<cfset form.dependencias = ''>
</cfif>	

<cfif isdefined('url.CFid') and not isdefined('form.CFid')>
	<cfset form.CFid = url.CFid>
</cfif>	

<cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFpath
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	</cfquery>
	<cfset vRuta = rsCFuncional.CFpath >
</cfif>	

<cfquery name="rsUltimo" datasource="#session.DSN#">
    Select distinct FGenerada
        from RHEstCesantiaCF
</cfquery>

<cfset vs_filtro = ''>

<cfif isdefined("form.ordenamiento") and form.ordenamiento EQ 1>
	<cfset vs_filtro = 'order by de.DEapellido1, de.DEnombre'>
<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 2>		
	<cfset vs_filtro = 'order by  de.DEnombre, de.DEapellido1'>
<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 3>
	<cfset vs_filtro = 'order by de.DEidentificacion'>
</cfif>

<cfif not isDefined("form.esCorporativo")>
	<cfset filtro1 = '<strong>#LB_CentroFuncional#: #form.CFdescripcion#</strong>'>
<cfelse>
	<cfset filtro1 = ''/>		
</cfif>

<cfset empresas = "0" >

<cfset form.jtreeJsonFormat = session.Ecodigo >

<cfif Form.chkOpcion eq 1>
	<cfflush interval="1"> 
</cfif>	

<!---Carga para Provision Asociacin FTEC--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2048" default="-1" returnvariable="vCargaAsociacion">

<!---Carga para Provision Cesantia FTEC--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2047" default="-1" returnvariable="vCargaCesantia">

<!--- 20140626 BUSCA EL CONCEPTO PARAMETRIZADO PARA CESANTIA --->                        
<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2687" default="-1" returnvariable="CIncidente">
<cfset Merror = ''>
<cfif CIncidente eq -1 or vCargaCesantia eq -1 or vCargaAsociacion eq -1>
	<cfif CIncidente eq -1 >
    	<cfset Merror =  Merror & ' * Concepto para el calculo de la cesantia * '>
    </cfif>
    <cfif vCargaCesantia eq -1 >
    	<cfset Merror =  Merror & ' * Carga para provision  de cesantia * '>
    </cfif>    
        <cfif vCargaAsociacion eq -1 >
    	<cfset Merror =  Merror & ' * Carga para Asociacion * '>
    </cfif>    
    <cfset DetErrs 	 = 'No se ha definido' & #Merror# & ' en parámetros generales, Verificar.'>
    <cf_dump var="#DetErrs#">
</cfif>


<!---Temporal para el calculo de la cesantia--->    
<cf_dbtemp name="TempEstCesa01" returnvariable="EstCesantia" datasource="#session.DSN#">
	<cf_dbtempcol name="Ecodigo" 			type="int" 		mandatory="no">
	<cf_dbtempcol name="DEid" 				type="numeric" 	mandatory="no">
    <cf_dbtempcol name="CFid" 				type="numeric" 	mandatory="no">
    <cf_dbtempcol name="FactorDias"			type="varchar(12)" 	mandatory="no">
    <cf_dbtempcol name="Tcodigo"			type="varchar(5)" 	mandatory="no">
    <cf_dbtempcol name="Fingreso" 			type="date" 	mandatory="no">
    <cf_dbtempcol name="Fhasta" 			type="date" 	mandatory="no">
    <cf_dbtempcol name="Annos" 				type="money" 	mandatory="no">
    <cf_dbtempcol name="Meses" 				type="money" 	mandatory="no">
    <cf_dbtempcol name="Dias" 				type="money" 	mandatory="no">
    <cf_dbtempcol name="DiasCesantia" 		type="money" 	mandatory="no">
    <cf_dbtempcol name="SalarioPromedio"	type="money" 	mandatory="no">
    <cf_dbtempcol name="MontoCesantia"		type="money" 	mandatory="no">
</cf_dbtemp>    

<!---Temporal para el calculo de dias por Centro Funcional--->    
<cf_dbtemp name="TempEstCesaCF01" returnvariable="EstCesantiaCF" datasource="#session.DSN#">
	<cf_dbtempcol name="DEid" 				type="numeric" 	mandatory="no">
    <cf_dbtempcol name="TotalDiasNomina"	type="numeric" 	mandatory="no">
    <cf_dbtempcol name="TotalProvCesa" 		type="money" 	mandatory="no">
    <cf_dbtempcol name="CFid" 				type="numeric" 	mandatory="no">
    <cf_dbtempcol name="DiasCF"				type="money" 	mandatory="no">
    <cf_dbtempcol name="ProviCesantiaCF"	type="money" 	mandatory="no"> <!---Provision Cesantia--->
    <cf_dbtempcol name="CesaCFProp" 		type="money" 	mandatory="no"> <!---Proporcion Cesantia--->
    <cf_dbtempcol name="PesoxCF" 			type="money" 	mandatory="no"> <!---Peso de la proporcion--->
    <cf_dbtempcol name="ASOxCF" 			type="money" 	mandatory="no">
	<cf_dbtempcol name="CesaxCFManual" 		type="money" 	mandatory="no">
    <cf_dbtempcol name="ASOxCFManual" 		type="money" 	mandatory="no">
    <cf_dbtempcol name="AdelantoCesaCFManual" type="money" 	mandatory="no">
    <cf_dbtempcol name="Fingreso" 			type="date" 	mandatory="no">
    <cf_dbtempcol name="AnnosLaborados"		type="money" 	mandatory="no">
    <cf_dbtempcol name="MesesLaborados"		type="money" 	mandatory="no">
    <cf_dbtempcol name="DiasLaborados"		type="money" 	mandatory="no">
    <cf_dbtempcol name="DiasPagoCesantia" 	type="money" 	mandatory="no">
    <cf_dbtempcol name="SalarioPromedio" 	type="money" 	mandatory="no">
    <cf_dbtempcol name="MontoCesantiaPagar"	type="money" 	mandatory="no">
    <cf_dbtempcol name="CesaxCFProporcional"type="money" 	mandatory="no">
    <cf_dbtempcol name="TotalProvASO"		type="money" 	mandatory="no">
    <cf_dbtempcol name="ASOCFProp" 			type="money" 	mandatory="no"> <!---Proporcion Cesantia--->
    <cf_dbtempcol name="ProviCesantia"		type="money" 	mandatory="no">
    <cf_dbtempcol name="TrasladoASEFUNDA"	type="money" 	mandatory="no">
    <cf_dbtempcol name="CesaPosTraslado"	type="money" 	mandatory="no">
    <cf_dbtempcol name="CesaNetaXPagar"		type="money" 	mandatory="no">
    <cf_dbtempcol name="Resultado"			type="money" 	mandatory="no">
    <cf_dbtempcol name="TotalReservado"     type="money"    mandatory="no">
    <cf_dbtempcol name="FGenerada"           type="date"     mandatory="no">
    <cf_dbtempcol name="CFpath"           type="varchar(255)"     mandatory="no">
</cf_dbtemp>



 <cfquery datasource="#session.DSN#" name="rs">
	<cfoutput>
    	insert into #EstCesantia# (Ecodigo, DEid,CFid,  Fingreso, Tcodigo, Annos, Meses, Dias, DiasCesantia, SalarioPromedio, MontoCesantia,Fhasta,FactorDias)
		select distinct lt.Ecodigo, lt.DEid, coalesce(rhp.CFidconta,rhp.CFid)
         , coalesce(ev.EVfantigCorp,ev.EVfantig), lt.Tcodigo, 0,0,0,0,0,0
        ,<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParsedateTime(form.FechaCorte)#" >
        ,tn.FactorDiasSalario
        from LineaTiempo lt 
			inner join DatosEmpleado de
				on lt.DEid = de.DEid
			inner join RHPlazas rhp 
				on rhp.RHPid = lt.RHPid
			inner join CFuncional cf
					on cf.CFid = coalesce(rhp.CFidconta,rhp.CFid) 
	    	inner join TiposNomina tn
	    		on lt.Ecodigo = tn.Ecodigo
	    		and lt.Tcodigo = tn.Tcodigo
            inner join EVacacionesEmpleado ev
            	on ev.DEid = lt.DEid
		where 1 = 1 
             and exists (select 1 <!---max(a.DLfvigencia)--->
                    from DLaboralesEmpleado a
                    inner join RHTipoAccion b
                        on b.RHTid = a.RHTid
                            and b.RHTcomportam = 1
                    where a.DEid = ev.DEid
                    and a.DLfvigencia >=(select coalesce(max(a.DLfvigencia),'19000101')
                                        from DLaboralesEmpleado a
                                        inner join RHTipoAccion b
                                        on b.RHTid = a.RHTid
                                        and b.RHTcomportam = 2
                                        where a.DEid = ev.DEid
                                        )
                    )

					and lt.Ecodigo in (
							<cfif not isDefined("form.esCorporativo")>
								#session.Ecodigo#
							<cfelse>	
								#form.jtreeJsonFormat#
							</cfif>
						)			
		and exists ( select 1 
					from EVacacionesEmpleado
					where DEid = lt.DEid
					and coalesce(EVfantigCorp,EVfantig) <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParsedateTime(form.FechaCorte)#" >
				   ) 
		<cfif isdefined("form.CFid") and form.CFid NEQ ''  >
            <cfif form.dependencias NEQ ''>
                and (upper(cf.CFpath) like '#ucase(vRuta)#/%' or cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">)
            <cfelse>
                and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">				
            </cfif>
        </cfif>
        <cfif isDefined('form.DEid') and len(DEid)>
            and lt.DEid = #form.DEid#
        </cfif>
        <cfif vDebugEmpleado>
            and lt.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vDebugEmpleadoLista#" list="true">)
        </cfif>
	</cfoutput>
</cfquery>

 
<cfquery datasource="#session.DSN#" name="xx">
	insert into #EstCesantiaCF# (DEid,CFid, DiasCF, ProviCesantiaCF, ASOxCF, CesaxCFManual, ASOxCFManual,AdelantoCesaCFManual, 
    TotalDiasNomina,TotalProvCesa,PesoxCF,CesaxCFProporcional,TotalProvASO)
    select x.DEid,x.CFid, 0 as DiasCF , sum(ProviCesantiaCF) as ProviCesantiaCF, 0 as ASOxCF, 0 as CesaxCFManual,0 as ASOxCFManual, 0 as AdelantoCesaCFManual,0,0,0,0,0
    from (
        select distinct rc.DEid,rc.CFid,rc.RCNid, coalesce(rc.montores,0) as ProviCesantiaCF
        from CalendarioPagos cp
        inner join RCuentasTipo rc
            on cp.CPid = rc.RCNid
            and rc.referencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCargaCesantia#">
            and rc.tiporeg in (30,31,40,41) 
        inner join  #EstCesantia#  ec
        	on ec.DEid = rc.DEid
        where cp.CPdesde >= ec.Fingreso
        	and cp.CPdesde <= ec.Fhasta
          ) x
    group by x.DEid,x.CFid
</cfquery>

<!--- se agregan los CF's que no estan en el hstoria del empeado (los registrados en historicos) --->
  
<cfquery datasource="#session.DSN#" name="xx">
    insert into #EstCesantiaCF# (DEid,CFid, DiasCF, ProviCesantiaCF, ASOxCF, CesaxCFManual, ASOxCFManual,AdelantoCesaCFManual, 
    TotalDiasNomina,TotalProvCesa,PesoxCF,CesaxCFProporcional,TotalProvASO,TotalReservado) 
    select x.DEid,x.CFid, 0 as DiasCF , 0 as ProviCesantiaCF, 0 as ASOxCF, 0 as CesaxCFManual,0 as ASOxCFManual, 0 as AdelantoCesaCFManual,0,0,0,0,0,0
    from RHInfoExternaCesantia x
    inner join #EstCesantia# y
        on y.DEid = x.DEid
    where x.CFid not in (select CFid from  #EstCesantiaCF# where DEid = x.DEid)
    group by x.DEid,x.CFid
</cfquery>

<cfquery datasource="#session.DSN#" >
    update #EstCesantiaCF# set TotalDiasNomina = coalesce((select sum(hp.PEcantdias) 
                                                    from HPagosEmpleado hp
                                                    inner join CalendarioPagos cp
                                                        on cp.CPid = hp.RCNid
                                                    inner join  (select distinct DEid,Fingreso ,Fhasta from  #EstCesantia# ) ec
                                                        on ec.DEid = hp.DEid
                                                    where hp.DEid = #EstCesantiaCF#.DEid
                                                        and hp.PEtiporeg = 0
                                                        and cp.CPdesde >= ec.Fingreso
                                                        and cp.CPdesde <= ec.Fhasta
                                                    ),0)
                                , TotalProvCesa = coalesce((select sum(hc.CCvalorpat)
                                                    from HSalarioEmpleado hp
                                                    inner join CalendarioPagos cp
                                                        on cp.CPid = hp.RCNid
                                                    inner join  (select distinct DEid,Fingreso ,Fhasta from  #EstCesantia# )  ec
                                                        on ec.DEid = hp.DEid
                                                    left join HCargasCalculo hc
                                                        on hc.RCNid = hp.RCNid
                                                        and hc.DEid = hp.DEid
                                                        and hc.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCargaCesantia#">
                                                    where hp.DEid = #EstCesantiaCF#.DEid
                                                        and cp.CPdesde >= ec.Fingreso
                                                        and cp.CPdesde <= ec.Fhasta
                                                    ),0)
                                                    
                                , TotalProvASO = coalesce((select sum(hc.CCvalorpat)
                                                    from HSalarioEmpleado hp
                                                    inner join CalendarioPagos cp
                                                        on cp.CPid = hp.RCNid
                                                    inner join  (select distinct DEid,Fingreso ,Fhasta from  #EstCesantia# ) ec
                                                        on ec.DEid = hp.DEid
                                                    left join HCargasCalculo hc
                                                        on hc.RCNid = hp.RCNid
                                                        and hc.DEid = hp.DEid
                                                        and hc.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCargaAsociacion#">
                                                    where hp.DEid = #EstCesantiaCF#.DEid
                                                        and cp.CPdesde >= ec.Fingreso
                                                        and cp.CPdesde <= ec.Fhasta
                                                    ),0)    
                                                    
                                  , AdelantoCesaCFManual = coalesce((select sum(ie.RHIECmonto)
                                                                        from RHInfoExternaCesantia ie
                                                                        <!---inner join  #EstCesantia#  ec
                                                                            on ec.DEid = ie.DEid
                                                                            and ec.CFid = ie.CFid--->
                                                                        where ie.DEid = #EstCesantiaCF#.DEid
                                                                        	and ie.CFid = #EstCesantiaCF#.CFid
                                                                            and ie.RHIECtiporeg = 1
                                                                            and coalesce(ie.RHIECestado,0) = 0
                                                                            <!---and ie.RHIECfecha between  ec.Fingreso and ec.Fhasta--->
                                                                ),0)


                                    , CesaxCFManual = coalesce((select sum(ie.RHIECmonto)
                                                                        from RHInfoExternaCesantia ie
                                                                        <!---inner join  #EstCesantia#  ec
                                                                            on ec.DEid = ie.DEid
                                                                            and ec.CFid = ie.CFid--->
                                                                        where ie.DEid = #EstCesantiaCF#.DEid
                                                                        	and ie.CFid = #EstCesantiaCF#.CFid
                                                                            and ie.RHIECtiporeg = 2
                                                                            and ie.DClinea = 12
                                                                            and coalesce(ie.RHIECestado,0) = 0
                                                                            <!---and ie.RHIECfecha between  ec.Fingreso and ec.Fhasta--->
                                                                ),0)
                                                                
                                    , ASOxCFManual  = coalesce((select sum(ie.RHIECmonto)
                                                                        from RHInfoExternaCesantia ie
                                                                        <!---inner join  #EstCesantia#  ec
                                                                            on ec.DEid = ie.DEid
                                                                            and ec.CFid = ie.CFid--->
                                                                        where ie.DEid = #EstCesantiaCF#.DEid
                                                                        	and ie.CFid = #EstCesantiaCF#.CFid
                                                                            and ie.RHIECtiporeg = 2
                                                                            and ie.DClinea = 14
                                                                            and coalesce(ie.RHIECestado,0) = 0
                                                                            <!---and ie.RHIECfecha between  ec.Fingreso and ec.Fhasta--->
                                                                ),0)
                      

</cfquery> 

<!--- 
<cf_dump select="select * from #EstCesantia#" abort=false>

<cf_dump select = "select * from #EstCesantiaCF#">   --->
 
<cfquery name="rsEstimCesantia" datasource="#session.DSN#" >
		select distinct Ecodigo, DEid, FactorDias, Tcodigo, Fingreso, Annos, Meses, Dias, DiasCesantia, SalarioPromedio, MontoCesantia
        from #EstCesantia# 
        order by DEid
</cfquery>

<link href="/cfmx<cfoutput>#session.sitio.css#</cfoutput>" rel="stylesheet" type="text/css">
<cfif Form.chkOpcion eq 1>
 	<script>window.jQuery || document.write('<script src="/cfmx/jquery/librerias/jquery-2.0.2.min.js"><\/script>')</script>
	<style type="text/css">.progress.active .progress-bar{-webkit-animation:progress-bar-stripes 2s linear infinite;animation:progress-bar-stripes 2s linear infinite}.progress-striped .progress-bar{background-image:-webkit-gradient(linear,0 100%,100% 0,color-stop(0.25,rgba(255,255,255,.15)),color-stop(0.25,transparent),color-stop(0.5,transparent),color-stop(0.5,rgba(255,255,255,.15)),color-stop(0.75,rgba(255,255,255,.15)),color-stop(0.75,transparent),to(transparent));background-image:-webkit-linear-gradient(45deg,rgba(255,255,255,.15)25%,transparent 25%,transparent 50%,rgba(255,255,255,.15)50%,rgba(255,255,255,.15)75%,transparent 75%,transparent);background-image:-moz-linear-gradient(45deg,rgba(255,255,255,.15)25%,transparent 25%,transparent 50%,rgba(255,255,255,.15)50%,rgba(255,255,255,.15)75%,transparent 75%,transparent);background-image:linear-gradient(45deg,rgba(255,255,255,.15)25%,transparent 25%,transparent 50%,rgba(255,255,255,.15)50%,rgba(255,255,255,.15)75%,transparent 75%,transparent);background-size:40px 40px}.progress-bar{float:left;width:0;font-size:12px;line-height:20px;color:#fff;text-align:center;background-color:#428bca;-webkit-box-shadow:inset 0 -1px 0 rgba(0,0,0,.15);box-shadow:inset 0 -1px 0 rgba(0,0,0,.15);-webkit-transition:width .6s ease;transition:width .6s ease;height:1em}
	</style>	
</cfif>	

<cfif vDebug>
    <cf_dump select="select * from #EstCesantiaCF#" abort=false>
</cfif>

<cfif CIncidente GT 0 >		
        <!--- 20140626 INICIA EL CICLO POR EMPLEADO --->    

        <cfloop query='rsEstimCesantia'> 
            <cfif Form.chkOpcion eq 1>
                <script type="text/javascript">                 
                    $("#progressBarGestion").css('width','<cfoutput>#int((currentrow/recordcount)*100)#</cfoutput>%'); 
                </script>	
            </cfif>
            
            <cfif isDefined("form.esCorporativo")>
                <!--- 20140626 BUSCA EL CONCEPTO PARAMETRIZADO PARA CESANTIA --->                        
                <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2687" default="0" returnvariable="CIncidente">
                    <cfinvokeargument name="Ecodigo" value="#rsEstimCesantia.Ecodigo#"/>
                </cfinvoke>
            </cfif>
            <cfif CIncidente neq 0>
                <!--- 20140626 BUSCA LA FORMULA ASOCIADA --->                                                
                <cfquery datasource="#session.dsn#" name="rsDatosConcepto">
                        select a.CIsprango, a.CIspcantidad, a.CImescompleto, b.CIcodigo, b.CIdescripcion
                        from CIncidentesD a
                            inner join CIncidentes b
                                on a.CIid=b.CIid
                        where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIncidente#">
                        and b.Ecodigo=#rsEstimCesantia.Ecodigo#
                </cfquery>
			   	<cfif rsDatosConcepto.Recordcount neq 0>
					<!--- 20140626 INVOCA LA CALCULADORA DE NOMINA CON LA FORMULA INDICADA --->                                                                                
                    <cfinvoke component="rh.admin.catalogos.calculadora.variables.var_SalarioPromedio" method="getSalarioPromedio" returnvariable="miSalarioPromedio">
                            <cfinvokeargument name="Ecodigo" 		value="#rsEstimCesantia.Ecodigo#"/>
                            <cfinvokeargument name="calc_promedio" 	value="true"/>
                            <cfinvokeargument name="CIsprango" 		value="#rsDatosConcepto.CIsprango#"/>
                            <cfinvokeargument name="CIspcantidad" 	value="#rsDatosConcepto.CIspcantidad#"/>
                            <cfinvokeargument name="CImescompleto" 	value="#rsDatosConcepto.CImescompleto#"/>
                            <cfinvokeargument name="lvarMasivo" 	value="false"/>
                            <cfinvokeargument name="DEid" 			value="#rsEstimCesantia.DEid#"/>
                            <cfinvokeargument name="lvarCIid" 		value="#CIncidente#"/>							
                            <cfinvokeargument name="Fecha1_Accion" 	value="#vFecha#"/>
                            <cfinvokeargument name="report" 		value="false"/>
                            <cfif vDebug>
                                <cfinvokeargument name="vDebug" value="true"/>    
                            </cfif>
                    </cfinvoke>
                </cfif>
                
            <cfif vDebug>
                miSalarioPromedio:<cfdump var="#miSalarioPromedio#">
            </cfif>
                
            </cfif>
            
            <cfset vFechaIngreso = rsEstimCesantia.FIngreso >

            <cfquery name="rsParametros" datasource="#Session.DSN#">
                select coalesce(<cf_dbfunction name="to_number" args="FactorDiasSalario" dec="4">,30) as Pvalor
                from TiposNomina
                where Ecodigo = #rsEstimCesantia.Ecodigo#
                  and Tcodigo = rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEstimCesantia.Tcodigo#">)
            </cfquery>
            <cfif rsParametros.Recordcount eq 0>
                <cfset FactorDiasSalario =  30>
            <cfelse>
                <cfset FactorDiasSalario =  rsParametros.Pvalor>
            </cfif>
            <!--- 20140626 SI NO HAY CONCEPTO ASOCIADO O FORMULACION EXISTENTE EL PROMEDIO ES 0 --->                                         
            <cfset Observacion="">
            <cfif CIncidente eq 0  >                                
                <cfset vSalarioPromedio = 0 >
                <cfset vSalarioPromedioOrig = 0 >
                <cfset vSalarioPromedio = 0 >
                <cfset Observacion=#LB_NoExisteConceptoCesantiaConfig#>
            <cfelse>
                <cfif rsDatosConcepto.Recordcount eq 0>
                        <cfset vSalarioPromedio = 0 >
                        <cfset vSalarioPromedioOrig = 0 >
                        <cfset vSalarioPromedio = 0 >
                        <cfset Observacion=#LB_NoExisteFormulaConcepto#>                                
                </cfif>
            </cfif>
            <!--- 20140626 ASIGNA EL TIPO DE CAMBIO DEL COMPONENTE SALARIO PROMEDIO EN LA FORMA QUE SE ENVIO--->   
                      
            <cfset vSalarioPromedio = miSalarioPromedio.valor  >
			<cfset vSalarioPromedioOrig = vSalarioPromedio >
            
            <!--- <cfif rsDatosConcepto.CIsprango NEQ 3>
                <cfset vSalarioPromedio = vSalarioPromedio / FactorDiasSalario >
            </cfif> --->
            

            <!--- 20140626 FECHA CAMBIO DE LEY DEL TRABAJADOR--->                                                                                 
            <cfset vFechaCorte = createdate(2001, 03, 01) > <!--- '20010301' --->
            <cfif vFecha gte vFechaIngreso >  			
                <cfset vAnosTotal =  datediff('yyyy', vFechaIngreso, vFecha) >
            <cfelse>  
                <cfset vAnosTotal = 0 >
            </cfif>
            <!--- 20140626  TOPE DE CESANTIA 8 AÑOS EN MESES---> 
            <cfset vRango =  8 * 12 > 

            <!--- Tiempo Laborado --->
            <cfset vTiempoAnos = abs(datediff('yyyy', vFechaIngreso, vFecha)) >
            <cfset vTiempoMeses = datediff('m', vFechaIngreso, vFecha ) - (vTiempoAnos * 12) >
            <cfset vTiempoDias = datediff('d', vFechaIngreso, dateadd('m', -vTiempoMeses, dateadd('yyyy', -vTiempoAnos, vFecha)))+1 >

            <cfset vTotalMeses = datediff('m', vFechaIngreso, vFecha) >

            <!---  Se modifica la fecha de ingreso para calcular sobre el rango permitido (8 años) --->
            <cfif vTotalMeses gt vRango >  			
                <cfset vFechaIngreso = dateadd('d',vFecha,-((vRango/12)*365)) >
                <cfset vTiempoCesantia = int(vRango/12)>
            <cfelse>
                <cfset vTiempoCesantia = int(abs(vTotalMeses/12))>
            </cfif>

            <!---  Años, Meses Antes de la Ley --->
            <cfif vFechaCorte gte vFechaIngreso >  			
                <cfset vAnosAntes = abs(datediff('yyyy', vFechaCorte, vFechaIngreso)) >
                <cfset vMesesAntes = round(abs(datediff('d', vFechaCorte, vFechaIngreso)) / 30.5) - (vAnosAntes * 12) >
            <cfelse>
                <cfset vAnosAntes = 0 >
                <cfset vMesesAntes = 0 >
            </cfif>

            <!---  Total Meses Después de la Ley --->
            <cfif vFechaIngreso lte vFechaCorte >  			
                <cfset vTotalMesesDespues = abs(datediff('m', vFechaCorte, vFecha)) >
            <cfelse>
                <cfset vTotalMesesDespues = abs(datediff('m', vFechaIngreso , vFecha)) >
            </cfif>

            <!--- Periodo de Transición --->
            <cfif ( vMesesAntes + vTotalMesesDespues ) gte 12 >
                <cfset mdproctran = 12 >
            <cfelse>
                <cfset mdproctran = ( vMesesAntes + vTotalMesesDespues ) >
            </cfif>

            <!--- Meses Después (sin transición) --->
            <cfif mdproctran gte vTotalMesesDespues >
                <cfset vMesesDespues = 0 >
            <cfelse>
                <cfset vMesesDespues = mdproctran - vMesesAntes >
            </cfif>

            <!--- Años Después --->
            <cfif vMesesAntes eq 0 >
                <cfset vAnosDespues = vTotalMesesDespues / 12 >
            <cfelse>
                <cfif ( vTotalMesesDespues - vMesesDespues) gte 12  >
                    <cfset vAnosDespues =  (vTotalMesesDespues - vMesesDespues) / 12 >
                <cfelse>
                    <cfset vAnosDespues =  0 >
                </cfif>	
            </cfif>

            <cfset vEnteroDespues = fix(vAnosDespues) >
            <cfset vResiduoDespues = vAnosDespues - vEnteroDespues >
                
            <!---  Años Después --->
            <cfif vResiduoDespues gte 0.50 >
                <cfset vAnosDespues = vEnteroDespues + 1 >
            <cfelse>
                <cfset vAnosDespues = vEnteroDespues >
            </cfif>

            <!--- Aplica --->							
            <cfset vAplica = 0 >
                            
            <cfif vTotalMeses gte 3 >
                    <cfif vTotalMeses lt 6 >
                        <cfset vAplica = 7 >
                    </cfif>
            </cfif>

            <cfif vTotalMeses gte 96 >
                <cfset vFechaIngreso = vFecha - (8 * 365) >
            </cfif>					
        
            <cfif vTotalMeses gte 6 and vTotalMeses lt 12 >
                <cfset vAplica = 14 >
            </cfif>
    
            <cfif vTotalMeses gte 12 and vTotalMeses lt 24 >
                <cfset vAplica = 19.5 >
            </cfif>

            <cfif vTotalMeses gte 24 and vTotalMeses lt 36 >
                <cfset vAplica = 20 >
            </cfif>		

            <cfif vTotalMeses gte 36 and vTotalMeses lt 48 >
                <cfset vAplica = 20.5 >
            </cfif>			
    
            <cfif vTotalMeses gte 48 and vTotalMeses lt 60 >
                <cfset vAplica = 21 >
            </cfif>			

            <cfif vTotalMeses gte 60 and vTotalMeses lt 72 >
                <cfset vAplica = 21.24 >
            </cfif>			
    
            <cfif vTotalMeses gte 72 and vTotalMeses lt 84 >
                <cfset vAplica = 21.5 >
            </cfif>						
            
            <cfif vTotalMeses gte 84 and vTotalMeses lt 96 >
                <cfset vAplica = 22 >
            </cfif>	

            <cfif vTotalMeses gte 96 and vTotalMeses lt 108 >
                <cfset vAplica = 22 >
            </cfif>						

            <cfif vTotalMeses gte 108 and vTotalMeses lt 120 >
                <cfset vAplica = 22 >
            </cfif>						

            <cfif vTotalMeses gte 120 and vTotalMeses lt 132 >
                <cfset vAplica = 21.5 >
            </cfif>						

            <cfif vTotalMeses gte 132 and vTotalMeses lt 144 >
                <cfset vAplica = 21 >
            </cfif>						
            
            <cfif vTotalMeses gte 144 and vTotalMeses lt 156 >
                <cfset vAplica = 20.5 >
            </cfif>						
            
            <cfif vTotalMeses gte 156 >
                <cfset vAplica = 20 >
            </cfif>

            <!--- Fin del Aplica --->	

            <cfset vDiasAntes = vAnosAntes * 30 >
            
            <cfif vAnosTotal gte 1 >
                <cfset vFactorDiasAntes = 30 >
            <cfelse>	
                <cfset vFactorDiasAntes = 20 >
            </cfif>

            <!--- Días antes de la transicion --->
            <cfif mdproctran EQ 0> <cfset mdproctran = 1> </cfif>
            <cfset vDiasAntesTran = ( vMesesAntes / mdproctran ) * vFactorDiasAntes >

            <!--- Días despues de la transicion --->
            <cfif vMesesAntes eq 0>
                <cfset vDiasDespuesTran = 0 >
            <cfelse>	
                <cfset vDiasDespuesTran = (vMesesDespues / mdproctran) * vAplica > 
            </cfif>

            <!--- Fin de TRANSICION --->
            <cfif vAnosDespues lt 0 >
                <cfset vDiasDespues = 0 >
            <cfelse>	
                <cfif vAnosDespues eq 0>
                    <cfset vDiasDespues = vAplica >
                <cfelse>	
                    <cfset vDiasDespues = vAnosDespues * vAplica > 
                </cfif>
            </cfif>

            <cfset vDiasCesantia = vDiasAntes + vDiasDespues + vDiasAntesTran + vDiasDespuesTran >
            <cfset vMontoColones = vSalarioPromedio * vDiasCesantia >

            <cfquery  datasource="#Session.DSN#">
                Update #EstCesantia# set 
                      Annos = #vTiempoAnos#
                    , Meses = #vTiempoMeses#
                    , Dias 	= #vTiempoDias#
                    , DiasCesantia 		= #vDiasCesantia#
                    , SalarioPromedio 	= #vSalarioPromedio#
                    , MontoCesantia		= #vMontoColones#
                where #EstCesantia#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstimCesantia.DEid#">
			</cfquery>
        </cfloop>
</cfif>

<cfif vDebug>
   <cf_dump select="select * from #EstCesantia#" abort=false> 
</cfif>
 
<!--- se actualiza monto total de los reservado suma de los manual mas lo aprovisionado--->
<cfquery  datasource="#Session.DSN#">
    update #EstCesantiaCF# set TotalReservado = (select sum(a.ProviCesantiaCF + a.CesaxCFManual) 
                                                from #EstCesantiaCF# a 
                                                where a.DEid = #EstCesantiaCF#.DEid)
</cfquery> 

<!--- <cf_dump select="select * from #EstCesantiaCF#" abort=true> --->

<cfquery datasource="#session.DSN#" >
    update #EstCesantiaCF# set DiasCF = (( (ProviCesantiaCF+CesaxCFManual) * TotalDiasNomina) / TotalReservado)
	where #EstCesantiaCF#.TotalReservado > 0
</cfquery>

<cfquery datasource="#session.DSN#" >
    update #EstCesantiaCF# set PesoxCF =  (((((ProviCesantiaCF+CesaxCFManual) * TotalDiasNomina) / TotalReservado) * 100 ) / TotalDiasNomina)
    where #EstCesantiaCF#.TotalReservado > 0 
        and #EstCesantiaCF#.TotalDiasNomina > 0
</cfquery>

<cfquery datasource="#session.DSN#" >
    update #EstCesantiaCF# set PesoxCF =  (((((ProviCesantiaCF+CesaxCFManual) * 1) / TotalReservado) * 100 ) / 1)
    where #EstCesantiaCF#.TotalReservado > 0 
        and #EstCesantiaCF#.TotalDiasNomina = 0
</cfquery>


<cfif vDebug>
    <cf_dump select="select * from #EstCesantiaCF#" abort=false>
</cfif>


<cfquery datasource="#session.DSN#" name="rs">
    insert into #EstCesantia# (Ecodigo, DEid,CFid,  Fingreso, Tcodigo, Annos, Meses, Dias, DiasCesantia, SalarioPromedio, MontoCesantia,Fhasta,FactorDias)
    select distinct y.Ecodigo, x.DEid, x.CFid, y.Fingreso, y.Tcodigo, y.Annos, y.Meses, y.Dias, y.DiasCesantia,y.SalarioPromedio, y.MontoCesantia, y.Fhasta, y.FactorDias
    from RHInfoExternaCesantia x
    inner join #EstCesantia# y
        on y.DEid = x.DEid
    where x.CFid not in (select CFid from  #EstCesantia# where DEid = x.DEid)
</cfquery>





<cfquery datasource="#session.DSN#" >
    update #EstCesantiaCF# set AnnosLaborados		= (select max(a.Annos) from #EstCesantia# a where a.DEid = #EstCesantiaCF#.DEid )
                            , MesesLaborados		= (select max(a.Meses) from #EstCesantia# a where a.DEid = #EstCesantiaCF#.DEid )
                            , DiasLaborados			= (select max(a.Dias) from #EstCesantia# a where a.DEid = #EstCesantiaCF#.DEid  )
                            , DiasPagoCesantia		= (select max(a.DiasCesantia) from #EstCesantia# a where a.DEid = #EstCesantiaCF#.DEid )
                            , SalarioPromedio		= (select max(a.SalarioPromedio) from #EstCesantia# a where a.DEid = #EstCesantiaCF#.DEid )
                            , MontoCesantiaPagar	= (select max(a.MontoCesantia) from #EstCesantia# a where a.DEid = #EstCesantiaCF#.DEid )
                            , Fingreso				= (select max(a.Fingreso) from #EstCesantia# a where a.DEid = #EstCesantiaCF#.DEid )
                            , CesaxCFProporcional	= ((((select max(coalesce(a.MontoCesantia,0)) 
                                                        from #EstCesantia# a 
                                                        where a.DEid = #EstCesantiaCF#.DEid 
                                                         )) * PesoxCF) / 100)
                            , ASOCFProp				= coalesce(((TotalProvASO * PesoxCF) / 100),0)
</cfquery>

<cfif vDebug>
    <cf_dump select="select * from #EstCesantiaCF#" abort=false>
</cfif>


<!--- <cf_dump select="select * from #EstCesantiaCF#" abort=false>
<cf_dump select="select * from #EstCesantia#"> --->



<cfquery name="rsEstimCesantia" datasource="#Session.DSN#">
    update #EstCesantiaCF# set 
        ProviCesantia 		= coalesce(ProviCesantiaCF,0) + coalesce(CesaxCFManual,0)
        ,TrasladoASEFUNDA 	= coalesce(ASOCFProp,0) + coalesce(ASOxCFManual,0)
        ,CesaPosTraslado 	= (coalesce(ProviCesantiaCF,0) + coalesce(CesaxCFManual,0)) - (coalesce(ASOCFProp,0) + coalesce(ASOxCFManual,0))- coalesce(AdelantoCesaCFManual,0)
        ,CesaNetaXPagar     = (coalesce(CesaxCFProporcional,0) - (coalesce(ASOCFProp,0) + coalesce(ASOxCFManual,0)) - coalesce(AdelantoCesaCFManual,0))
</cfquery> 

<cfquery name="rsEstimCesantia" datasource="#Session.DSN#">
    update #EstCesantiaCF# set 
        Resultado =  coalesce(CesaPosTraslado,0) - coalesce(CesaNetaXPagar,0)
        , FGenerada = <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParsedateTime(form.FechaCorte)#" >
        , CFpath = (select a.CFpath from CFuncional a where a.CFid = #EstCesantiaCF#.CFid )
</cfquery> 

<!--- <cfquery name="rsEstimCesantia" datasource="#Session.DSN#">
    update #EstCesantiaCF# set 
        ProviCesantia       = coalesce(ProviCesantiaCF,0) + coalesce(CesaxCFManual,0)
        ,TrasladoASEFUNDA   = coalesce(ASOCFProp,0) + coalesce(ASOxCFManual,0)
        ,CesaPosTraslado    = (coalesce(ProviCesantiaCF,0) + coalesce(CesaxCFManual,0)) - (coalesce(ASOCFProp,0) + coalesce(ASOxCFManual,0))- coalesce(AdelantoCesaCFManual,0)
        ,CesaNetaXPagar     = (coalesce(CesaxCFProporcional,0) - (coalesce(ASOCFProp,0) + coalesce(ASOxCFManual,0)) - coalesce(AdelantoCesaCFManual,0))
        ,Resultado          = ((coalesce(ProviCesantiaCF,0) + coalesce(CesaxCFManual,0)) - (coalesce(ASOCFProp,0) + coalesce(ASOxCFManual,0))- coalesce(AdelantoCesaCFManual,0)) - ((coalesce(CesaxCFProporcional,0) - (coalesce(ASOCFProp,0) + coalesce(ASOxCFManual,0)) - coalesce(AdelantoCesaCFManual,0)))
</cfquery>  --->
<cfif vDebug>
    <cf_dump select="select * from #EstCesantiaCF#" abort=false>
</cfif>

<cfquery datasource="#Session.DSN#">
    delete from RHEstCesantiaCF
</cfquery> 

<cfquery  datasource="#Session.DSN#">
    insert into RHEstCesantiaCF 
        (DEid
        ,CFid
        ,TotalDiasNomina
        ,TotalProvCesa
        ,DiasCF
        ,ProviCesantiaCF
        ,CesaCFProp
        ,PesoxCF
        ,ASOxCF
        ,CesaxCFManual
        ,ASOxCFManual
        ,AdelantoCesaCFManual
        ,Fingreso
        ,AnnosLaborados
        ,MesesLaborados
        ,DiasLaborados
        ,DiasPagoCesantia
        ,SalarioPromedio
        ,MontoCesantiaPagar
        ,CesaxCFProporcional
        ,TotalProvASO
        ,ASOCFProp
        ,ProviCesantia
        ,TrasladoASEFUNDA
        ,CesaPosTraslado
        ,CesaNetaXPagar
        ,Resultado
        ,TotalReservado
        ,FGenerada
        ,CFpath
        )
    select 
        DEid
        ,CFid
        ,TotalDiasNomina
        ,TotalProvCesa
        ,DiasCF
        ,ProviCesantiaCF
        ,CesaCFProp
        ,PesoxCF
        ,ASOxCF
        ,CesaxCFManual
        ,ASOxCFManual
        ,AdelantoCesaCFManual
        ,Fingreso
        ,AnnosLaborados
        ,MesesLaborados
        ,DiasLaborados
        ,DiasPagoCesantia
        ,SalarioPromedio
        ,MontoCesantiaPagar
        ,CesaxCFProporcional
        ,TotalProvASO
        ,ASOCFProp
        ,ProviCesantia
        ,TrasladoASEFUNDA
        ,CesaPosTraslado
        ,CesaNetaXPagar
        ,Resultado
        ,TotalReservado
        ,FGenerada
        ,CFpath
    from #EstCesantiaCF#
    order by CFid,DEid
</cfquery> 

<cfquery name="rsEstimCesantia" datasource="#Session.DSN#">
	select count(1)  as Existen
    from RHEstCesantiaCF b
</cfquery>
 


<!--- <cfquery name="rsEstimCesantia" datasource="#Session.DSN#">
    select 1  as Existen
    from dual b
</cfquery>
 --->
<form action="GenerarEstimacionCesantiaFundatec.cfm" name="form2" id="form2"  method="post">
    <cfif rsEstimCesantia.Existen GT 0>
        <input type="hidden" name="VerMensaje" value="1">
    <cfelse>
        <input type="hidden" name="VerMensaje" value="0">
    </cfif>
</form>

<script type="text/javascript">
    document.form2.submit();
</script>