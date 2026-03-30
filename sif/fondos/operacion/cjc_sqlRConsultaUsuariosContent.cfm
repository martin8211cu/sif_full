<!--- 
Archivo:  cjc_sqlRConsultaUsuariosContent.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    18 y 19 Octubre 2006.              
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

	<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
		<cfif parametros eq "">
			<cfset parametros="@cjm00cod = '#NCJM00COD#'">
		<cfelse>
			<cfset parametros=parametros & ",@cjm00cod = '#NCJM00COD#'">
		</cfif>
	</cfif>
	
	<cfif isdefined("CJM10TIP") and len(CJM10TIP)>
		<cfif parametros eq "">
			<cfset parametros="@cjm10tip = #CJM10TIP#">
		<cfelse>
			<cfset parametros=parametros & ",@cjm10tip = #CJM10TIP#">
		</cfif>			
	</cfif>
	
	<cfif isdefined("CJM10EST") and len(CJM10EST)>
		<cfif parametros eq "">
			<cfset parametros="@cjm10est = '#CJM10EST#'">
		<cfelse>
			<cfset parametros=parametros & ",@cjm10est = '#CJM10EST#'">
		</cfif>
	</cfif>	

	<cftry> 
		<cfquery name="RptLiq" datasource="#session.Fondos.dsn#">
			set nocount on
			exec sp_REP_Usuarios #PreserveSingleQuotes(parametros)#
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
		<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
			<cfset fondo = NCJM00COD>
		<cfelse>
			<cfset fondo = "">
		</cfif>
		
		<cfquery name="rsFondo" datasource="#session.Fondos.dsn#">
			select CJM00COD, CJM00DES
			from CJM000
			where CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fondo#" >
		</cfquery>
		
		<cfif isdefined("rsFondo") and rsFondo.RecordCount GT 0>
			<cfset titulo = rsFondo.CJM00COD & " - " & rsFondo.CJM00DES>
		<cfelse>
			<cfset titulo = "">
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
											<td class='CCN' colspan="4" align="center"><cfoutput>Consulta de Usuarios</cfoutput></td>
											<td class='CDN' width="30%">&nbsp;Usuario:&nbsp;<cfoutput>#session.usuario#</cfoutput></td>
										</tr>
										<tr> 
											<td class='CIN' width="30%">&nbsp;Hora:&nbsp;&nbsp;<cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
											<td class='CCN' colspan="4" align="center">Fondo</td>
											<td class='CDN' width="30%" align="right"></td>
										</tr>
										<tr> 
											<td class='CIN' width="30%">&nbsp;</td>
											<td class='CCN' colspan="4" align="center"><cfoutput>#titulo#</cfoutput>  </td>
											<td class='CDN' width="30%" align="right"></td>
										</tr>
									</table>
								</td>
							</tr>
								
							<tr>
								<td align="center" nowrap>
									<!--- REPORTE --->
									<table cellpadding="0" width="100%" cellspacing="0" align="center">
										<!--- Pinta el Encabezado --->														
										<tr><td colspan="6">&nbsp;</td></tr>
										
										<tr>
											<td class='CIT'><strong>C&oacute;digo</strong></td>
											<td class='CIT'><strong>Nombre</strong></td>
											<td class='CIT'><strong>Tipo</strong></td>
											<td class='CDT' align="center"><strong>Monto</strong></td>
											<td class='CCT' align="center"><strong>Centro Funcional</strong></td>
											<td class='CIT' align="center"><strong>Estado</strong></td>
										</tr>
										<!--- Pinta el Detalle de Consulta de Usuarios --->
										<cfloop query="RptLiq">
											<tr>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.CJM10LOG#</td>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.CGE20NOC#</td>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.TIPO#</td>
												<td class='CN' align="right">#LSCUrrencyFormat(RptLiq.MONTO, 'none')#</td>
												<td class='CN'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#RptLiq.CFUNCIONAL#</td>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.CJM10EST#</td>
											</tr>
										</cfloop>
	
										<tr><td colspan="6">&nbsp;</td></tr>
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


