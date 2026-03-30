<cfif isdefined("P_CJX19REL") and len(P_CJX19REL)>
	
	<script>
	window.parent.workspace1.focus();
	window.parent.workspace1.esconder(2);
	</script>
	
	<cfset P_CJX19REL = url.P_CJX19REL>

		<!--- Listado de los Documentos de Pago --->
		<cfquery name="DocumentosPago" datasource="#session.Fondos.dsn#">
					Select 
						CJX19REL,
						tipo =	case	when A.CJX23TIP = 'E' then 'Efectivo'
								when A.CJX23TIP = 'C' then 'Cheque'
								when A.CJX23TIP = 'T' then 'Tarjeta'
								when A.CJX23TIP = 'V' then 'Anticipo'
							end,
						consecutivo = CJX23CON,
						tipotrans = case when A.CJX23TTR = 'D' then 'Devolucion'
										when A.CJX23TTR = 'R' then 'Retiro'
										when A.CJX23TTR = 'C' then 'Compra Direc.'
									end,
						Monto = A.CJX23MON * case when A.CJX23TTR = 'D' then -1 else 1 end, 
						documento =	case	when A.CJX23TIP = 'E' then null
									when A.CJX23TIP = 'C' then A.CJX23CHK
									when A.CJX23TIP = 'T' then A.TR01NUT
									when A.CJX23TIP = 'V' then convert(varchar, A.CJX5IDE)
								end,
						Autorizacion = A.CJX23AUT, 
						Fecha = convert(varchar, A.CJX23FEC, 103), 
						conciliado = case when C.PERCOD is null and CJX23TIP = 'T' then 'No Conciliado' else 'Conciliado' end,
						tarjetahabiente = EMPNOM + ' ' + EMPAPA + ' ' + EMPAMA
					from CJX023 A
						left outer join CJX011 C
						  on  C.TS1COD = A.TS1COD
						  and C.TR01NUT = A.TR01NUT
						  and C.CJX11AUT = A.CJX23AUT
						  and C.CJX11ORI = 'M'
					
						left outer join PLM001 B
							on A.EMPCOD = B.EMPCOD  
					where A.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#P_CJX19REL#" >
					order by A.CJX23TIP								  
		</cfquery>
	
		<cfquery name="ExtTarjetas" datasource="#session.Fondos.dsn#">
				Select count(1) as cantidad
				from CJX023 A
				where A.CJX23TIP = 'T'
				  AND A.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#P_CJX19REL#">
		</cfquery>	
	
	<!--- Se hace el query de acuerdo a los documentos --->
	<cfif isdefined("DOCSEG") and DOCSEG eq 1>
	
		<!--- Listado de las Facturas de la Relacion (Encabezados) --->
		<cfquery name="Documentos" datasource="#session.Fondos.dsn#">
				select CJX20NUM,CJX20NUF,convert(varchar(10),CJX20FEF,103)CJX20FEF,EMPNOM + ' ' + EMPAPA + ' ' + EMPAMA as Empleado,
					   CJX20MNT, I04NOM,PRONOM,
					   case when CJX20TIP= 'A' then 
							'Ajuste' 
						when CJX20TIP= 'F' then 
							'Factura' 
						when CJX20TIP= 'V' then 
							'Viaticos y Otros' 
						end CJX20TIP
				from CJX020 A, CJX019 B, PLM001 C, I04ARC D, CPM002 E
				where A.CJX19REL = B.CJX19REL
				  and A.EMPCOD = C.EMPCOD
				  and A.I04COD = D.I04COD
				  and A.PROCOD *= E.PROCOD
				  and CJX19EST not in ('D','B')
				  and A.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#P_CJX19REL#" >
		</cfquery>

	<cfelse>
	
		<!--- Listado de las Facturas de la Relacion (Detalles) --->
		<cfquery name="Documentos" datasource="#session.Fondos.dsn#">
					select B.CJX20NUM, convert(varchar(10),B.CJX20FEF,103)CJX20FEF,D.EMPNOM + ' ' + D.EMPAPA + ' ' + D.EMPAMA as Empleado,
						   C.CJX21LIN, C.CJX21DSC, (C.CGM1IM + '-' + C.CGM1CD) as cuenta, ((C.CJX21MNT - C.CJX21MDS) + isnull(C.CJX21IGA, 0.00) + isnull(C.CJX21ICF, 0.00)) as Monto
					from  CJX019 A, CJX020 B, CJX021 C, PLM001 D
					where A.CJX19REL = B.CJX19REL					  
					  and B.CJX20NUM = C.CJX20NUM
					  and B.CJX19REL = C.CJX19REL					  
					  and B.EMPCOD   = D.EMPCOD
					  and A.CJX19EST not in ('D','B')
					  and A.CJX19REL = <cfqueryparam cfsqltype="cf_sql_integer"  value="#P_CJX19REL#" >
		</cfquery>

	</cfif>	
	<!--- Listado de los Vouches de la Relacion 
	<cfquery name="Vouchers" datasource="#session.Fondos.dsn#">
	</cfquery>--->
	<cfif isdefined("DOCSEG") and DOCSEG eq 1>
		<cfset titulo = "Encabezado">
	<cfelse>
		<cfset titulo = "Detalle">
	</cfif>

	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
	<tr>
		<td>
		
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>	
					<td align="center" colspan="9" nowrap>
							
						<link rel='stylesheet' type='text/css' href="../css/Corte_Pagina.css">
						<TABLE width="100%" align="center" border="0" cellspacing="0" class='T1'  cellpadding="1"> 
							
						<tr> 
								<td class='CIN' >&nbsp;Fecha: <cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput></td>
								<td class='CCN' colspan=9 > 
									Documentos de Relaciones
								</td>
								<td  class='CDN'>&nbsp;</td>
							</tr>
							<tr> 
								<td class='CIN' >&nbsp;Hora: <cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
								<td class='CCN' colspan=9>&nbsp;</td>
								<td class='CDN'> 
									&nbsp;Usuario: <cfoutput>#session.usuario#</cfoutput>
								</td>
							</tr>
							<tr>
								<td class='CIN'>&nbsp;</td>
								<td class='CCN'colspan=9> 
									 Documentos de la relacion:&nbsp;<cfoutput>#P_CJX19REL#</cfoutput>
								</td>
								<td class='CDN'>&nbsp;</td>
							</tr>							
							<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
							<tr>
								<td class='CIN'>&nbsp;</td>
								<td class='CCN'colspan=9> 
								Fondo de Trabajo:&nbsp;<cfoutput>#NCJM00COD#</cfoutput>
								</td>
								<td class='CDN'>&nbsp;</td>
							</tr>						
							</cfif>
							<cfif isdefined("NCJ01ID") and len(NCJ01ID)>
							<tr>
								<td class='CIN'>&nbsp;</td>
								<td class='CCN'colspan=9> 
								Caja:&nbsp;<cfoutput>#NCJ01ID#</cfoutput>
								</td>
								<td class='CDN'>&nbsp;</td>
							</tr>						
							</cfif>												
							
						</table>						
							
							
					</td>
				</tr>								
				<tr><td>&nbsp;</td></tr><!--- class='CIT' --->
				<tr><td colspan="9" align="center"><font size="-1"><strong>Documentos de Gasto: <cfoutput>#Titulo#</cfoutput></strong></font><!--- <hr> ---></td></tr>				
				<cfif isdefined("Documentos") and Documentos.recordcount gt 0>					
					<cfif isdefined("DOCSEG") and DOCSEG eq 1>
						<tr>
							<td align="center" colspan="9">
																				
								<table width="100%" cellpadding="2" cellspacing="0">
								<!--- Encabezado --->
								
 								<tr>
									<td width="11%" class='CIT'>No. Documento</td>
									<td width="5%" class='CIT'>Consec.</td>
									<td width="10%" class='CIT'>Fecha</td>
									<td width="22%" class='CIT'>Empleado</td>
									<td width="10%" class='CIT'><strong>Monto</strong></td>
									<td width="11%" class='CIT'><strong>Centro Funcional</strong></td>
									<td width="21%" class='CIT'><strong>Provedor</strong></td>
									<td width="10%" class='CIT' colspan="2"><strong>Tipo</strong></td>
								</tr> 
								<!---
								<tr>
									<td width="11%"><font size="-2"><strong>No. Documento</strong></font></td>
									<td width="5%"><font size="-2"><strong>Consec.</strong></font></td>
									<td width="10%"><font size="-2"><strong>Fecha</strong></font></td>
									<td width="22%"><font size="-2"><strong>Empleado</strong></font></td>
									<td width="10%"><font size="-2"><strong>Monto</strong></font></td>
									<td width="11%"><font size="-2"><strong>Centro Funcional</strong></font></td>
									<td width="21%"><font size="-2"><strong>Provedor</strong></font></td>
									<td width="10%"><font size="-2"><strong>Tipo</strong></font></td>
								</tr>		 						
								<tr><td colspan="8"><hr></td></tr>	--->	
								<cfoutput query="Documentos">
								<tr>												   
									<td class='CN'>#CJX20NUF#</td>
									<td class='CN'>#CJX20NUM#</td>
									<td class='CN'>#CJX20FEF#</td>
									<td class='CN'>#Empleado#</td>
									<td class='CN'>#numberformat(CJX20MNT,",9.99")#</td>
									<td class='CN'>#I04NOM#</td>
									<td class='CN'>#PRONOM#</td>
									<td class='CN' colspan="2">#CJX20TIP#</td>							
								</tr>
								</cfoutput>			
								</table>
								
							</td>
						</tr>													
					<cfelse>
						
						<tr>
							<td align="center" colspan="9">

								<!--- Detalle --->
								<table width="100%" cellpadding="2" cellspacing="0">
 								<tr>
									<td width="14%" class="CIT"><strong>Cons. Documento</strong></td>
									<td width="5%" class="CIT"><strong>Linea</strong></td>
									<td width="7%" class="CIT"><strong>Fecha</strong></td>
									<td width="18%" class="CIT"><strong>Empleado</strong></td>
									<td width="20%" class="CIT"><strong>Descripcion</strong></td>
									<td width="15%" class="CIT"><strong>Cuenta</strong></td>
									<td width="10%" class="CIT" colspan="3"><strong>Monto</strong></td>
								</tr> 
								<!---		
								<tr>
									<td width="10%"><font size="-2"><strong>Cons. Documento</strong></font></td>
									<td width="5%" ><font size="-2"><strong>Linea</strong></font></td>
									<td width="7%"><font size="-2"><strong>Fecha</strong></font></td>
									<td width="18%"><font size="-2"><strong>Empleado</strong></font></td>
									<td width="24%"><font size="-2"><strong>Descripcion</strong></font></td>
									<td width="15%"><font size="-2"><strong>Cuenta</strong></font></td>
									<td width="10%" colspan="2"><font size="-2"><strong>Monto</strong></font></td>
								</tr>
								<tr><td colspan="8"><hr></td></tr>--->
								<cfoutput query="Documentos">
								<tr>										
									<td class='CN'>#CJX20NUM#</td>
									<td class='CN'>#CJX21LIN#</td>
									<td class='CN'>#CJX20FEF#</td>
									<td class='CN'>#Empleado#</td>
									<td class='CN'>#CJX21DSC#</td>
									<td class='CN'>#cuenta#</td>
									<td class='CN' colspan="3">#NumberFormat(Monto,",9.99")#</td>							
								</tr>
								</cfoutput>
								</table>		
						
							</td>						
						</tr>						
										
					</cfif>			
				<cfelse>
					<tr>
						<td align="center" class='CN' colspan="9"><strong>-- No se encontraron Documentos en la relacion --</strong></td>
					</tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr><td colspan="9" align="center"><font size="-1"><strong>Documentos de Pago</strong></font></td></tr>				
				<cfif (isdefined("DocumentosPago") and DocumentosPago.recordcount gt 0)>
					<tr>						
						<td width="13%" class="CIT">Tipo Documento</td>
						<td width="13%" class="CIT">Consecutivo</td>
						<td width="13%" class="CIT">Monto</td>
						<cfif ExtTarjetas.cantidad gt 0>							
							<td width="13%" class="CIT">No. Tarjeta</td>
							<td width="12%" class="CIT">Autorizacion</td>
							<td width="12%" class="CIT">Fecha</td>
							<td width="5%" class="CIT">Estado</td>
							<td width="23%" class="CIT">Tarjetahabiente</td>
							<td width="13%" class="CIT">T.Transaccion</td>
						<cfelse>
							<td width="13%" class="CIT" colspan="5">No. Documento</td>							
						</cfif>
					</tr>
					<!---			
					<tr>						
						<td width="13%"><font size="-2"><strong>Tipo Documento</strong></font></td>
						<td width="13%"><font size="-2"><strong>Consec.</strong></font></td>
						<td width="13%"><font size="-2"><strong>Monto</strong></font></td>
						<cfif ExtTarjetas.cantidad gt 0>
							<td width="13%"><font size="-2"><strong>No. Tarjeta</strong></font></td>
							<td width="12%"><font size="-2"><strong>Autorizacion</strong></font></td>
							<td width="12%"><font size="-2"><strong>Fecha</strong></font></td>
							<td width="5%"><font size="-2"><strong>Estado</strong></font></td>
							<td width="23%"><font size="-2"><strong>Tarjetahabiente</strong></font></td>
						<cfelse>
							<td width="13%" colspan="5"><font size="-2"><strong>No. Documento</strong></font></td>							
						</cfif>
					</tr>							
					<tr><td colspan="9"><HR></td></tr> --->
					<cfoutput query="DocumentosPago">
					<tr>																 						
						<td class='CN'>#tipo#</td>
						<td class='CN'>#consecutivo#</td>
						<td class='CN'>#numberformat(Monto,",9.99")#</td>					
						<td class='CN'>#documento#</td>
						<cfif ExtTarjetas.cantidad gt 0>
							<td class='CN'>#Autorizacion#</td>
							<td class='CN'>#Fecha#</td>
							<td class='CN'>#conciliado#</td>
							<td class='CN' width="23%">#tarjetahabiente#</td>
							<td class='CN'>#tipotrans#</td>
						<cfelse>
							<td colspan="3" class='CN'>&nbsp;</td>
						</cfif>							
					</tr>
					</cfoutput>
					
				<cfelse>
					<tr>
						<td align="center" class='CN' colspan="9"><strong>-- No se encontraron Documentos de Pago --</strong></td>
					</tr>
				</cfif>				
				</table>
		
		</td>
	</tr>
	</table>
	

</cfif>