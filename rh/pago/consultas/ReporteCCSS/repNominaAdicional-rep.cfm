
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoPeriodo" Default="Monto Total Periodo" returnvariable="LB_MontoPeriodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Monto" Default="Monto" returnvariable="LB_Monto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cuenta" Default="CS" returnvariable="LB_CS"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_GenerarArchivoDeTexto" Default="Generar archivo de texto" returnvariable="BTN_GenerarArchivoDeTexto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoSeEncontraronRegistros" Default="No se encontraron registros" returnvariable="LB_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DeduccionTipo" Default="Deducci&oacute;n tipo" returnvariable="LB_DeduccionTipo"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_del" Default="Del" returnvariable="LB_del"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_al" Default="al" returnvariable="LB_al"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Corte" Default="Planilla Adicional Periodo" returnvariable="LB_Corte"/>

<cfoutput>
	<cfset vs_params = ''>
	<cfif isdefined("form.CPperiodo") and len(trim(form.CPperiodo))>
		<cfset vs_params = vs_params & '&Periodo=#form.CPperiodo#'>
	</cfif>
	<cfif isdefined("form.CPmes") and len(trim(form.CPmes))>
		<cfset vs_params = vs_params & '&Mes=#form.CPmes#'>
	</cfif>
	
	<cfset LvarFileName = "NominaAdicional.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title= "#LB_PlanillaAdicional#"
				filename="#LvarFileName#"
				irA="repNominaAdicional-filtro.cfm">
				
				<style id="Book1_12489_Styles">
				.xl65
					{mso-style-parent:style0;
					mso-number-format:0;}
				
				</style>
					
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>	
						<cfsavecontent variable="ENCABEZADO_IMP">
						<td align="center" colspan="4"><strong><font size="2">
						<cf_EncReporte
							Titulo="#LB_PlanillaAdicional#"
							filtro1="Periodo: #form.CPperiodo# - Mes: #form.CPmes#"	
							cols="4">
						<!---<tr class="tituloListas">
							<td ><b>#LB_Identificacion#</b></td>
							<td ><b>#LB_Nombre#</b></td>
							<td align="right" ><b>#LB_Monto#</b></td>
							<td ><b>#LB_CS#</b></td>
						</tr>--->
						</cfsavecontent>
						#ENCABEZADO_IMP#
						
						<cfsavecontent variable="SUBENCABEZADO_IMP">
						<td align="center" colspan="4"><strong><font size="2">
						<tr class="tituloListas">
							<td ><b>#LB_Identificacion#</b></td>
							<td ><b>#LB_Nombre#</b></td>
							<td align="right" ><b>#LB_Monto#</b></td>
							<td align="center" ><b>#LB_CS#</b></td>
						</tr>
						</cfsavecontent>
					</tr>
					<cfif (isdefined("form.CPperiodo") and len(trim(form.CPperiodo)) and isdefined("form.CPmes") and len(trim(form.CPmes)))> 
						<cfif rsReporte.RecordCount NEQ 0>
							<cfset CPM_ant = 0>
							<cfset CPM_act = 0>
							<cfset CPP_act = 0>
							<cfloop query="rsReporte">
								<cfif CPM_ant NEQ rsReporte.CPmes AND  CPM_ant NEQ 0>
									<tr>
										<td colspan="2"align="right" ><b>#LB_MontoPeriodo#</b></td>
										<td align="right"><strong><font style="font-size:12px; font-family:'Arial'">#LSNumberFormat(MontoCorte,'999,999,999.99')#</font></strong></td>
									</tr>
								<cfelse>
									
								</cfif>
									
								<tr <cfif rsReporte.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
									<cfif CPM_ant NEQ rsReporte.CPmes>
										<tr>
											<td colspan="4" align="center"><b>#LB_Corte# : #rsReporte.CPperiodo# - #rsReporte.CPmes#</b></td>
										</tr>
										#SUBENCABEZADO_IMP#
										<td align="left"> <font style="font-size:11px; font-family:'Arial'">#rsReporte.IDENTI#</font></td>
										<td align="left"> <font style="font-size:11px; font-family:'Arial'">#rsReporte.nombre#</font></td>
										<td align="right"><font style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.Monto,'999,999,999.99')#</font></td>
										<td align="center" class="xl65"> <font style="font-size:11px; font-family:'Arial'">#rsReporte.ClaseG#</font></td>
										<cfset CPM_ant = rsReporte.CPmes>
									<cfelse>
										<td align="left"> <font style="font-size:11px; font-family:'Arial'">#rsReporte.IDENTI#</font></td>
										<td align="left"> <font style="font-size:11px; font-family:'Arial'">#rsReporte.nombre#</font></td>
										<td align="right"><font style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsReporte.Monto,'999,999,999.99')#</font></td>
										<td align="center" class="xl65"> <font style="font-size:11px; font-family:'Arial'">#rsReporte.ClaseG#</font></td>
										<cfset MontoCorte = rsReporte.CorteMes>
									</cfif>
								</tr>
									
							</cfloop>
								<tr>
									<td colspan="2" align="right" ><b>#LB_MontoPeriodo#</b></td>
									<td align="right"><strong><font style="font-size:12px; font-family:'Arial'">#LSNumberFormat(MontoCorte,'999,999,999.99')#</font></strong></td>
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

