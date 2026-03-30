<cfset EncabezadoRenta  = ComProyRenta.GetEliquidacionRenta(form.RHRentaId)>
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
<cfparam name="Autorizacion" 		default="false">


<form name="formLiq" action="/cfmx/rh/autogestion/operacion/ProyeccionRenta-sql.cfm" method="post">
	<cfoutput>
	    	<input name="RHRentaId" type="hidden" value="#form.RHRentaId#" />
    		<input name="DEid" 		type="hidden" value="#form.DEid#" >
        <cfif Autorizador> 
			<input name="Autorizacion" 	type="hidden" value="1">
		</cfif>
   	</cfoutput>
	<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
        <!---►►►Encabezado◄◄◄--->
        <tr><td align="center"><strong><cf_translate key="DeclaracionJurada">Declaración Jurada ante el patrono</cf_translate></strong></td></tr>
        <tr><td align="center"><strong><cfoutput><cf_translate key="PeriodoDel">Período del</cf_translate>#TablaRenta.diaDesde# de #mesDesde# del #TablaRenta.AnoDesde# al #TablaRenta.diaHasta# de #mesHasta# del #TablaRenta.AnoHasta#</cfoutput></strong></td></tr>
        <tr><td align="center"><strong><cfoutput><cf_translate key="version">Versión:</cf_translate>#EncabezadoRenta.Nversion#  &nbsp;&nbsp; Estado:#EncabezadoRenta.Estado#</cfoutput></strong></td></tr>
        <tr>
			<td>
            	<cfoutput>
                    <table width="80%" align="center" border="1" cellpadding="1" cellspacing="0">
                    <!---=================SECCION DE RENTA BRUTA=================--->
                        <tr>
                            <td colspan="<cfif Autorizador>5<cfelse>4</cfif>"><cf_translate key="LB_RENTABRUTA"><strong>RENTA BRUTA</strong></cf_translate></td>
                        </tr>
                        <tr>
                                <td width="40%">&nbsp;</td>
                                <td width="20%" align="center" bgcolor="CCCCCC"><strong>#LB_Calculado#</strong></td>
                                <td width="20%" align="center" <cfif Autorizador>bgcolor="CCCCCC"</cfif>><strong>#LB_Empleado#</strong></td>
                            <cfif Autorizador>
                                <td width="20%" align="center"><strong>#LB_Autorizado#</strong></td>
                            </cfif>
                        </tr>
                    <cfloop query="rsFRentaBruta">
						<cfset rsDRentaBruta= ComProyRenta.GetRHDLiquidacionRenta(form.RHRentaId,rsFRentaBruta.RHCRPTID)>	
                        
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
                        <td align="right" bgcolor="CCCCCC"><cf_inputNumber name="Calculado#RHCRPTid#" value="#Lvar_Dato#"  decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"> </td>								
                        <td align="right" <cfif Autorizador>bgcolor="CCCCCC" <cfelse>  onclick="funcPopUpDet('/cfmx/rh/autogestion/operacion/DesgloceMensualRenta.cfm?Autorizacion=#Autorizacion#&RHRentaId=#form.RHRentaId#&RHCRPTID=#rsFRentaBruta.RHCRPTID#',50,50,800,600);" </cfif> > 
                            <input name="Empleado#RHCRPTid#" type="text" value="#LSCurrencyFormat(Lvar_DatoE,'none')#"  readonly style="border: 0; text-align:right; background-color: transparent;">
                        <cfif Autorizador>																																							
                            <td align="right" onclick="funcPopUpDet('/cfmx/rh/autogestion/operacion/DesgloceMensualRenta.cfm?Autorizacion=#Autorizacion#&RHRentaId=#form.RHRentaId#&RHCRPTID=#rsFRentaBruta.RHCRPTID#',50,50,800,600);">
                            <input name="Autorizado#RHCRPTid#" type="text" value="#LSCurrencyFormat(Lvar_DatoA,'none')#"  readonly style="border: 0; text-align:right; background-color: transparent;">
                        </cfif> 						
                    </tr>  																
                        <cfset Lvar_TotalRBC = Lvar_TotalRBC + Lvar_Dato>									
                        <cfset Lvar_TotalRBE = Lvar_TotalRBE + Lvar_DatoE>													
                    <cfif Autorizacion>
                        <cfset Lvar_TotalRBA = Lvar_TotalRBA + Lvar_DatoA>
                    </cfif>
                    </cfloop>
					<tr>
						<td><cf_translate key="LB_RENTANETA"><strong>RENTA NETA</strong></cf_translate></td>
						<td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(Lvar_TotalRBC,'none')#</strong></td>
						<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>><strong>#LSCurrencyFormat(Lvar_TotalRBE,'none')#</strong></td>
						<cfif Autorizacion>
							<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalRBA,'none')#</strong></td>
						</cfif>
					</tr>
					<tr><td colspan="<cfif Autorizacion>5<cfelse>4</cfif>">&nbsp;</td></tr>
					<tr><td colspan="<cfif Autorizacion>5<cfelse>4</cfif>"><cf_translate key="LB_DEDUCCIONES"><strong>DEDUCCIONES</strong></cf_translate></td></tr>
					<tr>
						<td width="40%">&nbsp;</td>
						<td width="20%" align="center" bgcolor="CCCCCC"><strong>#LB_Calculado#</strong></td>
						<td width="20%" align="center" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>><strong>#LB_Empleado#</strong></td>
						<cfif Autorizacion>
							<td width="20%" align="center"><strong>#LB_Autorizado#</strong></td>
						</cfif>
					</tr>	
                     <!---=================SECCION DE DEDUCCIONES=================--->	
                    <cfloop query="rsFDeduc">	
						<cfset rsDLiquidacion= ComProyRenta.GetRHDLiquidacionRenta(form.RHRentaId,rsFDeduc.RHCRPTID)>
						<cfset Lvar_Dato   = 0>
						<cfset Lvar_DatoE  = 0>
						<cfset Lvar_DatoA  = 0>																														
						<cfset form.TotalH = 0>
						<cfset form.TotalE = 0>
						<cfset form.TotalA = 0>		
					
						<cfif #Ucase(trim(rsFDeduc.RHCRPTcodigo))# EQ 'Cuotas'	>
							<cfset TotalIGSS   = ComProyRenta.GetTotalIGSS(form.RHRentaId)>	
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
						<cfif Autorizacion>
							<cfset Lvar_DatoA = form.TotalA>											
						</cfif>											
						
						<tr>
							<td width="30%">#RHCRPTDESCRIPCION#</td> 						
							<td align="right" bgcolor="CCCCCC"><cf_inputNumber name="Calculado#RHCRPTid#" value="#abs(Lvar_Dato)#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>
						    <td align="right" <cfif Autorizacion>bgcolor="CCCCCC" <cfelse> <cfif (TRIM(rsFDeduc.RHCRPTcodigo) EQ 'DeducPer') or trim(rsFDeduc.RHCRPTcodigo) EQ 'Cuotas'>     <cfelse> onclick="funcPopUpDet('/cfmx/rh/autogestion/operacion/DesgloceMensualRenta.cfm?Autorizacion=#Autorizacion#&RHRentaId=#form.RHRentaId#&RHCRPTID=#rsFDeduc.RHCRPTID#',50,50,800,600);" </cfif> </cfif>>
							<input name="Empleado#RHCRPTid#" type="text" value="#LSCurrencyFormat(abs(Lvar_DatoE),'none')#"  readonly style="border: 0; text-align:right; background-color: transparent;"></td>
							<cfif Autorizacion>								
								<td align="right" <cfif (TRIM(rsFDeduc.RHCRPTcodigo) EQ 'DeducPer') or (trim(rsFDeduc.RHCRPTcodigo) EQ 'Coutas')>     <cfelse> onclick="funcPopUpDet('/cfmx/rh/autogestion/operacion/DesgloceMensualRenta.cfm?Autorizacion=#Autorizacion#&RHRentaId=#form.RHRentaId#&RHCRPTID=#rsFDeduc.RHCRPTID#',50,50,800,600);" </cfif> >								
								<cf_inputNumber name="Autorizado#RHCRPTid#" value="#abs(Lvar_DatoA)#" decimales="2" modificable="false" tabindex="3" style="border: 0; background-color: transparent;" ></td>
							</cfif>
						</tr>
						<cfset Lvar_TotalDEDC = Lvar_TotalDEDC + Lvar_Dato>
						<cfset Lvar_TotalDEDE = Lvar_TotalDEDE + Lvar_DatoE>
						<cfif Autorizacion>
							<cfset Lvar_TotalDEDA = Lvar_TotalDEDA + Lvar_DatoA>
						</cfif>
					</cfloop>
                    <tr>
						<td><cf_translate key="LB_RENTANETA"><strong>DEDUCCIONES</strong></cf_translate></td>
						<td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(Lvar_TotalDEDC,'none')#</strong></td>
						<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>><strong>#LSCurrencyFormat(Lvar_TotalDEDE,'none')#</strong></td>
						<cfif Autorizacion>
							<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalDEDA,'none')#</strong></td>
						</cfif>
					</tr>
					<tr><td colspan="<cfif Autorizacion>5<cfelse>4	</cfif>">&nbsp;</td></tr>
					<!---=================RENTA IMPONIBLE O PERDIDA FISCAL=================--->	
					<cfset Lvar_TotalRIPFC = Lvar_TotalRBC - Lvar_TotalDEDC>
					<cfset Lvar_TotalRIPFE = Lvar_TotalRBE - Lvar_TotalDEDE>
					<cfif Autorizacion>
						<cfset Lvar_TotalRIPFA = Lvar_TotalRBA - Lvar_TotalDEDA>
					</cfif>
					<tr>
						<td><cf_translate key="LB_RENTANETA"><strong>RENTA IMPONIBLE O PERDIDA FISCAL</strong></cf_translate></td>
						<td align="right" bgcolor="CCCCCC">
						  <cf_inputNumber name="RentaImpHist" value="#LSNumberFormat(Lvar_TotalRIPFC,'99.99')#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" > </td>             
						<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>>
						 <cf_inputNumber name="RentaImpEmp" value="#Lvar_TotalRIPFE#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" > </td>
						<cfif Autorizacion>
							<td align="right"><cf_inputNumber name="RentaImpAut" value="#LSNumberFormat(Lvar_TotalRIPFA,'99.99')#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" >          </td>
						</cfif>
					</tr>
					<tr><td colspan="<cfif Autorizacion>4<cfelse>3</cfif>">&nbsp;</td></tr>
                    <!---=================IMPUESTO ANUAL DETERMINARDO=================--->	
						<cfset Lvar_TotalIADC = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFC)>
						<cfset Lvar_TotalIADE = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFE)>
					<cfif Autorizacion>
						<cfset Lvar_TotalIADA = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFA)>
					</cfif>
					<tr>
						<td><cf_translate key="LB_RENTANETA"><strong>IMPUESTO ANUAL DETERMINADO</strong></cf_translate></td>
						<td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(Lvar_TotalIADC,'none')#</strong></td>
						<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>>
						 <cf_inputNumber name="ImpAnualDeterminadoEmp" value="#LSNumberFormat(Lvar_TotalIADE,'99.99')#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" > </td>						
						<cfif Autorizacion>
							<td align="right"><cf_inputNumber name="ImpAnualDeterminadoAut" value="#LSNumberFormat(Lvar_TotalIADA,'99.99')#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" > </td>
						</cfif>
					</tr>
					<tr><td colspan="<cfif Autorizacion>4<cfelse>3</cfif>">&nbsp;</td></tr>
					
					<!---=================CREDITO FISCAL=================--->				
					<tr><td colspan="<cfif Autorizacion>4<cfelse>3</cfif>"><cf_translate key="LB_RENTABRUTA"><strong>(-) Cr&eacute;dito Fiscal permitido por la ley (50%)</strong></cf_translate></td></tr>
					<tr>
						<td width="40%">&nbsp;</td>
						<td width="20%" align="center" bgcolor="CCCCCC"><strong>#LB_Calculado#</strong></td>
						<td width="20%" align="center" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>><strong>#LB_Empleado#</strong></td>
						<cfif Autorizacion>
							<td width="20%" align="center"><strong>#LB_Autorizado#</strong></td>
						</cfif>
					</tr>
                    <cfloop query="rsFCredito">
					
						<cfset Lvar_Dato = 0>
						<cfset Lvar_DatoE = 0>
						<cfset Lvar_DatoA = 0>	
						<cfset rsDCreditoFiscal= ComProyRenta.GetRHDLiquidacionRenta(form.RHRentaId,rsFCredito.RHCRPTID)>		
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
																																					
						<cfif Autorizacion>
							<cfif form.TotalA GT 0>						   	
					    		<cfset Lvar_TotalCFPLA = form.TotalA>	
							<cfelse>	
								<cfset Lvar_TotalCFPLA =  (Lvar_TotalRBA*0.12) * 0.5>
							</cfif>											
						</cfif>										
						
						<!---CALCULO DEL MAXIMO CCREDITO FISCAL PERMITIDO POR LA LEY (50%) SEGUN LA RENTA INGRESADA --->							
							<cfset Lvar_MaxCalcEmpl =  (Lvar_TotalRBE*0.12) * 0.5>							
							<cfif Autorizacion>
								<cfset Lvar_MaxCalcAut =  (Lvar_TotalRBA*0.12) * 0.5>
							</cfif>					
												     
						<tr valign="bottom">
							<td width="30%">#RHCRPTDESCRIPCION#</td>
							<td align="right" bgcolor="CCCCCC"><cf_inputNumber name="CalculadoCredFiscal" value="#Lvar_TotalCFPLC#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;" ></td>
							<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"</cfif> >						
								<input name="OcultoEmpleado#RHCRPTid#" type="hidden"  value="#Lvar_MaxCalcEmpl#"/>																		
								<input name="CreditoFiscal_RHCRPTid"   type="hidden"  value="#RHCRPTid#"/>																							
								<cf_inputnumber name="EmpleadoCreditoFiscal" value="#Lvar_TotalCFPLE#" decimales="2" modificable="true" tabindex="1" style="border: 0; background-color: transparent;" onblur="Verifica(EmpleadoCreditoFiscal, OcultoEmpleado#RHCRPTid#) ">     </td>							
							<cfif Autorizacion>
								<input name="OcultoAutorizado#RHCRPTid#" type="hidden"  value="#Lvar_MaxCalcAut#"/>
														
								<td align="right"><cf_inputNumber name="AutorizadoCreditoFiscal" value="#Lvar_TotalCFPLA#" decimales="2" modificable="true" tabindex="3" style="border: 0; background-color: transparent;" onblur="VerificaAut(AutorizadoCreditoFiscal ,OcultoAutorizado#RHCRPTid#)"></td>
							</cfif>
						</tr>
                        <!--- FIN RENTA IMPONIBLE O PERDIDA FISCAL --->
					<tr><td colspan="<cfif Autorizacion>4<cfelse>3</cfif>">&nbsp;</td></tr>
					<!---=================IMPUESTO DETERMINADO=================--->						
						<cfset Lvar_TotalIDC = Lvar_TotalIADC- Lvar_TotalCFPLC>					
                        <cfset Lvar_TotalIDE = Lvar_TotalIADE - Lvar_TotalCFPLE>
                        <cfif Autorizacion>
                            <cfset Lvar_TotalIDA = Lvar_TotalIADA - Lvar_TotalCFPLA>
                        </cfif>
                        <cfif Lvar_TotalIDE LT 0>
                            <cfset Lvar_TotalIDE = 0.00>
                        </cfif>
                        <cfif Autorizacion>
							<cfif Lvar_TotalIDA LT 0>
                                <cfset Lvar_TotalIDA = 0.00>
                            </cfif>
                        </cfif>
                        <cfif Lvar_TotalIDC LT 0>
                            <cfset Lvar_TotalIDC = 0.00>
                        </cfif>
					<tr>
						<td><cf_translate key="LB_IMPUESTODETERMINADO"><strong>IMPUESTO DETERMINADO</strong></cf_translate></td>
						<td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(Lvar_TotalIDC,'none')#</strong></td>												
						<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>>
					    <cf_inputNumber name="ImpDeterminadoEmp" value="#Lvar_TotalIDE#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" ></td> 						
						<cfif Autorizacion>
							<td align="right"><cf_inputNumber name="ImpDeterminadoAut" value="#Lvar_TotalIDA#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" ></td> 								
						</cfif>
					</tr>
					</cfloop>
                    <!--- FIN IMPUESTO DETERMINADO --->
					<tr><td colspan="<cfif Autorizacion>4<cfelse>3</cfif>">&nbsp;</td></tr>
					<!--- RENTA CALCULADA --->
					
					<tr><td colspan="<cfif Autorizacion>4<cfelse>3</cfif>"><cf_translate key="LB_RENTACALCULADA"><strong>RENTA CALCULADA</strong></cf_translate></td></tr>
					<!---Renta de la Informacion de otros Patronos y Ex-patronos--->
                    <cfset TotalRentaRetenida_H = 0>
                    <cfset TotalRentaRetenida_A = 0>
                    <cfset TotalRentaRetenida_E = 0>
                                                          
                    <cfloop query="rsFRentaBruta">
                        <cfif rsFRentaBruta.RHRPTNOrigen NEQ 0>
                          <cfquery name="rsOrigen" datasource="#session.dsn#">
                          	select RHROid,RentaNetaAut , RentaNetaEmp
                            	from RHRentaOrigenes 
                             where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
                               and RHCRPTid  = #rsFRentaBruta.RHCRPTID#
                          </cfquery>
                          <cfset TotalRentaRetenida_A = TotalRentaRetenida_A + rsOrigen.RentaNetaAut>
                          <cfset TotalRentaRetenida_E = TotalRentaRetenida_E + rsOrigen.RentaNetaEmp>
                          <tr>
                         	 <td align="right"><strong>#rsFRentaBruta.RHCRPTDESCRIPCION#</strong>&nbsp;</td>
                             <td align="right" bgcolor="CCCCCC">&nbsp;</td>
							 <td align="right" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>>						
						 	 	<cf_inputNumber name="rentaOtrasE#rsOrigen.RHROid#" value="#rsOrigen.RentaNetaEmp#" decimales="2" modificable="#NOT Autorizador#" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" >
                             </td>
						<cfif Autorizacion>
							  <td align="right">
                              	<cf_inputNumber name="rentaOtrasA#rsOrigen.RHROid#" value="#rsOrigen.RentaNetaAut#" decimales="2" modificable="#Autorizador#" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" >
                              </td>
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
                         	where b.RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
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
                   
                        <cfif Autorizacion>
                            <cfset Lvar_RentaR = ComProyRenta.ObtieneRentaRetenida(session.Ecodigo,form.DEid,TablaRenta.EIRDesde,TablaRenta.EIRhasta)  + #rentaAdiccAut#>
                        <cfelse>
                            <cfset Lvar_RentaR = ComProyRenta.ObtieneRentaRetenida(session.Ecodigo,form.DEid,TablaRenta.EIRDesde,TablaRenta.EIRhasta)  + #rentaAdicc#>
                        </cfif>					   
					</cfloop>
                  
                    	<cfset TotalRentaRetenida_H = TotalRentaRetenida_H + Lvar_RentaR>
                    	<cfset Lvar_TotalIRC 		=  Lvar_TotalIDC - TotalRentaRetenida_H>	
						
                        <cfset TotalRentaRetenida_E = TotalRentaRetenida_E + Lvar_RentaR>
                        <cfset Lvar_TotalIRE 		=  Lvar_TotalIDE - TotalRentaRetenida_E>	
                        
					<cfif Autorizacion>
                    	<cfset TotalRentaRetenida_A = TotalRentaRetenida_A + Lvar_RentaR>
						<cfset Lvar_TotalIRA 		= Lvar_TotalIDA - TotalRentaRetenida_A>
                    </cfif>
                    
                    <cfif Lvar_TotalIRC LT 0>
                    	<cfset Lvar_TotalIRC = 0.00>
                    </cfif>
                     <cfif Lvar_TotalIRE LT 0>
                    	<cfset Lvar_TotalIRE = 0.00>
                    </cfif>
                    <cfif Autorizacion>
						<cfif Lvar_TotalIRA LT 0>
                            <cfset Lvar_TotalIRA = 0.00>
                        </cfif>
                    </cfif>
                    
                    <tr>
						<td align="right"><cf_translate key="LB_RENTARETENIDA"><strong>Renta Retenida</strong></cf_translate>&nbsp;</td>
						<td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(Lvar_RentaR,'none')#</strong></td>
						<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"</cfif>>						
						 <cf_inputNumber name="RentaRetenidaEmp" value="#Lvar_RentaR#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" ></td>
						<cfif Autorizacion>
							<td align="right"><cf_inputNumber name="RentaRetenidaAut" value="#Lvar_RentaR#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" ></td>
						</cfif>
					</tr>
                    <!---Total Renta Retenida--->
                    <tr>
							<td align="left"><cf_translate key="LB_totalrentaRetenida"><strong>TOTAL RENTA RETENIDA</strong></cf_translate>&nbsp;</td>
                        	<td align="right" bgcolor="CCCCCC"> <strong>#LSCurrencyFormat(TotalRentaRetenida_H, 'none')# </strong> </td>
                        	<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"  </cfif>> <strong>#LSCurrencyFormat(TotalRentaRetenida_E, 'none')# </strong> </td>
                        <cfif Autorizacion>
                        	<td align="right"> <strong>#LSCurrencyFormat(TotalRentaRetenida_A, 'none')# </strong> </td>
                        </cfif>
                    </tr>
                    <!---Impuesto a retener--->
					<tr>
						<td align="right"><cf_translate key="LB_IMPUESTOARETENER"><strong>IMPUESTO A RETENER</strong></cf_translate>&nbsp;</td>
						<td align="right" bgcolor="CCCCCC"> <strong>#LSCurrencyFormat(Lvar_TotalIRC, 'none')# </strong> </td>
						<td align="right" <cfif Autorizacion>bgcolor="CCCCCC"  </cfif>> 					
						 <cf_inputNumber name="ImpRetenEmp" value="#Lvar_TotalIRE#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" > </td>
						<cfif Autorizacion>
							<td align="right"> <cf_inputNumber name="ImpRetenAut" value="#Lvar_TotalIRA#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" > </td>
						</cfif>
						
					</tr>
					<tr>
						<cfset periodosPendientes = ComProyRenta.ObtienePeriodosPendientes(session.Ecodigo, form.DEid, TablaRenta.AnoDesde) >						
						<td align="right"><cf_translate key="LB_PERIODOSPENDIENTES"><strong>PERIODOS PENDIENTES DE PAGAR </strong> </cf_translate>&nbsp;</td>
						<td align="right" bgcolor="CCCCCC"> <strong>#LSCurrencyFormat(periodosPendientes,'none')#</strong> </td>
						<td align="right" bgcolor="CCCCCC"><cf_inputNumber name="PeriodosPendEmp" value="#periodosPendientes#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" > </td>
						<cfif Autorizacion>
							<td align="right"><cf_inputNumber name="PeriodosPendAut" value="#periodosPendientes#" decimales="2" modificable="false" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" > </td>												
						</cfif>						
					</tr>
					
					<tr>
					    <cfif periodosPendientes NEQ 0 >
								<cfset RetencionCalc= Lvar_TotalIRC / periodosPendientes>
                                <cfset RetencionEmpl= Lvar_TotalIRE / periodosPendientes>	
							<cfif Autorizacion>
								<cfset RetencionAut=  Lvar_TotalIRA / periodosPendientes>						
                            </cfif>
						<cfelse>
								<cfset RetencionCalc= Lvar_TotalIRC >
								<cfset RetencionEmpl= Lvar_TotalIRE >
                            <cfif Autorizacion>
								<cfset RetencionAut=  Lvar_TotalIRA >
                            </cfif>
						</cfif>
						<td align="right"><cf_translate key="LB_RETENCION_X_NOMINA"><strong>RETENCION POR NOMINA</strong></cf_translate>   </td>
						<td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(RetencionCalc,'none')#</strong> </td> 
						<td align="right" bgcolor="CCCCCC"><cf_inputNumber name="RetencionNomEmpl" value="#RetencionEmpl#" decimales="2" modificable="false" tabindex="1"  style="border:0; font-weight:bold; background-color:transparent;" ></td>
						<cfif Autorizacion>
							<td align="right"><cf_inputNumber name="RetencionNomAut" value="#RetencionAut#" decimales="2" modificable="false" tabindex="1"  style="border:0; font-weight:bold; background-color:transparent;" ></td>												
						</cfif>
					</tr>					
					<cfif Autorizacion>
						<input name="RentaAnual" type="hidden" value="#Lvar_TotalRBA#" />
						<input name="EIRdesde" type="hidden" value="#TablaRenta.EIRDesde#"  />
						<input name="EIRHasta" type="hidden" value="#TablaRenta.EIRhasta#"  />											
					<cfelse>					
						<input name="RentaAnual" type="hidden" value="#Lvar_TotalRBE#" />							
					</cfif>	
                   
               </table>
               		<cfset Lvar_Botones="">
                <cfif Autorizacion>
                    <cfif EncabezadoRenta.USRInicia EQ 'Usuario'>
                    	<cfset Lvar_Botones = 'Rechazar,'>	
                    </cfif>
                    	<cfset Lvar_Botones = Lvar_Botones  & 'Finalizar'>	
               <cfelse>
					<cfset Lvar_Botones = 'Enviar_a_Autorizacion'>
               </cfif>
               	<cf_botones values="Guardar,Eliminar,#Lvar_Botones#,Regresar,Imprimir" tabindex="4">
           </cfoutput>
                        </td>
                    </tr>
    </table>
</form>

<script>

	function VerificaAut(valor1,valor2){		
		 var valorDigitado = parseFloat(qf(valor1.value));
		 var valorPredeterminado = parseFloat(qf(valor2.value)); 	
		 
		 
		 if (valorDigitado > valorPredeterminado){	
			  valor1.value = Math.round(valorPredeterminado * 100) / 100;				
		 }	
					
		 var Lvarx=qf(document.formLiq.ImpAnualDeterminadoAut.value);	
		 Lvary = qf(valor1.value);
		 var valox=  parseFloat(Lvarx) - parseFloat(Lvary);				
		 document.formLiq.ImpDeterminadoAut.value= Math.round(parseFloat(valox)*100) / 100;		
		 
		 var ImpDeterminadoAut = qf(document.formLiq.ImpDeterminadoAut.value);
		 var RentaRetenidaAut= qf(document.formLiq.RentaRetenidaAut.value);
		 var ImpRetener = parseFloat(ImpDeterminadoAut) - parseFloat(RentaRetenidaAut);	 
		 document.formLiq.ImpRetenAut.value = Math.round(parseFloat(ImpRetener) *100) /100;			
		 RECalculaRetencionXNominaAut();
	}
	
	function RECalculaRetencionXNominaAut()
	{
		var ImpRetenAut= qf(document.formLiq.ImpRetenAut.value); 
		var PeriodosPendAut= qf(document.formLiq.PeriodosPendAut.value);
		if (PeriodosPendAut > 0) {
			var RetencionNomAut = parseFloat(ImpRetenAut)/ parseFloat(PeriodosPendAut);
		}
		else {
			var RetencionNomAut = parseFloat(ImpRetenAut);
		 }
	                     
		document.formLiq.RetencionNomAut.value = Math.round(parseFloat(RetencionNomAut)* 100) / 100; 
	
	}
	
	function Verifica(valor1,valor2){		
		 var valorDigitado = parseFloat(qf(valor1.value));
		 var valorPredeterminado = parseFloat(qf(valor2.value)); 	
		 
		 
		 if (valorDigitado > valorPredeterminado){	
			  valor1.value = Math.round(valorPredeterminado * 100) / 100;				
		 }	
					
		 var Lvarx=qf(document.formLiq.ImpAnualDeterminadoEmp.value);	
		 Lvary = qf(valor1.value);
		 var valox=  parseFloat(Lvarx) - parseFloat(Lvary);				
		 document.formLiq.ImpDeterminadoEmp.value= Math.round(parseFloat(valox)*100) / 100;		
		 
		 var ImpDeterminadoEmp = qf(document.formLiq.ImpDeterminadoEmp.value);
		 var RentaRetenidaEmp= qf(document.formLiq.RentaRetenidaEmp.value);
		 var ImpRetener = parseFloat(ImpDeterminadoEmp) - parseFloat(RentaRetenidaEmp);	 
		 document.formLiq.ImpRetenEmp.value = Math.round(parseFloat(ImpRetener) *100) /100;			
		 RECalculaRetencionXNominaEmp();
	}
	
	function RECalculaRetencionXNominaEmp()
	{ 
		var ImpRetenEmp= qf(document.formLiq.ImpRetenEmp.value); 
		var PeriodosPendEmp= qf(document.formLiq.PeriodosPendEmp.value);
		if (PeriodosPendEmp > 0) {
			var RetencionNomEmpl = parseFloat(ImpRetenEmp)/ parseFloat(PeriodosPendEmp);
		}
		else {
			var RetencionNomEmpl = parseFloat(ImpRetenEmp);
		 }
		
		document.formLiq.RetencionNomEmpl.value = Math.round(parseFloat(RetencionNomEmpl)* 100) / 100; 
	}
	
	var popUpDet=0;
	/*levanta una pantalla emergente con las dimenciones dadas*/
	function funcPopUpDet(URLStr, left, top, width, height){
	   var H = (screen.height - height) / 2; 
	   var L = (screen.width - width) / 2; 

		if(popUpDet){
			if(!popUpDet.closed) 
				popUpDet.close();
		}
		popUpDet = open(URLStr, 'popUpDet', 'toolbars=no, location=no, directories=no, status=no, menubars=no, scrollbars=yes, resizable=yes, copyhistory=yes, width='+width+', height='+height+', left='+L+', top='+H);
	}
	function funcLimpia(obj){
		if (obj.value == 'Sin Observaciones'){
			obj.value = '';
		}
		obj.style.color = '000000';
	}
	function funcRevisa(obj){
		if (obj.value == ''){
			obj.style.color = 'CCCCCC';
			obj.value = 'Sin Observaciones';
		}
	}
	function funcImprimir()
	{
		<cfoutput>window.open('/cfmx/rh/autogestion/operacion/ProyLiquiRenta-Report.cfm?RHRentaId=#form.RHRentaId#&Autorizacion=#Autorizador#', 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=650,left=130,top=50,screenX=150,screenY=150');</cfoutput>
		return false;
	}
	function funcEliminar()
	{
		return confirm('Esta seguro que desea eliminar la liquidación Actual?');
	}
	function funcGuardar()
	{
		return confirm('Esta seguro que desea guardar la liquidación Actual?');
	}
	function funcEnviar_a_Autorizacion()
	{
		return confirm('Esta seguro que desea enviar a Autorización la liquidación Actual?');
	}
	function funcFinalizar()
	{
		return confirm('Esta seguro que desea Finalizar la liquidación Actual?');
	}
</script>