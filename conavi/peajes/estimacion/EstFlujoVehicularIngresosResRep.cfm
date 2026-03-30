<!---<cfset mes = 'Enero,Feb,Marzo,Abril,Mayo,Junio,Julio,Agosto,Set,Oct,Nov,Dic'>	--->
<cfset registros = 0>
<cfset posicion = 0>
<cfset TotalflujoMensualEstimado = 0>
<cfset TotalflujoAnualEstimado = 0>	
<cfset TotalIngresoMensualEstimado = 0>	
<cfset TotalIngresoAnualEstimado = 0>	
<cfset IngresoTotalGeneral= 0>
<cfset FlujoTotalGeneral= 0>
<cfset Ingreso = 0>
<cfset flujo = 0>
<cfset TotalIngreso = 0>
<cfset Totalflujo = 0>
<cfset LvarNombreReporte = "Reporte Resumido de flujo e Ingresos">

<cfif IsDefined("url.Periodo") and len(trim(url.Periodo))>
	
	<cfif IsDefined("url.Peaje") and len(trim(url.Peaje)) and url.Peaje neq "all">
	 	<cfset LvarPid=  url.Peaje>       
		  <cfquery name="rsPeaje" datasource="#session.dsn#">
			select		
			  Pid, Pdescripcion
			  from Peaje 
			  where Pid = #LvarPid#			  
		  </cfquery>
	</cfif>  
		
	  <cfquery name="rsTiposVehiculos" datasource="#session.dsn#">
	  	select		
		  pv.PVid as PVid,
		  pv.PVdescripcion as vehiculo
		  from PVehiculos pv			  
	  </cfquery>
	  <table width="650" align="center" border="0" height="25px"> <!---inicio encabezado--->
				     <tr>
						 <td align="right"><strong>Usuario:</strong><cfoutput>#session.Usulogin#</cfoutput></td>
					 </tr>
				     <tr>
					      <td align="right"><strong>Fecha:</strong><cfoutput>#LSDateFormat(now(), 'dd/mm/yyyy')#</cfoutput></td>
				     </tr>
					 <tr><td align="center"><span class="titulox"><strong><font size="5"><cfoutput>#session.Enombre#</cfoutput></font></strong></span></td></tr>
					 <tr><td align="center"><span class="titulox"><strong><font size="3"><cfoutput>#LvarNombreReporte# 
					    <cfif isdefined("url.Peaje") and len(trim(url.Peaje)) and url.Peaje neq "all"> para el peaje: #rsPeaje.Pdescripcion# y </cfif>
                        <cfif isdefined("url.Periodo")and len(trim(url.Periodo))>   para el periodo: #url.Periodo#    </cfif>
                        </cfoutput></font></strong></span>
					 </td></tr>
      </table><!---fin encabezado--->
	  
      <table width="500" align="center" border="1" cellpadding="2" cellspacing="0"><!---inicio detalle--->
        	  <tr bgcolor="#666666">
			    	<td align="center"><strong>Tipo Vehículo</strong></td>
					<td align="center"><strong>Flujo Vehicular Est. Anual</strong></td>
					<td align="center"><strong>Ingresos estimados</strong></td>					
			  </tr>				
   <cfif rsTiposVehiculos.recordcount gt 0>
   	 <cfloop query="rsTiposVehiculos">
	 
	        <cfquery name="detalleIndividual" datasource="#session.dsn#">
				  select  
				       
					   co.COEPorcVariacion,
					   co.COEPerInicial as periodoInicial,
					   co.COEMesInicial as mesInicial,
					   co.COEPerFinal as periodoFinal,
					   co.COEMesFinal as mesFinal,
					   co.Pid,
					   sum(((co.COEPerFinal * 12 + co.COEMesFinal ) - ( co.COEPerInicial * 12 + co.COEMesInicial ) +1)) as totalmeses
				  from COEstimacionIng co
					   where co.COEPeriodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#url.Periodo#">
					   and co.PVid = #rsTiposVehiculos.PVid#
					  <cfif isdefined("url.Peaje") and len(trim(url.Peaje)) and url.Peaje neq "all">
					  and co.Pid = #LvarPid#
					  </cfif>
					   group by co.COEPorcVariacion,co.COEPerInicial, co.COEMesInicial, co.COEPerFinal, co.COEMesFinal,co.Pid
					   order by co.COEPorcVariacion,co.COEPerInicial, co.COEMesInicial, co.COEPerFinal, co.COEMesFinal,co.Pid
       </cfquery>
		
			<cfloop query="detalleIndividual">
			<cfset posicion = posicion - 1 >
					       	<cfif detalleIndividual.mesFinal eq 12 >				 
							<cfset perFinal = #detalleIndividual.periodoFinal# + 1 >			 
							<cfset  LvarFechaFinal = createdate(#perFinal#,'01','01')>
							<cfset LvarMaxDate= dateadd('s', -1, #LvarFechaFinal#)>					
					<cfelse>
							<cfset mesFinal = #detalleIndividual.mesFinal# + 1 >			  
							<cfset  LvarMaxDate = createdate(#detalleIndividual.periodoFinal#,#mesFinal# + 1,'01')>
					</cfif>
			    
			        <cfset  LvarFechaInicial = #detalleIndividual.periodoInicial#&'-'&detalleIndividual.mesInicial& '-'& '01 00:00:00'>
				  <cfquery name="rsdetalle" datasource="#session.dsn#">
					  Select  
						   coalesce(pt.Pid,0) as Pid, 
						   coalesce( pd.PVid,0) as PVid,
						   coalesce(sum(pd.PDTVcantidad), 0) as cantidad
					  from PDTVehiculos pd
						   inner join PETransacciones  pt
							   on pd.PETid = pt.PETid
						   where pt.PETfecha  between  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaInicial#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarMaxDate#">
							   and pd.PVid = #rsTiposVehiculos.PVid#
							   and pt.Pid = #detalleIndividual.Pid#
							   group by  pt.Pid,pd.PVid
							   order by  pt.Pid, pd.PVid  					   
		      </cfquery>
				   <cfquery name="PrecioVehiculo" datasource="#session.dsn#">
					  Select  PPrecio 
					  from PPrecio
					  where Pid = #detalleIndividual.Pid#
					  and PVid = #rsTiposVehiculos.PVid#
				   </cfquery>	   
			       <cfif #rsdetalle.cantidad# neq '' and #detalleIndividual.totalmeses# neq '' and #PrecioVehiculo.recordcount# gt 0 >
					    
						<cfset PromedioVehicular = #rsdetalle.cantidad# / #detalleIndividual.totalmeses#>  
		    	   				              
						<cfset PromedioFlujoVehicularEstimado =    #PromedioVehicular# + (#PromedioVehicular# * #detalleIndividual.COEPorcVariacion# /100)> 
     		    	
		           		<cfset PromedioMensualIngresoEstimado = #PrecioVehiculo.PPrecio# * #PromedioFlujoVehicularEstimado#>
					
					    <cfset FlujoVehicularEstimadoAnual=  #PromedioFlujoVehicularEstimado# * 12>  
		                
		                <cfset PromedioAnualIngresoEstimado = #FlujoVehicularEstimadoAnual# * #PrecioVehiculo.PPrecio#>	
			         
						<cfif registros eq 0 and registros neq #rsTiposVehiculos.PVid# >      <!----- Ejec  1 ---->	
											    
						    <cfset LvarVehiculoDes= #rsTiposVehiculos.vehiculo#>
						 	<cfset LvarVehiculoDes= #rsTiposVehiculos.vehiculo#>
							<cfset flujo = FlujoVehicularEstimadoAnual>
                            <cfset Ingreso = PromedioAnualIngresoEstimado>						
                            <cfset registros = #rsTiposVehiculos.PVid#>	
						
                           <!--- <cfset Totalflujo = Totalflujo + flujo>												
							<cfset TotalIngreso = TotalIngreso + Ingreso>--->
							
						<cfelseif registros neq 0 and registros eq #rsTiposVehiculos.PVid#>   <!----- Ejec  2 ---->	
						 
							<cfset LvarVehiculoDes= #rsTiposVehiculos.vehiculo#>						   
							<cfset flujo = flujo + FlujoVehicularEstimadoAnual>							
                            <cfset Ingreso = Ingreso + PromedioAnualIngresoEstimado>
							
						<!---	<cfset Totalflujo = Totalflujo + flujo>												
							<cfset TotalIngreso = TotalIngreso + Ingreso> --->
						
						<cfelseif  registros neq 0 and registros neq #rsTiposVehiculos.PVid#> <!----- Ejec  3 ---->	
									  
						      <tr>
									<td align="center"><cfoutput>#LvarVehiculoDes#</cfoutput></td>
									<td align="right"><cfoutput>#numberFormat(flujo,',9')#</cfoutput></td>
									<td align="right"><cfoutput>¢#numberFormat(Ingreso,',9.00')#</cfoutput></td>									
							  </tr>											  				 						
						  	<cfset Totalflujo = Totalflujo + flujo>												
							<cfset TotalIngreso = TotalIngreso + Ingreso> 
							
							<cfset LvarVehiculoDes= #rsTiposVehiculos.vehiculo#>							
     						<cfset Ingreso = 0>
                            <cfset flujo = 0> 
							
							<cfset flujo= FlujoVehicularEstimadoAnual>
                            <cfset Ingreso = PromedioAnualIngresoEstimado>
							<cfset registros = #rsTiposVehiculos.PVid#>
							
							
													     
			         </cfif>							  
										
 		
			  </cfif> <!---cantidad neq '' and  totalmeses neq '' and  precio vehiculo neq ''----->
				
			</cfloop>				                	
					
	 </cfloop>	
                     
					  <cfif  TotalIngreso gt 0 and Totalflujo gt 0 > 
     					<cfset Totalflujo = Totalflujo + flujo>												
						<cfset TotalIngreso = TotalIngreso + Ingreso> 
						       <tr>
									<td align="center"><cfoutput>#LvarVehiculoDes#</cfoutput></td>
									<td align="right"><cfoutput>#numberFormat(flujo,',9')#</cfoutput></td>
									<td align="right"><cfoutput>¢#numberFormat(Ingreso,',9.00')#</cfoutput></td>									
							  </tr>	
							   <tr bgcolor="#CCCCCC">
									<td align="center"><strong>Total:</strong></td>
									<td align="right"><strong><cfoutput>#numberFormat(Totalflujo,',9')#</cfoutput></strong></td>
									<td align="right"><strong><cfoutput>¢#numberFormat(TotalIngreso,',9.00')#</cfoutput></strong></td>									
							  </tr>
						<cfelseif detalleIndividual.recordcount eq 0 and TotalIngreso eq 0 and Totalflujo eq 0 >
						 <tr>
									<td  colspan="3"align="center"> --------------    No hay resgistros  -------------- </td>
									
						  </tr>	  	
					   </cfif>
							  
							  
	 </table>  
 </cfif>
</cfif>


