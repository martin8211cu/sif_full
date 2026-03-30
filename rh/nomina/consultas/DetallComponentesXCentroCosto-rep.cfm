<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DetalleDeComponentesPorCentroCosto" Default="Componentes por Centro de Costo " returnvariable="LB_DetalleDeComponentesPorCentroCosto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CentroCosto" Default="C.COSTO" returnvariable="LB_CentroCosto"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Unidad" Default="Centro Funcional" returnvariable="LB_Unidad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Programa" Default="Programa" returnvariable="LB_Programa"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Plaza" Default="PLAZAS" returnvariable="LB_Plaza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Totales" Default="T O T A L E S" returnvariable="LB_Totales"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TiemposCompletos" Default="TIEMPOS COMPLETOS " returnvariable="LB_TiemposCompletos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="MONTO" returnvariable="LB_Monto"/>
<style>
.detalle {
		font-style:italic;
		font-size:12px;
		}
</style>


  <!---<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>		
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">		
	<cf_web_portlet_start titulo="#LB_DetalleDeComponentesPorCentroCosto#">--->
	
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	
	 <cfsavecontent variable="Reporte">			
		<table width="85%" style="padding-left: 5px; padding-right: 5px;" align="center" border="0">
		 <tr>	
			<td colspan="3" <!---align="center"--->>			 			
					
				<cf_EncReporte
				Titulo="#LB_DetalleDeComponentesPorCentroCosto#" 
				Color="##E3EDEF" 					
				>				
			</td>	
		 </tr>				  			
			<cfoutput query="rsComponentesPlazaPresup" group="Odescripcion"> 		
			<tr><td colspan="3"  align="left">#LB_Programa#:&nbsp;#Odescripcion#</td> </tr>		
			<cfoutput  group="CFdescripcion"> 				 
				 <tr>
				     <td  <!---class="tituloListas"---> align="left">#LB_Unidad#:&nbsp;</td>
					 <td  <!---class="tituloListas"---> align="left">#CFdescripcion#</td>
				     <td <!---class="tituloListas"--->  align="left"><strong>#LB_CentroCosto#:&nbsp;#centroCostos#</strong></td>
					
				</tr>			
			 	 <tr><td>&nbsp;</td></tr>	
				 
										
				<cfquery name="rsComponentesXCentroFunc"  datasource="#session.DSN#">
						select 
								d.CScodigo,d.CSdescripcion, sum(c.Monto) as Monto
																 
								from RHEscenarios a
								inner join RHFormulacion b
									on b.RHEid = a.RHEid
									and  b.Ecodigo = a.Ecodigo
								
								inner join RHCFormulacion c
									on c.RHFid = b.RHFid
									and c.Ecodigo = b.Ecodigo
								
								inner join ComponentesSalariales d
									on d.CSid = c.CSid
									and d.Ecodigo = c.Ecodigo
								
								inner join RHPlazaPresupuestaria e
									on e.RHPPid = b.RHPPid
									and e.Ecodigo = d.Ecodigo
								
								inner join RHPlazas f
									on f.RHPPid = e.RHPPid
									and f.Ecodigo = e.Ecodigo
																									
								inner join CFuncional g
									on g.CFid = f.CFid
									and g.Ecodigo = f.Ecodigo
									and g.CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFcodigo#">
								
								inner join Oficinas ofic
									on ofic.Ocodigo = g.Ocodigo
									and ofic.Ecodigo = a.Ecodigo
								
								where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								  and a.RHEid = #RHEid#	
																  
								  group by d.CScodigo,d.CSdescripcion, c.Monto							 
						</cfquery>
						
					<cfset totalCentroCosto = 0>								
					<cfloop query="rsComponentesXCentroFunc">										
						<tr>	
							<td>&nbsp;</td>													
							<td align="right" class="detalle">#rsComponentesXCentroFunc.CScodigo#&nbsp;&nbsp;&nbsp;#CSdescripcion#</td>																															
							<td align="right" class="detalle" width="25%">#LSNumberFormat(Monto, '999,999,999.99')#</td>														
							<cfset totalCentroCosto = totalCentroCosto + Monto >
							
						</tr>  					
					</cfloop>	
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td>
						<td align="center" class="detalle"><strong>#LB_Totales#</strong></td>	
					</tr>		
					<tr>
						<td class="detalle"><strong>#LB_Plaza#:&nbsp;&nbsp;#cantidadPlazas#</strong></td>
						<td class="detalle"><strong>#LB_TiemposCompletos#:&nbsp;&nbsp;#tiemposCompl#&nbsp;&nbsp;&nbsp;&nbsp;#LB_Monto#:</strong></td>
						<td align="right" class="detalle"><strong>#LSNumberFormat(totalCentroCosto, '999,999,999.99')#</strong></td>											
					</tr>
					<!---<tr><td>----------------------------</td></tr>--->
						 							  		
		 </cfoutput><!--- AGRUPADO POR LA OFICNA --->
	   </cfoutput><!--- AGRUPADO POR EL CENTRO FUNCIONAL--->		 
  </table>					
																														             	
	</cfsavecontent>
	  <cfoutput>
	    
	<cfset LvarFileName = "LB_DetalleDeComponentesPorCentroCosto#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
		<cf_htmlReportsHeaders 
			title="#LB_DetalleDeComponentesPorCentroCosto#" 
			filename="#LvarFileName#"
			irA="DetallComponentesXCentroCosto-filtro.cfm"
			back="no"
			back2="yes" 
			>	
		  <cf_templatecss>	
		 #Reporte#

 </cfoutput>
<!---<cf_web_portlet_end>
<cf_templatefooter>	--->	
	