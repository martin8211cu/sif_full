<cfquery name="data" datasource="sifcontrol">
	select HYTAptshab, HYTAporcentaje, HYTApts , HYTASrestrict
	from HYTASolucionProblemas
	order by HYTAporcentaje desc, HYTAptshab
</cfquery>

<cfquery name="rsPct" dbtype="query">
	select distinct HYTAporcentaje
	from data
	order by HYTAporcentaje desc
</cfquery>

<cfquery name="rsPts" dbtype="query">
	select distinct HYTAptshab
	from data
	order by HYTAptshab
</cfquery>

<cfoutput>
<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">

<table width="100%" border="0" align="center">
	<tr>
		<td align="center">
			<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
				<cf_translate key="LB_CuadroAuxiliarParaLaSolucionDeProblemas">Cuadro Auxiliar para la Soluci&oacute;n de Problemas</cf_translate>
			</strong>
		</td>
	</tr>
</table><br>


<table width="100%" border="1" style="border-collapse:collapse;" cellpadding="0" cellspacing="0">

	<tr>
		<td colspan="2">&nbsp;</td>
		<td valign="top" colspan="#rsPts.RecordCount#" align="center"><b><cf_translate key="LB_Habilidades">Habilidades</cf_translate></b></td>
	</tr>

<!---
	<tr>
		<td colspan="2" align="center" valign="bottom" nowrap><table width="100%" border="1" style="border-collapse:collapse;" cellpadding="0" cellspacing="0"><tr><td><b>* El pensamiento est&aacute; guiado o circunscrito por:</b></td></tr></table></td>
		<cfloop query="complejidad">
			<td valign="top">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td nowrap><b>#complejidad.HYCPgrado#. #complejidad.HYCPdescripcion#</b></td></tr>
					<tr><td>#complejidad.HYCPdescalterna#</td></tr>
				</table>
			</td>
		</cfloop>
	</tr>
--->		

	<tr>
		<td colspan="2"></td>
		<cfloop query="rsPts">
			<td align="right"><b>#rsPts.HYTAptshab#</b></td>
		</cfloop>
	</tr>

	<cfloop query="rsPct">
		<cfset vPct = rsPct.HYTAporcentaje >
<!---
		<cfset vHPuntos = data.HYTAptshab >
		<cfset vPts = data.HYTApts >--->
		
		<cfset titulo = false>

		<tr>
			<cfif rsPct.CurrentRow eq 1 and not titulo >
				<td width="1%" valign="middle"   style="text-align: center; writing-mode:tb-rl;" rowspan="#rsPct.RecordCount#" nowrap>
					<b>* <cf_translate key="LB_SolucionDeProblemas">Soluci&oacute;n de Problemas</cf_translate></b>
				</td>
				<cfset  titulo = true >
			</cfif>
			
			<td align="center"><b>#rsPct.HYTAporcentaje#%</b></td>
			
			<cfquery name="data_1" dbtype="query">
				select HYTAptshab, HYTAporcentaje, HYTApts , HYTASrestrict
				from data
				where HYTAporcentaje = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPct.HYTAporcentaje#">
				order by HYTApts
			</cfquery>
						
			<cfloop query="data_1">
				<cfset vHPuntos = data_1.HYTAptshab >
				
				<cfif data_1.HYTASrestrict EQ 1>
					<!--- <td align="right" bgcolor="##CCCCCC" id="#vPct#_#vHPuntos#" class="<cfif rsPct.CurrentRow mod 2 neq 0>listaPar<cfelse>listaNon</cfif>" >#data_1.HYTApts#</td> --->
					<td align="right" bgcolor="##CCCCCC" id="#vPct#_#vHPuntos#">#data_1.HYTApts#</td>
				<cfelse>
					<!--- <td align="right" id="#vPct#_#vHPuntos#" class="<cfif rsPct.CurrentRow mod 2 neq 0>listaPar<cfelse>listaNon</cfif>" >#data_1.HYTApts#</td>--->
					<td align="right" id="#vPct#_#vHPuntos#">#data_1.HYTApts#</td>
				</cfif>
			</cfloop>
			
		</tr>			
		
	</cfloop>
</table>
</cfoutput>