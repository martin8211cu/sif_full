

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Blanco" Default="Blanco" returnvariable="LB_Blanco"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="Cuenta" returnvariable="LB_Cuenta"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DEduccion" Default="% Deducci&oacute;n" returnvariable="LB_DEduccion"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DeduccionTipo" Default="Deducci&oacute;n tipo" returnvariable="LB_DeduccionTipo"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_del" Default="Del" returnvariable="LB_del"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_al" Default="al" returnvariable="LB_al"/>

<cfoutput>
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
	
	<cfset LvarFileName = "SalarioEscolar.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title= "#LB_ReporteSalarioEscolarBP#"
				filename="#LvarFileName#"
				irA="repSalarioEscolar-filtro.cfm">
				
				<style id="Book1_12489_Styles">
				.xl65
					{mso-style-parent:style0;
					mso-number-format:0;}
				
				</style>
					
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>	
						<cfsavecontent variable="ENCABEZADO_IMP">
						<td align="center" colspan="6"><strong><font size="2">
						<cf_EncReporte
							Titulo="#LB_ReporteSalarioEscolarBP#"
							filtro1="Periodo: #form.Periodo# - Mes: #form.Mes#"	>
						<tr class="tituloListas">
							<td ><b>#LB_Identificacion#</b></td>
							<td ><b>#LB_Nombre#</b></td>
							<td ><b>#LB_Blanco#</b></td>
							<td ><b>#LB_Cuenta#</b></td>
							<td align="right"><b>#LB_Monto#</b></td>
							<td align="right"><b>#LB_Deduccion#</b></td>
						</tr>
						</cfsavecontent>
						#ENCABEZADO_IMP#
					</tr>
					<cfif (isdefined("form.Periodo") and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes)))
							or (isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta)))> 
						<cfif rsSalarioEscolar.RecordCount NEQ 0>
							<cfset actual = ''>
							<cfloop query="rsSalarioEscolar">
								<tr <cfif rsSalarioEscolar.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
									<cfif actual NEQ rsSalarioEscolar.DEidentificacion>
										<td align="left"> <font style="font-size:11px; font-family:'Arial'">#rsSalarioEscolar.DEidentificacion#</font></td>
										<td align="left"> <font style="font-size:11px; font-family:'Arial'">#rsSalarioEscolar.Nombre#</font></td>
										<td align="left"> <font style="font-size:11px; font-family:'Arial'">#rsSalarioEscolar.Blanco#</font></td>
										<td align="left" class="xl65"> <font style="font-size:11px; font-family:'Arial'">#rsSalarioEscolar.Cuenta#</font></td>
										<td align="right"><font style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsSalarioEscolar.Monto,'999,999,999.99')#</font></td>
										<td align="right"><font style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsSalarioEscolar.Deduccion,'999.99')#</font></td>
									</cfif>
								</tr>
							</cfloop>
								<tr><td colspan="6" align="center" class="letra">--- <cf_translate key="MGS_FinDelReporte" xmlfile="/rh/generales.xml">Fin del Reporte</cf_translate> ---</td></tr>
						<cfelse>
							<tr><td colspan="6" align="center"><b>----- #LB_NoSeEncontraronRegistros# -----</b></td></tr>
						</cfif>
					</cfif>
				</table>			
			</td>
		</tr>
	</table>
</cfoutput>

