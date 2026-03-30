<cfif isdefined("btnFiltrar")>
	<cffile file="#GetTempDirectory()#Rep_#session.usuario#" action="write" output="<!--- Generado #dateformat(now(),"DD/MM/YYYY")# #timeformat(now(),"HH:MM:SS")# --->" nameconflict="overwrite">
	<cffile file="#GetTempDirectory()#Rep_#session.usuario#Pintado" action="write" output="<!--- Generado #dateformat(now(),"DD/MM/YYYY")# #timeformat(now(),"HH:MM:SS")# --->" nameconflict="overwrite">
	
	<cfsavecontent variable="micontenido">	
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
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, false)>
	
	<cfset parametros = "">

	<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
		<cfif parametros eq "">
			<cfset parametros="@cjm00cod = '#NCJM00COD#'">
		<cfelse>
			<cfset parametros=parametros & ",@cjm00cod = '#NCJM00COD#'">
		</cfif>
	</cfif>
		
	<cfif isdefined("ORDEN_PAGO") and len(ORDEN_PAGO)>
		<cfif parametros eq "">
			<cfset parametros="@order_pago = #ORDEN_PAGO#">
		<cfelse>
			<cfset parametros=parametros & ",@order_pago = #ORDEN_PAGO#">
		</cfif>
	</cfif>	
		
	<cfif isdefined("FECHA_PAGO") and len(FECHA_PAGO)>
		<cfset FECHA = replace(FECHA_PAGO,"'","","all")>
		<cfif parametros eq "">
			<cfset parametros="@fecha = '#LSDateFormat(FECHA,'yyyymmdd')#'">
		<cfelse>
			<cfset parametros=parametros & ",@fecha = '#LSDateFormat(FECHA,'yyyymmdd')#'">
		</cfif>			
	</cfif>

	<cftry> 
		<cfquery name="RptLiq" datasource="#session.Fondos.dsn#">
			set nocount on
			exec cj_rep_liqcontabilizadas #PreserveSingleQuotes(parametros)#
			set nocount off
		</cfquery>			
	
	<cfcatch type="any">	
		<script language="JavaScript">
			var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
			mensaje = mensaje.substring(40,300)
			alert("Mensaje "+mensaje)
		</script>
		<cfabort>
	</cfcatch> 
	</cftry> 
	 	
</cfif>


<cfif isdefined("RptLiq") and RptLiq.recordcount gt 0 >
	<cfsavecontent variable="micontenido">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr>	
						<td align="center" colspan="7" nowrap>
							<link rel='stylesheet' type='text/css' href="../css/Corte_Pagina.css">
							<table width="100%" align="center" border="0" cellspacing="0" class='T1'  cellpadding="1"> 						
								<tr> 
									<td class='CIN' width="30%">&nbsp;</td>
									<td class='CCN' colspan=9 align="center">Liquidaciones Pagadas</td>
									<td class='CDN' width="30%">&nbsp;</td>
								</tr>
								<tr> 
									<td class='CIN' width="30%">&nbsp;Hora: <cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
									<td class='CCN' colspan=9 align="center">al <cfoutput>#RptLiq.fecha_pag#</cfoutput> </td>
									<td class='CDN' width="30%" align="right">Usuario: <cfoutput>#session.usuario#</cfoutput></td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<td align="center" colspan="11" nowrap>		
							<!--- REPORTE --->
							<table cellpadding="0" width="100%" cellspacing="0" align="center">
																				
								<cfset varfn = "">
								<cfloop query="RptLiq">
									<cfif isdefined("url.ORDEN_PAGO")>
										<!--- Crea Encabezado --->														
										<!--- Corte por OP --->	
										<cfif varfn neq #RptLiq.orden#>
											<tr><td colspan="4">&nbsp;</td></tr>
											<tr>
												<td colspan="4" class='CIN'>Orden de Pago: <cfoutput>#RptLiq.orden# </cfoutput></td>
											</tr>									
											<tr>
												<td class='CIT'><strong>Fondo</strong></td>
												<td class='CIT'><strong>No. Liquidaci&oacute;n</strong></td>
												<td class='CIT'><strong>Fecha Liquidaci&oacute;n</strong></td>
												<td class='CIT'><strong>Monto</strong></td>
											</tr>
											<cfset varfn = #RptLiq.orden#>
										</cfif>									
									<cfelse>
										<!--- Crea Encabezado --->
										<!--- Corte por Fondo --->													
										<cfif varfn neq #RptLiq.fondo#>
											<tr><td colspan="4">&nbsp;</td></tr>
											<tr>
												<td colspan="4" class='CIN'>Fondo: <cfoutput>#RptLiq.fondo# </cfoutput></td>
											</tr>									
											<tr>
												<td class='CIT'><strong>Orden de Pago</strong></td>
												<td class='CIT'><strong>No. Liquidaci&oacute;n</strong></td>
												<td class='CIT'><strong>Fecha Liquidaci&oacute;n</strong></td>
												<td class='CIT'><strong>Monto</strong></td>
											</tr>
											<cfset varfn = #RptLiq.fondo#>
										</cfif>
									</cfif>
									
									<cfoutput>
										<tr>											
											<td class='CN'>
												<cfif isdefined("url.ORDEN_PAGO")>
													#RptLiq.fondo#
												<cfelse>								
													<cfif len(trim(#RptLiq.orden#)) GT 0>#RptLiq.orden#<cfelse>Pendiente de Pago</cfif>
												</cfif>
											</td>
											<td class='CN'>#RptLiq.num#</td>
											<td class='CN'>#RptLiq.fecha_liq#</td>
											<td class='CN'>#numberformat(RptLiq.monto,",9.99")#</td>
										</tr>
									</cfoutput>
								</cfloop>
								<tr><td colspan="4">&nbsp;</td>	</tr>
							</table>
						</td>
					</tr>				
				</table>
			</td>
		</tr>
	</table>
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, true)>
<cfelse>
	<cfsavecontent variable="micontenido">
		<cfif isdefined("RptLiq")>
			<script>
				var EXCEL = window.parent.frames["workspace1"].document.getElementById("EXCEL");				
				EXCEL.style.visibility='hidden';	
				alert("-- No se encontraron resultados para la consulta solicitada --");
			</script>
		</cfif>
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, true)>
</cfif>


<cffunction name="fnGraba">
	<cfargument name="contenido" required="yes">
	<cfargument name="paraExcel" required="no" default="yes">
	<cfargument name="fin" required="no" default="no">
	
	<cfset tempfile_cfm = GetTempDirectory() & "Rep_" & session.usuario >
	<cfset tempfilepintado_cfm = GetTempDirectory() & "Rep_" & session.usuario & "Pintado" >
	
	<cfif not paraExcel>
		<cffile action="append" file="#tempfile_cfm#" output="#contenido#">
		<cffile action="append" file="#tempfilepintado_cfm#" output="#contenido#">
	<cfelse>
		<cfset contenido = replace(contenido,"   "," ","All")>
		<cfset contenido = REReplace(contenido,'([ \t\r\n])+',' ','all')>
		<cfif isdefined("contenidohtml")>
			<cfset contenidohtml = contenidohtml & contenido>
		<cfelse>
			<cfset contenidohtml = contenido>
		</cfif>
		
		<cfif len(contenidohtml) GT 1048576>
			<cffile action="append" file="#tempfile_cfm#" output="#contenidohtml#">
			<cffile action="append" file="#tempfilepintado_cfm#" output="#contenido#">
			<cfset contenidohtml = "">
		</cfif>
	</cfif>

	<cfif fin>
		<cffile action="append" file="#tempfile_cfm#" output="#contenidohtml#">
		<cffile action="append" file="#tempfilepintado_cfm#" output="#contenido#">
		<cfset contenidohtml = "">
	</cfif>
</cffunction>  

