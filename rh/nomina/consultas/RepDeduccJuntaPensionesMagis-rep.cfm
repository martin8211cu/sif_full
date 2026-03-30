<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default="C&eacute;dula" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido" Default="Apellido" returnvariable="LB_Apellido"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Regimen" Default="Regimen" returnvariable="LB_Regimen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Salario" Default="Salario" returnvariable="LB_Salario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Patrono" Default="Patrono" returnvariable="LB_Patrono"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Gastos" Default="Gastos" returnvariable="LB_Gastos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Total" Default="Total" returnvariable="LB_Total"/>

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
	
	<cfset LvarFileName = "DeduccionesJuntaPensionesMagisterio#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
			<td align="center">
			<cf_htmlReportsHeaders 
				title= "#LB_ReporteDeDeduccionesMagisterio#"
				filename="#LvarFileName#"
				irA="RepDeduccJuntaPensionesMagis-filtro.cfm">
					
				<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
					<tr>	
						<cfsavecontent variable="ENCABEZADO_IMP">
						<td align="center" colspan="10"><strong><font size="2">
						<cf_EncReporte
							Titulo="#LB_ReporteDeDeduccionesMagisterio#"							
						>
						<tr class="tituloListas">
							<td><b>#LB_Identificacion#</b></td>							
							<td><b>#LB_Apellido#</b></td>
							<td><b>#LB_Apellido#</b></td>
							<td><b>#LB_Nombre#</b></td>
							<td><b>#LB_Regimen#</b></td>
							<td><b>#LB_Salario#</b></td>
							<td><b>#LB_Empleado#</b></td>
						    <cfif not isdefined("form.muestraResum")>
								<td><b>#LB_Patrono#</b></td>
								<td><b>#LB_Gastos#</b></td>
								<td><b>#LB_Total#</b></td>		
							</cfif>					
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
										<td><font  style="font-size:11px; font-family:'Arial'">#rsDeducciones.RVcodigo#</font></td>
	                                    <td align="left"><font  style="font-size:11px; font-family:'Arial'"> #LSNumberFormat(rsDeducciones.SEsalariobruto,'999,999,999.99')#</font></td>
										  <td align="left"><font  style="font-size:11px; font-family:'Arial'"> #LSNumberFormat(rsDeducciones.CCvaloremp,'999,999,999.99')#</font></td>
									<cfif not isdefined("form.muestraResum")>	  
										 <td align="left"><font  style="font-size:11px; font-family:'Arial'"> #LSNumberFormat(rsDeducciones.CCvalorpat,'999,999,999.99')#</font></td>
										<cfset Gasto= (rsDeducciones.SEsalariobruto * 0.001) + (rsDeducciones.SEsalariobruto * 0.004) >
										<cfset Totalinea= (rsDeducciones.CCvaloremp + rsDeducciones.CCvalorpat + Gasto ) >
										 <td align="left"><font  style="font-size:11px; font-family:'Arial'"> #LSNumberFormat(Gasto,'999,999,999.99')#</font></td>
										  <td align="left"><font  style="font-size:11px; font-family:'Arial'"> #LSNumberFormat(Totalinea,'999,999,999.99')#</font></td>
									</cfif>  
										<cfset actual = rsDeducciones.DEidentificacion>
									<cfelse>									
										<cfset actual = rsDeducciones.DEidentificacion>
									</cfif>								
								</tr>
							</cfloop>							
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

