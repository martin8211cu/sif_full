<cfset EncabezadoRenta  = ComProyRenta.GetEliquidacionRenta(form.RHRentaId)>
<cfset TablaRenta 	    = ComProyRenta.GetEImpuestoRenta(-1,-1,EncabezadoRenta.EIRid)>
<cfset lista_meses 		= ('#LB_Enero#,#LB_Febrero#,#LB_Marzo#,#LB_Abril#,#LB_Mayo#,#LB_Junio#,#LB_Julio#,#LB_Agosto#,#LB_Septiembre#,#LB_Octubre#,#LB_Noviembre#,#LB_Diciembre#') >
<cfset mesDesde		    = listgetat(lista_meses, TablaRenta.mesDesde) >
<cfset mesHasta 	    = listgetat(lista_meses, TablaRenta.mesHasta) >

<cfif isdefined('Autorizacion')>
	<cfset Lvar_Modificable=false>
    <cfset Autorizador = true>
<cfelse>
	<cfset Lvar_Modificable=true>
     <cfset Autorizador = false>
</cfif>

<cfset Lvar_TotalRBC 	= 0>
<cfset Lvar_TotalRBE 	= 0>
<cfset Lvar_TotalRBA 	= 0>

<cfset Lvar_TotalDEDC 	= 0>
<cfset Lvar_TotalDEDE 	= 0>
<cfset Lvar_TotalDEDA 	= 0>

<cfset Lvar_TotalRIPFC 	= 0>
<cfset Lvar_TotalRIPFE 	= 0>
<cfset Lvar_TotalRIPFA 	= 0>

<cfset Lvar_TotalIADC 	= 0>
<cfset Lvar_TotalIADE 	= 0>
<cfset Lvar_TotalIADA 	= 0>

<cfset Lvar_TotalIRE 	= 0>
<cfset Lvar_TotalIRA 	= 0>

<cfquery name="rsDatos" datasource="#session.DSN#">
    select a.RHRentaId ,a.EIRid,a.DEid,b.RHCRPTid,b.MontoHistorico,b.MontoEmpleado,b.MontoAutorizado,b.Observaciones,
         Coalesce(RHLIVAplanilla_A,0) as RHLIVAplanilla_A, 
         Coalesce(RHLIVAplanilla_E,0) as RHLIVAplanilla_E, 
         Coalesce(RHLRentaRetenida,0) as RHLRentaRetenida
        from RHLiquidacionRenta a
            inner join RHDLiquidacionRenta b
             on b.RHRentaId = a.RHRentaId
    where a.RHRentaId   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
</cfquery>

<cfif NOT isdefined('rsDatos.RHLIVAplanilla_E') or NOT LEN(TRIM(rsDatos.RHLIVAplanilla_E))>
	<cfset RHLIVAplanilla_E= 0>
<cfelse>
	<cfset RHLIVAplanilla_E = rsDatos.RHLIVAplanilla_E>
</cfif>
<cfif NOT isdefined('rsDatos.RHLIVAplanilla_A') or NOT LEN(TRIM(rsDatos.RHLIVAplanilla_A))>
	<cfset RHLIVAplanilla_A= 0>
<cfelse>
	<cfset RHLIVAplanilla_A = rsDatos.RHLIVAplanilla_A>
</cfif>
<cfoutput>
<form name="formLid" action="/cfmx/rh/autogestion/operacion/liquidacionRentaGT-sql.cfm" method="post">
		<input name="RHRentaId" 	type="hidden" value="#form.RHRentaId#">
		<input name="DEid" 			type="hidden" value="#form.DEid#" >
	<cfif Autorizador>
    	<input name="Autorizacion" 	type="hidden" value="true">
    </cfif>
	<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
		<!---►►Titulo◄◄--->
        <tr>
        	<td align="center">
            	<strong><cf_translate key="DeclaracionJurada">DECLARACION JURADA ANTE EL PATRONO (#EncabezadoRenta.Estado#)</cf_translate></strong>
            </td>
		</tr>
		<!---►►Seccion Periodo del Liquidación◄◄--->
        <tr>
			<td align="center">
                <strong><cf_translate key="PeriodoDel">Período del</cf_translate>#repeatstring('0',2-Len(Day(TablaRenta.EIRdesde)))##Day(TablaRenta.EIRdesde)#&nbsp;de&nbsp;#mesDesde# del #TablaRenta.AnoDesde# al #repeatstring('0',2-Len(Day(TablaRenta.EIRhasta)))##Day(TablaRenta.EIRhasta)#&nbsp;de&nbsp;#mesHasta# del #TablaRenta.AnoHasta#</strong>
            </td>
		</tr>
		<!---►►Seccion Renta Bruta◄◄--->
        <cfset rsFRentaBruta = ComProyRenta.GetLineasReporte('GLRB')>
        <tr>
			<td>
            	<table width="90%" align="center" border="1" cellpadding="1" cellspacing="0">
                    <tr>
                        <td colspan="<cfif isdefined('Autorizacion')>4<cfelse>3</cfif>">
                        	<cf_translate key="LB_RENTABRUTA"><strong>RENTA BRUTA</strong></cf_translate>
                        </td>
                    </tr>
            		<tr>
                            <td width="30%">&nbsp;</td>
                            <td width="20%" align="center" bgcolor="CCCCCC"><strong>#LB_Calculado#</strong></td>
                            <td width="20%" align="center" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>><strong>#LB_Empleado#</strong></td>
						<cfif isdefined('Autorizacion')>
                            <td width="20%" align="center"><strong>#LB_Autorizado#</strong></td>
                        </cfif>	
							<td width="20%" align="center" ><strong>#LB_Observaciones#</strong></td>
            		</tr>
            <cfloop query="rsFRentaBruta">
            	<cfquery name="rsmonto" dbtype="query">
                    select MontoHistorico,MontoEmpleado,MontoAutorizado,Observaciones
                        from rsDatos
                     where RHCRPTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFRentaBruta.RHCRPTid#">
              	</cfquery>
              	<cfif rsmonto.RecordCount>
						<cfset Lvar_Dato  = rsmonto.MontoHistorico>
                        <cfset Lvar_DatoE = rsmonto.MontoEmpleado>
					<cfif isdefined('Autorizacion')>
                     	<cfset Lvar_DatoA = rsmonto.MontoAutorizado>
                    </cfif>
                <cfelse>
                		<cfset Lvar_SalBase = 0>
					<cfif TRIM(rsFRentaBruta.RHCRPTcodigo) EQ 'SalarioBruto'>
                    	<cfset Lvar_SalBase = 1>
                    </cfif>
						<cfset Lvar_Dato  = ComProyRenta.ObtieneTotal(session.Ecodigo,rsFRentaBruta.RHCRPTid,form.DEid,Lvar_SalBase,1,-1,-1,TablaRenta.EIRdesde,TablaRenta.EIRhasta)>
						<cfset Lvar_DatoE = Lvar_Dato>
					<cfif isdefined('Autorizacion')>
                            <cfset Lvar_DatoA = Lvar_Dato>
                    </cfif>
              </cfif>
              <tr>
                <td width="30%">#RHCRPTDESCRIPCION#</td>
                <td align="right" bgcolor="CCCCCC"><cf_inputNumber name="Calculado#RHCRPTid#" value="#Lvar_Dato#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>
                <td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>><cf_inputNumber name="Empleado#RHCRPTid#" value="#Lvar_DatoE#" decimales="2" modificable="#Lvar_Modificable#" tabindex="2" style="border: 0; background-color: transparent;" onblur="Verifica(Calculado#RHCRPTid#,this)"></td>
                <cfif isdefined('Autorizacion')>
                  <td align="right">
                  	<cf_inputNumber name="Autorizado#RHCRPTid#" value="#Lvar_DatoA#" decimales="2" modificable="true" tabindex="3" style="border: 0; background-color: transparent;" onblur="Verifica(Calculado#RHCRPTid#,this)">
                  </td>
                </cfif>
					<td align="left">
                    	<textarea name="Observaciones#RHCRPTid#" rows="1" cols="50" <cfif isdefined('Autorizacion')>onclick="funcLimpia(this);" onfocus="funcLimpia(this);" onblur="funcRevisa(this);"</cfif> style="overflow:auto;<cfif isdefined('rsmonto') and not LEN(TRIM(rsmonto.Observaciones))>color:##CCCCCC;</cfif>" <cfif not isdefined('Autorizacion')>readonly</cfif>><cfif isdefined('rsmonto') and LEN(TRIM(rsmonto.Observaciones))>#rsmonto.Observaciones#<cfelse>Sin Observaciones</cfif></textarea>
                    </td>
              </tr>
				  <cfset Lvar_TotalRBC = Lvar_TotalRBC + Lvar_Dato>
                  <cfset Lvar_TotalRBE = Lvar_TotalRBE + Lvar_DatoE>
              <cfif isdefined('Autorizacion')>
              	 <cfset Lvar_TotalRBA = Lvar_TotalRBA + Lvar_DatoA>
              </cfif>
            </cfloop>
            <!---►►Seccion Renta Neta◄◄--->
            <tr>
            	<td>
                	<cf_translate key="LB_RENTANETA"><strong>RENTA NETA</strong></cf_translate>
                </td>
              	<td align="right" bgcolor="CCCCCC">
                	<strong>#LSCurrencyFormat(Lvar_TotalRBC,'none')#</strong>
                </td>
              	<td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>>
                	<strong>#LSCurrencyFormat(Lvar_TotalRBE,'none')#</strong>
                </td>
              	<cfif isdefined('Autorizacion')>
                	<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalRBA,'none')#</strong></td>
              	</cfif>
			  <td>&nbsp;</td>
            </tr>
            <tr>
             	<td colspan="<cfif isdefined('Autorizacion')>5<cfelse>4</cfif>">&nbsp;</td>
            </tr>
            <!---►►Seccion Deducciones◄◄--->
           <cfset rsFDeduc = ComProyRenta.GetLineasReporte('GLRD')>
            <tr>
              <td colspan="<cfif isdefined('Autorizacion')>5<cfelse>4</cfif>"><cf_translate key="LB_DEDUCCIONES"><strong>DEDUCCIONES</strong></cf_translate></td>
            </tr>
            <tr>
              <td width="40%">&nbsp;</td>
              <td width="20%" align="center" bgcolor="CCCCCC"><strong>#LB_Calculado#</strong></td>
              <td width="20%" align="center" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>><strong>#LB_Empleado#</strong></td>
              <cfif isdefined('Autorizacion')>
                <td width="20%" align="center"><strong>#LB_Autorizado#</strong></td>
              </cfif>
			  <td width="20%" align="center" ><strong>#LB_Observaciones#</strong></td>
            </tr>
            <cfloop query="rsFDeduc">
              <cfquery name="rsmonto" dbtype="query">
                select MontoHistorico,MontoEmpleado,MontoAutorizado,Observaciones
                from rsDatos
                where RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFDeduc.RHCRPTid#">
              </cfquery>
             <cfif rsmonto.RecordCount>
			 	<cfset Lvar_Dato  = rsmonto.MontoHistorico>
				<cfset Lvar_DatoE = rsmonto.MontoEmpleado>
				<cfif isdefined('Autorizacion')>
					<cfset Lvar_DatoA = rsmonto.MontoAutorizado>
				</cfif>
             <cfelse>
                <cfif TRIM(rsFDeduc.RHCRPTcodigo) EQ 'DeducPer'>
					<cfset Lvar_Dato = ComProyRenta.GetDeducible(EncabezadoRenta.EIRid, TablaRenta.IRcodigo)>
				<cfelse>
					<cfif Ucase(TRIM(rsFDeduc.RHCRPTcodigo)) EQ Ucase('BonoAgui')>
						<cfset Lvar_TipoSuma = 1>
					<cfelse>
						<cfset Lvar_TipoSuma = 2>
					</cfif>
					<cfif TRIM(rsFDeduc.RHCRPTcodigo) EQ'Cuotas'> 
						<cfset Lvar_Dato = ComProyRenta.ObtieneIGSS(form.DEid,TablaRenta.EIRdesde,TablaRenta.EIRhasta)>
					<cfelse>	
						<cfset Lvar_Dato = ComProyRenta.ObtieneTotal(session.Ecodigo,rsFDeduc.RHCRPTid,form.DEid,0,Lvar_TipoSuma,-1,-1,TablaRenta.EIRdesde,TablaRenta.EIRhasta)>
                    </cfif>				                   
            	</cfif>
            		<cfset Lvar_DatoE = Lvar_Dato>
           		<cfif isdefined('Autorizacion')>
                  	<cfset Lvar_DatoA = Lvar_Dato>
            	</cfif>
           </cfif>
              <tr>
                <td width="30%">#RHCRPTDESCRIPCION#</td>
                <td align="right" bgcolor="CCCCCC"><cf_inputNumber name="Calculado#RHCRPTid#" value="#abs(Lvar_Dato)#" decimales="2" modificable="false" tabindex="1" style="border: 0; background-color: transparent;"></td>
                <td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>><cf_inputNumber name="Empleado#RHCRPTid#" value="#abs(Lvar_DatoE)#" decimales="2" modificable="#Lvar_Modificable#" tabindex="2" style="border: 0; background-color: transparent;" onblur="Verifica(Calculado#RHCRPTid#,this)"></td>
                <cfif isdefined('Autorizacion')>
                  <td align="right"><cf_inputNumber name="Autorizado#RHCRPTid#" value="#abs(Lvar_DatoA)#" decimales="2" modificable="true" tabindex="3" style="border: 0; background-color: transparent;" onblur="Verifica(Calculado#RHCRPTid#,this)"></td>
                </cfif>
				<td align="left"><textarea name="Observaciones#RHCRPTid#" rows="1" cols="50" <cfif isdefined('Autorizacion')>onclick="funcLimpia(this);" onfocus="funcLimpia(this);" onblur="funcRevisa(this);"</cfif> style="overflow:auto;<cfif isdefined('rsmonto') and not LEN(TRIM(rsmonto.Observaciones))>color:##CCCCCC;</cfif>" <cfif not isdefined('Autorizacion')>readonly</cfif>><cfif isdefined('rsmonto') and LEN(TRIM(rsmonto.Observaciones))>#rsmonto.Observaciones#<cfelse>Sin Observaciones</cfif></textarea></td>
              </tr>
              <cfset Lvar_TotalDEDC = Lvar_TotalDEDC + Lvar_Dato>
              <cfset Lvar_TotalDEDE = Lvar_TotalDEDE + Lvar_DatoE>
              <cfif isdefined('Autorizacion')>
                <cfset Lvar_TotalDEDA = Lvar_TotalDEDA + Lvar_DatoA>
              </cfif>
            </cfloop>
            <!---►►Seccion Total Deducciones◄◄--->
            <tr>
           		<td><cf_translate key="LB_RENTANETA"><strong>DEDUCCIONES</strong></cf_translate></td>
                <td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(Lvar_TotalDEDC,'none')#</strong></td>
                <td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>><strong>#LSCurrencyFormat(Lvar_TotalDEDE,'none')#</strong></td>
                <cfif isdefined('Autorizacion')>
                	<td align="right"><strong>#LSCurrencyFormat(Lvar_TotalDEDA,'none')#</strong></td>
                </cfif>
            </tr>
            <tr><td colspan="<cfif isdefined('Autorizacion')>4<cfelse>3</cfif>">&nbsp;</td></tr>
            <!---►►Seccion de Renta Imponible o Perdida Fiscal◄◄--->
            <cfset Lvar_TotalRIPFC = Lvar_TotalRBC - Lvar_TotalDEDC>
            <cfset Lvar_TotalRIPFE = Lvar_TotalRBE - Lvar_TotalDEDE>
            <cfif isdefined('Autorizacion')>
              <cfset Lvar_TotalRIPFA = Lvar_TotalRBA - Lvar_TotalDEDA>
            </cfif>
            <tr>
              <td><cf_translate key="LB_RENTANETA"><strong>RENTA IMPONIBLE O PERDIDA FISCAL</strong></cf_translate></td>
              <td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(Lvar_TotalRIPFC,'none')#</strong></td>
              <td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>><strong>#LSCurrencyFormat(Lvar_TotalRIPFE,'none')#</strong></td>
              <cfif isdefined('Autorizacion')>
                <td align="right"><strong>#LSCurrencyFormat(Lvar_TotalRIPFA,'none')#</strong></td>
              </cfif>
            </tr>
            <tr>
              <td colspan="<cfif isdefined('Autorizacion')>4<cfelse>3</cfif>">&nbsp;</td>
            </tr>
            <!---►►Seccion Impuesto Anual Determinado◄◄--->
            <cfset Lvar_TotalIADC = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFC)>
            <cfset Lvar_TotalIADE = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFE)>
            <cfif isdefined('Autorizacion')>
              <cfset Lvar_TotalIADA = ComProyRenta.ObtieneRenta(EncabezadoRenta.EIRid,Lvar_TotalRIPFA)>
            </cfif>
            <tr>
              <td><cf_translate key="LB_RENTANETA"><strong>IMPUESTO ANUAL DETERMINADO</strong></cf_translate></td>
              <td align="right" bgcolor="CCCCCC"><strong>#LSCurrencyFormat(Lvar_TotalIADC,'none')#</strong></td>
              <td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>><strong>#LSCurrencyFormat(Lvar_TotalIADE,'none')#</strong></td>
              <cfif isdefined('Autorizacion')>
                <td align="right"><strong>#LSCurrencyFormat(Lvar_TotalIADA,'none')#</strong></td>
              </cfif>
            </tr>
            <tr>
              <td colspan="<cfif isdefined('Autorizacion')>4<cfelse>3</cfif>">&nbsp;</td>
            </tr>
            <!---►►IVA Según Planilla◄◄--->
            <tr>
                    <td colspan="2">
                        <cf_translate key="LB_IVASegunPlanilla"><strong>IVA Según Planilla</strong></cf_translate>
                    </td>
                    <td width="20%" align="center" <cfif Autorizador>bgcolor="CCCCCC"</cfif>>
                        <cf_inputNumber name="RHLIVAplanilla_E" value="#RHLIVAplanilla_E#" decimales="2" modificable="#NOT Autorizador#" tabindex="3" style="border: 0; background-color: transparent;">
                    </td>
                <cfif isdefined('Autorizacion')>
                     <td width="20%" align="center">
                        <cf_inputNumber name="RHLIVAplanilla_A" value="#RHLIVAplanilla_A#" decimales="2" modificable="#Autorizador#" tabindex="3" style="border: 0; background-color: transparent;">
                     </td>
               	</cfif>
            </tr>
            <tr>
              <td colspan="<cfif isdefined('Autorizacion')>4<cfelse>3</cfif>">&nbsp;</td>
            </tr>
            <!---►►Monto IVA Máximo◄◄--->
            <tr>
              	<td><cf_translate key="LB_MontoIVAMaximo"><strong>Monto IVA Máximo</strong></cf_translate></td>
              	<td align="right" bgcolor="CCCCCC">
              		<strong>#LSCurrencyFormat(Lvar_TotalRBC * 0.12,'none')#</strong>
              	</td>
              	<td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>>
              		<strong>#LSCurrencyFormat(Lvar_TotalRBE * 0.12,'none')#</strong>
              	</td>
              <cfif isdefined('Autorizacion')>
                <td align="right">
                	<strong>#LSCurrencyFormat(Lvar_TotalRBA * 0.12,'none')#</strong>
                    <input name="CreditoIVA" type="hidden" value="#Lvar_TotalRBA * 0.12#" />
                </td>
              </cfif>
            </tr>
            <tr>
              <td colspan="<cfif isdefined('Autorizacion')>4<cfelse>3</cfif>">&nbsp;</td>
            </tr>
            <!---►►Seccion Renta Anual Calculada◄◄--->
            <!---
				 Impuesto a Retener: Impuesto determinado Anual– IVA SEGÚN PLANILLA - SI ES Negativo es cero.
				 Retenido en Exceso: Impuesto determinado Anual– IVA SEGÚN PLANILLA - SI ES Positivo es cero.
			--->
            	<cfset Lvar_RentaR   = ComProyRenta.ObtieneRentaRetenida(session.Ecodigo,form.DEid,TablaRenta.EIRdesde,TablaRenta.EIRhasta)>
            	<cfset Lvar_TotalIRE = Lvar_RentaR - RHLIVAplanilla_E>
            <cfif isdefined('Autorizacion')>
              	<cfset Lvar_TotalIRA = Lvar_RentaR - RHLIVAplanilla_A>
            </cfif>
            <tr>
              <td colspan="<cfif isdefined('Autorizacion')>4<cfelse>3</cfif>"><cf_translate key="LB_RENTACALCULADA"><strong>RENTA CALCULADA</strong></cf_translate></td>
            </tr>
            <!---subSeccion Renta de la Informacion de otros Patronos y Ex-patronos--->
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
                     <td align="right" <cfif Autorizador>bgcolor="CCCCCC"</cfif>>						
                        <cf_inputNumber name="rentaOtrasE#rsOrigen.RHROid#" value="#rsOrigen.RentaNetaEmp#" decimales="2" modificable="#NOT Autorizador#" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" >
                     </td>
                <cfif Autorizador>
                      <td align="right">
                        <cf_inputNumber name="rentaOtrasA#rsOrigen.RHROid#" value="#rsOrigen.RentaNetaAut#" decimales="2" modificable="#Autorizador#" tabindex="1" style="border: 0; font-weight:bold; background-color: transparent;" >
                      </td>
                </cfif>
                  </tr>
                </cfif>
             </cfloop>
            <!---►►subSeccion de Renta Retenida de la empresa Actual◄◄--->
            <cfif NOT ISDEFINED('rsDatos.RHLRentaRetenida') OR NOT LEN(TRIM(rsDatos.RHLRentaRetenida))>
            	<CFSET rsDatos.RHLRentaRetenida = Lvar_RentaR>
            </cfif>
            <cfset TotalRentaRetenida_H = TotalRentaRetenida_H + Lvar_RentaR>
            <cfset TotalRentaRetenida_E = TotalRentaRetenida_E + Lvar_RentaR>
            <cfset TotalRentaRetenida_A = TotalRentaRetenida_A + Lvar_RentaR>
            <tr>
                  <td align="left"><cf_translate key="LB_RENTARETENIDA"><strong>RENTA RETENIDA</strong></cf_translate>&nbsp;</td>
                  <td align="right" bgcolor="CCCCCC">
                        <strong>#LSCurrencyFormat(Lvar_RentaR,'none')#</strong>
                  </td>
                  <td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>>
                        <strong>#LSCurrencyFormat(Lvar_RentaR,'none')#</strong>
                  </td>
              <cfif isdefined('Autorizacion')>
                  <td align="right">
                  		<cf_inputNumber name="RHLRentaRetenida" value="#rsDatos.RHLRentaRetenida#" decimales="2" modificable="#Autorizador#" tabindex="3" style="border: 0; background-color: transparent;">
                  </td>
              </cfif>
            </tr>
            <!---subSeccion Total Renta Retenida--->
            <tr>
                    <td align="left"><cf_translate key="LB_totalrentaRetenida"><strong>TOTAL RENTA RETENIDA</strong></cf_translate>&nbsp;</td>
                    <td align="right" bgcolor="CCCCCC"> <strong>#LSCurrencyFormat(TotalRentaRetenida_H, 'none')# </strong> </td>
                    <td align="right" <cfif Autorizador>bgcolor="CCCCCC"  </cfif>> <strong>#LSCurrencyFormat(TotalRentaRetenida_E, 'none')# </strong> </td>
                <cfif Autorizador>
                    <td align="right"> <strong>#LSCurrencyFormat(TotalRentaRetenida_A, 'none')# </strong> </td>
                </cfif>
            </tr>
             <!---►►subSeccion de Impuesto a retener◄◄--->
            <tr>
              <td align="left" colspan="2">
              		<cf_translate key="LB_IMPUESTOARETENER"><strong>IMPUESTO A RETENER</strong></cf_translate> &nbsp;
              </td>
              <td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>>
              		<strong><cfif Lvar_TotalIRE GT 0>#LSCurrencyFormat(Lvar_TotalIRE,'none')#<cfelse>0.00</cfif></strong>
              </td>
              <cfif Autorizador>
               	<td align="right">
                	<strong><cfif Lvar_TotalIRA GT 0>#LSCurrencyFormat(Lvar_TotalIRA,'none')#<cfelse>0.00</cfif></strong>
                </td>
              </cfif>
            </tr>
             <!---►►subSeccion de Retenido en Exceso◄◄--->
            <tr>
              <td align="left" colspan="2"><cf_translate key="LB_RETENIDOENEXCESO"><strong>RETENIDO EN EXCESO</strong></cf_translate>&nbsp;</td>
              <td align="right" <cfif isdefined('Autorizacion')>bgcolor="CCCCCC"</cfif>>
              		<strong><cfif Lvar_TotalIRE LT 0>#LSCurrencyFormat(Lvar_TotalIRE,'none')#<cfelse>0.00</cfif></strong>
              </td>
              <cfif isdefined('Autorizacion')>
                <td align="right">
                	<strong><cfif Lvar_TotalIRA LT 0>#LSCurrencyFormat(Lvar_TotalIRA,'none')#<cfelse>0.00</cfif></strong>
                </td>
              </cfif>
            </tr>
            <input name="RentaAnual" 		type="hidden" value="#Lvar_TotalRBA#" />
            <input name="RentaRetenida" 	type="hidden" value="#Lvar_RentaR#" />
            <input name="ImpuestoRetener" 	type="hidden" value="#Lvar_TotalIRA#" />
            <input name="RetenidoExceso" 	type="hidden" value="#abs(Lvar_TotalIRA)#" />
			<input name="RentaImponible" 	type="hidden" value="#Lvar_TotalRIPFA#" />
			<input name="ImpuestoAnualDet" 	type="hidden" value="#Lvar_TotalIADA#" />			
			
          </table></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
            	<cfset Lvar_Botones="">
              <cfif Autorizador>
                    <cfif EncabezadoRenta.USRInicia EQ 'Usuario'>
                    	<cfset Lvar_Botones = 'Rechazar,'>	
                    </cfif>
                    	<cfset Lvar_Botones = Lvar_Botones  & 'Finalizar'>	
               <cfelse>
					<cfset Lvar_Botones = 'Enviar_a_Autorizacion'>
               </cfif>
               	<cf_botones values="Guardar,Eliminar,#Lvar_Botones#,Regresar,Imprimir" tabindex="4">
             </td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</form>
<cf_qforms form="formLid" objForm="objForm2">
		<cf_qformsRequiredField args="RHLIVAplanilla_E,IVA Según Planilla Empleado">
	<cfif Autorizador>
    	<cf_qformsRequiredField args="RHLIVAplanilla_A,IVA Según Planilla Autorizado">
		<cf_qformsRequiredField args="RHLRentaRetenida,Renta Retenida">
	</cfif>
</cf_qforms>
</cfoutput>
<script>
	function Verifica(valor1,valor2){
		if (valor1.value >= valor2.value){
			valor2.value = valor1.value;
		}
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
		<cfoutput>
			window.open('/cfmx/rh/autogestion/operacion/ProyLiquiRenta-Report.cfm?RHRentaId=#form.RHRentaId#&Autorizacion=#Autorizador#', 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=650,left=130,top=50,screenX=150,screenY=150');
		</cfoutput>
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