<cfif isdefined("btnFiltrar")>

<style>
	TD.CN {
		font-style : normal;
		font-weight : normal;
		font-variant : normal;
		border-left-width : 0;
		border-right-width : 0;
		border-top-width : 0;
		border-bottom-width : 0;
		font-family : Arial;
		font-size : 9.5;
		mso-style-parent:style0;
		mso-number-format:Fixed;
	}
	TD.DetallePar{
		font-style : normal;
		font-weight : bold;
		font-variant : normal;
		text-align  : left;
		border-left-width : 0;
		border-right-width : 0;
		border-top-width : 0;
		border-bottom-width : 0;
		font-family : Arial;
		font-size : 9.5;
		background-color : #DDE8E8;
	}	
	TD.DetalleImpar{
		font-style : normal;
		font-weight : bold;
		font-variant : normal;
		text-align  : left;
		border-left-width : 0;
		border-right-width : 0;
		border-top-width : 0;
		border-bottom-width : 0;
		font-family : Arial;
		font-size : 9.5;
		background-color : #FFFFFF;
	}	
	</style>

	<cfset parametros = "">
		
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
			<cfif parametros eq ""><cfset parametros="@CJM00COD = '#NCJM00COD#'"><cfelse><cfset parametros=parametros & ",@CJM00COD = '#NCJM00COD#'"></cfif>
		</cfif>
		<cfif isdefined("NCJ01ID") and len(NCJ01ID)>
			<cfif parametros eq ""><cfset parametros="@CJ01ID = '#NCJ01ID#'"><cfelse><cfset parametros=parametros & ",@CJ01ID = '#NCJ01ID#'"></cfif>
		</cfif>
		<cfif isdefined("PROCOD") and len(PROCOD)>
			
			<cfquery name="RsProv" datasource="#session.Fondos.dsn#">
			Select PRONOM
			from CPM002
			where PROCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PROCOD#">
			</cfquery>
			
			<cfif parametros eq ""><cfset parametros="@PROCOD = '#PROCOD#'"><cfelse><cfset parametros=parametros & ",@PROCOD = '#PROCOD#'"></cfif>			
		</cfif>
		<cfif isdefined("EMPCOD") and len(EMPCOD)>
			
			<cfquery name="RsEmpl" datasource="#session.Fondos.dsn#">
			Select EMPNOM + ' ' + EMPAPA + ' ' + EMPAMA NOMBRE
			from PLM001
			where EMPCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPCOD#">
			</cfquery>			
			
			<cfif parametros eq ""><cfset parametros="@EMPCOD = '#EMPCOD#'"><cfelse><cfset parametros=parametros & ",@EMPCOD = '#EMPCOD#'"></cfif>
		</cfif>		
		<cfif isdefined("INI_FECHAINI") and len(INI_FECHAINI)>
			<cfset INI_FECHA = replace(INI_FECHAINI,"'","","all")>
			<cfif parametros eq ""><cfset parametros="@FECHAINI = '#LSDateFormat(INI_FECHA,'yyyymmdd')#'"><cfelse><cfset parametros=parametros & ",@FECHAINI = '#LSDateFormat(INI_FECHA,'yyyymmdd')#'"></cfif>			
		</cfif>
		<cfif isdefined("FIN_FECHAFIN") and len(FIN_FECHAFIN)>
			<cfset FIN_FECHA = replace(FIN_FECHAFIN,"'","","all")>
			<cfif parametros eq ""><cfset parametros="@FECHAFIN = '#LSDateFormat(FIN_FECHA,'yyyymmdd')#'"><cfelse><cfset parametros=parametros & ",@FECHAFIN = '#LSDateFormat(FIN_FECHA,'yyyymmdd')#'"></cfif>
		</cfif>	
		
		<cfif isdefined("CJ3NUM") and len(CJ3NUM)>
			<cfif parametros eq ""><cfset parametros="@CJ3NUM = #CJ3NUM#"><cfelse><cfset parametros=parametros & ",@CJ3NUM = #CJ3NUM#"></cfif>
		</cfif>

	<cftry> 

	<cfquery name="RptLiq" datasource="#session.Fondos.dsn#">
		set nocount on
		exec sp_REP_LIQUIDACIONES #PreserveSingleQuotes(parametros)#
		set nocount off
	</cfquery>			
	
	
	<cfcatch type="any">	
		<script language="JavaScript">
			var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
			mensaje = mensaje.substring(40,300)
			alert(mensaje)
			//history.back()
		</script>
			
		<cfabort>
		</cfcatch> 
	</cftry>  	
	
</cfif>

<cfif isdefined("RptLiq") and RptLiq.recordcount gt 0 >
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
<tr>
	<td>
	
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
			<tr>	
				<td align="center" colspan="7" nowrap>
						
					<link rel='stylesheet' type='text/css' href="../css/Corte_Pagina.css">
					   <TABLE width="100%" align="center" border="0" cellspacing="0" class='T1'  cellpadding="1"> 						
					   <tr> 
							<td class='CIN' width="30%">&nbsp;Fecha: <cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput></td>
							<td class='CCN' colspan=9>Liquidaciones de Caja Detalladas</td>
							<td  class='CDN'width="30%">&nbsp;</td>
						</tr>
						<tr> 
							<td class='CIN' >&nbsp;Hora: <cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
							<td class='CCN' colspan=9>&nbsp;</td>
							<td class='CDN'>&nbsp;Usuario: <cfoutput>#session.usuario#</cfoutput></td>
						</tr>
						<tr>
							<td class='CIN' colspan=11 align="center">
							
								<table cellpadding="1" border="0" cellspacing="0" width="50%" align="center">								
								<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
								<tr>
									<td class='CCN'> 																				
										Fondo de Trabajo:&nbsp;<cfoutput>#NCJM00COD#</cfoutput>										
									</td>
								</tr>
								</cfif>	
								<cfif isdefined("NCJ01ID") and len(NCJ01ID)>
								<tr>
									<td class='CCN'>
										Caja:&nbsp;<cfoutput>#NCJ01ID#</cfoutput>																				
									</td>
								</tr>
								</cfif>
								<cfif isdefined("PROCOD") and len(PROCOD)>
								<tr>
									<td class='CCN'> 										
										Provedor:&nbsp;<cfoutput>#RsProv.PRONOM#</cfoutput>
									</td>
								</tr>
								</cfif>	
								<cfif isdefined("EMPCOD") and len(EMPCOD)>								
								<tr>									
									<td class='CCN'> 										
										Empleado:&nbsp;<cfoutput>#RsEmpl.NOMBRE#</cfoutput>
									</td>
								</tr>
								</cfif>
								<cfif isdefined("INI_FECHAINI") and len(INI_FECHAINI)>
								<tr>									
									<td class='CCN'> 										
										Desde:&nbsp;<cfoutput>#replace(INI_FECHAINI,"'","","all")#</cfoutput>										
									</td>			
								</tr>			
								</cfif>
								<cfif isdefined("FIN_FECHAFIN") and len(FIN_FECHAFIN)>																											
								<tr>															
									<td class='CCN'> 																				
										Hasta:&nbsp;<cfoutput>#replace(FIN_FECHAFIN,"'","","all")#</cfoutput>
									</td>									
								</tr>			
								</cfif>
								<cfif isdefined("CJ3NUM") and len(CJ3NUM)>																											
								<tr>															
									<td class='CCN'> 																				
										Numero de Liquidacion:&nbsp;<cfoutput>#CJ3NUM#</cfoutput>
									</td>									
								</tr>			
								</cfif>																				
								</table>												
							
							</td>							
						</tr>											
						</table>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="11" nowrap>
				
					<!--- REPORTE --->
					<table cellpadding="0" width="100%" cellspacing="0" align="center">
					<cfset Caja = "">
					<cfset NLiq = "">
					<cfset Ntran = "">
					<cfset MtotalLiq = "0">
					<cfloop query="RptLiq">

						<cfif Caja neq RptLiq.CJ01ID>
							
							<cfif Caja neq "">
								<tr><td colspan="6">&nbsp;</td></tr>
							</cfif>
							
							<cfset Caja = RptLiq.CJ01ID>
							<cfset NLiq = RptLiq.CJ3NUM>
							<cfset Ntran = RptLiq.CJ1NUM>
							
							<!--- Crea Encabezado --->							
							<tr>
								<td colspan="6" class='CIN'>Caja: <cfoutput>#Caja#</cfoutput></td>
							</tr>							
							<tr>
								<td colspan="6" class='CIN'>Liquidación: <cfoutput>#NLiq#</cfoutput></td>
							</tr>
							<tr>
								<td class='CIT'><strong>Transacción</font></strong></td>
								<td class='CIT'><strong>Liq. Fondo</strong></td>
								<td class='CIT'><strong>Documento</strong></td>
								<td class='CIT'><strong>Empleado</strong></td>
								<td class='CIT'><strong>Proveedor</strong></td>
								<td class='CIT'><strong>Neto</strong></td>
							</tr>
							<cfoutput>
							<tr>
								<td class='CN'>#RptLiq.CJ1NUM#</td>
								<td class='CN'>#RptLiq.CJ3NUM#</td>
								<td class='CN'>#RptLiq.FACDOC#</td>
								<td class='CN'>#RptLiq.EMPLEADO#</td>
								<td class='CN'>#RptLiq.PRONOM#</td>
								<td class='CN'>#numberformat(RptLiq.CJ1MNT,",9.99")#</td>
							</tr>
							<cfset MtotalLiq = MtotalLiq + RptLiq.CJ1MNT>
							</cfoutput>							
							
							<tr><td colspan="6">&nbsp;</td></tr>
							<tr>
								<!--- <td>&nbsp;</td> --->
								<td colspan="6">
									
									<table align="center" border="0" width="90%" cellpadding="0" cellspacing="0">
									<!--- <tr>
										<td class='CIT' width="5%"><strong>Linea</strong></td>
										<td class='CIT' width="30%"><strong>Descripción</strong></td>
										<td class='CIT' width="5%"><strong>UEN</strong></td>
										<td class='CIT' width="30%"><strong>Cuenta</strong></td>
										<td class='CIT' width="20%"><strong>Total</strong></td>
										<td class='CIT' width="10%"><strong>Imp. CF</strong></td>
									</tr> --->
									<tr>
										<td width="5%"><strong><font size="-2" face="Times New Roman, Times, serif">Linea</font></strong></td>
										<td width="40%" colspan="2"><strong><font size="-2" face="Times New Roman, Times, serif">Descripción</font></strong></td>
										<td width="5%"><strong><font size="-2" face="Times New Roman, Times, serif">UEN</font></strong></td>
										<td width="30%"><strong><font size="-2" face="Times New Roman, Times, serif">Cuenta</font></strong></td>
										<td width="20%"><strong><font size="-2" face="Times New Roman, Times, serif">Total</font></strong></td>
										<!--- <td width="10%"><strong><font size="-2" face="Times New Roman, Times, serif">Imp. CF</font></strong></td> --->
									</tr>
									<!--- <tr>
										<td colspan="6"><HR></td>
									</tr> --->
									<cfoutput>									
									<tr>
										<td class='CN'>#RptLiq.CJ2LIN#</td>
										<td class='CN' colspan="2">#RptLiq.CJ2DES#</td>
										<td class='CN'>#RptLiq.CGE5COD#</td>
										<td class='CN'>#RptLiq.CGM1IM#-#RptLiq.CGM1CD#</td>
										<td class='CN'>#numberformat(RptLiq.CJ2MNT,",9.99")#</td>
										<!--- <td class='CN'>#RptLiq.CJ2ICF#</td> --->
									</tr>
									</cfoutput>
									</table>
											
								</td>
							</tr>							
						
						
						<cfelse>
						
							<cfif NLiq neq RptLiq.CJ3NUM>
							
									<cfif NLiq neq "">
										<tr><td colspan="6">&nbsp;</td></tr>
										<tr>
											<td colspan="6" class='CD'>
											Total Liquidaci&oacute;n: <strong><cfoutput>#numberformat(MtotalLiq,",9.99")#</cfoutput></strong>
											<cfset MtotalLiq = "0">
											</td>
										</tr>
										<tr><td colspan="6">&nbsp;</td></tr>
									</cfif>
									
									<cfset Caja = RptLiq.CJ01ID>
									<cfset NLiq = RptLiq.CJ3NUM>
									<cfset Ntran = RptLiq.CJ1NUM>
									
									<!--- Crea Encabezado --->							
									<tr>
										<td colspan="6" class='CIN'>Caja: <cfoutput>#Caja#</cfoutput></td>
									</tr>							
									<tr>
										<td colspan="6" class='CIN'>Liquidación: <cfoutput>#NLiq#</cfoutput></td>
									</tr>
									<tr>
										<td class='CIT'><strong>Transacción</font></strong></td>
										<td class='CIT'><strong>Liq. Fondo</strong></td>
										<td class='CIT'><strong>Documento</strong></td>
										<td class='CIT'><strong>Empleado</strong></td>
										<td class='CIT'><strong>Proveedor</strong></td>
										<td class='CIT'><strong>Neto</strong></td>
									</tr>
									<cfoutput>
									<tr>
										<td class='CN'>#RptLiq.CJ1NUM#</td>
										<td class='CN'>#RptLiq.CJ3NUM#</td>
										<td class='CN'>#RptLiq.FACDOC#</td>
										<td class='CN'>#RptLiq.EMPLEADO#</td>
										<td class='CN'>#RptLiq.PRONOM#</td>
										<td class='CN'>#numberformat(RptLiq.CJ1MNT,",9.99")#</td>
									</tr>
									<cfset MtotalLiq = MtotalLiq + RptLiq.CJ1MNT>
									</cfoutput>							
									
									<tr><td colspan="6">&nbsp;</td></tr>
									<tr>
										<!--- <td>&nbsp;</td> --->
										<td colspan="6">
											
											<table align="center" border="0" width="90%" cellpadding="0" cellspacing="0">
											<!--- <tr>
												<td class='CIT' width="5%"><strong>Linea</strong></td>
												<td class='CIT' width="30%"><strong>Descripción</strong></td>
												<td class='CIT' width="5%"><strong>UEN</strong></td>
												<td class='CIT' width="30%"><strong>Cuenta</strong></td>
												<td class='CIT' width="20%"><strong>Total</strong></td>
												<td class='CIT' width="10%"><strong>Imp. CF</strong></td>
											</tr> --->
											<tr>
												<td width="5%"><strong><font size="-2" face="Times New Roman, Times, serif">Linea</font></strong></td>
												<td width="40%" colspan="2"><strong><font size="-2" face="Times New Roman, Times, serif">Descripción</font></strong></td>
												<td width="5%"><strong><font size="-2" face="Times New Roman, Times, serif">UEN</font></strong></td>
												<td width="30%"><strong><font size="-2" face="Times New Roman, Times, serif">Cuenta</font></strong></td>
												<td width="20%"><strong><font size="-2" face="Times New Roman, Times, serif">Total</font></strong></td>
												<!--- <td width="10%"><strong><font size="-2" face="Times New Roman, Times, serif">Imp. CF</font></strong></td> --->
											</tr>
											<!--- <tr>
												<td colspan="6"><HR></td>
											</tr> --->
											<cfoutput>									
											<tr>
												<td class='CN'>#RptLiq.CJ2LIN#</td>
												<td class='CN' colspan="2">#RptLiq.CJ2DES#</td>
												<td class='CN'>#RptLiq.CGE5COD#</td>
												<td class='CN'>#RptLiq.CGM1IM#-#RptLiq.CGM1CD#</td>
												<td class='CN'>#numberformat(RptLiq.CJ2MNT,",9.99")#</td>
												<!--- <td class='CN'>#RptLiq.CJ2ICF#</td> --->
											</tr>
											</cfoutput>
											</table>
													
										</td>
									</tr>														
							
							
							<cfelse>
						
						
									<cfif Ntran neq RptLiq.CJ1NUM>
																
										<cfif Ntran neq "">
											<tr><td colspan="6">&nbsp;</td></tr>											
										</cfif>
										<cfset Ntran = RptLiq.CJ1NUM>
										<!--- Datos del primer documento con su primer linea de detalle --->
										<cfoutput>
										<TR><TD colspan="8"><hr></TD></TR>
										<tr>
											<td class='CN'>#RptLiq.CJ1NUM#</td>
											<td class='CN'>#RptLiq.CJ3NUM#</td>
											<td class='CN'>#RptLiq.FACDOC#</td>
											<td class='CN'>#RptLiq.EMPLEADO#</td>
											<td class='CN'>#RptLiq.PRONOM#</td>
											<td class='CN'>#numberformat(RptLiq.CJ1MNT,",9.99")#</td>
										</tr>
										<cfset MtotalLiq = MtotalLiq + RptLiq.CJ1MNT>										
										</cfoutput>
										<tr><td colspan="6">&nbsp;</td></tr>
										<tr>
											<!--- <td>&nbsp;</td> --->
											<td colspan="6">
											
												<table align="center" border="0" width="90%" cellpadding="0" cellspacing="0">
												<!--- <tr>
													<td class='CIT' width="5%"><strong>Linea</strong></td>
													<td class='CIT' width="30%"><strong>Descripción</strong></td>
													<td class='CIT' width="5%"><strong>UEN</strong></td>
													<td class='CIT' width="30%"><strong>Cuenta</strong></td>
													<td class='CIT' width="20%"><strong>Total</strong></td>
													<td class='CIT' width="10%"><strong>Imp. CF</strong></td>
												</tr> --->							
												<tr>
													<td width="5%"><strong><font size="-2" face="Times New Roman, Times, serif">Linea</font></strong></td>
													<td width="40%" colspan="2"><strong><font size="-2" face="Times New Roman, Times, serif">Descripción</font></strong></td>
													<td width="5%"><strong><font size="-2" face="Times New Roman, Times, serif">UEN</font></strong></td>
													<td width="30%"><strong><font size="-2" face="Times New Roman, Times, serif">Cuenta</font></strong></td>
													<td width="20%"><strong><font size="-2" face="Times New Roman, Times, serif">Total</font></strong></td>
													<!--- <td width="10%"><strong><font size="-2" face="Times New Roman, Times, serif">Imp. CF</font></strong></td> --->
												</tr>
												<!--- 
												<tr>
													<td colspan="6"><HR></td>
												</tr> --->												
												<cfoutput>
												<tr>
													<td class='CN'>#RptLiq.CJ2LIN#</td>
													<td class='CN' colspan="2">#RptLiq.CJ2DES#</td>
													<td class='CN'>#RptLiq.CGE5COD#</td>
													<td class='CN'>#RptLiq.CGM1IM#-#RptLiq.CGM1CD#</td>
													<td class='CN'>#numberformat(RptLiq.CJ2MNT,",9.99")#</td>
													<!--- <td class='CN'>#RptLiq.CJ2ICF#</td> --->
												</tr>
												</cfoutput>
												</table>
													
											</td>
										</tr>									
									<cfelse>
										<tr>
											<!--- <td>&nbsp;</td> --->
											<td colspan="6">
											
												<table align="center" border="0" width="90%" cellpadding="0" cellspacing="0">																				
												<cfoutput>
												<tr>
													<td class='CN' width="5%">#RptLiq.CJ2LIN#</td>
													<td class='CN' width="40%" colspan="2">#RptLiq.CJ2DES#</td>
													<td class='CN' width="5%">#RptLiq.CGE5COD#</td>
													<td class='CN' width="30%">#RptLiq.CGM1IM#-#RptLiq.CGM1CD#</td>
													<td class='CN' width="20%">#numberformat(RptLiq.CJ2MNT,",9.99")#</td>
													<!--- <td class='CN' width="10%">#RptLiq.CJ2ICF#</td> --->
												</tr>
												</cfoutput>
												</table>									
											
											</td>
										</tr>	
										
									</cfif>
						
							</cfif>
							
						</cfif>										
					
					</cfloop>
					<tr><td colspan="6">&nbsp;</td></tr>
					<tr>
						<td colspan="6" class='CD'>
							Total Liquidaci&oacute;n: <strong><cfoutput>#numberformat(MtotalLiq,",9.99")#</cfoutput></strong>
							<cfset MtotalLiq = "0">
						</td>
					</tr>									
					</table>
					
				</td>
			</tr>				
			</table>
	
	</td>
</tr>
<cfelse>
	<cfif isdefined("RptLiq")>
	<script>
	alert("-- No se encontraron resultados para la consulta solicitada --");
	</script>
	</cfif>
</cfif>
</table>