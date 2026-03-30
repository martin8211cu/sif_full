
<cfif isdefined("Exportar")>
	<cfset form.btnDownload = true>	
</cfif>

<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traducción --->
<cfset LB_ReporteDeduccionCreditUnion = t.translate('LB_ReporteDeduccionCreditUnion','Reporte de Deducción de Credit Union')>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificación','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_NoCuenta = t.translate('LB_NoCuenta','No. Cuenta','/rh/generales.xml')>
<cfset LB_Salario = t.translate('LB_Salario','Salario','/rh/generales.xml')>
<cfset LB_Porcentaje = '%'>
<cfset LB_MontoColones = t.translate('LB_MontoColones','Monto Colones','/rh/generales.xml')>
<cfset LB_MontoDolares = t.translate('LB_MontoDolares','Monto Dolares','/rh/generales.xml')>
<cfset LB_Total = t.translate('LB_Total','Total','/rh/generales.xml')>
<cfset LB_NoExistenRegistrosQueMostrar = t.Translate('LB_NoExistenRegistrosQueMostrar','No existen registros que mostrar','/rh/generales.xml')>
 <cfset LB_IICA= t.translate('LB_IICA','Instituto Interamericano de Cooperación para la Agricultura')>
 
<cfset archivo = "ReporteDeduccionCreditUnion(#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#).xls">

<cf_htmlReportsHeaders filename="#archivo#" irA="ReporteDeduccionCreditUnion.cfm">

<cf_templatecss/>	

<cfif isdefined('form.chk_NominaAplicada')>
	<cfset H = 'H' />
<cfelse>
	<cfset H = '' />
</cfif>

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre"  conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select Edescripcion from Empresas 
	where
		<cfif isdefined("form.JTREELISTAITEM") and len(trim(form.JTREELISTAITEM))> 
		Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.JTREELISTAITEM#" list="yes">)
		<cfelse>
		Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfif>
 </cfquery>

<cfset LB_Corp = rsCEmpresa.CEnombre>
<cfset lvarCols = 7 >


<cfset filtro1 = "<strong>Empresas:</strong> #valueList(rsEmpresas.Edescripcion)# <br/>">
<cfif isdefined('form.chk_FiltroFechas') >	
	<cfset filtro1 = filtro1 & '<strong>Desde</strong> #form.FechaDesde# <strong>Hasta</strong> #form.FechaHasta#'>
<cfelse>	
	<cfset rsFiltroEncab = getFiltroEncab() >
	
	<cfloop query="rsFiltroEncab">
		<cfif RCtc neq 1 >
	        <cfset vTC = "(TC: #RCtc#)">
	    <cfelse>
	        <cfset vTC = "" >   
	    </cfif>
		<!---<cfset filtro1 &= '<strong>#CPcodigo# - #Tcodigo# - #Tdescripcion# - #CPdescripcion# #vTC#</strong><br/>'>--->
		<cfset filtro1 = filtro1 & '#Tcodigo# - #Tdescripcion# - #CPdescripcion# #vTC# <br/>'>
	</cfloop>
</cfif>


<cfset rsDedCredUnion = getQuery() >  <!--- Reporte de Deducción de Credit Union --->

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
	<cfif rsDedCredUnion.recordcount>	
		<cfif isdefined("Exportar") or isdefined("Consultar")>
			<cf_HeadReport 
            addTitulo1="#LB_IICA#"
            filtro1="#filtro1#"
            showEmpresa="false"
            showline="false" 
            cols="#lvarCols-2#">
			
			<!---<cf_EncReporte titulocentrado1='#LB_Corp#' filtro1="#filtro1#" cols="#lvarCols-2#"> addTitulo1='#LB_Corp#'--->
			<cfoutput>#getHTML(rsDedCredUnion)#</cfoutput>  
		</cfif>
	<cfelse>	 
		<!---<cf_EncReporte titulocentrado1='#LB_Corp#' filtro1="#filtro1#">	--->
		<cf_HeadReport 
			addTitulo1="#LB_IICA#"
            filtro1="#filtro1#"
            showEmpresa="false"
            showline="false">
		<div align="center" style="margin: 15px 0 15px 0"> --- <b><cfoutput>#LB_NoExistenRegistrosQueMostrar#</cfoutput></b> ---</div>
	</cfif>
</body>
</html>	

<cffunction name="getFiltroEncab" returntype="query">
	<cfquery name="rsFiltroEncab" datasource="#session.DSN#">
		select tn.Tcodigo, tn.Tdescripcion, cp.CPcodigo, cp.CPdescripcion, coalesce(rcn.RCtc,1) as RCtc
		from
		    CalendarioPagos cp  
		inner join #H#RCalculoNomina rcn 
		    on rcn.RCNid = cp.CPid
		    inner join TiposNomina tn 
		        on rcn.Ecodigo = tn.Ecodigo
		        and rcn.Tcodigo = tn.Tcodigo 
		where rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoList#" list="true" />)
	</cfquery>

	<cfreturn rsFiltroEncab>
</cffunction>

<cffunction name="getQuery" returntype="query">
	<cf_dbtemp name="temp_DedCreditUnion" returnvariable="tDCU">
		<cf_dbtempcol name="DEid"				type="numeric"      mandatory="yes">
	    <cf_dbtempcol name="DEidentificacion"	type="varchar(60)"  mandatory="yes">
	    <cf_dbtempcol name="Nombre"				type="varchar(280)" mandatory="yes">
	    <cf_dbtempcol name="Cuenta" 			type="char(100)"  	mandatory="yes">
	    <cf_dbtempcol name="Salario" 	        type="money" 		mandatory="yes">
	    <cf_dbtempcol name="Porcentaje" 	    type="money" 		mandatory="yes">
	    <cf_dbtempcol name="MontoColones"		type="money"		mandatory="yes">
	    <cf_dbtempcol name="MontoDolares"		type="money"		mandatory="yes"> 
	    <cf_dbtempcol name="RChasta"		    type="datetime"		mandatory="no">	
	</cf_dbtemp>

	<cf_dbfunction name="op_concat" returnvariable="concat">
	<cf_dbfunction name="to_number" args="coalesce(rhp.Pvalor,'-1')" returnvariable="to_numberPvalor">	

	<cfquery datasource="#session.DSN#" name="rstemp">
		insert into #tDCU# (DEid, DEidentificacion, Nombre, Cuenta, Salario, Porcentaje, MontoColones, MontoDolares)
		select dte.DEid, dte.DEidentificacion, dte.DEnombre #concat#' '#concat# dte.DEapellido1 #concat#' '#concat# dte.DEapellido2 as Nombre, 
			coalesce(dte.DEdato5,'') as Cuenta, 
			0 Salario, max(dde.Dvalor) as Porcentaje, 
			SUM(dc.DCvalor) as MontoColones, 
			(case when coalesce(rcn.RCtc,1) = 1 then 0 else dc.DCvalor/ max(rcn.RCtc) end) as MontoDolares 
			<!---, max(rcn.RChasta) as RChasta--->
		from #H#RCalculoNomina rcn
		<!---inner join #H#PagosEmpleado pe
		    on rcn.RCNid = pe.RCNid--->
		inner join #H#DeduccionesCalculo dc
			on dc.RCNid = rcn.RCNid 
			inner join DeduccionesEmpleado dde
				on dc.Did = dde.Did
				inner join RHParametros rhp
			        on dde.TDid = #preservesinglequotes(to_numberPvalor)#
			        and dde.Ecodigo = rhp.Ecodigo
			        and rhp.Pcodigo = 2686 <!---Deducción Credit UNION--->
				inner join DatosEmpleado dte
					on dde.DEid = dte.DEid  
		where rcn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined('form.chk_FiltroFechas') >
			<cfif isdefined('form.FechaDesde') and LEN(TRIM(form.FechaDesde))>
				and rcn.RCdesde >= <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LsParseDateTime(Form.FechaDesde)#">		
		    </cfif>
		    <cfif isdefined('form.FechaHasta') and LEN(TRIM(form.FechaHasta))>
		  		and rcn.RChasta <= <cf_jdbcquery_param cfsqltype="cf_sql_date" 	value="#LsParseDateTime(Form.FechaHasta)#">		
		    </cfif>		 
		<cfelse>
		    <cfif isdefined("form.TcodigoList") and len(trim(form.TcodigoList)) GT 0>
				and rcn.RCNid in (<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TcodigoList#" list="true" />)
			</cfif>	
		</cfif>               
		group by 
			dte.DEid, dte.DEidentificacion, dte.DEnombre, dte.DEapellido1, dte.DEapellido2, dte.DEdato5, dc.DCvalor, rcn.RCtc
		order by dte.DEidentificacion, dte.DEnombre, dte.DEapellido1, dte.DEapellido2
	</cfquery>

	<!---<cfquery datasource="#session.DSN#">
		Update #tDCU#
		set Salario = (Select max(pe.PEsalario) 
			            from #H#PagosEmpleado pe
			            inner join #H#RCalculoNomina hrc
			                on pe.RCNid =  hrc.RCNid
			            Where #tDCU#.DEid = pe.DEid
			             	and #tDCU#.RChasta between pe.PEdesde and pe.PEhasta
			          )
	    Where exists 
	      			  (Select 1
			            from #H#PagosEmpleado pe
			            inner join #H#RCalculoNomina hrc
			                on pe.RCNid =  hrc.RCNid
			            Where #tDCU#.DEid = pe.DEid
			            	and #tDCU#.RChasta between pe.PEdesde and pe.PEhasta
			          )
	</cfquery>--->

	<cfquery datasource="#session.DSN#">
		Update #tDCU#
		set Salario = (Select lt.LTsalario
			            from LineaTiempo lt
			             Where #tDCU#.DEid = lt.DEid
			             and lt.LThasta = (Select max(LThasta) 
			             	               from LineaTiempo b
			             	               Where lt.DEid=b.DEid
			             	               )
			          )
	   <!--- Where Salario = 0--->
	</cfquery>

	<cfquery name="rsDedCredUnion" datasource="#session.DSN#">
		Select DEid, DEidentificacion, Nombre, Cuenta, Salario, Porcentaje, SUM(MontoColones) as MontoColones, SUM(MontoDolares) as MontoDolares
		from #tDCU#
		group by DEid, DEidentificacion, Nombre, Cuenta, Salario, Porcentaje
        order by DEidentificacion
	</cfquery>
	<!---<cf_dump var="#rsDedCredUnion#">--->
	
	
	<cfreturn rsDedCredUnion>
</cffunction>

<cffunction name="getHTML" output="true">	
	<cfargument name="rsDedCredUnion" type="query" required="true">

	<table class="reporte" width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<thead  style="display: table-header-group">	
			<tr>
				<th><strong>#LB_Identificacion#</strong></th>
	            <th><strong>#LB_Nombre#</strong></th>
	            <th><strong>#LB_NoCuenta#</strong></th>
	            <th><strong>#LB_Salario#</strong></th>
	            <th><strong>#LB_Porcentaje#</strong></th>   
	            <th><strong>#LB_MontoColones#</strong></th> 
	            <th><strong>#LB_MontoDolares#</strong></th> 
			</tr>
		</thead>		
		<tbody>
			<cfset LvarTotalSalario = 0>
			<cfset LvarTotalMontoCRC = 0>
			<cfset LvarTotalMontoUSD = 0>

			<cfloop query='Arguments.rsDedCredUnion'>
				<tr>
					<td align='left'>#DEidentificacion#</td>
					<td align='left' nowrap>#Nombre#</td>
					<td align='left' nowrap>#Cuenta#</td>
					<td align='right'><cf_locale name="number" value="#Salario#"/></td>
					<td align='right'>#int(Porcentaje)#</td>
					<td align='right'><cf_locale name="number" value="#MontoColones#"/></td>
					<td align='right'><cf_locale name="number" value="#MontoDolares#"/></td>

					<cfset LvarTotalSalario += Salario>
					<cfset LvarTotalMontoCRC += MontoColones>
					<cfset LvarTotalMontoUSD += MontoDolares>
				</tr>	
			</cfloop>

			<tr>
				<td align='right' colspan="3"><strong>#LB_Total#</strong></td>
				<td align='right'><strong><cf_locale name="number" value="#LvarTotalSalario#"/></strong></td>
				<td align='right'></td>
				<td align='right'><strong><cf_locale name="number" value="#LvarTotalMontoCRC#"/></strong></td>
				<td align='right'><strong><cf_locale name="number" value="#LvarTotalMontoUSD#"/></strong></td>
			</tr>	
		</tbody>
	</table>
</cffunction>		