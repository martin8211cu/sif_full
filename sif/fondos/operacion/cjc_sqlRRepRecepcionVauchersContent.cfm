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
			
	<cfif isdefined("URL.PERCOD") and len(URL.PERCOD)>
		<cfif parametros eq "">
			<cfset parametros = " a.PERCOD = #URL.PERCOD#">
		<cfelse>
			<cfset parametros = parametros & " a.PERCOD = #URL.PERCOD#">
		</cfif>
	</cfif>
	
	<cfif isdefined("URL.MESCODI") and len(URL.MESCODI)>
		<cfif parametros eq "">
			<cfset parametros =" and a.MESCOD >= #URL.MESCODI#">
		<cfelse>
			<cfset parametros = parametros & " and a.MESCOD >= #URL.MESCODI#">
		</cfif>
	</cfif>
	
	<cfif isdefined("URL.MESCODF") and len(URL.MESCODF)>
		<cfif parametros eq "">
			<cfset parametros =" and a.MESCOD <= #URL.MESCODF#">
		<cfelse>
			<cfset parametros = parametros & " and a.MESCOD <= #URL.MESCODF#">
		</cfif>
	</cfif>
	
	<cfif isdefined("URL.NCJM00COD") and len(URL.NCJM00COD)>
		<cfif parametros eq "">
			<cfset parametros = " and a.CJM00COD = '#URL.NCJM00COD#'">
		<cfelse>
			<cfset parametros = parametros & " and a.CJM00COD = '#URL.NCJM00COD#'">
		</cfif>
	</cfif>
	
	<cfif isdefined("URL.CJX12IRC") and trim(URL.CJX12IRC) EQ 1>
		<cfif isdefined("URL.FECHA_VOUCHER") and len(URL.FECHA_VOUCHER)>
			<cfset FECHA = replace(URL.FECHA_VOUCHER,"'","","all")>
			<cfif parametros eq "">
				<cfset parametros = " and a.CJX12FRC between '#LSdateformat(FECHA,"yyyymmdd")#' and '#LSdateformat(FECHA,"yyyymmdd")# 11:59:59 PM'">
			<cfelse>
				<cfset parametros = parametros & " and a.CJX12FRC between '#LSdateformat(FECHA,"yyyymmdd")#' and '#LSdateformat(FECHA,"yyyymmdd")# 11:59:59 PM'">
			</cfif>			
		</cfif>
	</cfif>
		
	<cfif isdefined("URL.TR01NUT") and len(URL.TR01NUT)>
		<cfif parametros eq "">
			<cfset parametros = " and a.TR01NUT like '%#URL.TR01NUT#%'">
		<cfelse>
			<cfset parametros = parametros & " and a.TR01NUT like '%#URL.TR01NUT#%'">
		</cfif>
	</cfif>
	
	<cfif isdefined("URL.CJX12AUT") and len(URL.CJX12AUT)>
		<cfif parametros eq "">
			<cfset parametros = " and a.CJX12AUT like '%#URL.CJX12AUT#%'">
		<cfelse>
			<cfset parametros = parametros & " and a.CJX12AUT like '%#URL.CJX12AUT#%'">
		</cfif>
	</cfif>
	
	<cfif isdefined("URL.CJX12IRC") and len(URL.CJX12IRC)>
		<cfset VCJX12IRC = "">
		<cfif URL.CJX12IRC eq "1">
			<cfset VCJX12IRC = "a.CJX12IRC = ">		
		</cfif>
		<cfif parametros eq "">
			<cfset parametros = " and #VCJX12IRC##URL.CJX12IRC#">
		<cfelse>
			<cfset parametros = parametros & " and #VCJX12IRC##URL.CJX12IRC#">
		</cfif>
	</cfif>
	
	<cfif isdefined("URL.CJX12TIP") and len(URL.CJX12TIP) and trim(URL.CJX12TIP) NEQ 0>
		<cfif trim(URL.CJX12TIP) EQ 3>
			<cfif parametros eq "">
				<cfset parametros = " and a.CJX12TIP in (3,5,7)">
			<cfelse>
				<cfset parametros = parametros & " and a.CJX12TIP in (3,5,7)">
			</cfif>
		<cfelse>
			<cfif parametros eq "">
				<cfset parametros = " and a.CJX12TIP = #URL.CJX12TIP# ">
			<cfelse>
				<cfset parametros = parametros & " and a.CJX12TIP = #URL.CJX12TIP# ">
			</cfif>
		</cfif>
	</cfif>
	
	<cfif isdefined("URL.ORDENAR") and len(URL.ORDENAR)>
		<cfif parametros eq "">
			<cfset parametros = " #URL.ORDENAR# ">
		<cfelse>
			<cfset parametros = parametros & " #URL.ORDENAR# ">
		</cfif>
	</cfif>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cftry> 
		<cfquery name="RptLiq" datasource="#session.Fondos.dsn#">
			select 	a.CJM00COD,
					b.CJM00DES,        
					a.PERCOD,
					a.MESCOD,
					a.TS1COD,
					a.TR01NUT,
					a.CJX12AUT,
					convert(varchar,a.CJX12FAU,103) as CJX12FAU,
					case 
						when a.CJX12TIP in (1,2,4) then a.CJX12IMP else (a.CJX12IMP * -1) 
					end as CJX12IMP,
					case a.CJX12IRC        
						when 0 then 'Pendientes'
						when 1 then 'Recibidos'
					end as CJX12IRC,
					convert(varchar,datediff(dd, a.CJX12FAU, isnull(CJX12FRC, getdate()))) as DIAS_DIF,
					(select EMPCED from PLM001 p where p.EMPCOD = c.EMPCOD) as EMPCED,
					(select EMPAPA #_Cat#' '#_Cat# EMPAMA #_Cat#' '#_Cat# EMPNOM from PLM001 p where p.EMPCOD = c.EMPCOD) as EMPNOM,
					a.CJX12URC,
					convert(varchar,a.CJX12FRC,103) as CJX12FRC,
					case a.CJX12TIP 
						when 1 then 'Compras'
						when 2 then 'Avance de efectivo'
						when 3 then 'Pago Recibido'
						when 4 then 'Reversion de pago'
						when 5 then 'Reversion de Avance de efectivo'
						when 6 then 'Reintegro de la Linea de Pago'
						when 7 then 'Reversion de Compras'
					end as CJX12TIP
			from CJX012 a
				inner join CJM000 b
					on a.CJM00COD = b.CJM00COD
				inner join CATR01 c
					on a.TS1COD = c.TS1COD
					and a.TR01NUT = c.TR01NUT
			where #preservesinglequotes(parametros)#
		</cfquery>			
	
	<cfcatch type="any">	
		<script language="JavaScript">
			var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
			mensaje = mensaje.substring(40,300);
			alert(mensaje);
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
								<cfif isdefined("URL.CJX12IRC") and trim(URL.CJX12IRC) EQ 1>
									<cfset Titulo = "Reporte de Vouchers Recibidos">
								<cfelse>
									<cfset Titulo = "Reporte de Vouchers Pendientes">
								</cfif>
								<tr> 
									<td class='CIN' width="30%">&nbsp;</td>
									<td class='CCN' colspan=9 align="center"><cfoutput>#Titulo#</cfoutput></td>
									<td class='CDN' width="30%">&nbsp;</td>
								</tr>

								<tr> 
									<td class='CIN' width="30%">&nbsp;Hora: <cfoutput>#timeformat(Now(),"hh:mm:ss")#</cfoutput></td>
									<td class='CCN' colspan=9 align="center">al <cfoutput>#dateformat(Now(),"dd/mm/yyyy")#</cfoutput> </td>
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
									<!--- Crea Encabezado --->														
									<cfif varfn neq #RptLiq.CJM00COD#>
										<tr><td colspan="6">&nbsp;</td></tr>
										<tr>
											<td colspan="6" class='CIN'>Fondo: <cfoutput>#RptLiq.CJM00COD# - #RptLiq.CJM00DES#</cfoutput></td>
										</tr>									
										<tr>
											<td class='CIT'><strong>No. Tarjeta</strong></td>
											<td class='CIT'><strong>Tipo Voucher</strong></td>
											<td class='CIT'><strong>Autorizaci&oacute;n</strong></td>
											<td class='CIT'><strong>Fecha Voucher</strong></td>
											<td class='CIT'><strong>Monto</strong></td>
											<td class='CIT'><strong>C&eacute;dula</strong></td>
											<td class='CIT'><strong>Nombre</strong></td>
											<td class='CIT'><strong>D&iacute;as Atraso</strong></td>
											<cfif isdefined("URL.CJX12IRC") and trim(URL.CJX12IRC) EQ 1>
												<td class='CIT'><strong>Fecha Recepci&oacute;n</strong></td>
												<td class='CIT'><strong>Usuario</strong></td>
											</cfif>
										</tr>
										<cfset varfn = #RptLiq.CJM00COD#>						
									</cfif>
									<cfoutput>
										<tr>
											<td class='CN'>&nbsp;&nbsp;#RptLiq.TR01NUT#</td>
											<td class='CN'>&nbsp;&nbsp;#RptLiq.CJX12TIP#</td>
											<td class='CN'>&nbsp;&nbsp;#RptLiq.CJX12AUT#</td>
											<td class='CN'>&nbsp;&nbsp;#RptLiq.CJX12FAU#</td>
											<td class='CN' align="right">#LSNumberFormat(RptLiq.CJX12IMP, ',9.00')#</td>
											<td class='CN'>&nbsp;&nbsp;#RptLiq.EMPCED#</td>
											<td class='CN'>&nbsp;&nbsp;#RptLiq.EMPNOM#</td>
											<td class='CN'>&nbsp;&nbsp;&nbsp;&nbsp;#RptLiq.DIAS_DIF#
											</td>
											<cfif isdefined("URL.CJX12IRC") and trim(URL.CJX12IRC) EQ 1>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.CJX12FRC#</td>
												<td class='CN'>&nbsp;&nbsp;#RptLiq.CJX12URC#</td>
											</cfif>
										</tr>
									</cfoutput>
								</cfloop>
								<tr><td colspan="6">&nbsp;</td>	</tr>
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

