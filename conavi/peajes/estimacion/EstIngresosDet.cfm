<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cfset mes = 'Enero,Feb,Marzo,Abril,Mayo,Junio,Julio,Agosto,Set,Oct,Nov,Dic'>	
<cfset posicion = 0>
<cfset TotalflujoMensualEstimado = 0>
<cfset TotalflujoAnualEstimado = 0>	
<cfset TotalIngresoMensualEstimado = 0>	
<cfset TotalIngresoAnualEstimado = 0>	
<cfset IngresoTotalGeneral= 0>
<cfset FlujoTotalGeneral= 0>
<cfset LvarMonto = 0>
<cfset PromedioVehicular = 0>

<cfif isdefined ('form.COEPeriodo')>
	<cfset LvarPeriodo = #form.COEPeriodo#>
<cfelse>
	<cfquery name="Periodos" datasource="#session.dsn#">
		select a.CPPanoMesDesde /100 periodo, a.Mcodigo
		from CPresupuestoPeriodo a
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPPid = #CPPid#
	</cfquery>
	<cfset LvarPeriodo = #Periodos.periodo#>
</cfif>

	<cfset LvarNombreReporte = "Reporte Detallado de flujo e Ingresos">
	
	  <cfquery name="rsParametrosPeaje" datasource="#session.dsn#">
	  	select
			 co.COEEstado,
			 cf.CFdescripcion,
			 p.Pid as Pid,
			 p.Pdescripcion as peaje,
			 pv.PVid as PVid,
			 co.COEPeriodo,
			 co.COEPorcVariacion,
			 pv.PVdescripcion as vehiculo,
			 max(((co.COEPerFinal * 12 + co.COEMesFinal ) - ( co.COEPerInicial  * 12 + co.COEMesInicial ) +1)) as totalmeses			
        from PVehiculos pv
			left outer join COEstimacionIng co
				on pv.PVid = co.PVid
			inner join Peaje p
				on co.Pid= p.Pid
			inner join CFuncional cf
				on cf.CFid = p.CFid
			where co.COEPeriodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarPeriodo#">
			<cfif isdefined('url.LvarEstimar') and url.LvarEstimar eq 'TRUE'>
				and co.COEEstado = '2'
			</cfif>
			<cfif isdefined('url.Pid') and url.Pid neq ''>
				and p.Pid  = #url.Pid#
			</cfif>

			group by p.Pid,p.Pdescripcion,pv.PVid,co.COEPeriodo,co.COEPorcVariacion,pv.PVdescripcion,cf.CFdescripcion,co.COEEstado
			order by p.Pid,p.Pdescripcion,pv.PVid,co.COEPeriodo,co.COEPorcVariacion,pv.PVdescripcion,cf.CFdescripcion,co.COEEstado	
	  </cfquery> 
	  
	 	  <table width="100%" align="center" border="0" height="25px">
			   <tr>
				 	<td align="right"><strong>Usuario:</strong><cfoutput>#session.Usulogin#</cfoutput></td>
			   </tr>
			   <tr>
			  		<td align="right"><strong>Fecha:</strong><cfoutput>#LSDateFormat(now(), 'dd/mm/yyyy')#</cfoutput></td>
			   </tr>
			   <tr>
			 		<td align="center"><span class="titulox"><strong><font size="5"><cfoutput>#session.Enombre#</cfoutput></font></strong></span></td></tr>
			   <tr>
			  		<td align="center"><span class="titulox"><strong><font size="3"><cfoutput>#LvarNombreReporte#</cfoutput></font></strong></span></td>
				</tr>
       	</table>
       	
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
					<td colspan="11"><em><strong>&nbsp;Estimación de Ingresos para el año:<cfoutput>#numberFormat(LvarPeriodo,'9')#</cfoutput></strong></em></td>					
			  	</tr>
	
			   <tr>
			      <td colspan="11"><em><strong>&nbsp;</strong></em></td>
			   </tr>
			   <tr bgcolor="#CCCCCC">
			      <td align="center"><strong> Centro Funcional </strong></td>
			      <td align="center"><strong> Peaje </strong></td>
					<td align="center"><strong>Tipo Vehículo</strong></td>
					<td align="center"><strong> Desde - Hasta </strong></td>
					<td align="center"><strong>Prom. Vehicular </strong></td>
					<td align="center"><strong>% Variación </strong></td>
					<td align="center"><strong>Prom.Flujo Vehicular Est. Mensual </strong></td>
					<td align="center"><strong>Flujo Vehicular Est. Anual</strong></td>
					<td align="center"><strong> Tarifa </strong></td>
					<td align="center"><strong>Prom. mensual ingreso Est. </strong></td>
					<td align="center"><strong>Ingresos estimados</strong></td>
			  </tr>				
   <cfif rsParametrosPeaje.recordcount gt 0>
   <cfset LvarMonto = 0>
   <cfset LvarPromedioVehicular = 0>
   	 <cfloop query="rsParametrosPeaje">
	         <cfquery name="detalleIndividual" datasource="#session.dsn#">
				  select  
					   co.COEPorcVariacion,
					   co.COEPerInicial as periodoInicial,
					   co.COEMesInicial as mesInicial,
					   co.COEPerFinal as periodoFinal,
					   co.COEMesFinal as mesFinal,
					   sum(((co.COEPerFinal * 12 + co.COEMesFinal ) - ( co.COEPerInicial * 12 + co.COEMesInicial ) +1)) as totalmeses
				  from COEstimacionIng co
					   where co.COEPeriodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarPeriodo#">
					   and co.Pid =  #rsParametrosPeaje.Pid#
					   and co.PVid = #rsParametrosPeaje.PVid#
					   group by co.COEPorcVariacion,co.COEPerInicial, co.COEMesInicial, co.COEPerFinal, co.COEMesFinal
					   order by co.COEPorcVariacion,co.COEPerInicial, co.COEMesInicial, co.COEPerFinal, co.COEMesFinal
	         </cfquery>

			 <cfif detalleIndividual.mesFinal eq 12 > <!----Si el mes es 12 (Diciembre), no se le suma al periodo + 1 , se pone el mes en 01 y el dia tambien ....----->		 
			                                          <!---y se le resta un segundo dandonos el ultimo dia del año a los 11:59:59--->  
			    <cfset perFinal = #detalleIndividual.periodoFinal# + 1 >			 
			    <cfset  LvarFechaFinal = createdate(#perFinal#,'01','01')>
			    <cfset LvarMaxDate= dateadd('s', -1, #LvarFechaFinal#)>					
			<cfelse>
			    <cfset mesFinal = #detalleIndividual.mesFinal# + 1 >	 <!-------Si el mes es diferente de 12, se le agrega un mes mas y se le resta un segundo, dandonos el ultimo dia del mes a las 11:59:59---------->			
  			    <cfset  LvarMaxDate = createdate(#detalleIndividual.periodoFinal#,#mesFinal#,'01')>
				 <cfset LvarMaxDate= dateadd('s', -1, #LvarMaxDate#)>				
			</cfif>
			    <cfset  LvarFechaInicial = #detalleIndividual.periodoInicial#&'-'&detalleIndividual.mesInicial& '-'& '01 00:00:00'>
				 
      		<cfquery name="rsdetalle" datasource="#session.dsn#">
				 	 select  
					   coalesce(pt.Pid,0) as Pid, 
					   coalesce( pd.PVid,0) as PVid,
					   coalesce( sum(pd.PDTVcantidad), 0) as cantidad
				 	 from PDTVehiculos pd
					   inner join PETransacciones  pt
						   on pd.PETid = pt.PETid
					  where pt.PETfecha  between  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFechaInicial#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarMaxDate#">
						and pt.Pid = #rsParametrosPeaje.Pid#
						and pd.PVid = #rsParametrosPeaje.PVid#
						group by  pt.Pid,pd.PVid
						order by  pt.Pid, pd.PVid  					   
			   </cfquery>	
			   
			   <cfquery name="PrecioVehiculo" datasource="#session.dsn#">
			      Select  PPrecio 
				  from PPrecio
				  where Pid = #rsParametrosPeaje.Pid#
				  and PVid = #rsParametrosPeaje.PVid#
			   </cfquery>
			  
			    <cfif #rsdetalle.cantidad# neq '' and #detalleIndividual.totalmeses# neq '' and #PrecioVehiculo.recordcount# gt 0 >
					
					<!----   Promedio vehicular=   cantidad de vehiculos x peaje / catidad de meses de la muestra  ---->
					<cfset PromedioVehicular = #rsdetalle.cantidad# / #detalleIndividual.totalmeses#>  
					<cfset PromedioFlujoVehicularEstimado =    #PromedioVehicular# + (#PromedioVehicular# * #detalleIndividual.COEPorcVariacion# /100)> 
		         <cfset PromedioMensualIngresoEstimado = #PrecioVehiculo.PPrecio# * #PromedioFlujoVehicularEstimado#>
					<cfset FlujoVehicularEstimadoAnual=  #PromedioFlujoVehicularEstimado# * 12>  
		         <cfset PromedioAnualIngresoEstimado = #FlujoVehicularEstimadoAnual# * #PrecioVehiculo.PPrecio#>	
							
		       <cfif posicion eq 0 and  posicion neq rsParametrosPeaje.peaje>
			       <cfset TotalflujoMensualEstimado = #PromedioFlujoVehicularEstimado#>
					 <cfset TotalflujoAnualEstimado = #FlujoVehicularEstimadoAnual#>	
					 <cfset TotalIngresoMensualEstimado = #PromedioMensualIngresoEstimado#>	
					 <cfset TotalIngresoAnualEstimado = #PromedioAnualIngresoEstimado#>
					
			       <cfset posicion = #rsParametrosPeaje.peaje#>						
																		
			  <cfelseif posicion neq 0 and  posicion neq rsParametrosPeaje.peaje>
			       <cfset IngresoTotalGeneral = IngresoTotalGeneral + TotalIngresoAnualEstimado>					
				    <cfset FlujoTotalGeneral   = FlujoTotalGeneral + TotalflujoAnualEstimado>					 
						
				<tr>
				   <td align="center"><strong>Total</strong></td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center"><strong><cfoutput>#numberFormat(TotalflujoMensualEstimado,',9')#</cfoutput></strong></td>
					<td align="center"><strong><cfoutput>#numberFormat(TotalflujoAnualEstimado,',9')#</cfoutput></strong></td>
					<td align="center">&nbsp;</td>
					<td align="center"><strong><cfoutput>¢#numberFormat(TotalIngresoMensualEstimado,',9.00')#</cfoutput></strong></td>
					<td align="center"><strong><cfoutput>¢#numberFormat(TotalIngresoAnualEstimado,',9.00')#</cfoutput></strong></td>					
			  </tr>	
			  <tr>
					<td colspan="11">&nbsp;</td>
					<td colspan="11">&nbsp;</td>					
			  </tr> 
			  <tr bgcolor="#CCCCCC">
			      <td align="center"><strong> Centro Funcional </strong></td>
			      <td align="center"><strong> Peaje </strong></td>
					<td align="center"><strong>Tipo Vehículo</strong></td>
					<td align="center"><strong> Desde - Hasta </strong></td>
					<td align="center"><strong>Prom. Vehicular </strong></td>
					<td align="center"><strong>% Variación </strong></td>
					<td align="center"><strong>Prom.Flujo Vehicular Est. Mens </strong></td>
					<td align="center"><strong>Flujo Vehicular Est. Anual</strong></td>
					<td align="center"><strong> Tarifa </strong></td>
					<td align="center"><strong>Prom. mensual ingreso Est. </strong></td>
					<td align="center"><strong>Ingresos estimados</strong></td>
			  </tr>			
			  		<cfset TotalflujoMensualEstimado = 0>
			  		<cfset TotalflujoAnualEstimado = 0>	
			  		<cfset TotalIngresoMensualEstimado = 0>	
			  		<cfset TotalIngresoAnualEstimado = 0>
			  		<cfset TotalflujoMensualEstimado = #PromedioFlujoVehicularEstimado#>
			  		<cfset TotalflujoAnualEstimado = #FlujoVehicularEstimadoAnual#>	
			  		<cfset TotalIngresoMensualEstimado = #PromedioMensualIngresoEstimado#>	
			  		<cfset TotalIngresoAnualEstimado = #PromedioAnualIngresoEstimado#>
			  		<cfset posicion = #rsParametrosPeaje.peaje#>	
			   <cfelseif posicion neq 0 and  posicion eq rsParametrosPeaje.peaje>
			      <cfset TotalflujoMensualEstimado = TotalflujoMensualEstimado +  #PromedioFlujoVehicularEstimado#>
					<cfset TotalflujoAnualEstimado = TotalflujoAnualEstimado + #FlujoVehicularEstimadoAnual#>	
					<cfset TotalIngresoMensualEstimado = TotalIngresoMensualEstimado + #PromedioMensualIngresoEstimado#>	
					<cfset TotalIngresoAnualEstimado = TotalIngresoAnualEstimado +  #PromedioAnualIngresoEstimado#>
			  </cfif>	
		      <tr>
				   <td align="center" nowrap="nowrap"><strong><cfoutput>#rsParametrosPeaje.CFdescripcion#</cfoutput></strong></td>
				   <td align="center" nowrap="nowrap"><strong><cfoutput>#rsParametrosPeaje.peaje#</cfoutput></strong></td>
					<td align="center"><cfoutput>#rsParametrosPeaje.vehiculo#</cfoutput></td>
					<td align="center" nowrap="nowrap"><cfoutput>#detalleIndividual.periodoInicial#/#ListGetAt(mes,detalleIndividual.mesInicial)# - #detalleIndividual.periodoFinal#/#ListGetAt(mes,detalleIndividual.mesFinal)#</cfoutput></td>
					<td align="center"><cfoutput>#numberFormat(PromedioVehicular,',9')#</cfoutput></td>
					<td align="center"><cfoutput>#numberFormat(detalleIndividual.COEPorcVariacion,',9.0000')# %</cfoutput></td>
					<td align="center"><cfoutput>#numberFormat(PromedioFlujoVehicularEstimado,',9')#</cfoutput></td>
					<td align="center"><cfoutput>#numberFormat(FlujoVehicularEstimadoAnual,',9')#</cfoutput></td>
					<td align="center"><cfoutput>#numberFormat(PrecioVehiculo.PPrecio,',9.00')#</cfoutput></td>
					<td align="center"><cfoutput>#numberFormat(PromedioMensualIngresoEstimado,',9.00')#</cfoutput></td>
					<td align="center"><cfoutput>#numberFormat(PromedioAnualIngresoEstimado,',9.00')#</cfoutput></td>					
			  </tr>				  				
	   </cfif>         
 	 </cfloop>
		  <cfset LvarMonto += TotalIngresoAnualEstimado>
		   <cfset LvarPromedioVehicular += PromedioVehicular>
		 
		    <cfif detalleIndividual.recordcount neq 0  and FlujoTotalGeneral gte 0 and IngresoTotalGeneral gte 0  and LvarPromedioVehicular neq 0>
		    	<cfset IngresoTotalGeneral = IngresoTotalGeneral + TotalIngresoAnualEstimado>					
		      <cfset FlujoTotalGeneral   = FlujoTotalGeneral + TotalflujoAnualEstimado>	
		       <tr>
				   <td align="center"><strong>Total</strong></td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center"><strong><cfoutput>#numberFormat(TotalflujoMensualEstimado,',9')#</cfoutput></strong></td>
					<td align="center"><strong><cfoutput>#numberFormat(TotalflujoAnualEstimado,',9')#</cfoutput></strong></td>
					<td align="center">&nbsp;</td>
					<td align="center"><strong><cfoutput>¢#numberFormat(TotalIngresoMensualEstimado,',9.00')#</cfoutput></strong></td>
					<td align="center" nowrap="nowrap"><strong><cfoutput>¢#numberFormat(TotalIngresoAnualEstimado,',9.00')#</cfoutput></strong></td>					
			   </tr>	
			   <tr bgcolor="#999999">
				   <td align="center"><strong>Total General</strong></td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="center"><strong><cfoutput>#numberFormat(FlujoTotalGeneral,',9')#</cfoutput></strong></td>
					<td align="center">&nbsp;</td>
					<td align="center">&nbsp;</td>
					<td align="right" nowrap="nowrap"><strong><cfoutput>¢#numberFormat(IngresoTotalGeneral,',9.00')#</cfoutput></strong></td>					
			   </tr>			
			<cfelse>
		      <tr>
			    	<td colspan="11" align="center"> ---------------------  No hay registros  -----------------------</td>					
	         </tr>	
			</cfif>	 
 	<cfelse>
    	<tr>
		  	<td colspan="11" align="center"> ---------------------  No hay parámetros definidos -----------------------</td>					
	   </tr>	
 </cfif>
 </table>
 
 
	 <cfif isdefined ('url.LvarEstimar') and #url.LvarEstimar# neq ''>

		 <cfoutput>
			<form name="form1" action="EstEnviarFormulacion-sql.cfm" method="get" style="margin:0">
				<input type="hidden" name="periodo" 	value="#LvarPeriodo#" />
				
				<input type="hidden" name="TotalIngresoAnualEstimado" 	value="#TotalIngresoAnualEstimado#" />
				<input type="hidden" name="LvarMonto" 	value="#LvarMonto#" />
				
				
				<cfif isdefined ('form.CPPid')>
					<input type="hidden" name="CPPid" 	value="#form.CPPid#" />
					<input type="hidden" name="Mcodigo" value="#Periodos.Mcodigo#">
					<input type="hidden" name="Pid" value="#rsParametrosPeaje.Pid#">
				</cfif>
				<cfif not isdefined ('form.CPPid')>
					<input type="hidden" name="CPPid" 	value="#url.CPPid#" />
					<input type="hidden" name="Mcodigo" value="#Periodos.Mcodigo#">
					<input type="hidden" name="Pid" value="#rsParametrosPeaje.Pid#">
				</cfif>
				<tr>
				<cfif not isdefined ('form.COEPeriodo') and #rsParametrosPeaje.COEEstado# neq 2> 
					<td colspan="12" align="center">	
					<cfif isdefined('url.Pid') and url.Pid neq ''>
						<cfif LvarMonto eq 0>
						   <cfset valores ="Regresar">
						<cfelse>
						   <cfset valores = "Aplicar,Regresar">
						</cfif>
						<cf_botones values="#valores#" tabindex="1">
					<cfelse>
						<cf_botones values="Regresar" tabindex="1">
					</cfif>
					</td>
				<cfelseif isdefined ('form.CPPid') and #form.CPPid# neq ''>
					 <td colspan="12" align="center"><cf_botones values="Regresar" tabindex="1"></td>
					 
				<cfelseif #rsParametrosPeaje.COEEstado# eq 2> 
					 <td colspan="12" align="center" bgcolor="CC3333"><em><strong>&nbsp;La Estimación ya fué enviada a Formular</strong></em>	
					 <cf_botones values="Regresar" tabindex="1"></td>
				</cfif>
				</tr>
			</form>
			</cfoutput>
	  </cfif>

<script language="javascript" type="text/javascript">
		function funcRegresar(){
			location.href = 'EstEnviarFormulacion.cfm';
			return false;
		}
</script>

