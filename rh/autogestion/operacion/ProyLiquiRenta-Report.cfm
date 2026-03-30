<cfparam name="Stop" default="false">
<cfif not isdefined('URL.RHRentaId')>
	El Parámetro URL.RHRentaId es Requerido para Mostrar el Reporte.<br />
 	<cfabort>
</cfif>
<cfinclude template = "ProyeccionRenta-translate.cfm">
<cfset ComProyRenta  	= createobject("component","rh.Componentes.RH_ProyeccionRenta")>
<cfset EncabezadoRenta  = ComProyRenta.GetEliquidacionRenta(url.RHRentaId)>
<cfset TablaRenta 	    = ComProyRenta.GetEImpuestoRenta(-1,-1,EncabezadoRenta.EIRid)>
<cfset lista_meses      = ('#LB_Enero#,#LB_Febrero#,#LB_Marzo#,#LB_Abril#,#LB_Mayo#,#LB_Junio#,#LB_Julio#,#LB_Agosto#,#LB_Septiembre#,#LB_Octubre#,#LB_Noviembre#,#LB_Diciembre#') >
<cfset mesDesde		    = listgetat(lista_meses, TablaRenta.mesDesde) >
<cfset mesHasta 	    = listgetat(lista_meses, TablaRenta.mesHasta) >
<cfset rsFRentaBruta 	= ComProyRenta.GetLineasReporte('GLRB')>			   <!---Renta Bruta--->
<cfset rsColumnSalarioB = ComProyRenta.GetLineasReporte('GLRB','SalarioBruto')><!---Salario Bruto--->
<cfset rsFDeduc 		= ComProyRenta.GetLineasReporte('GLRD')>			   <!---Deducciones--->
<cfset rsFCredito 		= ComProyRenta.GetLineasReporte('GLRC')>			   <!---Credito Fiscal--->

<cfparam name="Lvar_TotalRBC" 		default="0">
<cfparam name="Lvar_TotalRBE" 		default="0">
<cfparam name="Lvar_TotalRBA" 		default="0">
<cfparam name="Lvar_TotalDEDC" 		default="0">
<cfparam name="Lvar_TotalDEDE" 		default="0">
<cfparam name="Lvar_TotalDEDA" 		default="0">
<cfif isdefined('url.Autorizacion') and url.Autorizacion>
	<cfset Autorizador = true>	
<cfelse>
	<cfset Autorizador = false>
</cfif>
<cfset RHRentaId = url.RHRentaId>
<cfset DEid		 =  EncabezadoRenta.DEid>
<cf_htmlReportsHeaders FileName="DecJura.xls" irA="" param="&RHRentaId=#URL.RHRentaId#&Autorizacion=#Autorizador#" close="true" back="false" title="Declaración Jurada ante el patrono">
<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0" >
        <!---►►►Encabezado◄◄◄--->
        <tr><td align="center"><strong><cf_translate key="DeclaracionJurada">Declaración Jurada ante el patrono</cf_translate></strong></td></tr>
        <tr><td align="center"><strong><cfoutput><cf_translate key="PeriodoDel">Período del</cf_translate>#TablaRenta.diaDesde# de #mesDesde# del #TablaRenta.AnoDesde# al #TablaRenta.diaHasta# de #mesHasta# del #TablaRenta.AnoHasta#</cfoutput></strong></td></tr>
        <tr><td align="center"><strong><cfoutput><cf_translate key="version">Versión:</cf_translate>#EncabezadoRenta.Nversion#  &nbsp;&nbsp; Estado:#EncabezadoRenta.Estado#</cfoutput></strong></td></tr>
 		<tr>
			<td>
            	<cfoutput>
                    <table width="80%" align="center" border="1" cellpadding="1" cellspacing="0"">
                    <!---=================SECCION DE RENTA BRUTA=================--->
                        <tr>
                            <td colspan="<cfif Autorizador>5<cfelse>4</cfif>"><cf_translate key="LB_RENTABRUTA"><strong>RENTA BRUTA</strong></cf_translate></td>
                        </tr>
                        <tr>
                                <td width="40%">&nbsp;</td>
                                <td width="20%" align="center"><strong>#LB_Calculado#</strong></td>
                                <td width="20%" align="center"><strong>#LB_Empleado#</strong></td>
                            <cfif Autorizador>
                                <td width="20%" align="center"><strong>#LB_Autorizado#</strong></td>
                            </cfif>
                        </tr>
                    <cfloop query="rsFRentaBruta">
						<cfset rsDRentaBruta= ComProyRenta.GetRHDLiquidacionRenta(RHRentaId,rsFRentaBruta.RHCRPTID)>	
                        
						<cfset Lvar_Dato 	= 0>
                        <cfset Lvar_DatoE 	= 0>
                        <cfset Lvar_DatoA   = 0>
                        <cfset form.TotalH 	= 0>
                        <cfset form.TotalE 	= 0>
                        <cfset form.TotalA 	= 0>	
                        <cfif TRIM(rsFRentaBruta.RHCRPTcodigo) EQ 'SalarioBruto'>
                            <cfset Lvar_SalBase = 1>
                        <cfelse>
                        	<cfset Lvar_SalBase = 0>
                        </cfif>
                        <cfloop query="rsDRentaBruta">
                            <cfset form.TotalH = form.TotalH + rsDRentaBruta.MontoHistorico>
                            <cfset form.TotalE = form.TotalE + rsDRentaBruta.MontoEmpleado>
                            <cfset form.TotalA = form.TotalA + rsDRentaBruta.MontoAutorizado>											
                        </cfloop>															
                            <cfset Lvar_Dato = form.TotalH>															
                            <cfset Lvar_DatoE = form.TotalE >
                        <cfif Autorizador>
                            <cfset Lvar_DatoA = form.TotalA>											
                        </cfif>																	
                   	<tr>
                            <td width="30%">#rsFRentaBruta.RHCRPTDESCRIPCION#</td>														
                            <td align="right">#Lvar_Dato#</td>								
                            <td align="right">#LSCurrencyFormat(Lvar_DatoE,'none')#</td>
                        <cfif Autorizador>																																							
                            <td align="right">#LSCurrencyFormat(Lvar_DatoA,'none')#</td>
                        </cfif> 						
                   	</tr>  																
                        <cfset Lvar_TotalRBC = Lvar_TotalRBC + Lvar_Dato>									
                        <cfset Lvar_TotalRBE = Lvar_TotalRBE + Lvar_DatoE>													
                    <cfif Autorizador>
                        <cfset Lvar_TotalRBA = Lvar_TotalRBA + Lvar_DatoA>
                    </cfif>
                    </cfloop>
					<tr>
						<td><cf_translate key="LB_RENTANETA"><strong>RENTA NETA</strong></cf_translate></td>
						<td align="right"<strong>#LSCurrencyFormat(Lvar_TotalRBC,'none')#</strong></td>
						<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalRBE,'none')#</strong></td>
						<cfif Autorizador>
							<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalRBA,'none')#</strong></td>
						</cfif>
					</tr>
					<tr><td colspan="<cfif Autorizador>5<cfelse>4</cfif>">&nbsp;</td></tr>
					<tr><td colspan="<cfif Autorizador>5<cfelse>4</cfif>"><cf_translate key="LB_DEDUCCIONES"><strong>DEDUCCIONES</strong></cf_translate></td></tr>
					<tr>
						<td width="40%">&nbsp;</td>
						<td width="20%" align="center"><strong>#LB_Calculado#</strong></td>
						<td width="20%" align="center"><strong>#LB_Empleado#</strong></td>
						<cfif Autorizador>
							<td width="20%" align="center"><strong>#LB_Autorizado#</strong></td>
						</cfif>
					</tr>	
                     <!---=================SECCION DE DEDUCCIONES=================--->	
                    <cfloop query="rsFDeduc">	
						<cfset rsDLiquidacion= ComProyRenta.GetRHDLiquidacionRenta(RHRentaId,rsFDeduc.RHCRPTID)>
						<cfset Lvar_Dato   = 0>
						<cfset Lvar_DatoE  = 0>
						<cfset Lvar_DatoA  = 0>																														
						<cfset form.TotalH = 0>
						<cfset form.TotalE = 0>
						<cfset form.TotalA = 0>		
					
						<cfif #Ucase(trim(rsFDeduc.RHCRPTcodigo))# EQ 'Cuotas'	>
							<cfset TotalIGSS   = ComProyRenta.GetTotalIGSS(RHRentaId)>	
							<cfset form.TotalH = form.TotalH + TotalIGSS.IGSSCal>
							<cfset form.TotalE = form.TotalE + TotalIGSS.IGSSEmp>
							<cfset form.TotalA = form.TotalA + TotalIGSS.IGSSAut>	
						<cfelse>				
							<cfloop query="rsDLiquidacion">
								<cfset form.TotalH = form.TotalH + MontoHistorico>
								<cfset form.TotalE = form.TotalE + MontoEmpleado>
								<cfset form.TotalA = form.TotalA + MontoAutorizado>											
							</cfloop>
						</cfif>
						<cfset Lvar_Dato  = form.TotalH>															
						<cfset Lvar_DatoE = form.TotalE>
						<cfif Autorizador>
							<cfset Lvar_DatoA = form.TotalA>											
						</cfif>											
						<tr>
                           		<td width="30%">#RHCRPTDESCRIPCION#</td> 						
                                <td align="right">#abs(Lvar_Dato)#</td>
                                <td align="right">#LSCurrencyFormat(abs(Lvar_DatoE),'none')#</td>
							<cfif Autorizador>								
								<td align="right">#abs(Lvar_DatoA)#</td>
							</cfif>
						</tr>
						<cfset Lvar_TotalDEDC = Lvar_TotalDEDC + Lvar_Dato>
						<cfset Lvar_TotalDEDE = Lvar_TotalDEDE + Lvar_DatoE>
						<cfif Autorizador>
							<cfset Lvar_TotalDEDA = Lvar_TotalDEDA + Lvar_DatoA>
						</cfif>
					</cfloop>
                    <tr>
                            <td><cf_translate key="LB_RENTANETA"><strong>DEDUCCIONES</strong></cf_translate></td>
                            <td align="right"><strong>#LSCurrencyFormat(Lvar_TotalDEDC,'none')#</strong></td>
                            <td align="right"><strong>#LSCurrencyFormat(Lvar_TotalDEDE,'none')#</strong></td>
						<cfif Autorizador>
							<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalDEDA,'none')#</strong></td>
						</cfif>
					</tr>
					<tr><td colspan="<cfif Autorizador>5<cfelse>4	</cfif>">&nbsp;</td></tr>
					<!---=================RENTA IMPONIBLE O PERDIDA FISCAL=================--->	
					<cfset Lvar_TotalRIPFC = Lvar_TotalRBC - Lvar_TotalDEDC>
					<cfset Lvar_TotalRIPFE = Lvar_TotalRBE - Lvar_TotalDEDE>
					<cfif Autorizador>
						<cfset Lvar_TotalRIPFA = Lvar_TotalRBA - Lvar_TotalDEDA>
					</cfif>
					<tr>
                            <td><cf_translate key="LB_RENTANETA"><strong>RENTA IMPONIBLE O PERDIDA FISCAL</strong></cf_translate></td>
                            <td align="right">#LSNumberFormat(Lvar_TotalRIPFC,'99.99')#</td>             
                            <td align="right">#Lvar_TotalRIPFE#</td>
						<cfif Autorizador>
							<td align="right">#LSNumberFormat(Lvar_TotalRIPFA,'99.99')#</td>
                        </cfif>
					</tr>
					
					<tr><td colspan="<cfif Autorizador>4<cfelse>3</cfif>">&nbsp;</td></tr>
                    <!---=================IMPUESTO ANUAL DETERMINARDO=================--->	
						<cfset Lvar_TotalIADC = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFC)>
						<cfset Lvar_TotalIADE = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFE)>
					<cfif Autorizador>
						<cfset Lvar_TotalIADA = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFA)>
					</cfif>
					<tr>
						<td><cf_translate key="LB_RENTANETA"><strong>IMPUESTO ANUAL DETERMINADO</strong></cf_translate></td>
						<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalIADC,'none')#</strong></td>
                        <td align="right">#LSNumberFormat(Lvar_TotalIADE,'99.99')#</td>						
						<cfif Autorizador>
                        	<td align="right">#LSNumberFormat(Lvar_TotalIADA,'99.99')#</td>
						</cfif>
					</tr>
					<tr><td colspan="<cfif Autorizador>4<cfelse>3</cfif>">&nbsp;</td></tr>
					
					<!---=================CREDITO FISCAL=================--->				
					<tr><td colspan="<cfif Autorizador>4<cfelse>3</cfif>"><cf_translate key="LB_RENTABRUTA"><strong>(-) Cr&eacute;dito Fiscal permitido por la ley (50%)</strong></cf_translate></td></tr>
					<tr>
						<td width="40%">&nbsp;</td>
						<td width="20%" align="center"><strong>#LB_Calculado#</strong></td>
						<td width="20%" align="center"><strong>#LB_Empleado#</strong></td>
						<cfif Autorizador>
							<td width="20%" align="center"><strong>#LB_Autorizado#</strong></td>
						</cfif>
					</tr>
                    <cfloop query="rsFCredito">
					
						<cfset Lvar_Dato = 0>
						<cfset Lvar_DatoE = 0>
						<cfset Lvar_DatoA = 0>	
						<cfset rsDCreditoFiscal= ComProyRenta.GetRHDLiquidacionRenta(RHRentaId,rsFCredito.RHCRPTID)>		
						<cfset form.TotalH = 0>
						<cfset form.TotalE = 0>
						<cfset form.TotalA = 0>							
						<cfloop query="rsDCreditoFiscal">
							<cfset form.TotalH = form.TotalH + MontoHistorico>
							<cfset form.TotalE = form.TotalE + MontoEmpleado>
							<cfset form.TotalA = form.TotalA + MontoAutorizado>											
						</cfloop>	
						<cfset Lvar_TotalCFPLC = form.TotalH>
						
						<cfif  form.TotalE gt 0>
							<cfset Lvar_TotalCFPLE = form.TotalE>
							<cfelse>
							<cfset Lvar_TotalCFPLE = (Lvar_TotalRBE*0.12) * 0.5 >
						</cfif>
																																					
						<cfif Autorizador>
							<cfif form.TotalA GT 0>						   	
					    		<cfset Lvar_TotalCFPLA = form.TotalA>	
							<cfelse>	
								<cfset Lvar_TotalCFPLA =  (Lvar_TotalRBA*0.12) * 0.5>
							</cfif>											
						</cfif>										
						
						<!---CALCULO DEL MAXIMO CCREDITO FISCAL PERMITIDO POR LA LEY (50%) SEGUN LA RENTA INGRESADA --->							
							<cfset Lvar_MaxCalcEmpl =  (Lvar_TotalRBE*0.12) * 0.5>							
							<cfif Autorizador>
								<cfset Lvar_MaxCalcAut =  (Lvar_TotalRBA*0.12) * 0.5>
							</cfif>					
												     
						<tr valign="bottom">
                                <td width="30%">#RHCRPTDESCRIPCION#</td>
                                <td align="right">#Lvar_TotalCFPLC#</td>
                                <td align="right">#Lvar_TotalCFPLE#</td>							
							<cfif Autorizador>
								<td align="right">#Lvar_TotalCFPLA#</td>
							</cfif>
						</tr>
                        <!--- FIN RENTA IMPONIBLE O PERDIDA FISCAL --->
					<tr><td colspan="<cfif Autorizador>4<cfelse>3</cfif>">&nbsp;</td></tr>
					<!---=================IMPUESTO DETERMINADO=================--->						
						<cfset Lvar_TotalIDC = Lvar_TotalIADC- Lvar_TotalCFPLC>					
                        <cfset Lvar_TotalIDE = Lvar_TotalIADE - Lvar_TotalCFPLE>
                        <cfif Autorizador>
                            <cfset Lvar_TotalIDA = Lvar_TotalIADA - Lvar_TotalCFPLA>
                        </cfif>
                        <cfif Lvar_TotalIDE LT 0>
                            <cfset Lvar_TotalIDE = 0.00>
                        </cfif>
                        <cfif Autorizador>
							<cfif Lvar_TotalIDA LT 0>
                                <cfset Lvar_TotalIDA = 0.00>
                            </cfif>
                        </cfif>
                        <cfif Lvar_TotalIDC LT 0>
                            <cfset Lvar_TotalIDC = 0.00>
                        </cfif>
					<tr>
                            <td><cf_translate key="LB_IMPUESTODETERMINADO"><strong>IMPUESTO DETERMINADO</strong></cf_translate></td>
                            <td align="right"><strong>#LSCurrencyFormat(Lvar_TotalIDC,'none')#</strong></td>												
                            <td align="right">#Lvar_TotalIDE#</td> 						
						<cfif Autorizador>
							<td align="right">#Lvar_TotalIDA#</td> 								
						</cfif>
					</tr>
					</cfloop>
                    <!--- FIN IMPUESTO DETERMINADO --->
					<tr><td colspan="<cfif Autorizador>4<cfelse>3</cfif>">&nbsp;</td></tr>
					<!--- RENTA CALCULADA --->
					
					<tr><td colspan="<cfif Autorizador>4<cfelse>3</cfif>"><cf_translate key="LB_RENTACALCULADA"><strong>RENTA CALCULADA</strong></cf_translate></td></tr>
					<!---Renta de la Informacion de otros Patronos y Ex-patronos--->
                    <cfset TotalRentaRetenida_H = 0>
                    <cfset TotalRentaRetenida_A = 0>
                    <cfset TotalRentaRetenida_E = 0>
                                                          
                    <cfloop query="rsFRentaBruta">
                        <cfif rsFRentaBruta.RHRPTNOrigen NEQ 0>
                          <cfquery name="rsOrigen" datasource="#session.dsn#">
                          	select RHROid,RentaNetaAut , RentaNetaEmp
                            	from RHRentaOrigenes 
                             where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHRentaId#">
                               and RHCRPTid  = #rsFRentaBruta.RHCRPTID#
                          </cfquery>
                          <cfif rsOrigen.recordcount EQ 0>
                          		<cfset RentaNetaAut = 0>
                                <cfset RentaNetaEmp = 0>
                          <cfelse>
                          	 	<cfset RentaNetaAut = rsOrigen.RentaNetaAut>
                                <cfset RentaNetaEmp = rsOrigen.RentaNetaEmp>
                          </cfif>
                          <cfset TotalRentaRetenida_A = TotalRentaRetenida_A + RentaNetaAut>
                          <cfset TotalRentaRetenida_E = TotalRentaRetenida_E + RentaNetaEmp>
                          <tr>
                         	 <td align="right"><strong>#rsFRentaBruta.RHCRPTDESCRIPCION#</strong>&nbsp;</td>
                             <td align="right">&nbsp;</td>
							 <td align="right">#RentaNetaEmp#</td>
						<cfif Autorizador>
							  <td align="right">#RentaNetaAut#</td>
						</cfif>
                          </tr>
                        </cfif>
                     </cfloop>
                    <!---renta de la empresa Actual--->
                    <cfset rentaAdicc = 0>
					<cfset rentaAdiccAut = 0>				
					
					<cfloop query="rsFRentaBruta">
                        <cfquery name="rsmonto"  datasource="#session.dsn#">
                        	select coalesce(sum(b.RentaRetenida),0) as RentaRetenida
                          		from RHDLiquidacionRenta b
                         	where b.RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHRentaId#">
                              and b.RHCRPTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFRentaBruta.RHCRPTid#"> 
                        </cfquery>
                        <cfif rsmonto.RecordCount EQ 0 OR NOT LEN(TRIM(rsmonto.RentaRetenida))>
                             <cfset LvarRentaRetenida = 0>
                        <cfelse>
                            <cfset LvarRentaRetenida = rsmonto.RentaRetenida >
                        </cfif>
                        <cfset rentaAdicc 	 = 0>
                        <cfset rentaAdiccAut = 0>
                        <cfset rentaAdicc 	 = rentaAdicc + LvarRentaRetenida>
                        <cfset rentaAdiccAut = rentaAdiccAut + LvarRentaRetenida >
                   
                        <cfif Autorizador>
                            <cfset Lvar_RentaR = ComProyRenta.ObtieneRentaRetenida(session.Ecodigo,DEid,TablaRenta.EIRDesde,TablaRenta.EIRhasta)  + #rentaAdiccAut#>
                        <cfelse>
                            <cfset Lvar_RentaR = ComProyRenta.ObtieneRentaRetenida(session.Ecodigo,DEid,TablaRenta.EIRDesde,TablaRenta.EIRhasta)  + #rentaAdicc#>
                        </cfif>					   
					</cfloop>
                  
                    	<cfset TotalRentaRetenida_H = TotalRentaRetenida_H + Lvar_RentaR>
                    	<cfset Lvar_TotalIRC 		=  Lvar_TotalIDC - TotalRentaRetenida_H>	
						
                        <cfset TotalRentaRetenida_E = TotalRentaRetenida_E + Lvar_RentaR>
                        <cfset Lvar_TotalIRE 		=  Lvar_TotalIDE - TotalRentaRetenida_E>	
                        
					<cfif Autorizador>
                    	<cfset TotalRentaRetenida_A = TotalRentaRetenida_A + Lvar_RentaR>
						<cfset Lvar_TotalIRA 		= Lvar_TotalIDA - TotalRentaRetenida_A>
                    </cfif>
                    
                    <cfif Lvar_TotalIRC LT 0>
                    	<cfset Lvar_TotalIRC = 0.00>
                    </cfif>
                     <cfif Lvar_TotalIRE LT 0>
                    	<cfset Lvar_TotalIRE = 0.00>
                    </cfif>
                    <cfif Autorizador>
						<cfif Lvar_TotalIRA LT 0>
                            <cfset Lvar_TotalIRA = 0.00>
                        </cfif>
                    </cfif>
                    
                    <tr>
						<td align="right"><cf_translate key="LB_RENTARETENIDA"><strong>Renta Retenida</strong></cf_translate>&nbsp;</td>
						<td align="right"><strong>#LSCurrencyFormat(Lvar_RentaR,'none')#</strong></td>
						<td align="right"> #LSCurrencyFormat(Lvar_RentaR,'none')#</td>
						<cfif Autorizador>
							<td align="right">#LSCurrencyFormat(Lvar_RentaR,'none')#</td>
						</cfif>
					</tr>
                    <!---Total Renta Retenida--->
                    <tr>
							<td align="left"><cf_translate key="LB_totalrentaRetenida"><strong>TOTAL RENTA RETENIDA</strong></cf_translate>&nbsp;</td>
                        	<td align="right"><strong>#LSCurrencyFormat(TotalRentaRetenida_H, 'none')# </strong> </td>
                        	<td align="right"><strong>#LSCurrencyFormat(TotalRentaRetenida_E, 'none')# </strong> </td>
                        <cfif Autorizador>
                        	<td align="right"><strong>#LSCurrencyFormat(TotalRentaRetenida_A, 'none')# </strong> </td>
                        </cfif>
                    </tr>
                    <!---Impuesto a retener--->
					<tr>
						<td align="right"><cf_translate key="LB_IMPUESTOARETENER"><strong>IMPUESTO A RETENER</strong></cf_translate>&nbsp;</td>
						<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalIRC, 'none')# </strong> </td>
						<td align="right">#Lvar_TotalIRE#</td>
						<cfif Autorizador>
							<td align="right">#Lvar_TotalIRA#</td>
						</cfif>
						
					</tr>
					<tr>
						<cfset periodosPendientes = ComProyRenta.ObtienePeriodosPendientes(session.Ecodigo, DEid, TablaRenta.AnoDesde) >						
                            <td align="right"><cf_translate key="LB_PERIODOSPENDIENTES"><strong>PERIODOS PENDIENTES DE PAGAR </strong> </cf_translate>&nbsp;</td>
                            <td align="right"> <strong>#LSCurrencyFormat(periodosPendientes,'none')#</strong> </td>
                            <td align="right">#periodosPendientes#</td>
						<cfif Autorizador>
							<td align="right">#periodosPendientes#</td>												
						</cfif>						
					</tr>
					<tr>
					    <cfif periodosPendientes NEQ 0 >
								<cfset RetencionCalc= Lvar_TotalIRC / periodosPendientes>
                                <cfset RetencionEmpl= Lvar_TotalIRE / periodosPendientes>	
							<cfif Autorizador>
								<cfset RetencionAut=  Lvar_TotalIRA / periodosPendientes>						
                            </cfif>
						<cfelse>
								<cfset RetencionCalc= Lvar_TotalIRC >
								<cfset RetencionEmpl= Lvar_TotalIRE >
                            <cfif Autorizador>
								<cfset RetencionAut=  Lvar_TotalIRA >
                            </cfif>
						</cfif>
                            <td align="right"><cf_translate key="LB_RETENCION_X_NOMINA"><strong>RETENCION POR NOMINA</strong></cf_translate>   </td>
                            <td align="right"><strong>#LSCurrencyFormat(RetencionCalc,'none')#</strong> </td> 
                            <td align="right">#RetencionEmpl#</td>
						<cfif Autorizador>
							<td align="right">#RetencionAut#</td>												
						</cfif>
					</tr>					
               </table>
               </cfoutput>
    	</td>
	</tr>
</table>