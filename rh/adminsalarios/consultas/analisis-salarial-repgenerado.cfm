<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ReporteDeAnalisisSalarial" Default="Reporte de An&aacute;lisis Salarial" returnvariable="LB_ReporteDeAnalisisSalarial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CentroFuncional" Default="Centro Funcional" returnvariable="LB_CentroFuncional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TipoDePago" Default="Tipo de Pago" returnvariable="LB_TipoDePago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Cedula" Default="C&eacute;dula" returnvariable="LB_Cedula" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Depto" Default="Departamento" returnvariable="LB_Depto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Puesto" Default="Puesto" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioPeriodo" Default="Salario Per&iacute;odo" returnvariable="LB_SalarioPeriodo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Salario" Default="Salario" returnvariable="LB_Salario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CodEncuesta" Default="Cod. Encuesta" returnvariable="LB_CodEncuesta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Percentil" Default="Percentil" returnvariable="LB_Percentil" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_SalarioMerc" Default="Salario Merc" returnvariable="LB_SalarioMerc" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_AnalisisSalarial" Default="An&aacute;lisis Salarial" returnvariable="LB_AnalisisSalarial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Diferencia" Default="Diferencia" returnvariable="LB_Diferencia" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><cfoutput>#LB_AnalisisSalarial#</cfoutput></title>
</head>

<body>

<cfif isdefined("url.RHASid") and Len(Trim(url.RHASid)) and isdefined("url.Formato") and Len(Trim(url.Formato))>
	<cftransaction>
		<cfset obj = CreateObject("component", "rh.Componentes.RH_AnalisisSalarial")>
		<cfset query = obj.GenerarAnalisisSalarial(url.RHASid, false)>
	</cftransaction>
	<cfif url.Formato EQ 'HTML'>
	
		<cf_htmlreportsheaders
			title="#LB_ReporteDeAnalisisSalarial#" 
			filename="ReporteAnalisisSalarial#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
			back="no" irA="" download="no">
			<!--- <cfdump var="#query#"> --->
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<cfoutput>
				<tr bgcolor="E3EDEF"><td colspan="11">&nbsp;</td></tr>
				<tr bgcolor="E3EDEF">
					<td align="center" colspan="11"><font size="4px" style="color:6188A5;">#session.Enombre#</font></td>
				</tr>
				<tr bgcolor="E3EDEF">
					<td width="85%" align="center" colspan="8"><font size="4px">#LB_ReporteDeAnalisisSalarial#</font></td>
					<td width="15%" align="right" colspan="3"><font size="2px">#LSDateFormat(Now(),'dd/mm/yyyy')#</font></td>
				</tr>
			</cfoutput>
			<cfoutput query="query" group="CFcodigo">
				<tr bgcolor="F7F7F7">
					<font size="4px">
					<td width="50%" colspan="5">#LB_CentroFuncional#:&nbsp; #CFcodigo# - #CFdescripcion#</td>
					<td width="50%" colspan="6">#LB_TipoDePago#:&nbsp;#TipoPago#</td>
					</font>
				</tr>
				<tr bgcolor="E3EDEF" style="font-size='14px'">
					<td width="10%">#LB_Cedula#</td>
					<td width="20%" nowrap>#LB_Nombre#</td>
					<td width="10%" nowrap>#LB_Depto#</td>
					<td width="11%" nowrap>#LB_Puesto#</td>
					<td width="10%" align="right" nowrap>#LB_SalarioPeriodo#</td>
					<td width="10%" align="right" nowrap>#LB_Salario#</td>
					<td width="8%" nowrap>#LB_CodEncuesta#</td>
					<td width="8%" align="center" nowrap>#LB_Percentil#</td>
					<td width="10%" align="right" nowrap>#LB_SalarioMerc#</td>
					<td width="10%" align="right" nowrap>#LB_Diferencia#</td>
					<td width="10%" align="right" nowrap>%</td>
				</tr>
			<cfoutput>
					<tr  style="font-size='14px'">
						<font size="2px">
						<td nowrap height="25">#DEidentificacion#</td>
						<td nowrap>#Nombre#</td>
						<td nowrap>#Ddescripcion#</td>
						<td nowrap>#RHPdescPuesto#</td>
						<td align="right" nowrap>#LSCurrencyFormat(SalPeriodo,'none')#</td>
						<td align="right" nowrap>#LSCurrencyFormat(SalMensual,'none')#</td>
						<td align="center" nowrap>#EPcodigo#</td>
						<td align="center" nowrap>#Perceptil#</td>
						<td align="right" nowrap>#LSCurrencyFormat(SalReferencia,'none')#</td>
						<td align="right" nowrap>#LSCurrencyFormat(SalMensual-SalReferencia,'none')#</td>
						<td align="right" nowrap>
							<cfif SalReferencia EQ 0><cfset Lvar_SalReferencia = 1><cfelse><cfset Lvar_SalReferencia = SalReferencia></cfif>
							#LSCurrencyFormat((SalMensual/Lvar_SalReferencia)*100,'none')#</td>
						</font>
					</tr>	
				</cfoutput>
				<tr><td colspan="9">&nbsp;</td></tr>
			</cfoutput>
		</table>
		
	<cfelse>
		<cfreport format="#url.Formato#" template= "analisis-salarial.cfr" query="#query#">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="Edescripcion" value="#session.Enombre#">
		</cfreport>
	</cfif>
<cfelse>
	<p align="center">
		<strong>Par&aacute;metros Inv&aacute;lidos</strong>
	</p>
</cfif>

</body>
</html>