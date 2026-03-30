
<cf_templatecss>
<cfsetting requesttimeout="3600"> 

<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LvarBack = "ReporteEstimacionCesantia.cfm">
<cfset LB_ReporteEstimacionCesantia = t.translate('LB_ReporteEstimacionCesantia','Reporte de Estimación de Cesantía')>
<cfset LB_CentroFuncional = t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_FechaIngreso = t.translate('LB_FechaIngreso','Fecha de Ingreso','/rh/generales.xml')>
<cfset LB_Antiguedad = t.translate('LB_Antiguedad','Antiguedad','/rh/generales.xml')>
<cfset LB_Meses = t.translate('LB_Meses','Meses','/rh/generales.xml')>
<cfset LB_Dias = t.translate('LB_Dias','Días','/rh/generales.xml')>
<cfset LB_DiasCesantia = t.translate('LB_DiasCesantia','Días Cesantía','/rh/generales.xml')>
<cfset LB_Salario = t.translate('LB_Salario','Salario','/rh/generales.xml')>
<cfset LB_MontoColones = t.translate('LB_MontoColones','Monto Colones','/rh/generales.xml')>
<cfset LB_MontoDolares = t.translate('LB_MontoDolares','Monto Dolares','/rh/generales.xml')>
<cfset LB_AnosLaborados = t.translate('LB_AnosLaborados','Años','/rh/generales.xml')>
<cfset LB_Observaciones = t.translate('LB_Obervaciones','Observaciones','/rh/generales.xml')>
<cfset LB_FinDelReporte = t.translate('LB_FinDelReporte','Fin del Reporte','/rh/generales.xml')>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>
<cfset LB_NoExisteConceptoCesantiaConfig = t.Translate('LB_NoExisteConceptoCesantiaConfig','No existe Concepto Cesantía','/rh/generales.xml')>
<cfset LB_NoExisteFormulaConcepto = t.Translate('LB_NoExisteFormulaConcepto','No existe Formula de Cesantía','/rh/generales.xml')>
<cfset MSG_Validacion = t.Translate('MSG_Validacion','El concepto de cesantia no ha sido configurado en alguna de las Empresas que se esta consultando, Ir a Parámetros Generales a Configuralo en cada Empresa que se desee consultar','/rh/generales.xml')>
<cfset LB_TipoCambio = t.Translate('LB_TipoCambio','Tipo de Cambio','/rh/generales.xml')>

<cfset archivo = "ReporteEstimacionCesantia.xls" />

<cfif isDefined("form.FechaCorte") and LEN(TRIM(form.FechaCorte))>
	<cfset vFecha = LSParseDateTime(form.FechaCorte) >
</cfif>	

<cfif isdefined("form.CFid") and len(trim(form.CFid)) eq 0>
	<cfset form.CFid = 0 >
</cfif>

<cfif not isdefined('form.dependencias')>
	<cfset form.dependencias = ''>
</cfif>	

<cfif isdefined('url.CFid') and not isdefined('form.CFid')>
	<cfset form.CFid = url.CFid>
</cfif>	

<cfparam name="form.jtreeListaItem" default="#session.Ecodigo#">

<cfif isdefined("form.LISTCF") and len(trim(form.LISTCF))>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select distinct CFpath
		from CFuncional
		where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.jtreeListaItem#" list="yes">)
		  and CFcodigo in  (<cfqueryparam cfsqltype="cf_sql_char" value="#form.LISTCF#" list="yes">)
	</cfquery>
	<cfset vRuta = rsCFuncional.CFpath >
    <cfquery name="rsCFuncional" datasource="#session.DSN#">
		select distinct CFdescripcion
		from CFuncional
		where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.jtreeListaItem#" list="yes">)
		  and CFcodigo in  (<cfqueryparam cfsqltype="cf_sql_char" value="#form.LISTCF#" list="yes">)
	</cfquery>
    <cfset vCentros = valueList(rsCFuncional.CFdescripcion,', ')>
</cfif>	

<cfif isDefined("form.jtreeListaItem")>
    <cf_translatedata name="get" tabla="Empresas" col="Edescripcion" returnvariable="LvarEdescripcion">
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
	    select #LvarEdescripcion# as Edescripcion 
	    from Empresas 
	    where Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">)
	</cfquery>

	<cfset rsCont = rsEmpresa.recordcount >
	<cfset vCont = 0 >
    <cfif rsCont gt 0> <cfset lvEmpresasSelect = ''></cfif>	
	<cfloop query="rsEmpresa">
		<cfset lvEmpresasSelect &= '#Edescripcion#' >
		<cfset vCont += 1 >
		<cfif vCont lt rsCont>
			<cfset lvEmpresasSelect &= ', ' >
		</cfif>
	</cfloop>
</cfif> 
<!--- Se colocan los tipos de cambio de las tablas vigentes actualmente--->
<cfquery name="rsTipoCambio" datasource="#session.DSN#">
    Select distinct rhtv.RHVTtipocambio as TipoCambio
    from  RHVigenciasTabla rhtv
    where rhtv.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.jtreeListaItem#" list="true">)
    and rhtv.RHVTestado = 'A'
    <cfif isdefined("vFecha") and len(trim(vFecha))>
    	and #vFecha# between rhtv.RHVTfecharige and rhtv.RHVTfechahasta
   </cfif>
   and rhtv.RHVTtipocambio <> 1
</cfquery>

<cfset vs_orden = ''>
<cfif isdefined("form.ordenamiento") and form.ordenamiento EQ 1>
	<cfset vs_orden = 'order by cf.CFcodigo, de.DEnombre, de.DEapellido1'>
<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 2>		
	<cfset vs_orden = 'order by cf.CFcodigo, de.DEapellido1, de.DEnombre'>
<cfelseif isdefined("form.ordenamiento") and form.ordenamiento EQ 3>
	<cfset vs_orden = 'order by de.DEidentificacion'>
<cfelse>
	<cfset vs_orden = 'order by cf.CFcodigo, de.DEnombre, de.DEapellido1'>
</cfif>

<cfset filtro2 = ''>
<cfif not isDefined("form.esCorporativo") and isdefined("form.CFdescripcion") and len(trim(form.CFdescripcion))>
	<cfset filtro2 = '<strong>#LB_CentroFuncional#: #form.CFdescripcion#</strong>'>
<cfelse>
	<cfif isdefined("form.LISTCF") and len(trim(form.LISTCF))>
    	<cfset filtro2 = vCentros>		
    </cfif>
</cfif>

<cfset filtro3 = ''>
<cfif isdefined("form.FechaCorte") and len(trim(form.FechaCorte))>
	<cfset filtro3 =  'Fecha de Corte: '&LSDateFormat(form.FechaCorte,'dd/mm/yyyy')>
</cfif>
<cfset filtro4 = ''>
<cfif isdefined("rsTipoCambio.TipoCambio") and len(trim(rsTipoCambio.TipoCambio))>
	<cfset filtro4 =  '#LB_TipoCambio#: '& rsTipoCambio.TipoCambio>
</cfif>

<cfset LvarHTTP = 'http://'>
<cfif isdefined("session.sitio.ssl_todo") and session.sitio.ssl_todo> <cfset LvarHTTP = 'https://'> </cfif>
<link href="<cfoutput>#LvarHTTP##cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">

<!---<cfparam name="Form.chkOpcion" default="1">
<cfif Form.chkOpcion eq 0>--->
<!---<cfif isdefined("Form.BTNExportar")>
	<cfcontent type="application/vnd.ms-excel; charset=windows-1252">
	<cfheader name="Content-Disposition" value="attachment; filename=#archivo#">
</cfif>--->


<!---<cfif Form.chkOpcion eq 1>
 	<script>window.jQuery || document.write('<script src="/cfmx/jquery/librerias/jquery-2.0.2.min.js"><\/script>')</script>
	<style type="text/css">.progress.active .progress-bar{-webkit-animation:progress-bar-stripes 2s linear infinite;animation:progress-bar-stripes 2s linear infinite}.progress-striped .progress-bar{background-image:-webkit-gradient(linear,0 100%,100% 0,color-stop(0.25,rgba(255,255,255,.15)),color-stop(0.25,transparent),color-stop(0.5,transparent),color-stop(0.5,rgba(255,255,255,.15)),color-stop(0.75,rgba(255,255,255,.15)),color-stop(0.75,transparent),to(transparent));background-image:-webkit-linear-gradient(45deg,rgba(255,255,255,.15)25%,transparent 25%,transparent 50%,rgba(255,255,255,.15)50%,rgba(255,255,255,.15)75%,transparent 75%,transparent);background-image:-moz-linear-gradient(45deg,rgba(255,255,255,.15)25%,transparent 25%,transparent 50%,rgba(255,255,255,.15)50%,rgba(255,255,255,.15)75%,transparent 75%,transparent);background-image:linear-gradient(45deg,rgba(255,255,255,.15)25%,transparent 25%,transparent 50%,rgba(255,255,255,.15)50%,rgba(255,255,255,.15)75%,transparent 75%,transparent);background-size:40px 40px}.progress-bar{float:left;width:0;font-size:12px;line-height:20px;color:#fff;text-align:center;background-color:#428bca;-webkit-box-shadow:inset 0 -1px 0 rgba(0,0,0,.15);box-shadow:inset 0 -1px 0 rgba(0,0,0,.15);-webkit-transition:width .6s ease;transition:width .6s ease;height:1em}
	</style>	
</cfif>	
--->
<!--- 
<cfif isdefined("Form.Exportar")>
	 <cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#" title="#LB_ReporteEstimacionCesantia#">
</cfif> --->
<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#" title="#LB_ReporteEstimacionCesantia#">
<!---<cfif not isdefined("Form.Exportar")>--->
	<cfflush interval="1"> 
<!---</cfif>	--->
<!--- <cf_HeadReport --->
<cf_EncReporte
    Titulo1='#LB_ReporteEstimacionCesantia#'
    filtro1='#lvEmpresasSelect#'
    filtro2='#filtro2#'
    filtro3='#filtro3#'
    filtro4='#filtro4#'
    showEmpresa = 'false' 
    cols = 12>
    

<cfquery name="rsEstimCesantia" datasource="#session.DSN#">
		select cf.CFcodigo, cf.CFdescripcion, de.DEid, de.DEnombre, de.DEapellido1, de.DEapellido2, de.DEidentificacion, lt.LTdesde, 0 as cesantia, lt.Tcodigo, tn.FactorDiasSalario, lt.Ecodigo, (select coalesce(x.EVfantig,x.EVfantigCorp) as FechaIngreso from EVacacionesEmpleado x where x.DEid = de.DEid) as FechaIngreso, 
        (select x.Pvalor from RHParametros x where x.Pcodigo=2687 and x.Ecodigo=lt.Ecodigo) as CIncidente
        , lt.RHJid,lt.LTid
		from LineaTiempo lt 
			inner join DatosEmpleado de
				on lt.DEid = de.DEid
			inner join RHPlazas rhp 
				on rhp.RHPid = lt.RHPid
			inner join CFuncional cf
					on rhp.CFid = cf.CFid
	    	inner join TiposNomina tn
	    		on lt.Ecodigo = tn.Ecodigo
	    		and lt.Tcodigo = tn.Tcodigo
		where <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParsedateTime(form.FechaCorte)#"> between lt.LTdesde and lt.LThasta
		and lt.Ecodigo in (
							<cfif not isDefined("form.esCorporativo")>
								#session.Ecodigo#
							<cfelse>	
								#form.JTREELISTAITEM#
							</cfif>
						)			
		and exists ( select 1 
					from EVacacionesEmpleado
					where DEid = lt.DEid
					and coalesce(EVfantigCorp,EVfantig) <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParsedateTime(form.FechaCorte)#" >
					<!---and DEid in (577,550,569)--->

                    <!--- 20160726. Se comenta esta condición, porque el Where origen ya valida que sean empleados Activos --->
                    <!---and coalesce(EVfliquidacion,lt.LThasta) >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParsedateTime(form.FechaCorte)#">--->
				   ) 
		<cfif isdefined("form.LISTCF") and len(trim(form.LISTCF))>
            <cfif isdefined("form.dependencias")>
                and (upper(cf.CFpath) like '#ucase(vRuta)#/%' or cf.CFcodigo in  (<cfqueryparam cfsqltype="cf_sql_char" value="#form.LISTCF#" list="yes">))
            <cfelse>
                and cf.CFcodigo in  (<cfqueryparam cfsqltype="cf_sql_char" value="#form.LISTCF#" list="yes">)			
            </cfif>
        </cfif>
		#vs_orden#
</cfquery>

<!---<cfdump var="#form#">
<cfdump var="#rsEstimCesantia#">--->
<cfif rsEstimCesantia.recordcount>	 
		<table class="reporte" width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<cfoutput>	
				<thead>	
					<tr>
			            <th><strong>#LB_Identificacion#</strong></th>
			            <th><strong>#LB_Nombre#</strong></th>
			            <th><strong>#LB_FechaIngreso#</strong></th>
			            <th><strong>#LB_AnosLaborados#</strong></th> 
			            <th><strong>#LB_Meses#</strong></th> 
						<th><strong>#LB_Dias#</strong></th>
						<th><strong>#LB_DiasCesantia#</strong></th>
			            <th><strong>#LB_Salario#</strong></th> 
			            <th><strong>#LB_MontoColones#</strong></th> 
			            <th><strong>#LB_MontoDolares#</strong></th> 
			            <th><strong>#LB_AnosLaborados#</strong></th> 
			            <th><strong>#LB_Observaciones#</strong></th>                         
					</tr>
				</thead>		
				<tbody>
			</cfoutput>		
			    
			<!--- 20140626 INICIA EL CICLO POR EMPLEADO --->   

					<cfloop query='rsEstimCesantia'> 
						
						<!--- 20140626 BUSCA EL CONCEPTO PARAMETRIZADO PARA CESANTIA --->                        
	                    <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2687" default="0" returnvariable="CIncidente">
							<cfinvokeargument name="Ecodigo" value="#rsEstimCesantia.Ecodigo#"/>
                        </cfinvoke>

                        <cfif not isdefined("CIncidente") or not len(trim(CIncidente))>
                        	<cfquery datasource="#session.dsn#" name="rsEmp">
                            	select Edescripcion from Empresas where Ecodigo=#rsEstimCesantia.Ecodigo#
                            </cfquery>
							<cfoutput><font color="##FF0000">#MSG_Validacion#: "#rsEmp.Edescripcion#"</font></cfoutput>
                        	<cfabort>
                        </cfif>
                        <cfif CIncidente neq 0 and len(trim(CIncidente))>
							<!--- 20140626 BUSCA LA FORMULA ASOCIADA --->                                                
                            <cfquery datasource="#session.dsn#" name="rsDatosConcepto">
                                    select b.CIid, b.CIdescripcion, coalesce(a.CIcantidad,12) as CIcantidad, a.CIrango, a.CItipo, a.CIdia, a.CImes, a.CIcalculo, a.CIsprango , coalesce(a.CIspcantidad,0) as CIspcantidad, a.CImescompleto, a.CImultiempresa 
                                    <!--- a.CIsprango, a.CIspcantidad, a.CImescompleto, b.CIcodigo, b.CIdescripcion --->
                                    from CIncidentesD a
                                        inner join CIncidentes b
                                            on a.CIid=b.CIid
                                    where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIncidente#">
                                    <cfif isdefined("form.jtreeListaItem") and len(trim(form.jtreeListaItem))>
                                    	and b.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.jtreeListaItem#" list="yes">)
                                    </cfif>
                            </cfquery>

	                        <cfif rsDatosConcepto.Recordcount neq 0>
                                    <cftry>
										<!--- 20160804 - ljimenez se ejecuta el concepto  de calculo de cesantia invocando a la calculadora--->
										<cfset FVigencia = LSDateFormat(vFecha, 'DD/MM/YYYY')>
										<cfset FFin = LSDateFormat(vFecha, 'DD/MM/YYYY')>

										<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>

										<cfset current_formulas = rsDatosConcepto.CIcalculo>
										<cfset presets_text = RH_Calculadora.get_presets(
																		fecha1_accion=CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
																	   fecha2_accion=CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
																	   CIcantidad=rsDatosConcepto.CIcantidad,
																	   CIrango=rsDatosConcepto.CIrango,
																	   CItipo=rsDatosConcepto.CItipo,
																	   DEid=rsEstimCesantia.DEid,
																	   RHJid=rsEstimCesantia.RHJid,
																	   Ecodigo=rsEstimCesantia.Ecodigo,
																	   RHTid=0,
																	   RHAlinea=rsEstimCesantia.LTid,
																	   CIdia=rsDatosConcepto.CIdia,
																	   CImes=rsDatosConcepto.CImes,
																	   Tcodigo="", <!--- Tcodigo solo se requiere si no va RHAlinea--->
																	   calc_promedio=FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
																	   masivo='false',
																	   tabla_temporal='',
																	   calc_diasnomina=FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
																	   , cantidad = 0
																	   , origen = '' 
																	   ,CIsprango=rsDatosConcepto.CIsprango
																	   ,CIspcantidad=rsDatosConcepto.CIspcantidad
																	   ,CImescompleto=rsDatosConcepto.CImescompleto
																	   ,MontoIncidencia=javaCast("null", "")
																	   ,FijarVariable=javaCast("null", "")
																	   ,Conexion=javaCast("null", "")
																	   ,CIid=rsDatosConcepto.CIid
																	   ,TablaComponentes="DLineaTiempo"
																	   ,CampoMontoTC="DLTmonto"
																	   ,CampoLlaveTC="LTid"
																	   ,ValorLlaveTC=rsEstimCesantia.LTid
																	   ,CImultiempresa=rsDatosConcepto.CImultiempresa
																	   )>
										<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
										<cfset calc_error = RH_Calculadora.getCalc_error()>
										<cfif Not IsDefined("values")>
											<cfif isdefined("presets_text")>
												<cf_errorCode	code="52014" msg="@errorDat_1@ & '----' & @errorDat_2@ & '-----' & @errorDat_3@"
																errorDat_1="#presets_text#"
																errorDat_2="#current_formulas#"
																errorDat_3="#calc_error#"
												>
											<cfelse>
												<cf_throw message="#calc_error#" >
											</cfif>
										</cfif>

											<cfset vDiasCesantia = values.get('cantidad').toString() >
											<cfset miSalarioPromedio.valor = values.get('importe').toString() > <!--- devuelve el salario promedio desde la formula del concepto de pago --->
										<cfcatch>
	                                            <cfset miSalarioPromedio.valor = 0>
	                                            <cfset vDiasCesantia = 0 >
	                                    </cfcatch>
                                	</cftry>

										<!--- <br>Importe><cfdump var="#values.get('importe').toString()#"></br>
										<br>Cantidad><cfdump var="#values.get('cantidad').toString()#"></br>
										<br>Resultado<cfdump var="#values.get('resultado').toString()#"></br>
										<br>Cantidad<cf_dump var="#presets_text#"></br>
										<cfabort>
										 --->
								</cfif>
						</cfif>
						<!--- 20140626 BUSCA EL TIPO DE CAMBIO DE LA TABLA SALARIAL VIGENTE --->  
                        <cfquery name="rsTipoCambioEmpleado" datasource="#session.DSN#">
                            Select coalesce(rhtv.RHVTtipocambio,1) as TipoCambio
                            from LineaTiempo lt
                                inner join RHCategoriasPuesto rhcp
                                    on lt.RHCPlinea = rhcp.RHCPlinea
                                    inner join RHCategoria rhc
                                        on rhcp.RHCid = rhc.RHCid
                                        inner join RHMontosCategoria rhmc        
                                            on rhc.RHCid = rhmc.RHCid
                                            inner join RHVigenciasTabla rhtv
                                                on rhmc.RHVTid = rhtv.RHVTid        
                                                and rhtv.RHVTestado = 'A'
                                                and lt.LTdesde between rhtv.RHVTfecharige and rhtv.RHVTfechahasta
                                                    inner join RHTTablaSalarial rhtt
                                                        on rhtv.RHTTid = rhtt.RHTTid
                                                        and rhcp.RHTTid = rhtt.RHTTid
                            where lt.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
                            and #vFecha# between lt.LTdesde and lt.LThasta
                        </cfquery>
						<cfif rsTipoCambioEmpleado.RecordCount eq 0 >
							<!--- 20140626 SINO LO ENCONTRO, BUSCA NUEVAMENTE EN EL ULTIMO CORTE DEL EMPLEADO --->  						                                        
                        	<cfquery name="rsTipoCambioEmpleado" datasource="#session.DSN#">
                            	Select coalesce(rhtv.RHVTtipocambio,1) as TipoCambio
                            from LineaTiempo lt
                                inner join RHCategoriasPuesto rhcp
                                    on lt.RHCPlinea = rhcp.RHCPlinea
                                        inner join RHCategoria rhc
                                            on rhcp.RHCid = rhc.RHCid
                                            inner join RHMontosCategoria rhmc        
                                                on rhc.RHCid = rhmc.RHCid
                                                inner join RHVigenciasTabla rhtv
                                                    on rhmc.RHVTid = rhtv.RHVTid        
                                                    and rhtv.RHVTestado = 'A'
                                                    and lt.LTdesde between rhtv.RHVTfecharige and rhtv.RHVTfechahasta
                                                    inner join RHTTablaSalarial rhtt
                                                        on rhtv.RHTTid = rhtt.RHTTid
                                                        and rhcp.RHTTid = rhtt.RHTTid
                            where lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
                            and lt.LTdesde in (Select max(ltref.LTdesde)
                                                from LineaTiempo ltref
                                                Where lt.DEid = ltref.DEid
                                                and lt.Ecodigo = ltref.Ecodigo)
                        </cfquery>
	                    </cfif>	
						<!--- 20140626 SINO LO ENCONTRO, SUPONE QUE EL TIPO DE CAMBIO ES 1 --->                                                             
						<cfif rsTipoCambioEmpleado.RecordCount eq 0 >
                            <cfquery name="rsTipoCambioEmpleado" datasource="#session.DSN#">
                                Select 1 as TipoCambio from dual
                            </cfquery>
                        </cfif>

					<!--- 20140626 ESTABLECE EL TIPO DE CAMBIO --->                                         
					<cfset vFechaIngresoOrig = FechaIngreso >
                    <cfset vFechaIngreso = FechaIngreso >

                    <cfquery name="rsParametros" datasource="#Session.DSN#">
                        select coalesce(<cf_dbfunction name="to_number" args="FactorDiasSalario">,30) as Pvalor
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
					<cfparam name="miSalarioPromedio.valor" default="0">
					<cfset vSalarioPromedio = miSalarioPromedio.valor  >
                    <cfif rsDatosConcepto.CIsprango EQ 3> <!---Promedio en días--->
						<cfset vSalarioPromedio = vSalarioPromedio * FactorDiasSalario >
					</cfif>
					<cfset vSalarioPromedioOrig = vSalarioPromedio >
					<cfset vSalarioPromedio = vSalarioPromedio / FactorDiasSalario >

				
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
					
					<cfset fechaAntiguedad 	= #ParseDateTime(vFechaIngreso)#>
					<cfset rsinfoAL.Annos 	= DateDiff("YYYY", #ParseDateTime(vFechaIngreso)#,#ParseDateTime(vFecha)#)>
					<cfset fechaAntiguedad 	= DateAdd("YYYY", rsinfoAL.Annos, fechaAntiguedad)>
					<cfset rsinfoAL.Meses 	= DateDiff("m", #ParseDateTime(fechaAntiguedad)#, #ParseDateTime(vFecha)#)>
					<cfset fechaAntiguedad 	= DateAdd("m", rsinfoAL.Meses, fechaAntiguedad)>
					<cfset rsinfoAL.Dias 	= DateDiff("d", fechaAntiguedad, #ParseDateTime(vFecha)#)>


                    <cfset vTiempoAnos = rsinfoAL.Annos>
                    <cfset vTiempoMeses = rsinfoAL.Meses>
                    <cfset vTiempoDias =  rsinfoAL.Dias>


                    <cfset vTotalMeses = datediff('m', vFechaIngreso, vFecha) >
	
                    <!---  Se modifica la fecha de ingreso para calcular sobre el rango permitido (8 años) --->
                    <cfif vTotalMeses gt vRango >  			
                        <cfset vFechaIngreso = dateadd('d',vFecha,-((vRango/12)*365)) >
                        <cfset vTiempoCesantia = int(vRango/12)>
                    <cfelse>
                        <cfset vTiempoCesantia = int(abs(vTotalMeses/12))>
                    </cfif>

                    <cfset vMontoColones = vSalarioPromedio * vDiasCesantia >
                    <cfset vMontoDolares = vMontoColones / rsTipoCambioEmpleado.TipoCambio >

                    <cfoutput>	
                    <tr>
                        <td align='left'>#DEidentificacion#</td> 
                        <td align='left'>
                            <cfif isdefined("form.mostrarComo") and form.mostrarComo EQ 1>
                                #DEnombre# #DEapellido1# #DEapellido2#
                            <cfelseif isdefined("form.mostrarComo") and form.mostrarComo EQ 2>		
                                #DEapellido1# #DEapellido2# #DEnombre#
                            <cfelse>
                                #DEnombre# #DEapellido1# #DEapellido2#
                            </cfif>
                        </td>
                        <td align='left'><cf_locale name="date" value="#vFechaIngresoOrig#"/></td>
                        <td align='center'>#vTiempoAnos#</td>
                        <td align='center'>#vTiempoMeses#</td>
                        <td align="center">#vTiempoDias#</td>
                        <td align="center">#round(vDiasCesantia * 100)/100#</td>
                        <td align='right'><cf_locale name="number" value="#vSalarioPromedioOrig#"/></td>
                        <td align='right'><cf_locale name="number" value="#vMontoColones#"/></td>
                        <td align='right'><cf_locale name="number" value="#vMontoDolares#"/></td>
                        <td align="center">#vTiempoCesantia#</td>
                        <td align="center">#Observacion#</td>
                    </tr>	
                    </cfoutput>
					</cfloop>
				</tbody>
			
		</table> 
 
<cfelse>	 
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>
