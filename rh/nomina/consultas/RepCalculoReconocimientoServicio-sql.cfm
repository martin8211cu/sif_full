 
 <cfif isdefined('form.formato') and compare(Form.formato,'excel') eq 0 >
	<cfset form.btnDownload = true>	
</cfif>

<cfset t = createObject("component","sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LabelAgno = t.Translate('Agno','Año','expediente-cons.xml')>
<cfset LabelAgnos = t.Translate('Agnos','Años','expediente-cons.xml')>
<cfset LabelMes = t.Translate('Mes','Mes','expediente-cons.xml')>
<cfset LabelMeses = t.Translate('Meses','Meses','expediente-cons.xml')>
<cfset LabelDia = t.Translate('dia','Día','expediente-cons.xml')>
<cfset LabelDias = t.Translate('dias','Días','expediente-cons.xml')>
<cfset LB_InformeAlMesDe = t.translate('LB_InformeAlMesDe','Informe al mes de','/rh/generales.xml')/>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')/>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>
<cfset LB_IICA= t.translate('LB_IICA','Instituto Interamericano de Cooperación para la Agricultura')>

<cfset archivo = "RepCalculoReconocimientoServicio(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders filename="#archivo#" irA="RepCalculoReconocimientoServicio.cfm">
<cf_templatecss/>

<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaEmpresasPermiso" returnvariable="EmpresaLista">

<cfif not isDefined("Form.CPperiodo")>
	<cfset form.CPperiodo = DateFormat(Now(),'yyyy') >
</cfif>	

<cfif not isDefined("Form.CPmes")>
	<cfset form.CPmes = DateFormat(Now(),'mm') >
</cfif>	

<cfif not isdefined('form.formato')>
	<cfset Form.formato = 'html'>
</cfif>

<cfif not isdefined('form.CIid')>
	<cfset Form.CIid = 0>
</cfif>

<cfquery datasource="#session.dsn#" name="rsIncidencia">
	select e.CIid, d.CIcalculo
	from CIncidentes e
	inner join CIncidentesD d
		on e.CIid = d.CIid
	where e.CItipo = 3
	and e.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
</cfquery> 

<cfif not findnocase('semanas',rsIncidencia.CIcalculo)>
	<cf_errorCode code="51852" msg="@errorDat_1@"
		errorDat_1="#t.Translate('LB_ElConceptoPagoSeleccionadoNoTieneSemanas','El Concepto de Pago seleccionado no tiene la variable semanas')#">
</cfif>


<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset titulocentrado2 = ''>
<cfset lvarCols = 10 >

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

<!--- obtiene meses para el idioma --->
<cfquery name="rsMeses" datasource="sifcontrol">
	select VSdesc, ltrim(rtrim(VSvalor)) as VSvalor  
	from VSidioma 
	where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo='#session.Idioma#')
	order by <cf_dbfunction name="to_number" args="VSvalor">
</cfquery>


<!--- se realiza el cambio de mes --->
<cfset lvarMes = form.CPmes>
<cfset lvarPeriodo = form.CPperiodo>
<cfif lvarMes eq 1>
	<cfset lvarMesAnt = 12>
	<cfset lvarPeriodoAnt = lvarPeriodo-1>
<cfelse>
	<cfset lvarMesAnt = lvarMes-1>
	<cfset lvarPeriodoAnt = lvarPeriodo>
</cfif>


<!--- Obtiene el resulset con el detalle del Calculo de Reconocimiento por Servicio --->
<cfset rsReporte = getQuery() >  

<cfif rsReporte.recordcount>
	<cfif isdefined('form.CPperiodo') and isdefined('form.CPmes')>
		<cfquery dbtype="query" name="rs1">
			select VSdesc 
			from rsMeses 
			where VSvalor = '#form.CPmes#'		
		</cfquery>

		<cfset titulocentrado2 = '#LB_InformeAlMesDe# #rs1.VSdesc# #form.CPperiodo#'>
	</cfif>


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
		<!---thead { display: table-header-group; }--->
		tfoot { display: none; }
	}
	table { page-break-inside:auto }
	tr { page-break-inside:avoid; page-break-after:auto }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>#LB_Corp#</title>
</head>
<body>

	<cfswitch expression="#Form.formato#">
		<cfcase value="html,excel">
			<!---<cf_EncReporte titulocentrado1='#LB_Corp#' titulocentrado2='#titulocentrado2#' cols="#lvarCols-2#" showEmpresa="#showEmpresa#">	--->
			<cf_HeadReport 
            addTitulo1="#LB_IICA#"
            filtro1="#titulocentrado2#"
            filtro2="#fEmpresas#"
			showEmpresa="false"
            showline="false" 
            cols="#lvarCols-2#">
			<cfoutput>#getHTML()#</cfoutput> 	
		</cfcase>
		<cfcase value="pdf">
			<cfdocument format="PDF">  
				<cf_HeadReport 
					addTitulo1="#LB_IICA#"
					filtro1="#titulocentrado2#"
					filtro2="#fEmpresas#"
					showEmpresa="false"
					showline="false" 
					cols="#lvarCols-2#">
				<cfoutput>#getHTML()#</cfoutput>
			</cfdocument>
		</cfcase>
	</cfswitch>
<cfelse>
	 <cf_HeadReport 
            addTitulo1="#LB_IICA#"
            filtro1="#fEmpresas#"
			showEmpresa="false"
            showline="false" 
            cols="#lvarCols-2#">
	<!---<cf_EncReporte titulocentrado1='#LB_Corp#' showEmpresa="#showEmpresa#">--->
	<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
</cfif>
</body>
</html>	

<cffunction name="getQuery" returntype="query">		 
	<cfset ultimodiaMes = dateAdd('d', -1, dateAdd('m', 1, createDate(form.cpperiodo, form.cpmes, 1)))>
	
	<cf_dbfunction name="op_concat" returnvariable="concat"> 
	<cfquery name="rsReporte" datasource="#session.dsn#">
	 	select lt.Ecodigo, de.DEid, de.DEidentificacion as codigo,tt.RHTTcodigo #concat#' - '#concat# rhc.RHCcodigo as clasificacion, de.DEapellido1 #concat#' '#concat# de.DEapellido2 #concat#' '#concat# de.DEnombre as nombre, coalesce(dlt.DLTmonto,0) as salarioBase,
	 		coalesce(ev.EVfvacas,ev.EVfantig) as ingreso
		from DatosEmpleado de
		inner join EVacacionesEmpleado ev
			on de.DEid = ev.DEid
		inner join LineaTiempo lt
			on de.DEid = lt.DEid	
		inner join DLineaTiempo dlt
			on lt.LTid = dlt.LTid
		inner join RHCategoriasPuesto rp
			on lt.RHCPlinea	= rp.RHCPlinea
		inner join RHTTablaSalarial tt
			on rp.RHTTid = tt.RHTTid
		inner join RHCategoria rhc
			on rp.RHCid = rhc.RHCid
		inner join ComponentesSalariales cs
			on dlt.CSid = cs.CSid
			and cs.CSsalariobase = 1
	 
		where lt.Ecodigo in (#form.JtreeListaItem#)		
		and lt.LTdesde = (
							select max(LTdesde)
							from LineaTiempo
							where DEid = de.DEid
							and LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#ultimodiaMes#">
							and LThasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(form.cpperiodo, form.cpmes, 1)#">
						)
		order by de.DEapellido1, de.DEapellido2, de.DEnombre
	</cfquery>  

	<cfreturn rsReporte>
</cffunction>
	

<cffunction name="getHTML" output="true">
	<!---<link href="<cfoutput>http://#cgi.server_name#<cfif len(trim(cgi.SERVER_PORT))>:#cgi.SERVER_PORT#</cfif></cfoutput>/cfmx/plantillas/IICA/css/reports.css" rel="stylesheet" type="text/css">--->
	<style type="text/css">
		.tituloDivisor { padding-top: 2em !important; padding-bottom: 1em !important; border-color: ##000 !important; border-left: 0 !important; border-right: 0 !important; }
		.reporte .subtotal { border-top: black; border-style: solid; border-top-width: 2px; } 
		.reporte{ width: 100% }
	</style>

   	<table class="reporte">
		<thead>
			<tr>
				<th width="7%">#t.Translate('LB_Consec','Consec')#.</th>
				<th width="7%">#t.Translate('LB_Codigo','Código','/rh/generales.xml')#</th>
				<th width="7%">#t.Translate('LB_NombredelFuncionario','Nombre del Funcionario')#</th>
				<th width="7%">#t.Translate('BTN_Clasificacion','Clasificación','/rh/generales.xml')#</th>
				<th width="7%">#t.Translate('LB_SalarioBaseAnual','Salario Base Anual')#</th>
				<th width="7%">#t.Translate('LB_SalarioBaseMensual','Salario Base Mensual')#</th>
				<th width="7%">#t.Translate('LB_AnodeIngreso','Año de Ingreso')#</th>
				<th width="7%">#t.Translate('LB_MesdeIngreso','Mes de Ingreso')#</th>
				<th width="7%">#t.Translate('LB_AnosmesesdeAntiguedad','Años y meses de Antiguedad')#</th>
				<th width="7%">#t.Translate('LB_AntiguedadCalculada','Antiguedad Calculada')#</th>
				<th width="7%">#t.Translate('LB_SemanasAdjudicadas','Semanas Adjudicadas')#</th>
				<th width="7%">#t.Translate('LB_CostoDeUnaSemana','Costo de una semana')#</th>
				<th width="7%">#t.Translate('LB_TotalaPagarSemanasdeReconocimiento','Total a pagar por semanas de reconocimiento')#</th>
			</tr>
		</thead>
      	<tbody>
	      	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>	
	      	<cfset totalsemana = 0>
	      	<cfset totalsemanaCal = 0>

	      	<cfoutput query="rsReporte">
	      		<tr>
		      		<td>#currentrow#</td>
		      		<td>#codigo#</td>
		      		<td nowrap>#nombre#</td>
		      		<td>#clasificacion#</td>
		      		<td align="right"><cf_locale name="NUMBER" value="#salarioBase*12#"/></td>
		      		<td align="right"><cf_locale name="NUMBER" value="#salarioBase#"/></td>
		      		<td align="right">#year(ingreso)#</td>
		      		<td align="right">#month(ingreso)#</td>
		      		<td align="right" nowrap>#getAntiguedadEnLetras(ingreso,ultimodiaMes,0)#</td>
					<td align="right" nowrap>#getAntiguedadEnLetras(ingreso,ultimodiaMes,1)#</td>   

					<!----- el calculo de la semana debe realizarse por medio de la calculadora segun la formula del concepto de pago con el calculo de semanas---->

		  			<cfscript>
		  		 		semanas = RH_Calculadora.calculate( RH_Calculadora.get_presets(CIid=rsIncidencia.CIid,Ecodigo=rsReporte.Ecodigo,DEid=rsReporte.DEid,Fecha1_Accion=ultimodiaMes) & ";" &  rsIncidencia.CIcalculo).get('semanas').toString();
		  			</cfscript>

					<td align="right">#int(semanas)#</td>
					<td align="right"><cf_locale name="NUMBER" value="#(salarioBase*12)/52#"/></td>  
					<td align="right"><cf_locale name="NUMBER" value="#((salarioBase*12)/52)*semanas#"/></td>
					<cfset totalsemana += (salarioBase*12)/52>
					<cfset totalsemanaCal += ((salarioBase*12)/52)*semanas>
	 			</tr>
	      	</cfoutput>

			<tr><td colspan="#lvarCols+3#">&nbsp;</td></tr>
      		<tr>
	      		<td align="right" colspan="#lvarCols+1#"><strong>#LB_Total#</strong></td>
				<td align="right"><strong><cf_locale name="NUMBER" value="#totalsemana#"/></strong></td>  
				<td align="right"><strong><cf_locale name="NUMBER" value="#totalsemanaCal#"/></strong></td>
 			</tr>
 			<tr><td colspan="#lvarCols+3#">&nbsp;</td></tr>
        </tbody>
    </table>
</cffunction>


<cffunction name="mifac">
	<cfargument name="mifac" type="any">
	<cf_dump vaR="#arguments.mifac#">
</cffunction>


<cffunction name="getAntiguedadEnLetras" returntype="string">
	<cfargument name="fecha" type="date" required="true">
	<cfargument name="fechacorte" type="date" required="true">
	<cfargument name="redondearMes" type="boolean" required="true" default="false">
        
    <cfset stringret = ''>
    <cfset lvarAgnos = DateDiff("yyyy", arguments.Fecha, arguments.fechacorte)>
    <cfset lvarMeses = DateDiff("m", DateAdd("yyyy",lvarAgnos,arguments.Fecha), arguments.fechacorte)>
    <cfset lvarDias = DateDiff("d", DateAdd("m",lvarMeses,DateAdd("yyyy",lvarAgnos,arguments.Fecha)), arguments.fechacorte)>    
    <cfif arguments.redondearMes>
    	<cfif lvarMeses gt 5>
    		<cfset lvarAgnos += 1>
    	</cfif>
    	<cfset stringret &= lvarAgnos>
        <cfif lvarAgnos EQ 1>
            <cfset stringret &=' '& LabelAgno>
         <cfelse>
            <cfset stringret &=' '& LabelAgnos>
        </cfif>
    <cfelse>	
    	<cfset stringret &= lvarAgnos>
        <cfif lvarAgnos EQ 1>
            <cfset stringret &=' '& LabelAgno>
         <cfelse>
            <cfset stringret &=' '& LabelAgnos>
        </cfif>
        <cfset stringret &=', '& lvarMeses>
        <cfif lvarMeses EQ 1>
            <cfset stringret &=' '& LabelMes>
         <cfelse>
            <cfset stringret &=' '& LabelMeses>
        </cfif>
        <cfset stringret &=', '& lvarDias>
         <cfif lvarDias EQ 1>
            <cfset stringret &=' '& LabelDia>
         <cfelse>
            <cfset stringret &=' '& LabelDias>
        </cfif>
    </cfif>
 
    <cfreturn stringret>
</cffunction>
 
			
