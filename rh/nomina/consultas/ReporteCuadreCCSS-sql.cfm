
<cfif isdefined("Exportar")>
    <cfset form.btnDownload = true> 
</cfif>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traducción --->
<cfset LB_ReporteCuadreCCSS = t.translate('LB_ReporteCuadreCCSS','Reporte de Cuadre CCSS','/rh/ReporteCuadreCCSS.xml')>
<cfset LB_DetalleCuentasPagarCCSS = t.translate('LB_DetalleCuentasPagarCCSS','Detalle de Cuentas por Pagar a la CCSS')>
<cfset LB_AlMesDe = t.translate('LB_AlMesDe','Al mes de')>
<cfset LB_TotalSalariosMensuales = t.translate('LB_TotalSalariosMensuales','Total de Salarios Mensuales','/rh/generales.xml')>
<cfset LB_GrupoCarga = t.translate('LB_GrupoCarga','Grupo de Carga','/rh/generales.xml')>
<cfset LB_ValorEmpleado = t.translate('LB_ValorEmpleado','Valor Empleado','/rh/generales.xml')>
<cfset LB_ValorPatrono = t.translate('LB_ValorPatrono','Valor Patrono','/rh/generales.xml')>
<cfset LB_MontoEmpleado = t.translate('LB_MontoEmpleado','Monto Empleado','/rh/generales.xml')>
<cfset LB_MontoPatrono = t.translate('LB_MontoPatrono','Monto Patrono','/rh/generales.xml')>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')>
<cfset LB_TotalPagar = t.translate('LB_TotalPagar','Total a Pagar','/rh/generales.xml')>
<cfset LB_TipoDeCambio = t.translate('LB_TipoDeCambio','Tipo de cambio','/rh/generales.xml')/> 
<cfset LB_InformeParaElPeriodo = t.translate('LB_InformeParaElPeriodo','Informe para el periodo','/rh/generales.xml')/>
<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>
<cfset LB_IICA= t.translate('LB_IICA','Instituto Interamericano de Cooperación para la Agricultura')>
<cfset LB_SalarioNomina = t.Translate('LB_SalarioNomina','Salario Nómina','/rh/generales.xml')>
<cfset LB_Maternidad = t.Translate('LB_Maternidad','Maternidad','/rh/generales.xml')>
<cfset LB_ConceptosPago = t.Translate('LB_ConceptosPago','Conceptos de Pago','/rh/generales.xml')>
<cfset LB_Salarios = t.Translate('LB_Salarios','Salario','/rh/generales.xml')>
<cfset LB_Subsidios = t.Translate('LB_Subsidios','Subsidios','/rh/generales.xml')>
<cfset LB_SalarioCargas = t.Translate('LB_SalarioCargas','Salario de Cargas','/rh/generales.xml')>

<cfset archivo = "ReporteCuadreCCSS(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders irA="ReporteCuadreCCSS.cfm" FileName="#archivo#">
<cf_templatecss>        

<cfif isdefined("form.sYear") and len(trim(form.sYear))>
    <cfset lvarYer = form.sYear > 
<cfelse>
    <cfset lvarYer = year(now()) >
</cfif>    

<cfif isdefined("form.sMes") and len(trim(form.sMes))>
    <cfset lvarMes = form.sMes > 
<cfelse>
    <cfset lvarMes = month(now()) >
</cfif>  

<cfif isdefined("form.mesPer") and len(trim(form.mesPer))>
    <cfset lvarMesPer = form.mesPer > 
<cfelse>
    <cfset lvarMesPer = month(now()) >
</cfif> 

<cfif not isdefined("Exportar") or not isdefined("Consultar")> 
    <cfset Consultar = true>
</cfif> 

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre"  conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
    select #LvarCEnombre# as CEnombre 
    from CuentaEmpresarial 
    where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset Lvar_TipoCambio = 1>
<cfset titulocentrado2 = ''>
<cfset lvarCols = 6>


<cfset showEmpresa = true>
<cfif isDefined("form.esCorporativo")>
    <cfif form.JtreeListaItem eq 0>
        <cfset form.JtreeListaItem = EmpresaLista>  
    </cfif>
    <cfset showEmpresa = false>
<cfelse>
    <cfset form.JtreeListaItem = session.Ecodigo>       
</cfif>

<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select Edescripcion as empresa
	from Empresas 
	where Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
</cfquery>
<cfset fEmpresas= valuelist(rsEmpresas.empresa,', ')>


<cfquery name="rsMeses" datasource="sifcontrol">
    select VSdesc, VSvalor 
    from VSidioma 
    where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.idioma#')
</cfquery>  

<cfquery name="rsSumaSalarios" datasource="#session.DSN#">
	select sum(SEsalariobruto) as SalariosTotal
	from CalendarioPagos cp 
	inner join HSalarioEmpleado se
		on cp.CPid=se.RCNid
	where cp.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#"> 
		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#">
		and cp.CPnocargasley = 0
</cfquery>

<!---Subsidios--->
<cfquery name="rsSumaSubsidios" datasource="#session.DSN#">
	select sum(PEmontores)  as SubsidiosTotal
	from CalendarioPagos cp 
	inner join HPagosEmpleado pe
		on cp.CPid=pe.RCNid
		and 0 < (select count(1) from RHTipoAccion x where x.RHTid=pe.RHTid and x.RHTnocargas=1 and x.RHTnocargasley=1)
	where cp.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#"> 
		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#">
		and cp.CPnocargasley = 0
</cfquery> 

<!--- Maternidades a sumar --->
<cfquery name="rsFactor" datasource="#session.DSN#">
	select sum(PEmontores * dr.Factor)   as AccionesFactor
	from CalendarioPagos cp 
	inner join HPagosEmpleado pe
		on cp.CPid=pe.RCNid
	inner join RHDrpt dr 
		on dr.RHTid = pe.RHTid 
		and dr.Excluir = 0
		and dr.Ecodigo = cp.Ecodigo
	where cp.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#"> 
		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#">
		and cp.CPnocargasley = 0
</cfquery> 

<!--- Maternidad a restar --->
<cfquery name="rsExclusion" datasource="#session.DSN#">
	select sum(PEmontores)  as Acciones
	from CalendarioPagos cp 
	inner join HPagosEmpleado pe
		on cp.CPid=pe.RCNid
	inner join RHDrpt dr 
		on dr.RHTid = pe.RHTid 
		and dr.Excluir = 0
		and dr.Ecodigo = cp.Ecodigo
	where cp.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#"> 
		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#">
		and cp.CPnocargasley = 0
</cfquery> 


<!--- Obtiene el Total de Salario Bruto para un periodo(año/mes) seleccionado --->
<cfquery name="rsTotSalarioBruto" datasource="#session.DSN#">
	select coalesce(sum(hse.SEsalariobruto),0) as totSalarioBruto
	from CalendarioPagos cp  
	inner join HSalarioEmpleado hse
	    on cp.CPid = hse.RCNid
	where cp.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
		and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
		and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#">
		and cp.CPnocargasley = 0
</cfquery> 

<!--- Obtiene el Total de Incidencias para un periodo(año/mes) seleccionado --->
<cfquery name="rsTotIncidencias" datasource="#session.DSN#">
	select coalesce(sum(ICmontores),0) as totIncidencias
	from CalendarioPagos cp
    inner join HRCalculoNomina rcn
        on cp.CPid=rcn.RCNid
	inner join HIncidenciasCalculo ic
	    on ic.RCNid = cp.CPid
	    inner join CIncidentes ci
	        on ci.CIid = ic.CIid
	 where cp.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
	   and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#">
	   and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#">
	   and cp.CPnocargasley = 0
	   and ci.CInocargasley = 0
</cfquery>

<!--- Obtiene el resulset con el detalle de los montos de cargas aplicados al empleado y patron --->
<cfset rsCuadreCCSS = getQuery() >  

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
	thead { display: table-header-group; }
	tfoot { display: table-footer-group; }
	
	@media print {
	thead { display: table-header-group; }
	tfoot { display: table-footer-group; }
	}
	@media screen {
		thead { display: none; }
		tfoot { display: none; }
	}
	table { page-break-inside:auto }
	tr { page-break-inside:avoid; page-break-after:auto }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>#LB_Corp#</title>
</head>
<body>

<cfif rsCuadreCCSS.recordcount>
    <cfset Lvar_TipoCambio = rsCuadreCCSS.tipocambio>
    <cfif createDate(year(rsCuadreCCSS.mesMax), month(rsCuadreCCSS.mesMax), 1) neq createDate(year(rsCuadreCCSS.mesMin), month(rsCuadreCCSS.mesMin), 1) >
        <cfquery dbtype="query" name="rs1">
            select VSdesc 
            from rsMeses 
            where VSvalor = '#month(rsCuadreCCSS.mesMin)#'
        </cfquery>

        <cfquery dbtype="query" name="rs2">
            select VSdesc 
            from rsMeses 
            where VSvalor = '#month(rsCuadreCCSS.mesMax)#'
        </cfquery>

        <cfset titulocentrado2 = '#LB_InformeParaElPeriodo# #rs1.VSdesc# #year(rsCuadreCCSS.mesMin)# - #rs2.VSdesc# #year(rsCuadreCCSS.mesMax)#'>
    <cfelse>    
        <cfquery dbtype="query" name="rs1">
            select VSdesc 
            from rsMeses 
            where VSvalor = '#month(rsCuadreCCSS.mesMax)#'
        </cfquery>

        <cfset titulocentrado2 = '#LB_InformeAlMesDe# #rs1.VSdesc# #year(rsCuadreCCSS.mesMax)#'>
    </cfif> 

    <cfif isdefined("Exportar") or isdefined("Consultar")>   
        <!---<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' filtro1="<b>#LB_TipoDeCambio#: #Lvar_TipoCambio#</b>" cols="#lvarCols-2#" showEmpresa="#showEmpresa#">--->
		<cf_HeadReport 
            addTitulo1="#LB_IICA#"
            filtro1="#titulocentrado2#"
            filtro2="#fEmpresas#"
			filtro3="#LB_TipoDeCambio#: #Lvar_TipoCambio#"
            showEmpresa="false"
            showline="false" 
            cols="#lvarCols-2#">
		<cfoutput>#getHTML(rsCuadreCCSS)#</cfoutput>   
    </cfif>
<cfelse>
	<cf_HeadReport 
            addTitulo1="#LB_IICA#"
            filtro1="#titulocentrado2#"
			filtro2="#fEmpresas#"
            filtro3="#LB_TipoDeCambio#: #Lvar_TipoCambio#"
            showEmpresa="false"
            showline="false" 
            cols="#lvarCols-2#">
    <!---<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' showEmpresa="#showEmpresa#">--->
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>
</body>
</html>	

<cffunction name="getQuery" returntype="query">
	<cf_translatedata name="get" tabla="DCargas" col="dc.DCdescripcion" returnvariable="LvarDCdescripcion">
	  <cfquery name="rsCuadreCCSS" datasource="#session.DSN#">
		select #LvarDCdescripcion# as DCdescripcion, dc.DCmetodo,
		dc.DCvaloremp, sum(hcc.CCvaloremp) as CCvaloremp, dc.DCvalorpat, sum(hcc.CCvalorpat) as CCvalorpat,
        min(cp.CPfpago) as mesMin, max(cp.CPfpago) as mesMax, max(rcn.RCtc) as tipocambio
		from CalendarioPagos cp 
        inner join HRCalculoNomina rcn
            on cp.CPid=rcn.RCNid
		inner join HCargasCalculo hcc
		    on cp.CPid = hcc.RCNid
		    inner join DCargas dc
		        on hcc.DClinea = dc.DClinea  
		where cp.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JtreeListaItem#" list="true">)
			and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarYer#"> 
			and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarMes#">
			and cp.CPnocargasley = 0

		<cfif isdefined("form.TcodigoListCg") and len(trim(form.TcodigoListCg)) GT 0>
			and dc.DCcodigo in (<cfqueryparam cfsqltype="cf_sql_char" value="#form.TcodigoListCg#" list="true" />)
		</cfif>	

		group by #LvarDCdescripcion#, dc.DCmetodo, dc.DCvaloremp, dc.DCvalorpat
		order by #LvarDCdescripcion#
	</cfquery> 
	
	<cfreturn rsCuadreCCSS>
</cffunction>	
 
<cffunction name="getHTML" output="true">
	<cfargument name="rsCuadreCCSS" type="query" required="true">

	<table class="reporte" width="100%">
        <thead>
            <tr><th colspan="#lvarCols#">#LB_DetalleCuentasPagarCCSS#</th></tr>
            <tr><th colspan="#lvarCols#">#LB_AlMesDe# #lvarMesPer# #lvarYer#</th></tr>
        </thead>
        <tbody>
    		<cfset totSalarioMensual = rsTotSalarioBruto.totSalarioBruto - rsExclusion.Acciones + rsFactor.AccionesFactor + rsTotIncidencias.totIncidencias - rsSumaSubsidios.SubsidiosTotal>
    		<tr>
    			<td colspan="#lvarCols-1#"><strong>#LB_SalarioNomina#</strong></td>
    			<td style="text-align: right;">
                    <strong>&##8353;<cf_locale name="number" value="#rsTotSalarioBruto.totSalarioBruto#"/></strong>
                </td>
    		</tr>
			<tr>
    			<td colspan="#lvarCols-1#"><strong>#LB_Maternidad#</strong></td>
    			<td style="text-align: right;">
                    <strong>&##8353;<cf_locale name="number" value="#rsFactor.AccionesFactor-rsExclusion.Acciones#"/></strong>
                </td>
    		</tr>
			<tr>
    			<td colspan="#lvarCols-1#"><strong>#LB_ConceptosPago#</strong></td>
    			<td style="text-align: right;">
                    <strong>&##8353;<cf_locale name="number" value="#rsTotIncidencias.totIncidencias#"/></strong>
                </td>
    		</tr>	
			<tr>
    			<td colspan="#lvarCols-1#"><strong>#LB_Salarios#</strong></td>
    			<td style="text-align: right;">
                    <strong>&##8353;<cf_locale name="number" value="#rsTotSalarioBruto.totSalarioBruto + rsFactor.AccionesFactor - rsExclusion.Acciones + rsTotIncidencias.totIncidencias#"/></strong>
                </td>
    		</tr>
			<tr>
    			<td colspan="#lvarCols-1#"><strong>#LB_Subsidios#</strong></td>
    			<td style="text-align: right;">
                    <strong>&##8353; <cf_locale name="number" value="#-1 * rsSumaSubsidios.SubsidiosTotal#"/></strong>
                </td>
    		</tr>
			
			<tr>
    			<td colspan="#lvarCols-1#"><strong>#LB_SalarioCargas#</strong></td>
    			<td style="text-align: right;">
                    <strong>&##8353;<cf_locale name="number" value="#totSalarioMensual#"/></strong>
                </td>
    		</tr>	
    		<tr><td colspan="#lvarCols#">&nbsp;</td></tr>
    		<tr>
    			<td colspan="2"><strong>#LB_GrupoCarga#</strong></td>
    			<td align="center"><strong>#LB_ValorEmpleado#</strong></td>
    			<td align="center"><strong>#LB_ValorPatrono#</strong></td>
    			<td align="center"><strong>#LB_MontoEmpleado#</strong></td>
    			<td align="center"><strong>#LB_MontoPatrono#</strong></td>
    		</tr>

        	<cfset totalEmpPorc = 0 >
            <cfset totalPatPorc = 0 >
        	<cfset totalEmp = 0 >
            <cfset totalPat = 0 >

        	<cfoutput query="Arguments.rsCuadreCCSS">
        		<cfif DCmetodo eq 1>
        			<cfset porcent = "%">
        		<cfelse>
        			<cfset porcent = "">	
        		</cfif>
        		<tr>
        			<td nowrap colspan="2">#DCdescripcion#</td>
        			<td style="text-align: right;">
                        <cfif DCvaloremp gt 0>
                            <cf_locale name="number" value="#DCvaloremp#"/>#porcent#
                        </cfif>
                    </td>
        			<td style="text-align: right;">
                        <cfif DCvalorpat gt 0>
                            <cf_locale name="number" value="#DCvalorpat#"/>#porcent#
                        </cfif>
                    </td>
        			<td style="text-align: right;">
                        <cfif CCvaloremp gt 0>
                            <cf_locale name="number" value="#CCvaloremp#"/>
                        </cfif>
                    </td>
        			<td style="text-align: right;">
                        <cfif CCvalorpat gt 0>
                            <cf_locale name="number" value="#CCvalorpat#"/>
                        </cfif>
                    </td>
        		</tr>
                <cfset totalEmpPorc += DCvaloremp >
                <cfset totalPatPorc += DCvalorpat >
        		<cfset totalEmp += CCvaloremp >
            	<cfset totalPat += CCvalorpat >
        	</cfoutput>

        	<tr><td colspan="#lvarCols#">&nbsp;</td></tr>
        	<cfset totalPag = totalEmp + totalPat >

    		<tr>
    			<td colspan="2"><strong>#LB_Total#</strong></td>
    			<td style="text-align: right;">
                    <strong><cf_locale name="number" value="#totalEmpPorc#"/></strong>%
                </td>
                <td style="text-align: right;">
                    <strong><cf_locale name="number" value="#totalPatPorc#"/></strong>%
                </td>
                <td style="text-align: right;">
                    <strong><cf_locale name="number" value="#totalEmp#"/></strong>
                </td>
    			<td style="text-align: right;">
                    <strong><cf_locale name="number" value="#totalPat#"/></strong>
                </td>
    		</tr>	
    		<tr><td colspan="#lvarCols#">&nbsp;</td></tr>
    		<tr>
    			<td colspan="#lvarCols-1#"><strong>#LB_TotalPagar#</strong></td>
    			<td style="text-align: right;">
                    <strong><cf_locale name="number" value="#totalPag#"/></strong>
                </td>
    		</tr>	
        </tbody>	
	</table>	
</cffunction>	