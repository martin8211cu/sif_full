<!--- Obtiene los datos del reporte --->
<cfinclude template="TotalesMercaderiaTransito-dbcommon.cfm">

<cfoutput>
<cfset Title          = "Reporte de Totales de la Mercadería en Tránsito">
<cfset FileName       = "TotalesMerTran">
<cfset FileName 	  = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">
<cfset vnDebitosOrden = 0>		<!----Variable numerica para los debitos de c/orden---->
<cfset vnCreditoOrden = 0>	    <!----Variable numerica para los creditos de c/linea---->
<cfset vsCorte 		  = ''>  			<!----Variable string con el numero de orden para efectos del corte ---->
<cfset vsPrimeraVez   = true>		<!---Variable par indicar el corte de totales por orden de compra---->
<cfset rsMonedas 	  = fnGetMoneda()>
<cf_htmlreportsheaders title="#Title#" filename="#FileName#" download="yes" ira="TotalesMercaderiaTransito.cfm">
<!---►►ENCABEZADO DEL REPORTE◄◄--->
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<!---►Nombre de la empresa --->
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>17<cfelse>15</cfif>" class="tituloAlterno" align="center"><strong>#session.Enombre#</strong></td>
	</tr>
	<!---►Titulo --->
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>17<cfelse>15</cfif>" class="letra" align="center"><b><font size="2">Auxiliar de Mercancías en Tránsito - #rsAuxiliarTransito.Cdescripcion#</font></b></td>
	</tr>
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>17<cfelse>15</cfif>" class="letra" align="center"><b><font size="2">Reporte de Total de Movimientos</font></b></td>
	</tr>
	<!---►Rango de Fechas de la consulta --->
	<cfif isdefined("form.fechaInicial") and len(trim(form.FechaInicial)) or isdefined("form.fechaFinal") and len(trim(form.FechaFinal))>
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>17<cfelse>15</cfif>" align="center" class="letra"><b>Fecha Inicial:</b> #form.fechainicial# &nbsp; <b> Final: </b>#form.FechaFinal#</td>
	</tr>
	</cfif>
	<!---►Fecha de la consulta --->
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>17<cfelse>15</cfif>" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
	<!---►Moneda (local) --->
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>17<cfelse>15</cfif>" align="center" class="letra"><b>Moneda:&nbsp;</b>#rsMonedas.Mnombre#</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
<cfflush interval="64">
<!---►►DETALLE DEL REPORTE◄◄--->
<table width="98%" cellpadding="1" cellspacing="0" border="0">
	<cfif rsTotalesMT.RecordCount NEQ 0>
  		<cfset vnSaldoActual   = 0>
	  	<cfset vnTotalAnterior = 0>
		
        <cfloop query="rsTotalesMT">
	  		<cfif vsCorte NEQ rsTotalesMT.OrdenCompra>
		  		<!---►Total de movimientos de una orden --->
				<cfif rsTotalesMT.CurrentRow neq 1>
                	<tr>
                    	<td colspan="10" align="right"><strong>Total de movimientos por orden de compra:&nbsp;&nbsp;</strong></td>
                        <td align="right" style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black;">#LSNumberFormat(vnDebitosOrden,',9.0000')#</td>
                        <td align="right" style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black;">#LSNumberFormat(vnCreditoOrden,',9.0000')#</td>
                    </tr>
           		</cfif>
		  			<tr><td colspan="13">&nbsp;</td></tr>
		  			<tr><td colspan="13">&nbsp;</td></tr>
				<!---►Proveedor de la orden de compra --->
                  	<tr style="background-color:##CCCCCC;">
                    	<td colspan="2"><strong>Proveedor:&nbsp;</strong></td>
                    	<td colspan="13" >&nbsp;#rsTotalesMT.CedulaProveedor#&nbsp;-&nbsp;#rsTotalesMT.NombreProveedor#</td>
                  	</tr>
		  		<!---►Orden de compra --->
                  	<tr style="background-color:##CCCCCC;">
                    	<td colspan="2" nowrap ><strong>N° Orden Compra:&nbsp;</strong></td>
                    	<td colspan="13">&nbsp;#rsTotalesMT.OrdenCompra#</td>
                  	</tr>
		  		<!----►Calculo del monto anterior----->
                    <cfinvoke method="fnGetSaldoAnterior" returnvariable="vnTotalAnterior">
                            <cfinvokeargument name="EOidorden" value="#rsTotalesMT.EOidorden#">
                        <cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
                            <cfinvokeargument name="DTfechamov" value="#LSParseDateTime(form.FechaInicial)#">
                        </cfif>
                        <cfif isdefined('form.Ccuenta') and len(trim(form.Ccuenta))>
                            <cfinvokeargument name="CTcuenta" value="#form.Ccuenta#">
                        </cfif>
                    </cfinvoke>
		  			<tr style="background-color:##CCCCCC;">
                        <td colspan="2" nowrap ><strong>Saldo Anterior:&nbsp;</strong></td>
                        <td colspan="13">&nbsp;#LSNumberFormat(vnTotalAnterior,',9.0000')#</td>
                  	</tr>
  		  		<!---►Cálculo del saldo actual --->
		  		<cfinvoke method="fnGetSaldoActual" returnvariable="vnSaldoActual">
                		<cfinvokeargument name="SaldoAnterior" 	value="#vnTotalAnterior#">
                    	<cfinvokeargument name="EOidorden" 		value="#rsTotalesMT.EOidorden#">
                    <cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>
                    	<cfinvokeargument name="BMUsucodigo" 	value="#form.Usucodigo#">
                    </cfif>
                    <cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>
                    	<cfinvokeargument name="SNcodigo" 		value="#form.SNcodigo1#">
                    </cfif>
                   <cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
                    	<cfinvokeargument name="FechaInicial" 	value="#LSParseDateTime(form.FechaInicial)#">
                    </cfif>
                    <cfif isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
                    	<cfinvokeargument name="FechaFinal" 	value="#LSParseDateTime(form.FechaFinal)#">
                    </cfif>
                    <cfif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1))>
                    	<cfinvokeargument name="ETidtracking" 	value="#form.ETidtracking_move1#">
                    </cfif>
                    <cfif isdefined("form.EPDid") and len(trim(form.EPDid))>
                    	<cfinvokeargument name="EPDid" 			value="#form.EPDid#">
                    </cfif>
                    <cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
                    	<cfinvokeargument name="CTcuenta" 		value="#form.Ccuenta#">
                    </cfif>
                </cfinvoke>
		  		<tr style="background-color:##CCCCCC;">
					<td colspan="2" nowrap ><strong>Saldo Actual:&nbsp;</strong></td>
					<td colspan="13">&nbsp;#LSNumberFormat(vnSaldoActual,',9.0000')#</td>
		  		</tr>
		  		<!---►Nombre de las columnas --->
                    <tr class="tituloListas">
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-left:  1px solid black; border-right: 1px solid black;" align="left"><strong>Movimiento&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" nowrap><strong>Tipo Documento&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="center"><strong>N° Documento&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="center"><strong>Cuenta Contable&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="center"><strong>N° Tracking&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="center"><strong>N° Desalmacenaje&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" ><strong>Fecha&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" nowrap><strong>N° Asiento&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" ><strong>Usuario&nbsp;</strong></td>
                        <td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="center"><strong>Tipo cambio&nbsp;</strong></td>
                        <td colspan="2" style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="center"><strong>Movimientos&nbsp;</strong></td>
                    <cfif isdefined("form.ColumnasAdicionales")>
                      	<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="center"><strong>Orden Compra&nbsp;</strong></td>
                      	<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" align="center"><strong>Cédula Proveedor&nbsp;</strong></td>
                      	<td style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black;" ><strong>Nombre Proveedor&nbsp;</strong></td>
                    </cfif>
              	</tr>
				  <cfset vnDebitosOrden = 0>
                  <cfset vnCreditoOrden = 0>
                  <cfset PrimeraVez = false>
		</cfif>
		<cfif not isdefined("form.AgruparTotales")>
			<tr>
                <td colspan="13">
                    <table width="100%" cellpadding="0" cellspacing="0">
                    	<tr>
                        	<td width="1%"><strong>Item:</strong></td>
                        	<td width="99%">&nbsp;&nbsp;#rsTotalesMT.DOdescripcion#</td>
                    	</tr>
                    </table>
                </td>
			</tr>
		</cfif>
			<tr>
		  	<td>#rsTotalesMT.Movimiento#&nbsp;</td>
            	<td nowrap>#rsTotalesMT.TipoDocumento#&nbsp;</td>
              	<td>#rsTotalesMT.NumeroDocumento#&nbsp;</td>
                <td>#rsTotalesMT.CFformato#&nbsp;</td>
              	<td align="center">#rsTotalesMT.NumeroTracking#&nbsp;</td>
              	<td align="center">#rsTotalesMT.NumeroPoliza#&nbsp;</td>
              	<cfif rsTotalesMT.Fecha neq "">
					<td>#DateFormat(rsTotalesMT.Fecha,'dd/mm/yyyy')#&nbsp;</td>
				<cfelse>
					<td>&nbsp;</td>	
				</cfif>
				<td>#rsTotalesMT.NumeroAsiento#&nbsp;</td>
              	<td>#rsTotalesMT.usulogin#&nbsp;</td>
              	<td align="center">#rsTotalesMT.TipoCambio#&nbsp;</td>
              	<td align="right" nowrap style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black; border-right:1px solid black;">
					<cfif rsTotalesMT.DTmonto GE 0>
                        #LSNumberFormat(rsTotalesMT.DTmonto,',9.0000')#
                        <cfset vnDebitos = vnDebitos + abs(rsTotalesMT.DTmonto)>	
                        <cfset vnDebitosOrden = vnDebitosOrden + abs(rsTotalesMT.DTmonto)>
                    <cfelse>
                        &nbsp;
                    </cfif>
		  		</td>
		  		<td align="right" nowrap style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black; border-right:1px solid black;">
					<cfif rsTotalesMT.DTmonto LT 0>
						#LSNumberFormat(abs(rsTotalesMT.DTmonto),',9.0000')#</td>
						<cfset vnCreditos = vnCreditos + abs(rsTotalesMT.DTmonto)>	
						<cfset vnCreditoOrden = vnCreditoOrden + abs(rsTotalesMT.DTmonto)>
					<cfelse>
						&nbsp;
					</cfif>
		  		</td>
		  		<cfif isdefined("form.ColumnasAdicionales")>
					<td align="center">#rsTotalesMT.OrdenCompra#&nbsp;</td>
					<td>#rsTotalesMT.CedulaProveedor#&nbsp;</td>
					<td>#rsTotalesMT.NombreProveedor#&nbsp;</td>
		  		</cfif>
			</tr>
			<cfset vsCorte = rsTotalesMT.OrdenCompra>		
	  </cfloop>
	<cfelse>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="13" align="center"><strong>---- No se encontraron datos ----</strong></td></tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>

		<cfif rsTotalesMT.RecordCount gt 0>
			<tr>
				<td colspan="10" align="right"><strong>Total de movimientos por orden de compra:&nbsp;&nbsp;</strong></td>
				<td align="right" style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black;">#LSNumberFormat(vnDebitosOrden,',9.0000')#</td>
				<td align="right" style="border-bottom: 1px solid black; border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black;">#LSNumberFormat(vnCreditoOrden,',9.0000')#</td>
			</tr>
		</cfif>
        <tr><td colspan="5">&nbsp;</td></tr>
		<tr>
        	<td colspan="11">
            	<table cellpadding="0" cellspacing="0" border="0" align="center">
				  <!---►►►►Obtener el Montos Anterior del Reporte, que cumpla con los filtros, 
                 		y que SI halla tenido Movimientos entre el rango de fechas (este monto Puede NO pegar con Auxiliares, 
                 		pero SI es la sumatoria de los Saldos Anteriores del Reporte)◄◄◄◄--->
						<cfset vnTotalAnterioReporte = 0>
                		<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
                        <cfquery name="rsAnteriorReporte" datasource="#session.dsn#">
                            select coalesce(#LvarCalculoMontoAnterior#,0) as totalAnterior
                              from CMDetalleTransito a
                               LEFT OUTER JOIN DPolizaDesalmacenaje dpd
                                    ON dpd.DPDlinea = a.DPDlinea
                                    
                                left outer join EDocumentosI h
                                    on a.EDIid = h.EDIid 
                                    and a.Ecodigo = h.Ecodigo
									
								left join HEDocumentosCP z
									on z.Ddocumento = h.Ddocumento	
                            
                                left outer join  Usuario i
                                    on a.BMUsucodigo = i.Usucodigo
                                    
                                    inner join DatosPersonales j
                                        on i.datos_personales = j.datos_personales		
                            
                                inner join ETracking f
                                    on a.ETidtracking = f.ETidtracking
                                    and a.Ecodigo = f.Ecodigo
                            
                                left outer join EPolizaDesalmacenaje g
                                    on a.EPDid = g.EPDid	
                                    and a.Ecodigo = g.Ecodigo		

                                inner join DOrdenCM b
                                    on a.DOlinea = b.DOlinea
                                    and a.EOidorden = b.EOidorden
                                
                                            
                                inner join EOrdenCM c
                                    on a.EOidorden = c.EOidorden
                        
                                inner join SNegocios d
                                    on c.SNcodigo = d.SNcodigo
                                    and c.Ecodigo = d.Ecodigo
                                 
                                 LEFT OUTER JOIN CFinanciera cf
                                    on cf.Ccuenta = a.CTcuenta
                            where <cf_dbfunction name="to_date00" args="DTfechamov"> < <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaInicial)#">
                              and a.EOidorden  IN (select a.EOidorden
                                                    from CMDetalleTransito a
                                                        inner join ETracking f
                                                            on a.ETidtracking = f.ETidtracking
                                                           and a.Ecodigo 	  = f.Ecodigo
                                                         inner join DOrdenCM b
                                                            on a.DOlinea 	= b.DOlinea
                                                           and a.EOidorden  = b.EOidorden
                                                          
                                                        inner join EOrdenCM c
                                                            on a.EOidorden 	= c.EOidorden
                                                        inner join SNegocios d
                                                                on c.SNcodigo = d.SNcodigo
                                                                and c.Ecodigo = d.Ecodigo
                                                    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">					
                                                        <!---Filtro del usuario----->
                                                        <cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>
                                                            and a.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
                                                        </cfif>
                                                        <!---Filtro del socio de negocio---->
                                                        <cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>
                                                            and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#">
                                                        </cfif>
                                                        <!----Filtro de numeros de orden de compra---->
                                                        <cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and (isdefined("form.EOnumero2")) and len(trim(form.EOnumero2)) EQ 0>
                                                            and c.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
                                                        <cfelseif isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) and (isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) EQ 0)>
                                                            and c.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
                                                        <cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>	
                                                            and c.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
                                                        </cfif> 	
														<!---
														
                                                        <!----Filtro de fechas de la poliza----->
                                                        <cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
                                                            and <cf_dbfunction name="to_date00"	args="a.DTfechamov"> >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaInicial)#">
                                                        </cfif>
                                                        <cfif isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
                                                            and <cf_dbfunction name="to_date00"	args="a.DTfechamov"> <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaFinal)#">
                                                        </cfif>
														--->
														
														<!----Filtro de fechas de la poliza,----->
        
														<!--- Fechas Desde / Hasta --->
															<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial)) and isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
																<cfif datecompare(form.FechaInicial, form.FechaFinal) eq -1> 
																	<cfset LvarFecha1 =  lsparsedatetime(form.FechaInicial)>
																<cfset LvarFecha2 =  lsparsedatetime(form.FechaFinal)>
																	<cfelseif datecompare(form.FechaInicial, form.FechaFinal) eq 1>
																<cfset LvarFecha1 =  lsparsedatetime(form.FechaFinal)>
																	<cfset LvarFecha2 =  lsparsedatetime(form.FechaInicial)>
																<cfelseif datecompare(form.FechaInicial, form.FechaFinal) eq 0>
																	<cfset LvarFecha1 =  lsparsedatetime(form.FechaInicial)>
																	<cfset LvarFecha2 =  LvarFecha1>
																</cfif>
																<cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
																	and coalesce(z.EDfechaaplica,DTfechamov)  between <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha1#">
																	and <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha2#">
																
														   <cfelseif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
																and coalesce(z.EDfechaaplica,DTfechamov) >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaInicial)#">
														   <cfelseif isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
																<cfset LvarFecha2 =  lsparsedatetime(form.FechaFinal)>
																<cfset LvarFecha2 =  dateAdd("s",86399,LvarFecha2)>
																and coalesce(z.EDfechaaplica,DTfechamov) <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha2#">
															</cfif>
														
                                                        <!---Filtro de numero de tracking----->
                                                        <cfif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1))>
                                                            and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
                                                        </cfif>
                                                        <!---Filtro de póliza---->
                                                        <cfif isdefined("form.EPDid") and len(trim(form.EPDid))>
                                                            and a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
                                                        </cfif>				
                                                        <cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
                                                            and a.CTcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">
                                                        </cfif>
                                                        #LvarFiltroImpuestoSeguro#
                                                )
                                                
                            </cfquery>
                     		<cfif isdefined('rsAnteriorReporte') and rsAnteriorReporte.totalAnterior NEQ 0>
                           		<cfset vnTotalAnterioReporte = rsAnteriorReporte.totalAnterior>
                    		</cfif>		
               		 </cfif>
                	<tr><td colspan="13">&nbsp;</td></tr>
                <tr>
                    <td align="center" bgcolor="##C4C4C4" colspan="6"><strong>Total consulta</strong></td>
                </tr>
                <tr>
                    <td colspan="2" align="right" nowrap style="border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black;"><strong>Total Anterior</strong></td>
                    <td colspan="2" align="right" nowrap style="border-top: 1px solid black; border-right: 1px solid black;"><strong>Débitos</strong></td>
                    <td align="right" style="border-top: 1px solid black; border-right: 1px solid black;"><strong>Créditos</strong></td>
                    <td align="right" style="border-top: 1px solid black; border-right: 1px solid black;"><strong>Saldo Actual</strong></td>
                </tr>
                <tr>
                    <td colspan="2" align="right" class="titulolistas" style="border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black; border-bottom: 1px solid black;">#LSNumberFormat(vnTotalAnterioReporte,',9.0000')#</td>
                    <td colspan="2" align="right" class="titulolistas" style="border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">#LSNumberFormat(vnDebitos,',9.0000')#</td>
                    <td align="right" class="titulolistas" style="border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">#LSNumberFormat(vnCreditos,',9.0000')#</td>
                    <td align="right" class="titulolistas" style="border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">#LSNumberFormat(vnTotalAnterioReporte + vnDebitos - vnCreditos,',9.0000')#</td>
                </tr>
					
					<!---►►►►Obtener el Montos Anterior Auxiliar, inferior a la fecha Desde del Filtro, 
							 halla tenido o no Movimientos entre el rango de fechas (este monto pega con Auxiliares, 
							 pero no es la sumatoria de los Saldos Anteriores del Reporte)
					 ◄◄◄◄--->
                     <cfset vnSaldoAnteriorTotal = 0>
					<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
                        <cfquery name="rsTotalAnterior" datasource="#session.DSN#">
                            select coalesce(#LvarCalculoMontoAnterior#,0) as totalAnterior
                            from CMDetalleTransito a
                            	LEFT OUTER JOIN DPolizaDesalmacenaje dpd
                                    ON dpd.DPDlinea = a.DPDlinea
                                    
                                left outer join EDocumentosI h
                                    on a.EDIid = h.EDIid 
                                    and a.Ecodigo = h.Ecodigo
									
								left join HEDocumentosCP z
									on z.Ddocumento = h.Ddocumento
                            
                                left outer join  Usuario i
                                    on a.BMUsucodigo = i.Usucodigo
                                    
                                    inner join DatosPersonales j
                                        on i.datos_personales = j.datos_personales		
                            
                                inner join ETracking f
                                    on a.ETidtracking = f.ETidtracking
                                    and a.Ecodigo = f.Ecodigo
                            
                                left outer join EPolizaDesalmacenaje g
                                    on a.EPDid = g.EPDid	
                                    and a.Ecodigo = g.Ecodigo		
                                    
                                inner join DOrdenCM b
                                    on a.DOlinea = b.DOlinea
                                    and a.EOidorden = b.EOidorden
                                 
								left join EOrdenCM c
									on a.EOidorden = c.EOidorden

								left join SNegocios d
									on c.SNcodigo = d.SNcodigo
									and c.Ecodigo = d.Ecodigo
                              
                            where a.Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#session.Ecodigo#">					
                            <!---Filtro del usuario----->
                            <cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo))>
                                and a.BMUsucodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
                            </cfif>
                            <!---Filtro del socio de negocio---->
                            <cfif isdefined("form.SNcodigo1") and len(trim(form.SNcodigo1))>
                                and c.SNcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.SNcodigo1#">
                            </cfif>
                            <!----Filtro de numeros de orden de compra---->
                            <cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and (isdefined("form.EOnumero2")) and len(trim(form.EOnumero2)) EQ 0>
                                and c.EOnumero >= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
                            <cfelseif isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) and (isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) EQ 0)>
                                and c.EOnumero <= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
                            <cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>	
                                and c.EOnumero between <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
                            </cfif> 	
                            <!----Filtro de fechas de la poliza----->
                            <cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
                                and coalesce(EDfechaaplica,DTfechamov)  < <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaInicial)#">
                            </cfif>
                            <!---Filtro de numero de tracking----->
                            <cfif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1))>
                                and a.ETidtracking = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
                            </cfif>
                            <!---Filtro de póliza---->
                            <cfif isdefined("form.EPDid") and len(trim(form.EPDid))>
                                and a.EPDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.EPDid#">
                            </cfif>				
                            <cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
                                and a.CTcuenta = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">
                            </cfif>
                            #LvarFiltroImpuestoSeguro#
                        </cfquery>
                        <cfif isdefined('rsTotalAnterior') and rsTotalAnterior.totalAnterior NEQ 0>
                                <cfset vnSaldoAnteriorTotal = rsTotalAnterior.totalAnterior>
                        </cfif>		
                    </cfif>
                   <tr><td colspan="13">&nbsp;</td></tr>
                    <tr>
                    	<td align="center" bgcolor="##C4C4C4" colspan="6"><strong>Total consulta auxiliar(Con o sin Movimientos en las Fechas Filtro)</strong></td>
               		</tr>
                	<tr>
                        <td colspan="2" align="right" nowrap style="border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black;"><strong>Total Anterior</strong></td>
                        <td colspan="2" align="right" nowrap style="border-top: 1px solid black; border-right: 1px solid black;"><strong>Débitos</strong></td>
                        <td align="right" style="border-top: 1px solid black; border-right: 1px solid black;"><strong>Créditos</strong></td>
                        <td align="right" style="border-top: 1px solid black; border-right: 1px solid black;"><strong>Saldo Actual</strong></td>
                	</tr>
                	<tr>
                        <td colspan="2" align="right" class="titulolistas" style="border-top: 1px solid black; border-right: 1px solid black; border-left: 1px solid black; border-bottom: 1px solid black;">#LSNumberFormat(vnSaldoAnteriorTotal,',9.0000')#</td>
                        <td colspan="2" align="right" class="titulolistas" style="border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">#LSNumberFormat(vnDebitos,',9.0000')#</td>
                        <td align="right" class="titulolistas" style="border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">#LSNumberFormat(vnCreditos,',9.0000')#</td>
                        <td align="right" class="titulolistas" style="border-top: 1px solid black; border-right: 1px solid black; border-bottom: 1px solid black;">#LSNumberFormat(vnSaldoAnteriorTotal + vnDebitos - vnCreditos,',9.0000')#</td>
                	</tr>
                </table>
             </td>
	</tr>
     <tr><td colspan="13">&nbsp;</td></tr>
</table>
</cfoutput>
<!---►►►►Funcion para obtener la moneda Local◄◄◄--->
<cffunction name="fnGetMoneda" access="private" returntype="query">
	<cfquery name="rsMonedas" datasource="#session.DSN#">
			select b.Mnombre
			from Empresas a 
				inner join Monedas b
					on a.Mcodigo = b.Mcodigo
					and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
    <cfreturn rsMonedas>
</cffunction>
<!---►►►►Funcion para obtener el Montos Anterior de una Orden de Compra◄◄◄◄--->
<cffunction name="fnGetSaldoAnterior" access="private" returntype="numeric">
	<cfargument name="EOidorden"  type="numeric" required="yes">
	 <cfargument name="DTfechamov" type="date" 	 required="no">
      <cfargument name="CTcuenta"   type="numeric" required="no">
   	   <cfargument name="Conexion"  type="string"  required="no">
    
    <cfif NOT isdefined('Arguments.Conexion')>
    	<cfset Arguments.Conexion = session.dsn>
    </cfif>
    
    <cfif NOT isdefined('Arguments.DTfechamov')>
		<cfreturn 0>
	</cfif>
    <cfquery name="rsTotalAnterior" datasource="#Arguments.Conexion#">
		select coalesce(sum(a.DTmonto * a.tipocambio),0) as totalAnterior
			from CMDetalleTransito a
				
				left outer join EDocumentosI h
					on a.EDIid = h.EDIid 
					and a.Ecodigo = h.Ecodigo
				
				left join HEDocumentosCP z
					on z.Ddocumento = h.Ddocumento
				
		  where a.EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#"> 
		  	<cfif isdefined('Arguments.DTfechamov')>
            	and coalesce(EDfechaaplica,DTfechamov)  <= <cfqueryparam cfsqltype="cf_sql_date"    value="#Arguments.DTfechamov#">
            </cfif>
		  <cfif isdefined("Arguments.Ccuenta")>
			and CTcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">
		  </cfif>
	</cfquery>
    <cfif rsTotalAnterior.RecordCount gt 0>			  
		  <cfreturn rsTotalAnterior.totalAnterior>
    <cfelse>
          <cfreturn 0>
     </cfif>
</cffunction>
<!---►►►►Funcion para obtener el Montos Actual de una Orden de Compra◄◄◄◄--->
<cffunction name="fnGetSaldoActual" access="private" returntype="numeric">
	<cfargument name="Ecodigo"       type="numeric"  required="no">
   	 <cfargument name="Conexion"      type="string"   required="no">
   	  <cfargument name="EOidorden"     type="numeric"  required="yes">
       <cfargument name="BMUsucodigo"   type="numeric"  required="no">
        <cfargument name="SNcodigo"  	 type="numeric"  required="no">
         <cfargument name="FechaInicial"  type="date"     required="no">
          <cfargument name="FechaFinal"    type="date"     required="no">
           <cfargument name="ETidtracking"  type="numeric"  required="no">
            <cfargument name="EPDid"  		 type="numeric"  required="no">
             <cfargument name="CTcuenta"  	  type="numeric"  required="no">
              <cfargument name="SaldoAnterior"  type="numeric"  required="yes">
     
			  <cfif NOT isdefined('Arguments.Ecodigo')>
                    <cfset Arguments.Ecodigo = session.Ecodigo>
              </cfif>
              <cfif NOT isdefined('Arguments.Conexion')>
                    <cfset Arguments.Conexion = session.dsn>
              </cfif>
    
 	<cfquery name="rsTotalActual" datasource="#session.dsn#">
		select coalesce(sum(a.DTmonto * a.tipocambio), 0) as totalActual				
			
			from CMDetalleTransito a
				
				left outer join EDocumentosI h
					on a.EDIid = h.EDIid 
					and a.Ecodigo = h.Ecodigo
				
				left join HEDocumentosCP z
					on z.Ddocumento = h.Ddocumento
					
				inner join EOrdenCM c
					on c.EOidorden = a.EOidorden
				   and c.Ecodigo   = a.Ecodigo
			  where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  	and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EOidorden#">
			<cfif isdefined("Arguments.BMUsucodigo")>
                and a.BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">
            </cfif>
			<cfif isdefined("Arguments.SNcodigo")>
                and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
            </cfif>
			<cfif isdefined("Arguments.FechaInicial")>
                and coalesce(EDfechaaplica,DTfechamov)  >= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaInicial#">
            </cfif>
			<cfif isdefined("Arguments.FechaFinal")>
                and coalesce(EDfechaaplica,DTfechamov)  <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaFinal#">
            </cfif>
			<cfif isdefined("Arguments.ETidtracking")>
                and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETidtracking#">
            </cfif>
			<cfif isdefined("Arguments.EPDid")>
                and a.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EPDid#">
            </cfif>				
            <cfif isdefined("Arguments.CTcuenta")>
                and a.CTcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTcuenta#">
            </cfif>
	</cfquery>
		  <cfif rsTotalActual.RecordCount gt 0>
		  		<cfreturn Arguments.SaldoAnterior + rsTotalActual.totalActual>
          <cfelse>
          		<cfreturn Arguments.SaldoAnterior>
		  </cfif>
</cffunction>