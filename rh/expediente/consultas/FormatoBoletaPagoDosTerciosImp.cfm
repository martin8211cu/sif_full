	<!---Verificar cual es el formato de boleta--->
	<cfquery name="rsFormato" datasource="#session.DSN#">
		select coalesce(Pvalor,'20') as Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 720
	</cfquery>

	<cfif isdefined("rsFormato") and rsFormato.Pvalor EQ '30'>
		<!---*******************************************************************---->
		<!---FORMATO PARA 1/2 DE PAGINA (COOPELESCA)--->
		<!---*******************************************************************---->
		<cfinclude template="FormatoBoletaPagoMediaPag.cfm">
	<cfelse>
		<!---*******************************************************************---->
		<!---FORMATO PARA 1/3 DE PAGINA (CEFA)--->
		<!---*******************************************************************---->
		<!----========================================================---->
		<!--- 	Para utilizar este archivo se requiere:
				** Tabla temporal ConceptosPago = Esta tabla contiene todos los conceptos de pago.
					-Campo descconcepto,cantconcepto,montoconcepto = Conceptos que suman (columna 1 - izquierda)
					-Campos descconceptoB,cantconceptoB,montoconceptoB  = Conceptos que restan (columna 2 - derecha)
					--RCNid (Mismo que CPid) = Calendario de pagos
				** Variable vb_pagebreak:
						true = hace corte de pagina por cada 10 lineas de conceptos.
						false = no hace corte de pagina por "tamaño", solo por empleado.
				**Variable vb_flashpaper:
						true = Indica que el formato es flashpape, por lo tanto se agrega una linea mas en el margen superior....		
						false = El formato es PDF...
		----->							
		<cfif not isdefined("vb_pagebreak")>
			<cfset vb_pagebreak = false>
		</cfif>
		<cfif not isdefined("vb_flashpaper")>
			<cfset vb_flashpaper = false>
		</cfif>
		<cfif vb_flashpaper is true>
			<cfset lineas = 22>
			<cfset lineasPagina = 66>	
		<cfelse>
			<cfset lineas = 26>
			<cfset lineasPagina = 69>
		</cfif>
		<!----========================================================---->
		<!----================= TODO EL COMPROBANTE  =================----->		
		<cfsavecontent variable="DETALLE">
			<cfif vb_pagebreak is true>
				<style type="text/css">
					td {font-size: 9pt; font-family: Arial, Helvetica, sans-serif; font-weight: normal}
					.saltopagina {
					  page-break-after: always;
					 } 
					 comprobante{font-family:Arial, Helvetica, sans-serif; font-size:12pt;}
					 empresa{font-family:Arial, Helvetica, sans-serif; font-size:12pt;}
				</style>
				<!---Tamaños fijos de columnas y tabla---->
				<cfset vs_width = '948'>
				<cfset vn_250 = '250'>
				<cfset vn_80 = '80'>
				<cfset vn_100 = '120'>
				<cfset vn_120 = '120'>
				<cfset vn_7 = '11'>
				<cfset vn_270 = '270'>
			<cfelse>	
				<style type="text/css">
					td {font-size: 7pt; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
					.saltopagina {
					  page-break-after: always;
					 } 
					 comprobante{font-family:Arial, Helvetica, sans-serif; font-size:10pt;}
					 empresa{font-family:Arial, Helvetica, sans-serif; font-size:10pt;}
				</style>
				<!---Tamaños variables (%) de columnas y tabla---->				
				<cfset vs_width = '100%'>
				<cfset vn_250 = '25%'>
				<cfset vn_100 = '5%'>
				<cfset vn_80 = '10%'>				
				<cfset vn_120 = '15%'>
				<cfset vn_7 = '6%'>
				<cfset vn_270 = '26%'>
			</cfif>
			
			<cfoutput><table width="#vs_width#"  border="0" cellspacing="0" cellpadding="0" align="center"></cfoutput><!----950---->	
				<CFSET CONTADOR_GRAL = 0>
				<cfoutput query="ConceptosPago" group="DEid">
					<cfset vn_DEid = DEid>
					<CFSET CONTADOR = 1>			<!---Contador de lineas por c/tercio de pagina. Pueden ser 26 lineas--->		
					<CFSET CURRENT = 0>
					<cfset VN_CONTADORPAGINAS = 1>	<!---Contador de paginas, si son mas de 10 conceptos se colocan en otra boleta con numero de pagina---->			
					<cfif vb_pagebreak is true>
						<cfset VN_lineasEmp = ConceptosPago.lineasEmp>
					<cfelse>
						<cfset VN_lineasEmp = 0>
					</cfif>
					<!---Datos del Encabezado--->
					<cfset vs_nomina = ConceptosPago.nomina>
					<cfset vs_desdenomina = ConceptosPago.desdenomina>
					<cfset vs_hastanomina = ConceptosPago.hastanomina>
					<cfset vs_empleado = ConceptosPago.empleado>
					<cfset vs_cuenta = ConceptosPago.cuenta>
					<cfset vs_departamento = ConceptosPago.departamento>
					<cfset vs_puntoventa = ConceptosPago.puntoventa>
					<!---Datos del Detalle--->
					<cfset vs_devengado = ConceptosPago.devengado>
					<cfset vs_deducido = ConceptosPago.deducido>
					<cfset vs_neto = ConceptosPago.neto>
					<cfset vs_etiquetacta = ConceptosPago.EtiquetaCuenta>
					<!----================= ENCABEZADO COMPROBANTE  =================----->									
					<cfsavecontent variable="Encabezado">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							 <tr><td>&nbsp;</td></tr> 						 
							 <cfif vb_flashpaper is true>
								<tr><td>&nbsp;</td></tr> 						 
							 </cfif>
							 <tr>
								<td valign="top">
									<table width="100%" cellspacing="0" cellpadding="0" border="0">
										 <tr>
											<td width="230" nowrap>
												<strong class="comprobante"><cf_translate key="LB_Boleta_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml" >Boleta de Pago</cf_translate></strong>
											</td>
											<td width="670" align="center" ><strong class="empresa">#Session.Enombre#</strong></td>
											<td width="45" align="center">#LSDateFormat(now(),'dd/mm/yyyy')#</td>
										  </tr>	 
									</table>
								</td>
							  </tr>	 
							 <tr>
								<td valign="top">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
									  <tr>
										<td width="202" height="19" nowrap><strong><cf_translate key="LB_Recursos_Humanos">Recursos Humanos</cf_translate></strong></td>
										<td width="98" align="right"><strong><cf_translate key="LB_Nomina">N&oacute;mina:</cf_translate></strong></td>
										<td width="353">#vs_nomina#</td>
										<td width="295" align="right"><strong><cf_translate key="LB_Del">Del</cf_translate></strong>: #LSDateFormat(vs_desdenomina,'dd/mm/yyyy')# <strong><cf_translate key="LB_Al">al</cf_translate></strong> #LSDateFormat(vs_hastanomina,'dd/mm/yyyy')# </td>
									  </tr>
									</table>
								</td>
							 </tr>
							<tr>
								<td valign="top">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="109" valign="top"><strong><cf_translate  key="LB_Empleado">Empleado:</cf_translate></strong>&nbsp;</td>
											<td width="385" valign="top" align="left">#vs_empleado#</td>																		
											<td width="355" valign="top" align="left">
												<cfif len(trim(vs_etiquetacta)) GT 39>
													&nbsp;#Mid(vs_etiquetacta,1,39)#
												<cfelse>
													&nbsp;#trim(vs_etiquetacta)# #trim(vs_cuenta)#
												</cfif>	
											</td>
										<!---	<td width="20" valign="top">
												<cfif len(trim(vs_cuenta)) GT 39>
													&nbsp;#Mid(vs_cuenta,1,39)#
												<cfelse>
													&nbsp;#vs_cuenta#
												</cfif>	
											</td> --->
										</tr>
										<tr>
											<td width="109" height="33" valign="top"><strong><cf_translate  key="LB_Departamento">Departamento:</cf_translate></strong>&nbsp;</td>
											<td width="385" valign="top">
												<cfif len(trim(vs_departamento)) GT 42>
													#Mid(vs_departamento,1,42)#
												<cfelse>
													#vs_departamento#
												</cfif>													
											</td>
											<td width="135" align="left" valign="top">
												<strong>
													<cf_translate  key="LB_PuntoVenta">Punto Venta:</cf_translate>
												</strong>
													&nbsp;#vs_puntoventa#
												</td>										
										</tr>
									</table>
								</td>
							</tr>	
								
						</table>
					</cfsavecontent>	
					<!----================= SUMATORIA COMPROBANTE  =================----->		
					<cfsavecontent variable="Sumatoria">
						<table  width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td width="9%" align="right"><strong><cf_translate key="LB_Devengado">Devengado:&nbsp;&nbsp;</cf_translate></strong></td>
											<td width="25%">#LSNumberFormat(ConceptosPago.devengado, '(___,___,___,___,___.__)')#</td>
											<td width="8%" align="right"><strong><cf_translate  key="LB_Deducido">&nbsp;Deducido:&nbsp;&nbsp;</cf_translate></strong></td>
											<td width="25%"><cfif ConceptosPago.deducido GT 0></cfif>#LSCurrencyFormat(ConceptosPago.deducido, 'none')#<cfif ConceptosPago.deducido GT 0></cfif></td>
											<td width="10%" align="right"><strong><cf_translate  key="LB_Neto">Neto:&nbsp;&nbsp;</cf_translate></strong></td>
											<td width="25%">#LSNumberFormat(ConceptosPago.neto, '(___,___,___,___,___.__)')#</td>
										</tr>
										<!---
										<tr>
											<td valign="top" colspan="6">
												<table border="0" cellpadding="0" cellspacing="0">												
													<cfif len(trim(rsEtiquetaPie.Mensaje)) GT 175>
														<tr><td><p>#Mid(rsEtiquetaPie.Mensaje, 1, 175)#</p></td></tr><!----style="font-size:10pt;"---->
														<tr><td ><p>#Mid(rsEtiquetaPie.Mensaje, 176,175)#</p></td></tr><!---style="font-size:10pt;"---->
													<cfelse>
														<tr>
															<td width="100%">#trim(rsEtiquetaPie.Mensaje)#</td>
														</tr>
													</cfif>									
												</table>
											</td>
										</tr>
										---->								
									</table>
								</td>
							</tr>								
						</table>
					</cfsavecontent>
					<tr><td colspan="7" valign="top">#Encabezado#</td></tr>
					<CFSET CONTADOR_GRAL = CONTADOR_GRAL +  12>
					<cfset vn_rellenar = false><!----Variable para rellenar cuando las lineas de la boleta son menos de 26---->
					<cfoutput>					
						<cfif CONTADOR EQ 1><!---En la primera linea del detalle se pinta el encabezado-labels del mismo---->						
							<tr>
								<td width="#vn_250#" valign="top" style="border-bottom: 1px solid black;"><strong><cf_translate  key="LB_Concepto">Concepto</cf_translate></strong></td>
								<td width="#vn_80#" valign="top" style="border-bottom: 1px solid black;"><strong><cf_translate  key="LB_Cantidad">Cantidad</cf_translate></strong></td>
								<td width="#vn_120#" align="right" valign="top" style="border-bottom: 1px solid black;"><strong><cf_translate  key="LB_Monto">Monto</cf_translate></strong></td>
								<td width="#vn_7#">&nbsp;</td>
								<td width="#vn_270#" valign="top" style="border-bottom: 1px solid black;"><strong><cf_translate  key="LB_Concepto">Concepto</cf_translate></strong></td>
								<td width="#vn_100#" valign="top" style="text-align:center;border-bottom: 1px solid black;"><strong><cf_translate  key="LB_ControlaSaldo">Saldo Posterior</cf_translate></strong></td>
								<td width="#vn_80#" valign="top" style="text-align:center;border-bottom: 1px solid black;"><strong><cf_translate  key="LB_Cantidad">Cantidad</cf_translate></strong></td>								
								<td width="#vn_120#" valign="top" style="text-align:right;border-bottom: 1px solid black;"><strong><cf_translate  key="LB_Monto">Monto</cf_translate></strong></td>
							</tr>
						</cfif>								
						<tr>
							<td valign="top" width="#vn_270#" nowrap>
								<cfif len(trim(descconcepto))>
									<cfif len(descconcepto) GT 24>
										#Mid(descconcepto, 1, 24)#
									<cfelse>
										#descconcepto#
									</cfif>								
								<cfelse>&nbsp;</cfif>							
							</td>
						
							<td valign="top" width="#vn_80#" nowrap align="center"><cfif len(trim(cantconcepto))>#cantconcepto#<cfelse>&nbsp;</cfif></td>
							<td valign="top" width="#vn_120#" style="text-align:right;">						
								<cfif ConceptosPago.montoconcepto NEQ 0 and len(trim(ConceptosPago.descconcepto)) NEQ 0>
									#LSNumberFormat(ConceptosPago.montoconcepto,'(___,___,___,___,___.__)')#					
								<cfelseif len(trim(ConceptosPago.descconcepto)) NEQ 0>
									#LSNumberFormat(ConceptosPago.montoconcepto,'(___,___,___,___,___.__)')#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td width="#vn_7#">&nbsp;</td>
							<td valign="top" width="#vn_270#">
								<cfif len(trim(descconceptoB))>
									<cfif len(descconceptoB) GT 24>
										#Mid(descconceptoB, 1, 24)#
									<cfelse>
										#descconceptoB#
									</cfif>								
								<cfelse>&nbsp;</cfif>	
							</td>
								<td valign="top" width="#vn_100#" nowrap><cfif controlaSaldo EQ 1 >#LSCurrencyFormat(saldoDeducc, 'none')#<cfelse>&nbsp;</cfif></td>
							<td valign="top" width="#vn_80#" align="center"><cfif len(trim(cantconceptoB))>#cantconceptoB#<cfelse>&nbsp;</cfif></td>
							<td valign="top" width="#vn_120#" style="text-align:right">
								<cfif ConceptosPago.montoconceptoB NEQ 0 and len(trim(ConceptosPago.montoconceptoB)) NEQ 0>
									#LSNumberFormat(ConceptosPago.montoconceptoB,'(___,___,___,___,___.__)')#					
								<cfelseif len(trim(ConceptosPago.montoconceptoB)) NEQ 0>
									#LSNumberFormat(ConceptosPago.montoconceptoB,'(___,___,___,___,___.__)')#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
						</tr>	
						<CFSET CONTADOR = CONTADOR + 1>	
						<CFSET CONTADOR_GRAL = CONTADOR_GRAL + 1>					
						
						<cfif vb_pagebreak is true><!---========= Si se indica corte de pagina =========----->
							<!----Si son mas de 10 conceptos de pago (tanto los que suman o los que restan)---->		
							<cfif CONTADOR-1 GT 9 and CONTADOR-1 NEQ VN_lineasEmp><!---- and CONTADOR LT ConceptosPago.RecordCount--->				
								<cfset vn_tempContador = CONTADOR>																		
								<cfset CONTADOR = 1>
								<tr><td colspan="7">&nbsp;</td></tr>
								<tr><td colspan="7">#sumatoria#</td></tr>
								<!----ETIQUETA DEL PIE DE PAGINA ---->
								<cfif len(trim(rsEtiquetaPie.Mensaje)) GT 125>
									<tr><td colspan="7" width="950">#Mid(rsEtiquetaPie.Mensaje, 1, 125)#</td></tr><!----style="font-size:10pt;"---->
									<tr><td colspan="7" width="950">#Mid(rsEtiquetaPie.Mensaje, 126,125)#</td></tr><!---style="font-size:10pt;"---->
								<cfelse>
									<tr>
										<td colspan="7" width="950">#trim(rsEtiquetaPie.Mensaje)#</td>
									</tr>
								</cfif>										
								<tr>
									<td colspan="7" align="right">
										&nbsp;<!---<em><cf_translate  key="LB_Pagina">P&aacute;gina</cf_translate>&nbsp;#VN_CONTADORPAGINAS#</em>---->
									</td>
								</tr>							
								<cfset VN_CONTADORPAGINAS = VN_CONTADORPAGINAS + 1>							
								<cfset vn_hasta = lineas-(vn_tempContador+10)>
								<cfloop index = "i"	from = "1"	to = "#vn_hasta#"><!---Rellenar si son menos de 26 lineas--->
									<cfif CONTADOR_GRAL LTE lineasPagina><!---Si no se ha llegado al limite de lineas de la pagina que es 72--->
										<tr><td colspan="7">&nbsp;</td></tr>		
										<CFSET CONTADOR_GRAL = CONTADOR_GRAL + 1>
									</cfif>							
									<cfif CONTADOR_GRAL GTE lineasPagina><!--- Cambio de pagina... ---><!---and CURRENT NEQ ConceptosPago.RecordCount--->
										<tr><td style="page-break-before:always;"></td></tr>
										<CFSET CONTADOR_GRAL = 0>							
										<cfbreak>
									</cfif>
								</cfloop>
								<cfset vn_tempContador = 0>
								<tr><td colspan="7">#Encabezado#</td></tr>	
								<CFSET CONTADOR_GRAL = CONTADOR_GRAL +  10>
								<!---Variable para que se continue pintando el ciclo de los conceptos y luego si es necesario haga el relleno en el espacio luego del numero de pagina, 
									sino lo hace entre el titulo del detalle y los conceptos...---->						
								<CFSET vn_rellenar = true>
							</cfif>
						</cfif><!---====== Fin de si hay corte de pagina =======---->
						
						<CFSET CURRENT = ConceptosPago.CurrentRow>								
					</cfoutput>					
					<!---CORTE DEL EMPLEADO--->				
					<tr><td>&nbsp;</td></tr>
					<tr><td colspan="7">#sumatoria#</td></tr>	
					<!----ETIQUETA DEL PIE DE PAGINA ---->
					<cfif len(trim(rsEtiquetaPie.Mensaje)) GT 125>
						<tr><td colspan="7" width="950">#Mid(rsEtiquetaPie.Mensaje, 1, 125)#</td></tr><!----style="font-size:10pt;"---->
						<tr><td colspan="7" width="950">#Mid(rsEtiquetaPie.Mensaje, 126,125)#</td></tr><!---style="font-size:10pt;"---->
					<cfelse>
						<tr>
							<td colspan="7" width="950">#trim(rsEtiquetaPie.Mensaje)#</td>
						</tr>
					</cfif>										
					
					<tr>
						<td colspan="7" align="right">
							&nbsp;<!---<em><cf_translate key="LB_Pagina">P&aacute;gina</cf_translate>&nbsp;#VN_CONTADORPAGINAS#</em>--->
						</td>
					</tr>	
					<!----Luego del pintado de los conceptos se hace el relleno si hubo corte por la cantidad de conceptos > 10--->
					<cfif vn_rellenar is true>
						<cfset vn_hasta = lineas-(CONTADOR+10)>
						<cfloop index = "i"	from = "1"	to = "#vn_hasta#"><!---Loop para "rellenar" si no hay 26 lineas en la boleta--->
							<cfif CONTADOR_GRAL LTE lineasPagina><!---Si no se ha llegado al limite de lineas de la pagina que es 72--->
								<tr><td colspan="7">&nbsp;</td></tr>	
								<CFSET CONTADOR_GRAL = CONTADOR_GRAL + 1>	
							</cfif>						
							<cfif CONTADOR_GRAL GTE lineasPagina and CURRENT NEQ ConceptosPago.RecordCount><!---Cambio de pagina--->
								<tr><td style="page-break-before:always;"></td></tr>
								<CFSET CONTADOR_GRAL = 0>							
								<cfbreak>
							</cfif>
						</cfloop>
						<cfset vn_rellenar = false><!---Esta variable se utiliza solo cuando hubo un corte de boleta por la cantidad de conceptos > 10--->	
						<cfset CONTADOR = 0>
					</cfif>				
					<cfif vb_pagebreak is true><!---========= Si se indica corte de pagina =========----->
						<!---Relleno a 26 lineas si no hubo corte por cantidad de conceptos > 10---->						
						<cfif CONTADOR NEQ 0 and (CONTADOR+10) LT lineas><!---Cada tercio de pagina tiene 26 lineas aproximadamente--->
							<cfset vn_hasta = lineas-(CONTADOR+10)>
							<cfloop index = "i"	from = "1"	to = "#vn_hasta#"><!---Loop para "rellenar" si no hay 26 lineas en la boleta--->
								<cfif CONTADOR_GRAL LTE lineasPagina><!---Si no se ha llegado al limite de lineas de la pagina que es 72--->
									<tr><td colspan="7">&nbsp;</td></tr>		
									<CFSET CONTADOR_GRAL = CONTADOR_GRAL + 1>
								</cfif>						
								<cfif CONTADOR_GRAL GTE lineasPagina and CURRENT NEQ ConceptosPago.RecordCount><!---La pagina tiene 72 lineas aproximadamente--->
									<tr><td style="page-break-before:always;"></td></tr>
									<CFSET CONTADOR_GRAL = 0>							
									<cfbreak>
								</cfif>
							</cfloop>
						</cfif>	
					</cfif>					   				
				</cfoutput>					
			</table>	
		</cfsavecontent>	
	</cfif>	