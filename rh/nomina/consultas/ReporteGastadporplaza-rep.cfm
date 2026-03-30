<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RepGastoxPlanxPLZ" Default="Reporte de Gastado por planilla por Plaza " returnvariable="LB_RepGastoxPlanxPLZ"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Prog" Default="Programa" returnvariable="LB_Prog"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescUnidad" Default="Descripci&oacute;n de la unidad " returnvariable="LB_DescUnidad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Planilla" Default="Planilla" returnvariable="LB_Planilla"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaDesde" Default="Desde" returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaHasta" Default="Hasta" returnvariable="LB_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_BaseSal" Default="Base Salarial" returnvariable="LB_BaseSal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CodPLZ" Default="C&oacute;digo" returnvariable="LB_CodPLZ"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Plaza" Default="Plaza" returnvariable="LB_Plaza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CodDepto" Default="C&oacute;digo" returnvariable="LB_CodDepto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescripDepto" Default="Departamento" returnvariable="LB_DescripDepto"/>
<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>

<style>
.detalle {
		font-size:10px;
		text-align:left;}
</style>		
		  
<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		  
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
		<cfif rsGastadoCompXPlz.RecordCount>
			<tr>				
		    <cfoutput query="rsGastadoCompXPlz" group="RCNid">	
				<tr>	
					<td colspan="10" align="center">				 
					<table width="97%" cellspacing="0" cellpadding="0">					
						<cf_EncReporte
						Titulo="#LB_RepGastoxPlanxPLZ#" 
						Color="##E3EDEF" 	
						filtro1="&nbsp;#LB_Planilla#:&nbsp;#RCDescripcion#&nbsp;#LB_FechaDesde#:&nbsp;#DateFormat(RCdesde, "mmmm d, yyyy")# &nbsp;#LB_FechaHasta#:&nbsp; #DateFormat(RChasta,"mmmm d, yyyy")#" 							
						>		
					</td>	
				</tr>
								
				<tr><td>&nbsp;</td></tr>
				<tr class="tituloListas">					
						<td class="detalle" ><strong>#LB_CodPLZ#</strong></td>
						<td class="detalle" ><strong>#LB_Plaza#</strong></td>
						<td class="detalle"><strong>#LB_Prog#</strong></td>
						<td class="detalle"><strong>#LB_CodDepto#</strong></td>				
						<td class="detalle"><strong>#LB_DescripDepto#</strong></td>							
						<td class="detalle"><strong>#LB_BaseSal#</strong></td>	
													
						<cfquery name="rsColumnas" datasource="#session.DSN#">
							select RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion, RHRPTNcodigo
							from RHReportesNomina a
								inner join RHColumnasReporte b
									on b.RHRPTNid = a.RHRPTNid 
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and a.RHRPTNcodigo = 'REPRE'
						</cfquery>	
																	
						<cfloop query="rsColumnas">
							<td align="right" class="detalle" ><strong>#RHCRPTdescripcion#</strong></td>		
						</cfloop>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<cfoutput group="RHPid">				
					<tr>
						<td class="detalle">#RHPcodigo#</td> 
						<td class="detalle">#RHPdescripcion#</td> 
						<td class="detalle">#oficina#</td> 
						<td class="detalle">#Deptocodigo#</td>
						<td class="detalle">#Ddescripcion#</td>
						<td class="detalle">#LSNumberFormat(montoSalBase,'99.99')#</td> 
						<cfset RCNid = #RCNid#>													
						<cfset RHPid = #RHPid#>
																	  
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
									Select  sum(HincCal.ICmontores) as monto
									
									from 
										 HIncidenciasCalculo HincCal						
									where HincCal.RCNid = #RCNid# 
									 and HincCal.CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CSid1#" list="yes">  )

									and HincCal.CFid = (select DISTINCT plz.CFid
													from HPagosEmpleado HPagos 
														,RHPlazas plz
													where HPagos.RCNid = HincCal.RCNid
													and HPagos.DEid = HincCal.DEid
													and plz.RHPid =  HPagos.RHPid
													and HPagos.RHPid=#RHPid# )
														
								</cfquery>																					
								<!--- <cf_dump var="#rsHincidencias#">--->
										
									<cfset monto = rsHincidencias.monto>
							</cfif>									
							 <td align="right" class="detalle">#LSNumberFormat(monto, '99.99')#</td>																				
					</cfloop>		
		 	   </tr>
		   <tr><td>&nbsp;</td></tr>		
		 	</cfoutput> <!--- Agrupado por la plaza --->
					
    </cfoutput> <!--- Agrupado por la nomina --->		  				
	  	</table>		
		<cfelse>
		<table width="792" align="center" border="0" cellspacing="0" cellpadding="2">
		<cfoutput>
			<tr><td align="center"class="titulo_empresa2"><strong>#LB_NoHayDatosRelacionados#</strong></td></tr>
		</cfoutput>
		</table>			
	</cfif>
				
	</cfsavecontent>


		
	<cfoutput>	    
	<cfset LvarFileName = "ReportePresupuestoporCentroCosto#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">	
	<cf_htmlReportsHeaders 
			title="#LB_RepGastoxPlanxPLZ#" 
			filename="#LvarFileName#"
			irA="ReporteGastadporporplaza-filtro.cfm"
			back="no"
			back2="yes" 
			>	
    	<cf_templatecss>
		 #Reporte#		 
 	</cfoutput>
