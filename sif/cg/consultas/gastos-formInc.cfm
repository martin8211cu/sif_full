


<style type="text/css" >
	.linea{ border-right:1px solid black; }
	.cuadro{ border-right:1px solid black;
			 border-top:1px solid black;
			 border-bottom:1px solid black; }
	.cuadro2{  border-top:1px solid black;
			 border-bottom:1px solid black; }
	.lineaArriba{  border-top:1px solid black; }
	.cuadro3{ border-right:1px solid black;
			 border-top:1px solid black; }
	
</style>


<table width="99%" align="center" border="0" cellpadding="2" cellspacing="0"  style="border:1px solid black;">
	<tr>
		<td rowspan="2" style="padding-left:20px; border-bottom:1px solid black; border-right:1px solid black; padding-left:50px;" colspan="2" class="tituloListas"><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate></td>
		<td colspan="3" align="center" class="tituloListas" ><cf_translate key=LB_SaldosR>Saldos Reales</cf_translate></td>
		<td colspan="3" align="center" bgcolor="#FAFAFA"  ><strong><cf_translate key=LB_Presupuesto>Presupuesto</cf_translate></strong></td>
		<td colspan="3" align="center" class="tituloListas" ><cf_translate key=LB_Diferencia>Diferencia</cf_translate></td>

	</tr>
	<tr>
		<!---<td rowspan="2" style="border-bottom:1px solid black; border-right:1px solid black;" colspan="2" style="padding-left:20px;" class="tituloListas">Descripci&oacute;n</td>--->
		<td style="border-bottom:1px solid black;" class="tituloListas" align="right"><cf_translate key=LB_Anterior>Anterior</cf_translate></td>
		<td style="border-bottom:1px solid black;" class="tituloListas" align="right"><cf_translate key=LB_Corriente>Corriente</cf_translate></td>
		<td style="border-bottom:1px solid black;" class="tituloListas" align="right">Total</td>

		<td style="border-bottom:1px solid black;" bgcolor="#FAFAFA"  align="right"><strong><cf_translate key=LB_Anterior>Anterior</cf_translate></strong></td>
		<td style="border-bottom:1px solid black;" bgcolor="#FAFAFA"  align="right"><strong><cf_translate key=LB_Corriente>Corriente</cf_translate></strong></td>
		<td style="border-bottom:1px solid black;" bgcolor="#FAFAFA"  align="right"><strong>Total</strong></td>

		<td style="border-bottom:1px solid black;" class="tituloListas" align="right"><cf_translate key=LB_Anterior>Anterior</cf_translate></td>
		<td style="border-bottom:1px solid black;" class="tituloListas" align="right"><cf_translate key=LB_Corriente>Corriente</cf_translate></td>
		<td style="border-bottom:1px solid black;" class="tituloListas" align="right">Total</td>

	</tr>

	<cfset tot_acumulado_anterior = 0 >
	<cfset tot_monto_mes = 0 >
	<cfset tot_monto_actual = 0 >

	<cfset ptot_acumulado_anterior = 0 >
	<cfset ptot_monto_mes = 0 >
	<cfset ptot_monto_actual = 0 >

	<cfset dtot_acumulado_anterior = 0 >
	<cfset dtot_monto_mes = 0 >
	<cfset dtot_monto_actual = 0 >

	<cfoutput query="datos" group="PCEcodigo">
		<cfoutput group="grupo">
			<cfif datos.currentrow neq 1 >
				<tr>
					<td colspan="2" align="center"  class="linea"><strong>SUB-TOTAL</strong></td>
					<td align="right"  class="cuadro"><strong>#LSNumberFormat(acumulado_anterior,',9.00')#</strong></td>
					<td align="right" class="cuadro"><strong>#LSNumberFormat(monto_mes,',9.00')#</strong></td>
					<td align="right" class="cuadro" ><strong>#LSNumberFormat(monto_actual,',9.00')#</strong></td>


					<td align="right"  class="cuadro"><strong>#LSNumberFormat(pacumulado_anterior,',9.00')#</strong></td>
					<td align="right" class="cuadro"><strong>#LSNumberFormat(pmonto_mes,',9.00')#</strong></td>
					<td align="right" class="cuadro" ><strong>#LSNumberFormat(pmonto_actual,',9.00')#</strong></td>

					<td align="right"  class="cuadro"><strong>#LSNumberFormat(dacumulado_anterior,',9.00')#</strong></td>
					<td align="right" class="cuadro"><strong>#LSNumberFormat(dmonto_mes,',9.00')#</strong></td>
					<td align="right" class="cuadro2" ><strong>#LSNumberFormat(dmonto_actual,',9.00')#</strong></td>

				</tr>
			</cfif> 
			
			<cfset acumulado_anterior = 0 >
			<cfset monto_mes = 0 >
			<cfset monto_actual = 0 >
	
			<cfset pacumulado_anterior = 0 >
			<cfset pmonto_mes = 0 >
			<cfset pmonto_actual = 0 >

			<cfset dacumulado_anterior = 0 >
			<cfset dmonto_mes = 0 >
			<cfset dmonto_actual = 0 >

			<tr>
				<td colspan="2" style="border-right:1px solid black;" bgcolor="##FAFAFA" nowrap="nowrap"><strong>#datos.grupo# #datos.descripgrupo#</strong></td>
				<td  class="linea">&nbsp;</td>
				<td  class="linea">&nbsp;</td>
				<td  class="linea">&nbsp;</td>
				<td  class="linea">&nbsp;</td>
				<td  class="linea">&nbsp;</td>
				<td  class="linea">&nbsp;</td>
				<td  class="linea">&nbsp;</td>
				<td  class="linea">&nbsp;</td>

			</tr>
			<cfoutput>
				<tr>
					<td style="padding-left:20px;" >#datos.rubro#</td>
					<td style="border-right:1px solid black;">#datos.descriprubro#</td>
					<td align="right" class="linea">#LSNumberFormat(datos.MontoAcumAnterior,',9.00')#</td>
					<td align="right" class="linea">#LSNumberFormat(datos.MontoMes,',9.00')#</td>
					<td align="right" class="linea">#LSNumberFormat(datos.MontoActual,',9.00')#</td>


					<td align="right" class="linea">#LSNumberFormat(datos.PresInicial,',9.00')#</td>
					<td align="right" class="linea">#LSNumberFormat(datos.PresMes,',9.00')#</td>
					<td align="right" class="linea">#LSNumberFormat(datos.PresFinal,',9.00')#</td>

					<td align="right" class="linea">#LSNumberFormat(datos.DifInicial,',9.00')#</td>
					<td align="right" class="linea">#LSNumberFormat(datos.DifMes,',9.00')#</td>
					<td align="right" >#LSNumberFormat(datos.DifFinal,',9.00')#</td>

				</tr>
				<cfset acumulado_anterior       = acumulado_anterior + datos.MontoAcumAnterior >
				<cfset monto_mes                = monto_mes + datos.MontoMes>
				<cfset monto_actual             = monto_actual + datos.MontoActual>
				
				<cfset pacumulado_anterior      = pacumulado_anterior + datos.PresInicial >
				<cfset pmonto_mes               = pmonto_mes + datos.PresMes>
				<cfset pmonto_actual            = pmonto_actual + datos.PresFinal>

				<cfset dacumulado_anterior      = dacumulado_anterior + datos.DifInicial >
				<cfset dmonto_mes               = dmonto_mes + datos.DifMes>
				<cfset dmonto_actual            = dmonto_actual + datos.DifFinal>

				<cfset tot_acumulado_anterior   = tot_acumulado_anterior + datos.MontoAcumAnterior >
				<cfset tot_monto_mes            = tot_monto_mes + datos.MontoMes>
				<cfset tot_monto_actual         = tot_monto_actual + datos.MontoActual>
				
				<cfset ptot_acumulado_anterior  = ptot_acumulado_anterior + datos.PresInicial >
				<cfset ptot_monto_mes           = ptot_monto_mes + datos.PresMes>
				<cfset ptot_monto_actual        = ptot_monto_actual + datos.PresFinal>

				<cfset dtot_acumulado_anterior  = dtot_acumulado_anterior + datos.DifInicial >
				<cfset dtot_monto_mes           = dtot_monto_mes + datos.DifMes>
				<cfset dtot_monto_actual        = dtot_monto_actual + datos.DifFinal>

			</cfoutput>
		</cfoutput>
	</cfoutput>
	<!--- Ultimo Total--->
	<cfif isdefined("acumulado_anterior") and isdefined("monto_mes") and isdefined("monto_actual")>
	<cfoutput>
	<tr>
		<td colspan="2" align="center" class="linea"><strong>SUB-TOTAL</strong></td>
		<td align="right" class="cuadro"><strong>#LSNumberFormat(acumulado_anterior,',9.00')#</strong></td>
		<td align="right" class="cuadro"><strong>#LSNumberFormat(monto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro"><strong>#LSNumberFormat(monto_actual,',9.00')#</strong></td>

		<td align="right" class="cuadro"><strong>#LSNumberFormat(pacumulado_anterior,',9.00')#</strong></td>
		<td align="right" class="cuadro"><strong>#LSNumberFormat(pmonto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro"><strong>#LSNumberFormat(pmonto_actual,',9.00')#</strong></td>

		<td align="right" class="cuadro"><strong>#LSNumberFormat(dacumulado_anterior,',9.00')#</strong></td>
		<td align="right" class="cuadro"><strong>#LSNumberFormat(dmonto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro2"><strong>#LSNumberFormat(dmonto_actual,',9.00')#</strong></td>

	</tr>
	</cfoutput>
	</cfif>

	<cfif datos.recordcount gt 0 and isdefined("tot_acumulado_anterior") and isdefined("tot_monto_mes") and isdefined("tot_monto_actual")>
	<cfoutput>
	<tr>
		<td colspan="2" style="border-right:1px solid black;">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>

	</tr>	
	<tr>
		<td colspan="2" align="center"  class="linea"><strong>GRAN TOTAL</strong></td>
		<td align="right" class="cuadro3"><strong>#LSNumberFormat(tot_acumulado_anterior,',9.00')#</strong></td>
		<td align="right" class="cuadro3"><strong>#LSNumberFormat(tot_monto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro3"><strong>#LSNumberFormat(tot_monto_actual,',9.00')#</strong></td>

		<td align="right" class="cuadro3"><strong>#LSNumberFormat(ptot_acumulado_anterior,',9.00')#</strong></td>
		<td align="right" class="cuadro3"><strong>#LSNumberFormat(ptot_monto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro3"><strong>#LSNumberFormat(ptot_monto_actual,',9.00')#</strong></td>

		<td align="right" class="cuadro3"><strong>#LSNumberFormat(dtot_acumulado_anterior,',9.00')#</strong></td>
		<td align="right" class="cuadro3"><strong>#LSNumberFormat(dtot_monto_mes,',9.00')#</strong></td>
		<td align="right" class="lineaArriba"><strong>#LSNumberFormat(dtot_monto_actual,',9.00')#</strong></td>
	</tr>
	</cfoutput>
	</cfif>
</table>

<!--- borra la tabla temporal --->
<cfquery datasource="#session.dsn#">
	delete from #reporte#
</cfquery>

<table width="99%">
	<tr><td align="center">--- <cf_translate key =LB_FinReporte>Fin del reporte</cf_translate> ---</td></tr>
</table>
