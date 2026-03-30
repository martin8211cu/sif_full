<!--- 
Archivo:  cjc_sqlRDetalleCuentaContableContent.cfm
Creado:   Randall Colomer en el ICE.   
Fecha:    20 Octubre 2006.              
--->

<cfif isdefined("url.btnFiltrar")>
	<cfsavecontent variable="micontenido">
		<cfoutput>
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
		</cfoutput>
	</cfsavecontent>
	
	<cfset fnGraba(micontenido, true, false)>
	
	<!--- Parmetros para ejecutar el procedimiento --->
	<cfset parametros = "">
 	<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
		<cfif parametros eq "">
			<cfset parametros="@cjm00cod = '#NCJM00COD#'">
		<cfelse>
			<cfset parametros=parametros & ",@cjm00cod = '#NCJM00COD#'">
		</cfif>
	</cfif>
	<cfif isdefined("NCJ01ID") and len(NCJ01ID)>
		<cfif parametros eq "">
			<cfset parametros="@cj01id = '#NCJ01ID#'">
		<cfelse>
			<cfset parametros=parametros & ",@cj01id = '#NCJ01ID#'">
		</cfif>
	</cfif>
	<cfif isdefined("PERCOD") and len(PERCOD)>
		<cfif parametros eq "">
			<cfset parametros="@cj1per = #PERCOD#">
		<cfelse>
			<cfset parametros=parametros & ",@cj1per = #PERCOD#">
		</cfif>
	</cfif>
	<cfif isdefined("MESCODI") and len(MESCODI)>
		<cfif parametros eq "">
			<cfset parametros="@cj1mesI = #MESCODI#">
		<cfelse>
			<cfset parametros=parametros & ",@cj1mesI = #MESCODI#">
		</cfif>
	</cfif>
	<cfif isdefined("MESCODF") and len(MESCODF)>
		<cfif parametros eq "">
			<cfset parametros="@cj1mesF = #MESCODF#">
		<cfelse>
			<cfset parametros=parametros & ",@cj1mesF = #MESCODF#">
		</cfif>
	</cfif>
	<cfif isdefined("REPORTE") and len(REPORTE)>
		<cfif parametros eq "">
			<cfset parametros="@tiprep = #REPORTE#">
		<cfelse>
			<cfset parametros=parametros & ",@tiprep = #REPORTE#">
		</cfif>
	</cfif>
	<cfif isdefined("FECHAINI") and len(FECHAINI)>
		<cfif parametros eq "">
			<cfset parametros="@cj1fecI = '#LSDateFormat(FECHAINI,'yyyymmdd')#'">
		<cfelse>
			<cfset parametros=parametros & ",@cj1fecI = '#LSDateFormat(FECHAINI,'yyyymmdd')#'">
		</cfif>
	</cfif>
	<cfif isdefined("FECHAFIN") and len(FECHAFIN)>
		<cfif parametros eq "">
			<cfset parametros="@cj1fecF = '#LSDateFormat(FECHAFIN,'yyyymmdd')#'">
		<cfelse>
			<cfset parametros=parametros & ",@cj1fecF = '#LSDateFormat(FECHAFIN,'yyyymmdd')#'">
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
	<cfif isdefined("EMPCED") and len(EMPCED)>
		<cfif parametros eq "">
			<cfset parametros="@empced = '#EMPCED#'">
		<cfelse>
			<cfset parametros=parametros & ",@empced = '#EMPCED#'">
		</cfif>
	</cfif>
	<cfif isdefined("PROCED") and len(PROCED)>
		<cfif parametros eq "">
			<cfset parametros="@proced = '#PROCED#'">
		<cfelse>
			<cfset parametros=parametros & ",@proced = '#PROCED#'">
		</cfif>
	</cfif>
 	
	<cfsetting requesttimeout="900">
	<cftry> 
		<cfquery name="RptLiq" datasource="#session.Fondos.dsn#" debug="yes">
			set nocount on
			exec sp_REP_TrasnxFondo #PreserveSingleQuotes(parametros)# 
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
	<cfif isdefined("NCJM00COD") and len(NCJM00COD)>
		<cfset fondoCaja = NCJM00COD>
	<cfelse>
		<cfset fondoCaja = "">
	</cfif>
	
	<cfquery name="rsFondoCaja" datasource="#session.Fondos.dsn#">
		select CJM00COD as NCJM00COD, CJM00COD,CJM00DES 
		from CJM000
		where CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fondoCaja#" >
	</cfquery>
	
	<cfif isdefined("rsFondoCaja") and rsFondoCaja.RecordCount GT 0>
		<cfset fondo = rsFondoCaja.NCJM00COD & " - " & rsFondoCaja.CJM00DES>
	<cfelse>
		<cfset fondo = "">
	</cfif>

	<cfif isdefined("REPORTE") and trim(REPORTE) EQ 1>
		<cfset tamano = 10 >
	<cfelse>
		<cfset tamano = 20 >
	</cfif>

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
									<!--- Lnea No. 01 del Encabezado --->
									<tr> 
										<td class='CIN' width="30%">&nbsp;Fecha:&nbsp;<cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput></td>
										<td class='CCN' colspan="<cfoutput>#tamano#</cfoutput>" align="center" nowrap="nowrap"><cfoutput>Detalle de Transacciones por Fondo</cfoutput></td>
										<td class='CDN' width="30%">&nbsp;Usuario:&nbsp;<cfoutput>#session.usuario#</cfoutput></td>
									</tr>
		
									<!--- Lnea No. 02 del Encabezado --->
									<tr> 
										<td class='CIN' width="30%">&nbsp;Hora:&nbsp;&nbsp;<cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
										<td class='CCN' colspan="<cfoutput>#tamano#</cfoutput>" align="center" nowrap="nowrap">Fondo de Trabajo <cfoutput>#PERCOD#</cfoutput></td>
										<td class='CDN' width="30%" align="right"></td>
									</tr>
									
									<!--- Lnea No. 03 del Encabezado --->
									<tr> 
										<td class='CIN' width="30%">&nbsp;</td>
										<td class='CCN' colspan="<cfoutput>#tamano#</cfoutput>" align="center" nowrap="nowrap">Fondo de Trabajo: <cfoutput>#fondo#</cfoutput></td>
										<td class='CDN' width="30%" align="right"></td>
									</tr>
									
									<!--- Lnea No. 04 del Encabezado --->
									<tr> 
										<td class='CIN' width="30%">&nbsp;</td>
										<td class='CCN' colspan="<cfoutput>#tamano#</cfoutput>" align="center" nowrap="nowrap">
											Periodo: <cfoutput>#PERCOD#</cfoutput> 
											<cfif isdefined("MESCODI") and len(MESCODI) and isdefined("MESCODF") and len(MESCODF)>
												- Mes Inicial: <cfoutput>#MESCODI#</cfoutput> Mes Final: <cfoutput>#MESCODF#</cfoutput></td>
											</cfif>
										<td class='CDN' width="30%" align="right"></td>
									</tr>
									
									<!--- Lnea No. 05 del Encabezado --->
									<cfif ( isdefined("FECHAINI") and len(FECHAINI) ) and ( isdefined("FECHAFIN") and len(FECHAFIN) )>
										<tr> 
											<td class='CIN' width="30%">&nbsp;</td>
											<td class='CCN' colspan="<cfoutput>#tamano#</cfoutput>" align="center" nowrap="nowrap">Del: <cfoutput>#LSDateFormat(FECHAINI,'dd/mm/yyyy')#</cfoutput> al: <cfoutput>#LSDateFormat(FECHAFIN,'dd/mm/yyyy')#</cfoutput></td>
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
	</cfoutput>
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, true)>
	<cfif isdefined("REPORTE") and trim(REPORTE) EQ 1>
		<cfset fnEncabezado1()>
		<cfset fnDetalle1()>
	<cfelse>
		<cfset fnEncabezado2()>
		<cfset fnDetalle2()>
		<cfsavecontent variable="micontenido">
		<cfoutput>
			<!--- Pinta el Detalle de Consulta de Usuarios --->
			<tr>
				<td class='CN' nowrap="nowrap" colspan="14">&nbsp;</td>
				<td class='CNN' nowrap="nowrap" align="right"><strong>#NumberFormat(montoTotal,",9.99")#</strong></td>
				<td class='CN' nowrap="nowrap" colspan="7">&nbsp;</td>
			</tr>
			<tr><td colspan="22">&nbsp;</td></tr>
		</cfoutput>
		</cfsavecontent>
		<cfset fnGraba(micontenido, true, false)>
	</cfif>
	<cfsavecontent variable="micontenido">
	<cfoutput>
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

<cffunction name="fnDetalle1">
	<!--- Pinta el Detalle de Consulta de Usuarios --->
	<cfloop query="RptLiq">
		<cfsavecontent variable="micontenido">
		<cfoutput>
		<tr>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ01ID#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ1NUM#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ1TIP#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.PROCED#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.PRONOM#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.FACDOC#</td>
			<td class='CN' nowrap="nowrap" align="center">&nbsp;&nbsp;#dateformat(RptLiq.FECHA,"dd/mm/yyyy")#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.EMPCED#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.EMPNOM#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CP9COD#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CP9DES#</td> 
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ2LIN#</td>
		</tr>
		</cfoutput>
		</cfsavecontent>
		<cfset fnGraba(micontenido, true, false)>
	</cfloop>
</cffunction>

<cffunction name="fnDetalle2">
	<cfset montoTotal = 0>
	<cfloop query="RptLiq">
		<cfsavecontent variable="micontenido">
		<cfoutput>
		<tr>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ01ID#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ1NUM#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ1TIP#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.PROCED#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.PRONOM#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.FACDOC#</td>
			<td class='CN' nowrap="nowrap" align="center">&nbsp;&nbsp;#dateformat(RptLiq.FECHA,"dd/mm/yyyy")#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.EMPCED#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.EMPNOM#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CP9COD#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CP9DES#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ2LIN#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ2DES#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CTA_CONT#</td>
			<td class='CN' nowrap="nowrap" align="right">#NumberFormat(RptLiq.CJ2MNT,",9.99")#</td>
			<td class='CN' nowrap="nowrap" align="center">&nbsp;&nbsp;#dateformat(RptLiq.FECHA_DIGI,"dd/mm/yyyy")#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJ1VER#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJX04NUM#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Activo#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Vehiculo#</td>
			<td class='CN' nowrap="nowrap" align="right">&nbsp;&nbsp;#RptLiq.Kilometraje#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.Litros#</td>
			<td class='CN' nowrap="nowrap">&nbsp;&nbsp;#RptLiq.CJM16COD#</td>
		</tr>
		</cfoutput>
		<cfset montoTotal = montoTotal + RptLiq.CJ2MNT>
		</cfsavecontent>
		<cfset fnGraba(micontenido, true, false)>
	</cfloop>
</cffunction>

<cffunction name="fnEncabezado1">
	<cfsavecontent variable="micontenido">
	<!--- Pinta el Encabezado --->
	<tr><td colspan="12">&nbsp;</td></tr>
	<tr>
		<td class='CIT'><strong>Caja</strong></td>
		<td class='CIT'><strong>No. Trans.</strong></td>
		<td class='CIT'><strong>Tipo Doc.</strong></td>
		<td class='CIT'><strong>C&eacute;dula Proveedor</strong></td>
		<td class='CIT'><strong>Proveedor</strong></td>
		<td class='CIT'><strong>No. Factura</strong></td>
		<td class='CCT' align="center"><strong>Fecha</strong></td>
		<td class='CIT'><strong>C&eacute;dula Empleado</strong></td>
		<td class='CIT'><strong>Nombre Empleado</strong></td>
		<td class='CIT'><strong>C&oacute;digo Autorizador</strong></td>
		<td class='CIT'><strong>Nombre Autorizador</strong></td>
		<td class='CIT'><strong>L&iacute;nea</strong></td>
	</tr>
	<tr><td colspan="12">&nbsp;</td></tr>
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, false)>
</cffunction>

<cffunction name="fnEncabezado2">
	<cfsavecontent variable="micontenido">
	<!--- Pinta el Detallado --->
	<tr><td colspan="22">&nbsp;</td></tr>
	<tr>
		<td class='CIT'><strong>Caja</strong></td>
		<td class='CIT'><strong>No. Trans.</strong></td>
		<td class='CIT'><strong>Tipo Doc.</strong></td>
		<td class='CIT'><strong>C&eacute;dula Proveedor</strong></td>
		<td class='CIT'><strong>Proveedor</strong></td>
		<td class='CIT'><strong>No. Factura</strong></td>
		<td class='CCT' align="center"><strong>Fecha</strong></td>
		<td class='CIT'><strong>C&eacute;dula Empleado</strong></td>
		<td class='CIT'><strong>Nombre Empleado</strong></td>
		<td class='CIT'><strong>C&oacute;digo Autorizador</strong></td>
		<td class='CIT'><strong>Nombre Autorizador</strong></td>
		<td class='CIT'><strong>L&iacute;nea</strong></td>
		<td class='CIT'><strong>Descripci&oacute;n Gasto</strong></td>
		<td class='CIT'><strong>Cuenta Contable</strong></td>
		<td class='CIT'><strong>Monto Compras</strong></td>
		<td class='CCT' align="center"><strong>Fecha Digitaci&oacute;n</strong></td>
		<td class='CIT'><strong>Estado </strong></td>
		<td class='CIT'><strong>Num. Liq. </strong></td>
		<td class='CIT'><strong>Activo </strong></td>
		<td class='CIT'><strong>Veh&iacute;culo </strong></td>
		<td class='CIT'><strong>Kilometraje </strong></td>
		<td class='CIT'><strong>Litros </strong></td>
		<td class='CIT'><strong>Ord. Servicio</strong></td>
	</tr>
	</cfsavecontent>
	<cfset fnGraba(micontenido, true, false)>
</cffunction>

<!--- Funcion que permite grabar el reporte en una archivo Excel --->
<cffunction name="fnGraba">
	<cfargument name="contenido" required="yes">
	<cfargument name="paraExcel" required="no" default="yes">
	<cfargument name="fin" required="no" default="no">

	<cfif not paraExcel>
		<cffile action="append" file="#tempfilepintado_cfm#" output="#contenido#">
	<cfelse>
		<cfset contenido = replace(contenido,"   "," ","All")>
		<cfset contenido = REReplace(contenido,'([ \t\r\n])+',' ','all')>
		<cfset contenidohtml = contenidohtml & contenido>
		<cfif len(contenidohtml) GT 32768 or fin>
			<cffile action="append" file="#tempfilepintado_cfm#" output="#contenidohtml#">
			<cfset contenidohtml = "">
		</cfif>
	</cfif>
</cffunction>  

