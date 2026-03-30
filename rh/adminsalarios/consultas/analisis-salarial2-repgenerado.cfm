<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ReporteDeAnalisisSalarial" Default="Reporte de An&aacute;lisis de Dispersi&oacute;n Salarial" returnvariable="LB_ReporteDeAnalisisSalarial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioMenos" Default="Salario - %" returnvariable="LB_SalarioMenos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioMas" Default="Salario + %" returnvariable="LB_SalarioMas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Salario" Default="Salario" returnvariable="LB_Salario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Puntos" Default="Puntos" returnvariable="LB_Puntos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Percentil" Default="Percentil" returnvariable="LB_Percentil" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioReferencia" Default="Salario Referencia" returnvariable="LB_SalarioReferencia" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nivel" Default="Nivel" returnvariable="LB_Nivel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PuntosMinimos" Default="Puntos M&iacute;nimos" returnvariable="LB_PuntosMinimos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PuntosMedios" Default="Puntos Medios" returnvariable="LB_PuntosMedios" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PuntosMaximos" Default="Puntos M&aacute;ximos" returnvariable="LB_PuntosMaximos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Total" Default="Total" returnvariable="LB_Total" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TotalGeneral" Default="Total General" returnvariable="LB_TotalGeneral" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FinDelReporte" Default="Fin del Reporte" returnvariable="LB_FinDelReporte" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioEncuesta" Default="Salario<br>Encuesta" returnvariable="LB_SalarioEncuesta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioEmpresaVrsSalarioEncuesta" Default="Sal. Empresa<br> Vrs<br> Sal. Encuesta" returnvariable="LB_SalarioEmpresaVrsSalarioEncuesta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioEmpresaVrsSalarioPromEscalaHAY" Default="Sal. Empresa<br> Vrs <br>Sal. Med.<br> Escala HAY" returnvariable="LB_SalarioEmpresaVrsSalarioPromEscalaHAY" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioPromedioEmpresa" Default="Sal.<br>Medio<br>Empresa" returnvariable="LB_SalarioPromedioEmpresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Minimo" Default="M&iacute;nimo" returnvariable="LB_Minimo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Medio" Default="Medio" returnvariable="LB_Medio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Maximo" Default="M&aacute;ximo" returnvariable="LB_Maximo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Escala" Default="Escala" returnvariable="LB_Escala" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Salarial" Default="Salarial" returnvariable="LB_Salarial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HAY" Default="HAY" returnvariable="LB_HAY" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>An&aacute;lisis Salarial</title>
</head>

<body>

	<cftransaction>
		<cfset obj = CreateObject("component", "rh.Componentes.RH_AnalisisSalarial")>
		<cfset obj.GenerarTablasDispersion()>
		<cfset obj.GenerarDispersionSalarial(Url.RHASid)>
		<cfset query = obj.ObtenerDetalleDispersion(Url.puntos)>
	</cftransaction>
	<table width="792" cellpadding="2" cellspacing="0" border="0">
		<cfoutput>
			<tr bgcolor="E3EDEF"><td colspan="14">&nbsp;</td></tr>
			<tr bgcolor="E3EDEF">
				<td align="center" colspan="13"><font size="4px" style="color:6188A5;">#session.Enombre#</font></td>
				<td>&nbsp;</td>
			</tr>
			<tr bgcolor="E3EDEF">
				<td align="center" colspan="13"><font size="4px">#LB_ReporteDeAnalisisSalarial#</font></td>
				<td align="right"><font size="2px">#LSDateFormat(Now(),'dd/mm/yyyy')#</font></td>
			</tr>
		</cfoutput>
		<cfsilent>
			<cfset Lvar_SalTotalG = 0>
			<cfset Lvar_PromTotalG = 0>
			<cfset Lvar_EncuTotalG = 0>
			<cfset Lvar_EmpEncuTotalG = 0>
		</cfsilent>
		<cfoutput query="query" group="Nivel">
			<tr bgcolor="E3EDEF" style="font-size:12px;">
				<td align="center" colspan="4">#LB_Nivel#: #query.Nivel#</td>
				<td align="center" colspan="4">#LB_PuntosMinimos#: #query.minimo#</td>
				<td align="center" colspan="3">#LB_PuntosMedios#: #query.PunMedios#</td>
				<td align="center" colspan="3">#LB_PuntosMaximos#: #query.maximo#</td>
			</tr>
		
			<tr bgcolor="E4E4E4" style="font-size:12px;" valign="bottom">
				<td width="50">#LB_Identificacion#</td>
				<td nowrap>#LB_Nombre#</td>
				<td nowrap>#LB_Puesto#</td>
				<td  align="center" nowrap width="30">#LB_Puntos#</td>
				<td align="center" nowrap width="75">#LB_SalarioPromedioEmpresa#</td>
				<td align="center" nowrap width="75"><div align="right" style="font-size:16px">#LB_Escala#</div><br>
					#LB_Minimo#</td>
				<td align="center" nowrap width="75"><div align="center" style="font-size:16px">#LB_Salarial#</div><br>#LB_Medio#</td>
				<td align="center" nowrap width="75"><div align="left" style="font-size:16px">#LB_HAY#</div><br>#LB_Maximo#</td>
				<td align="center" nowrap width="30">#LB_Percentil#</td>
				<td align="center" nowrap width="75">#LB_SalarioEncuesta#</td>
				<td align="center" nowrap width="75">#LB_SalarioEmpresaVrsSalarioPromEscalaHAY#</td>
				<td align="center" nowrap width="30">%<br>#LB_SalarioEmpresaVrsSalarioPromEscalaHAY#</td>
				<td align="center" nowrap width="75">#LB_SalarioEmpresaVrsSalarioEncuesta#</td>
				<td align="center" nowrap width="30">%<br>#LB_SalarioEmpresaVrsSalarioEncuesta#</td>
			</tr>
			<cfsilent>
				<cfset Lvar_SalTotalN = 0>
				<cfset Lvar_PromTotalN = 0>
				<cfset Lvar_EncuTotalN = 0>
				<cfset Lvar_EmpEncuTotalN = 0>
				<cfset Lvar_SalPromHAY = 0>
				<cfset Lvar_EmpEncu = 0>
				<cfset Lvar_EmpHAY = 0>
			</cfsilent>
			<cfoutput>
				<cfset Lvar_EmpEncu = Salario-SalReferencia>
				<cfset Lvar_EmpHAY = Salario-DESsalprom>
				<tr  style="font-size:12px;">
					<td nowrap height="25">#DEidentificacion#</td>
					<td nowrap>#Nombre#</td>
					<td nowrap>#RHPcodigo# &nbsp; #RHPdescpuesto#</td>
					<td align="center" nowrap>#ptsTotal#</td>
					<td align="right" nowrap>#LSCurrencyFormat(Salario,'none')#</td>
					<td align="right" nowrap>#LSCurrencyFormat(DESsalmin,'none')#</td>
					<td align="right" nowrap>#LSCurrencyFormat(DESsalprom,'none')#</td>
					<td align="right" nowrap>#LSCurrencyFormat(DESsalmax,'none')#</td>
					<td align="center" nowrap>#Perceptil#</td>
					<td align="right" nowrap>#LSCurrencyFormat(SalReferencia,'none')#</td>
					<td align="right" nowrap>#LSCurrencyFormat(Lvar_EmpHAY,'none')#</td>
					<td align="right" nowrap>
						<cfif DESsalprom EQ 0>
						-
						<cfelse>
						#LSCurrencyFormat((Lvar_EmpHAY/DESsalprom)*100,'none')#
						</cfif>
					</td>
					<td align="right" nowrap>#LSCurrencyFormat(Lvar_EmpEncu,'none')#</td>
					<td align="right" nowrap>
						<cfif SalReferencia EQ 0>
						-
						<cfelse>
						#LSCurrencyFormat((Lvar_EmpEncu/SalReferencia)*100,'none')#
						</cfif>
					</td>
				</tr>	
				<cfset Lvar_SalTotalN = Lvar_SalTotalN + Salario>
				<cfset Lvar_PromTotalN = Lvar_PromTotalN + DESsalprom>
				<cfset Lvar_EncuTotalN = Lvar_EncuTotalN + SalReferencia>
				<cfset Lvar_EmpEncuTotalN = Lvar_EmpEncuTotalN + Lvar_EmpEncu>
				<cfset Lvar_SalTotalG = Lvar_SalTotalG + Salario>
				<cfset Lvar_PromTotalG = Lvar_PromTotalG + DESsalprom>
				<cfset Lvar_EncuTotalG = Lvar_EncuTotalG + SalReferencia>
				<cfset Lvar_EmpEncuTotalG = Lvar_EmpEncuTotalG + Lvar_EmpEncu>
			</cfoutput>
			<tr style="font-size:12px;">
				<td colspan="4" align="right"><strong>#LB_Total#&nbsp;#query.Nivel#</strong></td>
				<td align="right">#LSCurrencyFormat(Lvar_SalTotalN,'none')#</td>
				<td>&nbsp;</td>
				<td align="right">#LSCurrencyFormat(Lvar_PromTotalN,'none')#</td>
				<td colspan="2">&nbsp;</td>
				<td align="right">#LSCurrencyFormat(Lvar_EncuTotalN,'none')#</td>
				<td align="right">#LSCurrencyFormat(Lvar_SalTotalN-Lvar_PromTotalN,'none')#</td>
				<td align="right">
					<cfif Lvar_PromTotalN EQ 0>
					-
					<cfelse>
					#LSCurrencyFormat(((Lvar_SalTotalN-Lvar_PromTotalN)/Lvar_PromTotalN)*100,'none')#
					</cfif>
				</td>
				<td align="right">#LSCurrencyFormat(Lvar_EmpEncuTotalN,'none')#</td>
				<td align="right">
					<cfif Lvar_EncuTotalN EQ 0>
					-
					<cfelse>
					#LSCurrencyFormat((Lvar_EmpEncuTotalN/Lvar_EncuTotalN)*100,'none')#
					</cfif>
				</td>
			</tr>
			<tr><td colspan="14">&nbsp;</td></tr>
		</cfoutput>
		<cfoutput>
			
			<tr><td colspan="9" height="8"></td></tr>
			<tr style="font-size:12px;">
				<td colspan="4" align="right"><strong>#LB_TotalGeneral#</strong></td>
				<td align="right">#LSCurrencyFormat(Lvar_SalTotalG,'none')#</td>
				<td>&nbsp;</td>
				<td align="right">#LSCurrencyFormat(Lvar_PromTotalG,'none')#</td>
				<td colspan="2">&nbsp;</td>
				<td align="right">#LSCurrencyFormat(Lvar_EncuTotalG,'none')#</td>
				<td align="right">#LSCurrencyFormat(Lvar_SalTotalG-Lvar_PromTotalG,'none')#</td>
				<td align="right">
					<cfif Lvar_PromTotalG EQ 0>
					-
					<cfelse>
					#LSCurrencyFormat(((Lvar_SalTotalG-Lvar_PromTotalG)/Lvar_PromTotalG)*100,'none')#
					</cfif>
				</td>
				<td align="right">#LSCurrencyFormat(Lvar_EmpEncuTotalG,'none')#</td>
				<td align="right">
					<cfif Lvar_EncuTotalG EQ 0>
					-
					<cfelse>
					#LSCurrencyFormat((Lvar_EmpEncuTotalG/Lvar_EncuTotalG)*100,'none')#
					</cfif>
				</td>
			</tr>
			<tr><td colspan="9">&nbsp;</td></tr>
			<tr style="font-size='14px'">
			<td colspan="14" align="center">---------------------------------------------------------------------------#LB_FinDelReporte#---------------------------------------------------------------------------</td></tr>
		</cfoutput>
	</table>

</body>
</html>