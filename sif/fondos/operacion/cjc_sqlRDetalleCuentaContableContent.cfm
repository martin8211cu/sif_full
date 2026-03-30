<!--- 
Archivo:  cjc_sqlRDetalleCuentaContableContent.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    20 Octubre 2006.              
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
	
	<!--- Parámetros para ejecutar el procedimiento --->
	<cfset parametros = "">
	<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
		<cfif parametros eq "">
			<cfset parametros="@cjm00cod = '#NCJM00COD#'">
		<cfelse>
			<cfset parametros=parametros & ",@cjm00cod = '#NCJM00COD#'">
		</cfif>
	</cfif>
	<cfif isdefined("CP7SUBI") and len(CP7SUBI)>
		<cfif parametros eq "">
			<cfset parametros="@cp7subI = #CP7SUBI#">
		<cfelse>
			<cfset parametros=parametros & ",@cp7subI = #CP7SUBI#">
		</cfif>
	</cfif>
	<cfif isdefined("CP7SUBF") and len(CP7SUBF)>
		<cfif parametros eq "">
			<cfset parametros="@cp7subF = #CP7SUBF#">
		<cfelse>
			<cfset parametros=parametros & ",@cp7subF = #CP7SUBF#">
		</cfif>
	</cfif>
	<cfif isdefined("CMAYOR") and len(CMAYOR)>
		<cfif parametros eq "">
			<cfset parametros="@cgm1im = '#CMAYOR#'">
		<cfelse>
			<cfset parametros=parametros & ",@cgm1im = '#CMAYOR#'">
		</cfif>
	</cfif>
	<cfif isdefined("CtaFinal") and len(CtaFinal)>
		<cfif parametros eq "">
			<cfset parametros="@cgm1cd = '#CtaFinal#'">
		<cfelse>
			<cfset parametros=parametros & ",@cgm1cd = '#CtaFinal#'">
		</cfif>
	</cfif>
	<cfif isdefined("FECHAINI") and len(FECHAINI)>
		<cfif parametros eq "">
			<cfset parametros="@fecini = '#LSDateFormat(FECHAINI,'yyyymmdd')#'">
		<cfelse>
			<cfset parametros=parametros & ",@fecini = '#LSDateFormat(FECHAINI,'yyyymmdd')#'">
		</cfif>
	</cfif>
	<cfif isdefined("FECHAFIN") and len(FECHAFIN)>
		<cfif parametros eq "">
			<cfset parametros="@fecfin = '#LSDateFormat(FECHAFIN,'yyyymmdd')#'">
		<cfelse>
			<cfset parametros=parametros & ",@fecfin = '#LSDateFormat(FECHAFIN,'yyyymmdd')#'">
		</cfif>
	</cfif>
	
	<cfsetting requesttimeout="12000">	
	<cftry> 
		<cfquery name="RptLiq" datasource="#session.Fondos.dsn#">
			set nocount on
			exec sp_REP_DetalleCuenta #PreserveSingleQuotes(parametros)#
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

<!--- Session del Pintado del Reporte --->
<cfif isdefined("RptLiq") and RptLiq.recordcount gt 0 > 
	<cfsavecontent variable="micontenido">
		<cfoutput>
			<link rel='stylesheet' type='text/css' href="../css/Corte_Pagina.css">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td>
					
						<table width="100%" border="0" cellpadding="2" cellspacing="0">
							<tr>
								<td align="center" nowrap>
									<table width="100%" align="center" border="0" cellspacing="0" class='T1'  cellpadding="1"> 						
										<!--- Línea No. 1 del Encabezado --->
										<tr> 
											<td class='CIN' width="30%">&nbsp;Fecha:&nbsp;<cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput></td>
											<td class='CCN' colspan="11" align="center" nowrap="nowrap"><cfoutput>Gastos por Cuenta Detallada</cfoutput></td>
											<td class='CDN' width="30%">&nbsp;Usuario:&nbsp;<cfoutput>#session.usuario#</cfoutput></td>
										</tr>
										
										<!--- Línea No. 2 del Encabezado --->
										<cfif ( isdefined("FECHAINI") and len(FECHAINI) ) and ( isdefined("FECHAFIN") and len(FECHAFIN) )>
											<tr> 
												<td class='CIN' width="30%">&nbsp;Hora:&nbsp;&nbsp;<cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
												<td class='CCN' colspan="11" align="center" nowrap="nowrap">Del: <cfoutput>#LSDateFormat(FECHAINI,'dd/mm/yyyy')#</cfoutput> al <cfoutput>#LSDateFormat(FECHAFIN,'dd/mm/yyyy')#</cfoutput></td>
												<td class='CDN' width="30%" align="right"></td>
											</tr>
										</cfif>
										
										<!--- Línea No. 3 del Encabezado --->
										<cfif ( isdefined("CMAYOR") and len(CMAYOR) ) 
											and ( isdefined("CtaFinal") and len(CtaFinal) ) 
											and ( isdefined("CtaFinalCompleta") and len(CtaFinalCompleta) ) >
											<tr> 
												<td class='CIN' width="30%">&nbsp;</td>
												<td class='CCN' colspan="11" align="center" nowrap="nowrap">Cuenta: <cfoutput>#CtaFinalCompleta#</cfoutput>  </td>
												<td class='CDN' width="30%" align="right"></td>
											</tr>
										</cfif>
										
										<!--- Línea No. 4 del Encabezado --->
										<cfif (isdefined("CP7SUBI") and len(CP7SUBI) ) and ( isdefined("CP7SUBF") and len(CP7SUBF) )>
											<cfset gtoInicial = CP7SUBI>
											<cfset gtoFinal = CP7SUBF>
											
											<!--- Consulta para obtener la descripción del Gasto Inicial --->
											<cfquery name="rsGastoInicial" datasource="#session.Fondos.dsn#">
												select CP7SUB, CP7DES
												from CPM007
												where CP7SUB = <cfqueryparam cfsqltype="cf_sql_integer" value="#gtoInicial#">
											</cfquery>
											
											<cfif isdefined("rsGastoInicial") and rsGastoInicial.RecordCount GT 0>
												<cfset gastoInicial = rsGastoInicial.CP7SUB & " - " & rsGastoInicial.CP7DES>
											<cfelse>
												<cfset gastoInicial = "">
											</cfif>
											
											<!--- Consulta para obtener la descripción del Gasto Final --->
											<cfquery name="rsGastoFinal" datasource="#session.Fondos.dsn#">
												select CP7SUB, CP7DES
												from CPM007
												where CP7SUB = <cfqueryparam cfsqltype="cf_sql_integer" value="#gtoFinal#">
											</cfquery>
											
											<cfif isdefined("rsGastoFinal") and rsGastoFinal.RecordCount GT 0>
												<cfset gastoFinal = rsGastoFinal.CP7SUB & " - " & rsGastoFinal.CP7DES>
											<cfelse>
												<cfset gastoFinal = "">
											</cfif>

											<tr> 
												<td class='CIN' width="30%">&nbsp;</td>
												<td class='CCN' colspan="11" align="center" nowrap="nowrap">O.G. Inicial: <cfoutput>#gastoInicial#</cfoutput>  O.G. Final <cfoutput>#gastoFinal#</cfoutput></td>
												<td class='CDN' width="30%" align="right"></td>
											</tr>
										</cfif>

									</table>
								</td>
							</tr>
								
							<tr>
								<td align="center" nowrap>
									<!--- REPORTE --->
									<table cellpadding="0" width="100%" cellspacing="0" align="center">
										<!--- Pinta el Encabezado --->														
										<tr><td colspan="13">&nbsp;</td></tr>
										
										<tr>
											<td class='CIT' nowrap="nowrap"><strong>Objeto Gasto</strong></td>
											<td class='CIT' nowrap="nowrap"><strong>Segmento</strong></td>
											<td class='CCT' nowrap="nowrap" align="center"><strong>Cuenta</strong></td>
											<td class='CCT' nowrap="nowrap" align="center"><strong>Detalle</strong></td>
											<td class='CIT' nowrap="nowrap"><strong>Empleado</strong></td>
											<td class='CCT' nowrap="nowrap"><strong>Fecha</strong></td>
											<td class='CIT' nowrap="nowrap"><strong>Tipo</strong></td>
											<td class='CIT' nowrap="nowrap"><strong>No. Factura</strong></td>
											<td class='CCT' nowrap="nowrap" align="center"><strong>Monto</strong></td>
											<td class='CIT' nowrap="nowrap"><strong>Proveedor</strong></td>
											<td class='CIT' nowrap="nowrap"><strong>Caja</strong></td>
											<td class='CIT' nowrap="nowrap"><strong>Tra/Rel</strong></td>
											<td class='CIT' nowrap="nowrap"><strong>Veh&iacute;culo</strong></td>
										</tr>
										
										<!--- Pinta el Detalle de Consulta de Usuarios --->
										<cfloop query="RptLiq">
											<tr>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.obj#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Uen#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Cuenta#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Det_gasto#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Empleado#</td>
												<td class='CN' nowrap="nowrap" align="center">&nbsp;&nbsp;#dateformat(RptLiq.FecApl,"dd/mm/yyyy")#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Tipo#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.No_Fact#</td>
												<td class='CN' nowrap="nowrap" align="right">#LSCUrrencyFormat(RptLiq.Monto, 'none')#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Proveedor#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Caja#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Tra_Rel#</td>
												<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Vehiculo#</td>
											</tr>
										</cfloop>
	
										<tr><td colspan="13">&nbsp;</td></tr>
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


