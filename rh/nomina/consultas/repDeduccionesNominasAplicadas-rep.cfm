<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoRebajado" Default="Monto Rebajado" returnvariable="LB_MontoRebajado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DEduccion" Default="Deducci&oacute;n - Referencia" returnvariable="LB_DEduccion"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DeduccionTipo" Default="Deducci&oacute;n tipo" returnvariable="LB_DeduccionTipo"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_del" Default="Del" returnvariable="LB_del"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_al" Default="al" returnvariable="LB_al"/>

<cfoutput>
	<cfquery name="TotalDeducciones" dbtype="query">
		select sum(Monto) as total
		from rsDeducciones
	</cfquery>

	<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
		select TDid, TDcodigo, TDdescripcion 
		from TDeduccion 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#">
	</cfquery>
		
	<cfset vs_params = ''>
	<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
		<cfset vs_params = vs_params & '&Periodo=#form.Periodo#'>
	</cfif>
	<cfif isdefined("form.Mes") and len(trim(form.Mes))>
		<cfset vs_params = vs_params & '&Mes=#form.Mes#'>
	</cfif>
	
	
	<cfif isdefined("form.deduccion") and len(trim(form.deduccion))>
		<cfset vs_params = vs_params & '&deduccion=#form.deduccion#'>
	</cfif>
	
	<cfset LvarFileName = "DeduccionesAplicadas#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title= "#LB_ReporteDeDeduccionesNominasAplicadas#"
				filename="#LvarFileName#"
				irA="repDeduccionesNominasAplicadas-filtro.cfm">
					
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>	
						<cfsavecontent variable="ENCABEZADO_IMP">
						<td align="center" colspan="4"><strong><font size="2">
						<cf_EncReporte
							Titulo="#LB_ReporteDeDeduccionesNominasAplicadas#"
							filtro1="#LB_DeduccionTipo# : #rsTipoDeduccion.TDdescripcion#"
							filtro2="#LB_del# #DateFormat(fdesde, "dd/mm/yyyy")# #LB_al# #DateFormat(fhasta, "dd/mm/yyyy")#"
						>
						<tr class="tituloListas">
							<td><b>#LB_Identificacion#</b></td>
							<td><b>#LB_Nombre#</b></td>
							<td><b>#LB_Deduccion#</b></td>
							<td align="right"><b>#LB_MontoRebajado#</b></td>
						</tr>
						</cfsavecontent>
						#ENCABEZADO_IMP#
					</tr>
					<cfif (isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes)))
							or (isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta)))> 
						<cfif rsDeducciones.RecordCount NEQ 0>
							<cfset actual = ''>
							
							<!---<cf_dump var="#rsDeducciones#">--->
							
							<cfloop query="rsDeducciones">
								<tr <cfif rsDeducciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
									<cfif actual NEQ rsDeducciones.DEidentificacion>
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.DEidentificacion#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.Nombre#</font></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.Ddescripcion# - #rsDeducciones.Dreferencia#</font></td>
										<cfset actual = rsDeducciones.DEidentificacion>
									<cfelse>
										<td colspan="2"></td>
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.Ddescripcion# - #rsDeducciones.Dreferencia#</font></td>
										<cfset actual = rsDeducciones.DEidentificacion>
									</cfif>
									<td align="right"><font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsDeducciones.Monto,'999,999,999.99')#</font></td>
								</tr>
							</cfloop>
							<tr>
								<td colspan="3" align="right"><b><cf_translate key="LB_Total">Total</cf_translate>:</b>&nbsp;</td>
								<td align="right" style="border-top:1px solid black;">#LSNumberFormat(TotalDeducciones.total,'999,999,999.99')#</font></td>
							</tr>
							<tr><td colspan="4" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
						<cfelse>
							<tr><td colspan="4" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
						</cfif>
					</cfif>
				</table>			
			</td>
		</tr>
	</table>
</cfoutput>

