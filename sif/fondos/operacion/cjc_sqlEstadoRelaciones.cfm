<cfif isdefined("btnFiltrar")>

	<p><center>
	<img id="imgespera" style="display:block" src="imagenes/esperese.gif" alt="Un momento por favor.... trabajando en el reporte" width="320" height="90" border="0">
	</center></p>
	<p>
	<cfloop from="1" to="110" index="miau">
		<!--- mucho espacio en blanco --->
	</cfloop>
	</p>
	<cfflush>
	
	<cfsetting requesttimeout="3600">
	
	<cftry> 
	<cfquery name="RptRelaciones" datasource="#session.Fondos.dsn#">
		set nocount on 
		
		exec sp_REP_CJX019
		<cfif isdefined("CJX19RELini") and len(CJX19RELini)>
			@CJX19RELini = <cfqueryparam cfsqltype="cf_sql_integer" value="#CJX19RELini#">,
		</cfif>
		<cfif isdefined("CJX19RELfin") and len(CJX19RELfin)>
			@CJX19RELfin = <cfqueryparam cfsqltype="cf_sql_integer" value="#CJX19RELfin#">,
		</cfif>				
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
			@CJM00COD = <cfqueryparam cfsqltype="cf_sql_char" value="#NCJM00COD#">,
		</cfif>
		<cfif isdefined("NCJ01ID") and len(NCJ01ID)>
			@CJ01ID = <cfqueryparam cfsqltype="cf_sql_char" value="#NCJ01ID#">,
		</cfif>
		<cfif isdefined("INI_CJX19FED") and len(INI_CJX19FED)>
			<cfset INI_CJX19FED = replace(INI_CJX19FED,"'","","all")>
			@CJX19FEDini = '#LSDateFormat(INI_CJX19FED,'yyyymmdd')#',
		</cfif>
		<cfif isdefined("FIN_CJX19FED") and len(FIN_CJX19FED)>
			<cfset FIN_CJX19FED = replace(FIN_CJX19FED,"'","","all")>
			@CJX19FEDfin =	'#LSDateFormat(FIN_CJX19FED,'yyyymmdd')#',
		</cfif>
		<cfif isdefined("RELEST")and RELEST neq 1>
			<cfif RELEST eq 2>
				@ESTADO = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
			<cfelse>
				@ESTADO = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
			</cfif>
		<cfelse>
			@ESTADO = NULL
		</cfif>
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

<cfif isdefined("RptRelaciones") and RptRelaciones.recordcount gt 0 >
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
<tr>
	<td>
	
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
			<tr>	
				<td align="center" colspan="7" nowrap>
						
					<link rel='stylesheet' type='text/css' href="../css/Corte_Pagina.css">
					<TABLE width="100%" border="0" cellspacing="0" class='T1'  cellpadding="1"> 
						
					<tr> 
							<td class='CIN' >&nbsp;Fecha: <cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput></td>
							<td class='CCN' colspan=9 > 
								Estado de las Relaciones
							</td>
							<td  class='CDN'>&nbsp;</td>
						</tr>
						<tr> 
							<td class='CIN' >&nbsp;Hora: <cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
							<td class='CCN' colspan=9>PRODUCTO</td>
							<td class='CDN'> 
								&nbsp;Usuario: <cfoutput>#session.usuario#</cfoutput>
							</td>
						</tr>
						<tr>
							<td class='CIN'>&nbsp;</td>
							<td class='CCN'colspan=9> 
								<cfif isdefined("INI_CJX19FED") and len(INI_CJX19FED) and isdefined("FIN_CJX19FED") and len(FIN_CJX19FED)>
									<cfset FechaDini = INI_CJX19FED>
									<cfset FechaDfin = FIN_CJX19FED>							
								<cfelse>
									<cfif isdefined("INI_CJX19FED") and len(INI_CJX19FED)>
										<cfset FechaDini = INI_CJX19FED>
									<cfelse>
										<cfset FechaDini = dateformat(RptRelaciones.CJX19FED,"dd/mm/yyyy")>
									</cfif>
									<cfif isdefined("FIN_CJX19FED") and len(FIN_CJX19FED)>
										<cfset FechaDfin = FIN_CJX19FED>
									<cfelse>
										<cfset FechaDfin = dateformat(RptRelaciones.CJX19FED,"dd/mm/yyyy")>							
									</cfif>
								    <cfoutput query="RptRelaciones">
										
											<cfset factual=dateformat(RptRelaciones.CJX19FED,"dd/mm/yyyy")>
											<cfif datediff("d",factual,FechaDini) gte 0>
												<cfset FechaDini = factual>
											</cfif>
											<cfif datediff("d",factual,FechaDfin) lte 0>
												<cfset FechaDfin = factual>
											</cfif>											
										
									</cfoutput>
								</cfif>							
							
								<cfif isdefined("CJX19RELini") and len(CJX19RELini) and isdefined("CJX19RELfin") and len(CJX19RELfin)>
									<cfset minrelacion = CJX19RELini>
									<cfset maxrelacion = CJX19RELfin>								
								<cfelse>
																					
									<cfset minrelacion = RptRelaciones.CJX19REL>
									<cfset maxrelacion = RptRelaciones.CJX19REL>
									<cfoutput query="RptRelaciones">
										
										<cfset relactual = RptRelaciones.CJX19REL>
										<cfif relactual lt minrelacion>
											<cfset minrelacion = relactual>
										</cfif>
										<cfif relactual gt maxrelacion>
											<cfset maxrelacion = relactual>
										</cfif>								
									
									</cfoutput>																		
									
								</cfif>
								 Desde la relacion:&nbsp;<cfoutput>#minrelacion#</cfoutput> &nbsp;&nbsp; Hasta la relacion: <cfoutput>#maxrelacion#</cfoutput>																					
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
						<tr>
							<td class='CIN'>&nbsp;</td>
							<td class='CCN'colspan=9> 
								<cfif isdefined("RELEST")and RELEST neq 1>
									<cfif RELEST eq 2>
										Solo Relaciones Conciliadas
									<cfelse>
										Solo Relaciones No Conciliadas
									</cfif>
								<cfelse>
									Todas las Relaciones
								</cfif>								
							</td>
							<td class='CDN'>&nbsp;</td>
						</tr>
						<tr>
							<td class='CIN'>&nbsp;</td>
							<td class='CCN'colspan=9> 
							Relaciones Digitadas entre:&nbsp;<cfoutput>#dateformat(FechaDini,"dd/mm/yyyy")#</cfoutput> &nbsp;y&nbsp; <cfoutput>#dateformat(FechaDfin,"dd/mm/yyyy")#</cfoutput>&nbsp;
							</td>
							<td class='CDN'>&nbsp;</td>
						</tr>
						
					</table>						
						
						
				</td>
			</tr>
			<tr>				
				<td width="14%" class='CIT'><strong>Num. Relación</strong></td>
				<td width="9%" class='CIT'><strong>Caja</strong></td>
				<td width="13%" class='CIT'><strong>Fondo</strong></td>
				<td width="19%" class='CIT'><strong>Fecha de Digitacion</strong></td>
				<td width="13%" class='CIT'><strong>Estado Actual</strong></td>
				<td width="17%" class='CIT' align="right"><strong>Monto Total</strong></td>
				<td width="15%" class='CIT'><strong>Conciliada</strong></td>
			</tr>			
			<cfif isdefined("INFOSEG")>				
				<cfset infoseg = INFOSEG>
			<cfelse>
				<cfset infoseg = 1>
			</cfif>
			
			<cfset totalAcumulado = 0>
			<cfoutput query="RptRelaciones">
			<tr>
				<td class='CN'><a href="cjc_EstadoRelacionesDocumentos.cfm?P_CJX19REL=#CJX19REL#&NCJM00COD=#trim(CJM00COD)#&NCJ01ID=#trim(CJ01ID)#&DOCSEG=#infoseg#"><font color="##000000">#CJX19REL#</font></a></td>
				<td class='CN'>#CJ01ID#</td>
				<td class='CN'>#CJM00COD#</td>
				<td class='CN'>#LSdateformat(CJX19FED,"dd/mm/yyyy")#</td>
				<td class='CN'>#CJX19EST#</td>
				<td class='CN' align="right">#NumberFormat(MONTOTOTAL,",9.99")#
				<cfloop from="1" to="20" step="1" index="i">&nbsp;</cfloop></td>
				<td class='CN'>#ESTADO#</td>
				
				<cfset totalAcumulado = totalAcumulado + MONTOTOTAL >
			</tr>
			</cfoutput>
			
			<cfoutput>
				<tr>
					<td class='CN' colspan="5">&nbsp;</td>
					<td class='CNN' align="right">
						<strong>#NumberFormat(totalAcumulado,",9.99")#</strong>
						<cfloop from="1" to="20" step="1" index="i">&nbsp;</cfloop>
					</td>
					<td class='CN'>&nbsp;</td>
				</tr>
			</cfoutput>
			</table>
	
	</td>
</tr>
<cfelse>
	<cfif isdefined("RptRelaciones")>
	<script>
	alert("-- No se encontraron resultados para la consulta solicitada --");
	</script>
	</cfif>
</cfif>
</table>

<script>
var imgobj = document.getElementById("imgespera");
imgobj.style.display = "none";
</script>
