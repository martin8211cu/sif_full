<!--- 
Archivo:  cjc_sqlRLiquidacionesRecibidasContent.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    09 Noviembre 2006.              
--->
<cfif isdefined("url.btnFiltrar")>
	<cffile file="#GetTempDirectory()#Rep_#session.usuario#" 
			action="write" 
			output="<!--- Generado #dateformat(now(),"DD/MM/YYYY")# #timeformat(now(),"HH:MM:SS")# --->" 
			nameconflict="overwrite">
	<cffile file="#GetTempDirectory()#Rep_#session.usuario#Pintado" 
			action="write" 
			output="<!--- Generado #dateformat(now(),"DD/MM/YYYY")# #timeformat(now(),"HH:MM:SS")# --->" 
			nameconflict="overwrite">

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
		</style>
	</cfsavecontent>
	
	<cfset fnGraba(micontenido, true, false)>

	<cfset parametros = "">

	<cfif (isdefined("URL.FECHAINI") and len(URL.FECHAINI)) and (isdefined("URL.FECHAFIN") and len(URL.FECHAFIN))>
		<cfset FECHAI = replace(URL.FECHAINI,"'","","all")>
		<cfset FECHAF = replace(URL.FECHAFIN,"'","","all")>
		<cfif parametros eq "">
			<cfset parametros = " and CJX04RED between '#LSdateformat(FECHAI,"yyyymmdd")#' and '#LSdateformat(FECHAF,"yyyymmdd")# 11:59:59 PM'">
		<cfelse>
			<cfset parametros = parametros & " and CJX04RED between '#LSdateformat(FECHAI,"yyyymmdd")#' and '#LSdateformat(FECHAF,"yyyymmdd")# 11:59:59 PM'">
		</cfif>			
	</cfif>

	<cfif isdefined("URL.NCJM00COD") and len(URL.NCJM00COD)>
		<cfif parametros eq "">
			<cfset parametros = " and CJM00COD = '#URL.NCJM00COD#'">
		<cfelse>
			<cfset parametros = parametros & " and CJM00COD = '#URL.NCJM00COD#'">
		</cfif>
	</cfif>

	<cfif isdefined("URL.NCGE20NOL") and len(URL.NCGE20NOL)>
		<cfif parametros eq "">
			<cfset parametros = " and CJX04URE = '#URL.NCGE20NOL#'">
		<cfelse>
			<cfset parametros = parametros & " and CJX04URE = '#URL.NCGE20NOL#'">
		</cfif>
	</cfif>
		
	<cfsetting requesttimeout="12000">

	<cftry> 
		<cfquery name="RptLiq" datasource="#session.Fondos.dsn#">
				select 
				CJM00COD, 
				CJX04NUM, 
				convert(varchar,CJX04RED,103) as CJX04RED,
				convert(varchar,CJX04FLI,103) as CJX04FLI,
				CJX04URE,
				CGE20NOC
			from CJX004 a
				left outer join CGE020 b
					on a.CJX04URE = b.CGE20NOL
			where CJX04RED is not null
				#preservesinglequotes(parametros)#
			<cfif isdefined("REPORTE") and trim(REPORTE) EQ 1>
				order by CJM00COD,CJX04NUM				
			<cfelse>
				order by CJX04URE, CJM00COD,CJX04NUM				
			</cfif>
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

<!--- Session del Pintado del Reporte --->
<cfif isdefined("RptLiq") and RptLiq.recordcount gt 0 >
	<cfsavecontent variable="micontenido">
		<cfif isdefined("REPORTE") and trim(REPORTE) EQ 1>
			<cfset tamano = 5 >
			<cfset titulo = "Detallado">
		<cfelse>
			<cfset tamano = 4 >
			<cfset titulo = "Resumido">
		</cfif>

		<cfoutput>
			<link rel='stylesheet' type='text/css' href="../css/Corte_Pagina.css">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td>
					
						<table width="100%" border="0" cellpadding="2" cellspacing="0">
							<tr>
								<td align="center" nowrap>
									<table width="100%" align="center" border="0" cellspacing="0" class='T1'  cellpadding="1"> 						
										<tr> 
											<td class='CIN' width="30%">&nbsp;Fecha:&nbsp;<cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput></td>
											<td class='CCN' colspan="<cfoutput>#tamano#</cfoutput>" align="center" nowrap="nowrap"><cfoutput>Reporte #titulo# de</cfoutput></td>
											<td class='CDN' width="30%">&nbsp;Usuario:&nbsp;<cfoutput>#session.usuario#</cfoutput></td>
										</tr>
										<tr> 
											<td class='CIN' width="30%">&nbsp;Hora:&nbsp;&nbsp;<cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
											<td class='CCN' colspan="<cfoutput>#tamano#</cfoutput>" align="center" nowrap="nowrap"><cfoutput>Recepci&oacute;n  de  Liquidaciones</cfoutput></td>
											<td class='CDN' width="30%" align="right"></td>
										</tr>
										<tr> 
											<td class='CIN' width="30%">&nbsp;</td>
											<td class='CCN' colspan="<cfoutput>#tamano#</cfoutput>" align="center" nowrap="nowrap">Del: <cfoutput>#LSDateFormat(FECHAINI,'dd/mm/yyyy')#</cfoutput> al: <cfoutput>#LSDateFormat(FECHAFIN,'dd/mm/yyyy')#</cfoutput></td>
											<td class='CDN' width="30%" align="right"></td>
										</tr>
									</table>
								</td>
							</tr>
								
							<tr>
								<td align="center" nowrap>
									<!--- REPORTE --->
									<table cellpadding="0" width="100%" cellspacing="0" align="center">
										<cfif isdefined("REPORTE") and trim(REPORTE) EQ 1>
										
											<!--- Pinta el Encabezado --->
											<tr><td colspan="5">&nbsp;</td></tr>
											<tr>
												<td class='CIT'><strong>Fondo</strong></td>
												<td class='CIT'><strong>No. Liquidaci&oacute;n</strong></td>
												<td class='CCT' align="center"><strong>Fecha Liquidaci&oacute;n</strong></td>
												<td class='CCT' align="center"><strong>Fecha Recepci&oacute;n</strong></td>
												<td class='CIT'><strong>Usuario Recepci&oacute;n</strong></td>
											</tr>
											<!--- Pinta el Detalle de Consulta de Usuarios --->
											<cfloop query="RptLiq">
												<tr>
													<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJM00COD#</td>
													<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJX04NUM#</td>
													<td class='CN' nowrap="nowrap" align="center">#RptLiq.CJX04RED#</td>
													<td class='CN' nowrap="nowrap" align="center">#RptLiq.CJX04FLI#</td>
													<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJX04URE#</td>
												</tr>
											</cfloop>
											<tr><td colspan="5">&nbsp;</td></tr>
											
										<cfelse>
										
											<cfset corteUsuario = "">
											<cfset labelUsuario = "">
											<cfset contaUsuario = 0>
											
											<cfloop query="RptLiq">
												<cfif corteUsuario neq #RptLiq.CJX04URE#>
													<cfif labelUsuario neq "">
														<tr><td colspan="4">&nbsp;</td></tr>
														<tr>
															<td colspan="4" class='CNN' nowrap="nowrap"><strong>Cantidad Recepciones por Usuario: <cfoutput>#contaUsuario#</cfoutput></strong></td>
														</tr>
														<cfset contaUsuario = 0>	
													</cfif>	

													<!--- Pinta el Encabezado del Reporte Resumido --->
													<tr><td colspan="4">&nbsp;</td></tr>
													<tr>
														<td colspan="4" class='CIT'>Usuario Rec.: <cfoutput>#RptLiq.CJX04URE# - #RptLiq.CGE20NOC#</cfoutput></td>
													</tr>									
													<tr>
														<td class='CIT'><strong>Fondo</strong></td>
														<td class='CIT'><strong>No. Liquidaci&oacute;n</strong></td>
														<td class='CCT' align="center"><strong>Fecha Liquidaci&oacute;n</strong></td>
														<td class='CCT' align="center"><strong>Fecha Recepci&oacute;n</strong></td>
													</tr>
													<cfset corteUsuario = #RptLiq.CJX04URE#>
													<cfset labelUsuario = #RptLiq.CJX04URE#>
												</cfif>												
												<!--- Pinta el Detalle del Reporte Resumido --->
												<cfoutput>
													<tr>
														<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJM00COD#</td>
														<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJX04NUM#</td>
														<td class='CN' nowrap="nowrap" align="center">#RptLiq.CJX04RED#</td>
														<td class='CN' nowrap="nowrap" align="center">#RptLiq.CJX04FLI#</td>
													</tr>
												</cfoutput>
												<cfset contaUsuario = contaUsuario + 1>

											</cfloop>
											<tr><td colspan="4">&nbsp;</td></tr>
											<tr>
												<td colspan="4" class='CNN' nowrap="nowrap"><strong>Cantidad Recepciones por Usuario: <cfoutput>#contaUsuario#</cfoutput></strong></td>
											</tr>											
											<tr><td colspan="4">&nbsp;</td></tr>
											
										</cfif>

									</table>
								</td>	
							</tr>
							
						</table>
						
					</td>
				</tr>
			</table>
		</cfoutput>
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


<!--- Función que permite grabar el reporte en una archivo Excel --->
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


