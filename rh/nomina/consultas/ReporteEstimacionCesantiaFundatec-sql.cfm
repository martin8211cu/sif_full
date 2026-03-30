
<cf_templatecss>
<cfsetting requesttimeout="8600">
			 
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LvarBack = "ReporteEstimacionCesantiaFundatec.cfm">

<cfset LB_ReporteEstimacionCesantia = t.translate('LB_ReporteEstimacionCesantia','Reporte de Estimación de Cesantía')>
<cfset LB_CentroFuncional = t.translate('LB_CentroFuncional','Centro Funcional','/rh/generales.xml')>

<cfset LB_CFPadre = t.translate('LB_CFPadre','Centro funcional padre','/rh/generales.xml')>
<cfset LB_CFHijo = t.translate('LB_CFHijo','Centro funcional','/rh/generales.xml')>

<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_FechaIngreso = t.translate('LB_FechaIngreso','Fecha de ingreso','/rh/generales.xml')>
<cfset LB_Antiguedad = t.translate('LB_Antiguedad','Antiguedad','/rh/generales.xml')>
<cfset LB_Meses = t.translate('LB_Meses','Meses','/rh/generales.xml')>
<cfset LB_Dias = t.translate('LB_Dias','Días','/rh/generales.xml')>
<cfset LB_TotalDiasPagar = t.translate('LB_TotalDiasPagar','Total días a pagar','/rh/generales.xml')>
<cfset LB_SalarioPromedioDiario = t.translate('LB_SalarioPromedioDiario','Salario <br> promedio <br> diario','/rh/generales.xml')>

<cfset LB_DiasLabPorCF = t.translate('LB_DiasLabPorCF','Días laborados <br> por CF','/rh/generales.xml')>
<cfset LB_PorcCesantiaPagarPorCF = t.translate('LB_PorcCesantiaPagarPorCF','Porcentaje <br> Cesantía pagar <br> por CF','/rh/generales.xml')>
<cfset LB_CesantiaPagarPorCF = t.translate('LB_CesantiaPagarPorCF','Cesantía pagar <br> por CF','/rh/generales.xml')>
<cfset LB_ProvCesantiaPorCF = t.translate('LB_ProvCesantiaPorCF','Provisión <br> cesantia por CF','/rh/generales.xml')>
<cfset LB_TrasladoASEFUDA = t.translate('LB_TrasladoASEFUDA','Traslado <br> ASEFUNDA','/rh/generales.xml')>

<cfset LB_AdelantoCesantia = t.translate('LB_AdelantoCesantia','Adelanto cesantía','/rh/generales.xml')>
<cfset LB_CesantiaNetaProvporCF = t.translate('LB_CesantiaNetaProvporCF','Cesantía neta <br> provisionada <br> por CF ','/rh/generales.xml')>
<cfset LB_CesantiaNetaPagarxCF = t.translate('LB_CesantiaNetaPagarxCF','Cesantia neta pagar<br> por CF','/rh/generales.xml')>
<cfset LB_SuficienciaInsuficiencias = t.translate('LB_SuficienciaInsuficiencias','Suficiencia / <br> Insuficiencias','/rh/generales.xml')>

<cfset LB_MontoTotalCesantiaPagarColones = t.translate('LB_MontoTotalCesantiaPagarColones','Monto total cesantía a pagar Colones','/rh/generales.xml')>
<cfset LB_AnosLaborados = t.translate('LB_AnosLaborados','Años','/rh/generales.xml')>


<cfset LB_FinDelReporte = t.translate('LB_FinDelReporte','Fin del Reporte','/rh/generales.xml')>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>
<cfset LB_NoExisteConceptoCesantiaConfig = t.Translate('LB_NoExisteConceptoCesantiaConfig','No existe concepto cesantía','/rh/generales.xml')>
<cfset LB_NoExisteFormulaConcepto = t.Translate('LB_NoExisteFormulaConcepto','No existe fórmula de cesantía','/rh/generales.xml')>

<cfset MSG_NoCesantia = t.translate('MSG_NoCesantia','No está definido el concepto para cesantía <br> verificar <br> Parámetros RH / Parámetros Generales / Formulación cáculos especiales')>

<cfset LB_Informacional = t.translate('LB_Informacional','Información al ','/rh/generales.xml')>

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
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
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
    <cfset filtro2 = '<strong>#LB_Informacional#: #lsdateformat(rsUltimo.FGenerada)#</strong>'>
<cfelse>
	<cfset filtro1 = ''/>		
    <cfset filtro2 = '<strong>#LB_Informacional#: #lsdateformat(rsUltimo.FGenerada)#</strong>'>
</cfif>


<cfset empresas = "0" >

<cfset form.jtreeJsonFormat = session.Ecodigo >


<cfif Form.chkOpcion eq 0>
	<cfcontent type="application/vnd.ms-excel; charset=windows-1252">
	<cfheader name="Content-Disposition" value="attachment; filename=#archivo#">
</cfif>
<cfif Form.chkOpcion eq 1>
	<cf_htmlReportsHeaders irA="#LvarBack#" FileName="#archivo#" title="#LB_ReporteEstimacionCesantia#">
</cfif>	
<cf_EncReporte	Titulo="#LB_ReporteEstimacionCesantia#" Color="##E3EDEF" filtro1="#filtro1#" filtro2="#filtro2#">	
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



<cfset vDebug = "false">


<cfquery name="rsEstimCesantia" datasource="#Session.DSN#">
	select  b.DEid,b.CFid, b.DiasCF, b.ProviCesantiaCF, b.ASOxCF, b.CesaxCFManual, b.ASOxCFManual, b.AdelantoCesaCFManual
     , b.AnnosLaborados, b.MesesLaborados, b.DiasLaborados, b.DiasPagoCesantia, b.SalarioPromedio, b.MontoCesantiaPagar
     , b.TotalDiasNomina as DiasBaseCF, b.ASOCFProp
     , b.PesoxCF
     , b.Fingreso
     , b.CesaxCFProporcional
     , b.ProviCesantia, b.TrasladoASEFUNDA, b.CesaPosTraslado, b.CesaNetaXPagar, b.Resultado
     , de.DEnombre,de.DEapellido1,de.DEapellido2, de.DEidentificacion
	 , cf.CFcodigo, cf.CFdescripcion
     , (select cfr.CFcodigo from CFuncional cfr where cfr.CFid = cf.CFidresp) as CFcodigoPadre
     , (select cfr.CFdescripcion from CFuncional cfr where cfr.CFid = cf.CFidresp) as CFdescripcionPadre

    from RHEstCesantiaCF b
    inner join DatosEmpleado de
    	on de.DEid = b.DEid
    inner join CFuncional cf
    	on cf.CFid = b.CFid
    where 1=1
        <cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
            <cfif #form.dependencias# NEQ ''>
                and (upper(cf.CFpath) like '#ucase(vRuta)#/%' or cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">)
            <cfelse>
                and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">             
            </cfif>
        </cfif>
        <cfif isDefined('form.DEid') and len(DEid)>
            and b.DEid = #form.DEid#
        </cfif>
	#vs_filtro#        
</cfquery>

 

 

<cfquery name="rsTotales" datasource="#Session.DSN#">
	select 
     sum(DiasCF) as DiasCF
    ,sum(CesaxCFProporcional) as CesaxCFProporcional
    ,sum(ProviCesantia) as ProviCesantia
    ,sum(TrasladoASEFUNDA) as TrasladoASEFUNDA
    ,sum(CesaPosTraslado) as CesaPosTraslado
    ,sum(AdelantoCesaCFManual) as AdelantoCesaCFManual
    ,sum(CesaNetaXPagar) as CesaNetaXPagar
    ,sum(Resultado) as Resultado
    ,sum(PesoxCF) as PesoxCF
    from RHEstCesantiaCF b
    where 1=1
        <cfif isdefined("form.CFid") and #form.CFid# NEQ ''  >
            <cfif #form.dependencias# NEQ ''>
                and (upper(b.CFpath) like '#ucase(vRuta)#/%' or b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">)
            <cfelse>
                and b.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">             
            </cfif>
        </cfif>
        <cfif isDefined('form.DEid') and len(DEid)> 
            and b.DEid = #form.DEid#
        </cfif>
</cfquery>

<!---<cf_dump var="#rsTotales#">--->


 

 
<cfif rsEstimCesantia.recordcount and CIncidente neq -1 or vCargaCesantia neq -1 or vCargaAsociacion neq -1>
    <table class="reporte" width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
        <cfoutput>	
            <thead>	
                <tr>
                    <th><strong>#LB_Identificacion#</strong></th>
                    <th><strong>#LB_Nombre#</strong></th>
                    <th><strong>#LB_CFPadre#</strong></th>
                    <th><strong>#LB_CFHijo#</strong></th>
                    <th><strong>#LB_FechaIngreso#</strong></th>
                    <th><strong>#LB_AnosLaborados#</strong></th> 
                    <th><strong>#LB_Meses#</strong></th> 
                    <th><strong>#LB_Dias#</strong></th>
                    <th><strong>#LB_TotalDiasPagar#</strong></th>
                    <th><strong>#LB_SalarioPromedioDiario#</strong></th> 
                    <th><strong>#LB_MontoTotalCesantiaPagarColones#</strong></th>
                    
                    <th><strong>#LB_DiasLabPorCF#</strong></th>
                    <th><strong>#LB_PorcCesantiaPagarPorCF#</strong></th>
                    <th><strong>#LB_CesantiaPagarPorCF#</strong></th>
                    <th><strong>#LB_ProvCesantiaPorCF#</strong></th>
                    <th><strong>#LB_TrasladoASEFUDA#</strong></th>

                    <th><strong>#LB_AdelantoCesantia#</strong></th>
                    <th><strong>#LB_CesantiaNetaProvporCF#</strong></th>
                    <th><strong>#LB_CesantiaNetaPagarxCF#</strong></th>
                    <th><strong>#LB_SuficienciaInsuficiencias#</strong></th>                                        
                </tr>
            </thead>		
            <tbody>
        </cfoutput>		
        <cfif Form.chkOpcion eq 1>
            <div class="row" id="divBarraProgreso">
                <div class="col-lg-12" style="padding:2%">
                    <div class="bs-example">
                          <div class="progress progress-striped active">	
                            <div id="progressBarGestion" name="progressBarGestion" class="progress-bar" style="width: <cfif not len(trim(rsEstimCesantia.DEid))>100<cfelse>1</cfif>%"></div>
                          </div>	          	
                    </div>
                </div>		
            </div>	              
        </cfif>      

        <cfoutput query="rsEstimCesantia">	
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
                <td align='left'>#CFdescripcionPadre#</td> 
                <td align='left'>#CFdescripcion#</td> 
                <td align='center'><cf_locale name="date" value="#Fingreso#"/></td>
                <td align='right'><cf_locale name="number" value="#AnnosLaborados#"/></td>
                <td align='right'><cf_locale name="number" value="#MesesLaborados#"/></td>
                <td align='right'><cf_locale name="number" value="#DiasLaborados#"/></td>
                <td align='right'><cf_locale name="number" value="#DiasPagoCesantia#"/></td>
                <td align='right'><cf_locale name="number" value="#SalarioPromedio#"/></td>
                <td align='right'><cf_locale name="number" value="#MontoCesantiaPagar#"/></td>
                <td align='right'><cf_locale name="number" value="#DiasCF#"/></td>
                <td align='right'><cf_locale name="number" value="#PesoxCF#"/></td>
                
				<!---Cesantia por CF--->
                <td align='right'><cf_locale name="number" value="#CesaxCFProporcional#"/></td>
                <!---Provisión Cesantía--->
                <!---<td align='right'><cf_locale name="number" value="#ProviCesantiaCF + CesaxCFManual#"/></td>--->
                <td align='right'><cf_locale name="number" value="#ProviCesantia#"/></td>
                <!---Traslado ASEFUNDA--->
                <!---<td align='right'><cf_locale name="number" value="#ASOCFProp + ASOxCFManual#"/></td>--->
                <td align='right'><cf_locale name="number" value="#TrasladoASEFUNDA#"/></td> 
                <!---Saldo Cesantía Desp Traslados--->
                <!---<td align='right'><cf_locale name="number" value="#(ProviCesantiaCF + CesaxCFManual) - (ASOCFProp + ASOxCFManual)- AdelantoCesaCFManual#"/></td>--->
                <td align='right'><cf_locale name="number" value="#AdelantoCesaCFManual#"/></td>
                <!---Adelanto Cesantía (monto fech última liquidación)--->
                <td align='right'><cf_locale name="number" value="#CesaPosTraslado#"/></td>
                <!---Cesantía Neta a Pagar--->
                <!---<td align='right'><cf_locale name="number" value="#(CesaxCFProporcional - (ASOCFProp + ASOxCFManual) - AdelantoCesaCFManual)#"/></td>--->
                <td align='right'><cf_locale name="number" value="#CesaNetaXPagar#"/></td>
                <!---Resultado--->
                <!---<td align='right'><cf_locale name="number" value="#((ProviCesantiaCF + CesaxCFManual) - (ASOCFProp + ASOxCFManual)- AdelantoCesaCFManual) - ((CesaxCFProporcional - (ASOCFProp + ASOxCFManual) - AdelantoCesaCFManual))#"/></td>--->
                <td align='right'><cf_locale name="number" value="#Resultado#"/></td>
            </tr>	
        </cfoutput>
        <cfoutput query="rsTotales">	
        	<tr>
                <td colspan="11">&nbsp; </td>
                <!---DiasCF--->
				<td  align='right'><cf_locale name="number" value="#DiasCF#"/></td>
                <!---Porcentaje--->
                <cfif isDefined('form.DEid') and len(DEid)> 
                    <td  align='right'><cf_locale name="number" value="#PesoxCF#"/></td>
                <cfelse>
                    <td>&nbsp; </td>
                </cfif>
				<!---Cesantia por CF--->
                <td  align='right'><cf_locale name="number" value="#CesaxCFProporcional#"/></td>
                <!---Provisión Cesantía--->
                <!---<td align='right'><cf_locale name="number" value="#ProviCesantiaCF + CesaxCFManual#"/></td>--->
                <td align='right'><cf_locale name="number" value="#ProviCesantia#"/></td>
                <!---Traslado ASEFUNDA--->
                <!---<td align='right'><cf_locale name="number" value="#ASOCFProp + ASOxCFManual#"/></td>--->
                <td align='right'><cf_locale name="number" value="#TrasladoASEFUNDA#"/></td> 
                <!---Saldo Cesantía Desp Traslados--->
                <!---<td align='right'><cf_locale name="number" value="#(ProviCesantiaCF + CesaxCFManual) - (ASOCFProp + ASOxCFManual)- AdelantoCesaCFManual#"/></td>--->
                <td align='right'><cf_locale name="number" value="#AdelantoCesaCFManual#"/></td>
                <!---Adelanto Cesantía (monto fech última liquidación)--->
                <td align='right'><cf_locale name="number" value="#CesaPosTraslado#"/></td>
                <!---Cesantía Neta a Pagar--->
                <!---<td align='right'><cf_locale name="number" value="#(CesaxCFProporcional - (ASOCFProp + ASOxCFManual) - AdelantoCesaCFManual)#"/></td>--->
                <td align='right'><cf_locale name="number" value="#CesaNetaXPagar#"/></td>
                <!---Resultado--->
                <!---<td align='right'><cf_locale name="number" value="#((ProviCesantiaCF + CesaxCFManual) - (ASOCFProp + ASOxCFManual)- AdelantoCesaCFManual) - ((CesaxCFProporcional - (ASOCFProp + ASOxCFManual) - AdelantoCesaCFManual))#"/></td>--->
                <td align='right'><cf_locale name="number" value="#Resultado#"/></td>
            </tr>	
        </cfoutput>
        
        </tbody>
</table> 
 
		<cfif Form.chkOpcion eq 1> <!--- HTML --->
		
			<div align="center" style="margin: 15px 0 15px 0"><strong>*** <cfoutput>#LB_FinDelReporte#</cfoutput> *** </strong></div>
			<script type="text/javascript">                 
				$("#divBarraProgreso").remove();
			</script>	
		</cfif>		

<!---         <cf_dump select="select * from #EstCesantiaCF#" abort=true> --->
 
<cfelse>	 
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>
