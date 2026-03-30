<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Planilla" Default="Planilla" returnvariable="LB_Planilla"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaDesde" Default="Desde" returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaHasta" Default="Hasta" returnvariable="LB_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RepGastoXPlanillaXUnid" Default="Reporte de Gastado por Planilla por Unidad " returnvariable="LB_RepGastoXPlanillaXUnid"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescUnidad" Default="Descripci&oacute;n de la unidad " returnvariable="LB_DescUnidad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_BaseSal" Default="Base Salarial" returnvariable="LB_BaseSal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Plaza" Default="Plaza" returnvariable="LB_Plaza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Unidad" Default="Unidad" returnvariable="LB_Unidad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cod" Default="C&oacute;digo" returnvariable="LB_Cod"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescripDepto" Default="Departamento" returnvariable="LB_DescripDepto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Prog" Default="Programa" returnvariable="LB_Prog"/>
  
<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:15px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:15px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:15px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:16px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:10px;
		text-align:left;}
	.detaller {
		font-size:15px;
		text-align:right;}
	.detallec {
		font-size:15x;
		text-align:center;}	
		
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>
  
  
  <cfinvoke component="sif.Componentes.Translate"  
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>		

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		
	 <cfsavecontent variable="Reporte">	
		<table width="95%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">		
		 <tr>	
			<td colspan="9" align="center">				 
			<table width="97%" cellspacing="0" cellpadding="0" border="1">					
				<cf_EncReporte
				Titulo="#LB_RepGastoXPlanillaXUnid#" 
				Color="##E3EDEF" 								
				>		
			</td>	
		  </tr>
	<cfif rsGastadoXPlanillaCFunc.RecordCount>
		  
		  <cfoutput query="rsGastadoXPlanillaCFunc">	
		  <tr><td>&nbsp;</td></tr>	
		
		 	<cfoutput group="RCNid">
		
			<tr class="listaCorte1"> <td colspan="11">&nbsp;#LB_Planilla#:&nbsp;#RCDescripcion#&nbsp;#LB_FechaDesde#:&nbsp;#DateFormat(RCdesde, "mmmm d, yyyy")# &nbsp;#LB_FechaHasta#:&nbsp; #DateFormat(RChasta,"mmmm d, yyyy")#</td></tr>
			<cfoutput group="CFid">
		  		<tr class="listaCorte2"><td colspan="11">&nbsp;#LB_Unidad#:&nbsp;#CFdescripcion#</td></tr>
		        <tr><td>&nbsp;</td></tr>				  
		 		<tr class="tituloListas">		  									
					<td class="detalle" align="right"><strong>#LB_Prog#</strong></td>
					<td class="detalle" align="right"><strong>#LB_Cod#</strong></td>				
					<td class="detalle" align="right"><strong>#LB_DescripDepto#</strong></td>							
					<td class="detalle" align="right"><strong>#LB_BaseSal#</strong></td>						
					<cfquery name="rsColumnas" datasource="#session.DSN#">
						select RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion, RHRPTNcodigo
						from RHReportesNomina a
							inner join RHColumnasReporte b
								on b.RHRPTNid = a.RHRPTNid 
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and a.RHRPTNcodigo = 'REPRE'
					</cfquery>									
					<cfloop query="rsColumnas">
						<td align="right" class="detalle" ><strong>&nbsp;#RHCRPTdescripcion#</strong></td>		
					</cfloop></tr>
		
				<tr>												
					<td class="detalle" nowrap="nowrap">#Odescripcion#</td> 					
					<td class="detalle">#Deptocodigo#</td>
					<td class="detalle"nowrap="nowrap">#Ddescripcion#</td>
					<td align="right" class="detalle">#LSNumberFormat(montoSalBase,'99.99')#</td> 
			
					<cfset CFid = #CFid#>															  
					<cfloop query="rsColumnas">																	
					<cfquery name="rsCIid" datasource="#session.DSN#">
					 select distinct a.CIid
					   from RHReportesNomina c
						inner join RHColumnasReporte b
						inner join RHConceptosColumna a
							on a.RHCRPTid = b.RHCRPTid
							on b.RHRPTNid = c.RHRPTNid
							and b.RHCRPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsColumnas.RHCRPTcodigo#">  
						where c.RHRPTNcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsColumnas.RHRPTNcodigo#">
						and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>
							
					<cfset monto = 0>
					 <cfif rsCIid.RecordCount gt 0 and len(trim(rsCIid.CIid))>				 				 
				 		<cfset Lvar_CSid1 = ValueList(rsCIid.CIid)>			
										
						<cfquery name="rsHincidencias" datasource="#session.DSN#">
							select  
								sum(HincCal.ICmontores) as monto
								, HincCal.CFid
															
							from CalendarioPagos calPago,
								 HSalarioEmpleado sqlEmpl,
								 HIncidenciasCalculo HincCal
							
								where 
								calPago.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">			
								<cfif isdefined('form.FECHA') and len(trim(form.FECHA))>
									and calPago.CPhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#nuevaFecha#"> 
								</cfif>	
								<cfif isdefined('form.anno') and len(trim(form.anno))>	
									and calPago.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anno#">
								</cfif>
								 <cfif isdefined('form.CPcodigo' ) and len(trim(form.CPcodigo)) >
									and calPago.CPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.CPcodigo)#">
								</cfif>	
								 <cfif isdefined('form.Tcodigo' ) and len(trim(form.Tcodigo)) >
									and calPago.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
								</cfif>	
							
								and sqlEmpl.RCNid = calPago.CPid 
							
							 	and HincCal.RCNid = sqlEmpl.RCNid 
							 	and HincCal.DEid = sqlEmpl.DEid
							 	and HincCal.CFid = #CFid#		
							 	and HincCal.CIid =(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid1#" list="yes">  )
							 					
								group by  HincCal.CFid
						</cfquery>
						<cfset monto = rsHincidencias.monto>
					</cfif>									
					 <td align="right" class="detalle">#LSNumberFormat(monto, '99.99')#</td>
																		
			</cfloop>		
		 	   </tr>
		   <tr><td>&nbsp;</td></tr>	
		 
		   			</cfoutput>	<!--- Agrupado por el Centro Funcional --->
				</cfoutput>	<!--- Agrupado por planilla --->								
			</cfoutput>		
			<cfelse>
				<table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
				<cfoutput>
					<tr><td align="center"class="titulo_empresa2"><strong>#LB_NoHayDatosRelacionados#</strong></td></tr>
				</cfoutput>
				</table>				
			  </cfif>				
	  	</table>				
	</cfsavecontent>
	
	<cfoutput>	    
	<cfset LvarFileName = "ReportePresupuestoporCentroCosto#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">	
	<cf_htmlReportsHeaders 
			title="#LB_RepGastoXPlanillaXUnid#" 
			filename="#LvarFileName#"
			irA="ReporteGastadporPlanillaXCentroFunc-filtro.cfm"
			back="no"
			back2="yes" 
			>	
    	<cf_templatecss>
		 #Reporte#		 
 	</cfoutput>
