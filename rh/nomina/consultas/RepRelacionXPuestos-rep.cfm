<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_REsum_RelacionPuestos" Default="Resumen General de Relación de Puestos" returnvariable="LB_REsum_RelacionPuestos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Categoria" Default="Cat." returnvariable="LB_Categoria"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_codigoPuesto" Default="Puecod" returnvariable="LB_codigoPuesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TiempoCompleto" Default="T.C" returnvariable="LB_TiempoCompleto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Plazas" Default="No Plazas" returnvariable="LB_Plazas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_BaseActual" Default="Base Actual" returnvariable="LB_BaseActual"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_BasePropuesta" Default="Base Propuesta" returnvariable="LB_BasePropuesta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalAnual" Default="Total Anual" returnvariable="LB_TotalAnual"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Totales" Default="Totales" returnvariable="LB_Totales"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Total" Default="Total" returnvariable="LB_Total"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OtrosIncentivos" Default="Resumen de Otros Incentivos" returnvariable="LB_OtrosIncentivos"/>

  <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>		
	<!---<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">		
	<cf_web_portlet_start titulo="#LB_REsum_RelacionPuestos#">--->

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	
	
	 <cfsavecontent variable="Reporte">	
		<table width="75%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">		
		 <tr>	
			<td colspan="8" align="center">				 
			<table width="97%" cellspacing="0" cellpadding="0">					
				<cf_EncReporte
				Titulo="#LB_REsum_RelacionPuestos#" 
				Color="##E3EDEF" 					
				>		
			</td>	
		  </tr>
		  <cfoutput>
		  <tr class="tituloListas">
		  	<td align="left"><strong>#LB_Categoria#</strong></td>
			<td ><strong>#LB_codigoPuesto#</strong></td>			
			<td align="center"><strong>#LB_Puesto#</strong></td>
		 	<td align="center"><strong>#LB_TiempoCompleto#</strong></td>
		 	<td align="center"><strong>#LB_Plazas#</strong></td>
			<td align="center"><strong>#LB_BaseActual#</strong></td>
			<td align="center"><strong>#LB_BasePropuesta#</strong></td>
		  	<td align="center"><strong>#LB_TotalAnual#</strong></td>
		   </tr>
		   <tr><td>&nbsp;</td></tr>
			
			<cfset totalTiempoComp = 0>	
			<cfset totalCantPLZ = 0>	
			<cfset totalTotalAnual = 0>	
				
			<cfloop query="rsResumenPuestos">		
				 <tr>				 
					<td align="left">#RHCcodigo#</td> 
					<td >#RHPcodigo#</td> 	
					<td align="left">#RHPdescpuesto#</td> 	
					<td align="right">#tiemposCompl#</td> 
					<td align="right">#cantPlz#</td> 	
					<td align="right">&nbsp;#LSNumberFormat(baseActual, '999,999,999.99')#</td>	
					<td align="right">&nbsp;#LSNumberFormat(basePropuesta, '999,999,999.99')#</td>	
					<td align="right">&nbsp;#LSNumberFormat(totalAnual, '999,999,999.99')#</td>	
					<cfset totalTiempoComp = totalTiempoComp + tiemposCompl >		
					<cfset totalCantPLZ = totalCantPLZ + cantPlz>	
					<cfset totalTotalAnual = totalTotalAnual + totalAnual>						
				</tr>						
			</cfloop>
				<tr><td>&nbsp;</td></tr>
				<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td><strong>#LB_Totales#:</strong></td>
						<td align="right"><strong>#LSNumberFormat(totalTiempoComp, '999,999,999.99')#</strong></td>
						<td align="right"><strong>#totalCantPLZ#</strong></td>					
						<td align="right">&nbsp;</td>
						<td align="right">&nbsp;</td>
						<td align="right"><strong>#LSNumberFormat(totalTotalAnual, '999,999,999.99')#</strong></td>	
				</tr>
				
				<tr><td align="right">&nbsp;</td></tr>
				<tr><td align="right" colspan="2" nowrap="nowrap"><strong>#LB_OtrosIncentivos#:</strong></td></tr>
					
				<cfset TotalOtrosIncent= 0 >
				<cfloop query="rsResumOtrosIncent">		 					
						<tr>						
						<td align="right">&nbsp;</td>
						<td align="right">&nbsp;</td>
						<td align="right" nowrap="nowrap">#CSdescripcion#</td>
						<td align="right">#LSNumberFormat(monto, '999,999,999.99')#</td>	</tr>	
						<cfset TotalOtrosIncent= TotalOtrosIncent +  monto >			
				</cfloop>	
										
					<tr><td align="right">&nbsp;</td></tr>
					<tr>
						<td align="right">&nbsp;</td>
						<td align="right">&nbsp;</td>
						<td><strong>#LB_Total#</strong></td>
						<td align="right"><strong>#LSNumberFormat(TotalOtrosIncent, '999,999,999.99')#</strong></td>
					</tr>
					
				</cfoutput>	
	  	</table>				
	</cfsavecontent>
	
	<cfoutput>	    
	<cfset LvarFileName = "ResumenGeneraldeRelacionPuestos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	
	<cf_htmlReportsHeaders 
			title="#LB_REsum_RelacionPuestos#" 
			filename="#LvarFileName#"
			irA="RepRelacionXPuestos-filtro.cfm"
			back="no"
			back2="yes" 
			>	
    	<cf_templatecss>
		 #Reporte#
		 
 	</cfoutput>
<!---<cf_web_portlet_end>
<cf_templatefooter>	
--->