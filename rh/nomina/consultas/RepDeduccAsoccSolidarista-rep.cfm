<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="C&eacute;dula" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido" Default="Apellido" returnvariable="LB_Apellido"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>

<cfoutput>		
	<cfset vs_params = ''>
	<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
		<cfset vs_params = vs_params & '&Periodo=#form.Periodo#'>
	</cfif>
	<cfif isdefined("form.Mes") and len(trim(form.Mes))>
		<cfset vs_params = vs_params & '&Mes=#form.Mes#'>
	</cfif>	
	<cfif isdefined("form.CPid") and len(trim(form.CPid))>
		<cfset vs_params = vs_params & '&CPid=#form.CPid#'>
	</cfif>	
	
	<cfset LvarFileName = "DeduccionesAsoccSolidarista#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title= "#LB_ReporteDeDeduccionesAsoc#"
				filename="#LvarFileName#"
				irA="RepDeduccAsoccSolidarista-filtro.cfm">
					
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>	
						<cfsavecontent variable="ENCABEZADO_IMP">
						<td align="center" colspan="8"><strong><font size="2">
						<cf_EncReporte
							Titulo="#LB_ReporteDeDeduccionesAsoc#"							
						>
						<tr class="tituloListas">
							<td><b>#LB_Identificacion#</b></td>							
							<td><b>#LB_Apellido#</b></td>
							<td><b>#LB_Apellido#</b></td>
							<td><b>#LB_Nombre#</b></td>		
							<cfloop query="rsColumDinamiDeduccAsoc">
								<td align="right"><b>#RHCRPTdescripcion#</b></td>	
							</cfloop>
												
						</tr>
						</cfsavecontent>
						#ENCABEZADO_IMP#
					</tr>
					<cfif (isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes)))> 
						<cfif rsDeducciones.RecordCount NEQ 0>
							<cfset actual = ''>							
							<cfloop query="rsDeducciones">
								<tr <cfif rsDeducciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
									<cfif actual NEQ rsDeducciones.DEidentificacion>
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.DEidentificacion#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.DEapellido1#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.DEapellido2#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.DEnombre#</font></td>
										
										<!--- DEDUCCIONES --->	
										<cfloop query="rsColumDinamiDeduccAsoc">	
										
											<cfquery name="rsTDid" datasource="#session.DSN#">
												select distinct TDid
												from RHConceptosColumna
												where RHCRPTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHCRPTid#">
												  and TDid is not null
											</cfquery>
											<cfset Lvar_TDid = 0>
											<cfif rsTDid.RecordCount ><cfset Lvar_TDid = ValueList(rsTDid.TDid)></cfif>
											
											<cfquery name="rsSumaTDid" datasource="#session.DSN#">
												select coalesce(sum(DCvalor),0) as monto
												
												from HDeduccionesCalculo a
												
												inner join DeduccionesEmpleado b
													on b.Did = a.Did
													
												inner join TDeduccion c
													on c.TDid = b.TDid
																																							
												where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeducciones.DEid#">
												  and c.TDid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_TDid#" list="yes">)
												  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
												  
												  and a.RCNid = #CPid#
											</cfquery>
											<cfset MontoDeduc = 0>
											<cfif rsSumaTDid.RecordCount and rsSumaTDid.Monto GT 0><cfset MontoDeduc = rsSumaTDid.Monto></cfif>
											
										<td align="right"><font  style="font-size:11px; font-family:'Arial'"> #LSNumberFormat(MontoDeduc,'999,999,999.99')#</font></td>
																					
										</cfloop>
										<!--- FIN DEDUCCIONES --->	
																				 								
										<cfset actual = rsDeducciones.DEidentificacion>
									<cfelse>									
										<cfset actual = rsDeducciones.DEidentificacion>
									</cfif>								
								</tr>
							</cfloop>							
							<tr><td colspan="4" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
						<cfelse>
							<tr><td colspan="8" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
						</cfif>
					</cfif>
				</table>			
			</td>
		</tr>
	</table>
</cfoutput>

