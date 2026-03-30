
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

	<cfif isdefined("NCJ01ID") and len(NCJ01ID)>
		<cfif parametros eq "">
			<cfset parametros="@ncj01id = '#NCJ01ID#'">
		<cfelse>
			<cfset parametros=parametros & ",@ncj01id = '#NCJ01ID#'">
		</cfif>
	</cfif>
	
	<cfif isdefined("FECHAINI") and len(FECHAINI)>
		<cfset FECHA_INI = replace(FECHAINI,"'","","all")>
		<cfif parametros eq "">
			<cfset parametros="@fechaIni = '#LSDateFormat(FECHA_INI,'yyyymmdd')#'">
		<cfelse>
			<cfset parametros=parametros & ",@fechaIni = '#LSDateFormat(FECHA_INI,'yyyymmdd')#'">
		</cfif>			
	</cfif>
	
	<cfif isdefined("FECHAFIN") and len(FECHAFIN)>
		<cfset FECHA_FIN = replace(FECHAFIN,"'","","all")>
		<cfif parametros eq "">
			<cfset parametros="@fechaFin = '#LSDateFormat(FECHA_FIN,'yyyymmdd')#'">
		<cfelse>
			<cfset parametros=parametros & ",@fechaFin = '#LSDateFormat(FECHA_FIN,'yyyymmdd')#'">
		</cfif>
	</cfif>	

	<cftry> 
		<cfquery name="RptLiq" datasource="#session.Fondos.dsn#">
			set nocount on
			exec sp_REP_CJ032 #PreserveSingleQuotes(parametros)#
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
		<cfif isdefined("NCJ01ID") and len(NCJ01ID)>
			<cfset fondoCaja = NCJ01ID>
		<cfelse>
			<cfset fondoCaja = "">
		</cfif>
		<cfif isdefined("FECHAINI") and len(FECHAINI)>
			<cfset fechaI = replace(FECHAINI,"'","","all")>
		<cfelse>
			<cfset fechaI =  "">
		</cfif>
		<cfif isdefined("FECHAFIN") and len(FECHAFIN)>
			<cfset fechaF = replace(FECHAFIN,"'","","all")>
		<cfelse>
			<cfset fechaF =  "">
		</cfif> 
		
		<cfquery name="rsFondoCaja" datasource="#session.Fondos.dsn#">
			select CJ01ID,CJ1DES
			from CJM001
			where CJ01ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fondoCaja#" >
		</cfquery>
		
		<cfif isdefined("rsFondoCaja") and rsFondoCaja.RecordCount GT 0>
			<cfset fondo = rsFondoCaja.CJ01ID>
			<cfset descripcion = rsFondoCaja.CJ1DES>
		<cfelse>
			<cfset fondo = "">
			<cfset descripcion = "">
		</cfif>

		<cfoutput>
			<cfset TotalCompras = 0>	
			<cfset TotalAvances = 0>	
			<cfset TotalDevoluc = 0>	
			<cfset TotalGeneral = 0>
			<cfset LineaTotales = "------------------------------">

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
											<td class='CN' colspan=9 align="center"><cfoutput>Reporte de Vouchers Digitados</cfoutput></td>
											<td class='CDN' width="30%">&nbsp;</td>
										</tr>
										<tr> 
											<td class='CIN' width="30%">&nbsp;Hora:&nbsp;<cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
											<td class='CCN' colspan=9 align="center">Fecha Inicial: <cfoutput>#dateformat(fechaI,"dd/mm/yyyy")#</cfoutput> a la Fecha Final: <cfoutput>#dateformat(fechaF,"dd/mm/yyyy")#</cfoutput> </td>
											<td class='CDN' width="30%" align="right">Usuario:&nbsp;<cfoutput>#session.usuario#</cfoutput></td>
										</tr>
									</table>
								</td>
							</tr>
								
							<tr>
								<td align="center" colspan="7" nowrap>
									<!--- REPORTE --->
									<table cellpadding="0" width="100%" cellspacing="0" align="center">
										<!--- Pinta el Encabezado --->														
										<tr><td colspan="7">&nbsp;</td></tr>
										
										<tr>
											<td colspan="7" class='CIN'>Fondo: <cfoutput>#fondo# - #descripcion#</cfoutput></td>
										</tr>
																			
										<tr>
											<td class='CIT'><strong>Tipo</strong></td>
											<td class='CIT'><strong>No. Tarjeta</strong></td>
											<td class='CIT'><strong>Responsable</strong></td>
											<td class='CDT' align="center"><strong>Compras</strong></td>
											<td class='CDT' align="center"><strong>Avances</strong></td>
											<td class='CDT' align="center"><strong>Devoluciones</strong></td>
											<td class='CDT' align="center"><strong>Total</strong></td>
										</tr>
										<!--- Pinta el Detalle de Vouchers Digitados --->
										<cfloop query="RptLiq">
											<!--- Se asigna el valor de los montos --->
											<cfset Compras = abs(RptLiq.Compras)>
											<cfset Avances = abs(RptLiq.Avances)>
											<cfset Devoluc = abs(RptLiq.Devoluciones)>
											<cfset Totales = ((Compras+Avances)-Devoluc)>
											
											<!--- Totaliza los montos de las columnas --->
											<cfset TotalCompras = TotalCompras + Compras>
											<cfset TotalAvances = TotalAvances + Avances>
											<cfset TotalDevoluc = TotalDevoluc + Devoluc>
											<cfset TotalGeneral = TotalGeneral + Totales>
											
											<tr>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.TS1COD#</td>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.TR01NUT#</td>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.EMPCED# - #RptLiq.EMPNOM#</td>
												<td class='CN' align="right">#LSCUrrencyFormat(Compras, 'none')#</td>
												<td class='CN' align="right">#LSCUrrencyFormat(Avances, 'none')#</td>
												<td class='CN' align="right">#LSCUrrencyFormat(Devoluc, 'none')#</td>
												<td class='CN' align="right">#LSCUrrencyFormat(Totales, 'none')#</td>
											</tr>
										</cfloop>
										<tr>
												<td class='CN'>&nbsp;</td>
												<td class='CN'>&nbsp;</td>
												<td class='CN'>&nbsp;</td>
												<td class='CN' align="right">#LineaTotales#</td>
												<td class='CN' align="right">#LineaTotales#</td>
												<td class='CN' align="right">#LineaTotales#</td>
												<td class='CN' align="right">#LineaTotales#</td>
										</tr>
	
										<tr>
												<td class='CN'>&nbsp;</td>
												<td class='CN'>&nbsp;</td>
												<td class='CN'>&nbsp;</td>
												<td class='CN' align="right">#LSCUrrencyFormat(TotalCompras, 'none')#</td>
												<td class='CN' align="right">#LSCUrrencyFormat(TotalAvances, 'none')#</td>
												<td class='CN' align="right">#LSCUrrencyFormat(TotalDevoluc, 'none')#</td>
												<td class='CN' align="right">#LSCUrrencyFormat(TotalGeneral, 'none')#</td>
										</tr>
										
										<tr><td colspan="7">&nbsp;</td></tr>
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

