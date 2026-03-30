<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>#session.Enombre#</strong></font></td></tr>
	<tr align="center"><td align="center"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><strong>Detalle de Gastos</strong></font></td></tr>
	<cfif isdefined("area")>
		<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Area de Responsabilidad: #area.descripcion#</strong></font></td></tr>	
	</cfif>
	<tr align="center"><td align="center"><font size="3" face="Times New Roman, Times, serif"><strong>Periodo: #form.mes#/#form.Periodo#</strong></font></td></tr>
</table>
</cfoutput>


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
		<td rowspan="2" style="padding-left:20px; border-bottom:1px solid black; border-right:1px solid black; padding-left:50px;" colspan="2" class="tituloListas"><strong>Descripci&oacute;n</strong></td>
		<td colspan="2" align="center" bgcolor="#FAFAFA"  ><strong>Saldos Reales</strong></td>
		<td colspan="2" align="center" bgcolor="#FAFAFA"  ><strong>Presupuesto</strong></td>
		<td colspan="3" align="center" class="tituloListas" >Diferencia</td>
	</tr>
	<tr>
		<!---<td rowspan="2" style="border-bottom:1px solid black; border-right:1px solid black;" colspan="2" style="padding-left:20px;" class="tituloListas">Descripci&oacute;n</td>--->
		<td style="border-bottom:1px solid black;" bgcolor="#FAFAFA"  align="right"><strong>Mensual</strong></td>
		<td style="border-bottom:1px solid black;" bgcolor="#FAFAFA"  align="right"><strong>Acumulado</strong></td>

		<td style="border-bottom:1px solid black;" bgcolor="#FAFAFA"  align="right"><strong>Mensual</strong></td>
		<td style="border-bottom:1px solid black;" bgcolor="#FAFAFA"  align="right"><strong>Acumulado</strong></td>

		<td style="border-bottom:1px solid black;" class="tituloListas" align="right">Mensual</td>
		<td style="border-bottom:1px solid black;" class="tituloListas" align="right">Acumulado</td>
	</tr>

	<cfset tot_monto_mes = 0 >
	<cfset tot_monto_actual = 0 >

	<cfset ptot_monto_mes = 0 >
	<cfset ptot_monto_actual = 0 >

	<cfset dtot_monto_mes = 0 >
	<cfset dtot_monto_actual = 0 >

	<cfoutput query="datos" group="mayor">
		<!---<cfoutput group="grupo">--->
			<cfif datos.currentrow neq 1 >
				<tr>
					<td colspan="2" align="center"  class="linea"><strong>SUB-TOTAL</strong></td>
					<td align="right" class="cuadro"><strong>#LSNumberFormat(monto_mes,',9.00')#</strong></td>
					<td align="right" class="cuadro" ><strong>#LSNumberFormat(monto_actual,',9.00')#</strong></td>

					<td align="right" class="cuadro"><strong>#LSNumberFormat(pmonto_mes,',9.00')#</strong></td>
					<td align="right" class="cuadro" ><strong>#LSNumberFormat(pmonto_actual,',9.00')#</strong></td>

					<td align="right" class="cuadro"><strong>#LSNumberFormat( (monto_mes-pmonto_mes),',9.00')#</strong></td>
					<td align="right" class="cuadro2" ><strong>#LSNumberFormat( (monto_actual-pmonto_actual),',9.00')#</strong></td>
				</tr>
			</cfif> 
			
			<cfset monto_mes = 0 >
			<cfset monto_actual = 0 >
	
			<cfset pmonto_mes = 0 >
			<cfset pmonto_actual = 0 >

			<cfset dmonto_mes = 0 >
			<cfset dmonto_actual = 0 >

			<cfset padding = 40 >
			<cfoutput>
				<tr>
					<td colspan="2" style="border-right:1px solid black; padding-left: #datos.nivel*20#">#datos.descrip#</td>

					<td align="right" style="padding-right: #(datos.nivel)*padding# " class="linea">#LSNumberFormat(datos.movmes,',9.00')#</td>
					<td align="right"  style="padding-right: #(datos.nivel)*padding# " class="linea">#LSNumberFormat(datos.saldofin,',9.00')#</td>

					<td align="right" bgcolor="##f5f5f5" style="padding-right: #(datos.nivel)*padding# " class="linea">#LSNumberFormat(datos.pmensual,',9.00')#</td>
					<td align="right" bgcolor="##f5f5f5" style="padding-right: #(datos.nivel-1)*padding# " class="linea">#LSNumberFormat(datos.pfinal,',9.00')#</td>

					<td align="right" style="padding-right: #(datos.nivel)*padding# " class="linea">#LSNumberFormat( ( datos.movmes-datos.pmensual ) ,',9.00')#</td>
					<td align="right" style="padding-right: #(datos.nivel)*padding# " >#LSNumberFormat( (datos.saldofin-datos.pfinal) ,',9.00')#</td>
				</tr>

			</cfoutput>

			<cfset monto_mes                = monto_mes + datos.movmes>
			<cfset monto_actual             = monto_actual + datos.saldofin>
			
			<cfset pmonto_mes               = pmonto_mes + datos.pmensual>
			<cfset pmonto_actual            = pmonto_actual + datos.pfinal>

			<cfset dmonto_mes               = dmonto_mes + (monto_mes-pmonto_actual) >
			<cfset dmonto_actual            = dmonto_actual + (monto_actual-pmonto_actual) >

			<cfset tot_monto_mes            = tot_monto_mes + datos.movmes>
			<cfset tot_monto_actual         = tot_monto_actual + datos.saldofin>
			
			<cfset ptot_monto_mes           = ptot_monto_mes + datos.pmensual >
			<cfset ptot_monto_actual        = ptot_monto_actual + datos.pfinal>

			<cfset dtot_monto_mes           = dtot_monto_mes + (tot_monto_mes - ptot_monto_mes )>
			<cfset dtot_monto_actual        = dtot_monto_actual + (tot_monto_actual - ptot_monto_actual)>

		<!---</cfoutput>--->
	</cfoutput>
	<!--- Ultimo Total--->
	<cfif isdefined("monto_mes") and isdefined("monto_actual")>
	<cfoutput>
	<tr>
		<td colspan="2" align="center" class="linea"><strong>SUB-TOTAL</strong></td>
		<td align="right" class="cuadro"><strong>#LSNumberFormat(monto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro"><strong>#LSNumberFormat(monto_actual,',9.00')#</strong></td>

		<td align="right" bgcolor="##f5f5f5" class="cuadro"><strong>#LSNumberFormat(pmonto_mes,',9.00')#</strong></td>
		<td align="right" bgcolor="##f5f5f5" class="cuadro"><strong>#LSNumberFormat(pmonto_actual,',9.00')#</strong></td>

		<td align="right" class="cuadro"><strong>#LSNumberFormat(dmonto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro2"><strong>#LSNumberFormat(dmonto_actual,',9.00')#</strong></td>

	</tr>
	</cfoutput>
	</cfif>

	<cfif datos.recordcount gt 0 and isdefined("tot_monto_mes") and isdefined("tot_monto_actual")>
	<cfoutput>
	<tr>
		<td colspan="2" style="border-right:1px solid black;">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  bgcolor="##f5f5f5" class="linea">&nbsp;</td>
		<td  bgcolor="##f5f5f5" class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
		<td  class="linea">&nbsp;</td>
	</tr>	
	<tr>
		<td colspan="2" align="center"  class="linea"><strong>GRAN TOTAL</strong></td>
		<td align="right" class="cuadro3"><strong>#LSNumberFormat(tot_monto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro3"><strong>#LSNumberFormat(tot_monto_actual,',9.00')#</strong></td>

		<td align="right" class="cuadro3" bgcolor="##f5f5f5"><strong>#LSNumberFormat(ptot_monto_mes,',9.00')#</strong></td>
		<td align="right" class="cuadro3" bgcolor="##f5f5f5" ><strong>#LSNumberFormat(ptot_monto_actual,',9.00')#</strong></td>

		<td align="right" class="cuadro3"><strong>#LSNumberFormat(tot_monto_mes-ptot_monto_mes,',9.00')#</strong></td>
		<td align="right" class="lineaArriba"><strong>#LSNumberFormat(tot_monto_actual-ptot_monto_actual,',9.00')#</strong></td>
	</tr>
	</cfoutput>
	</cfif>
</table>

<table width="99%">
	<tr><td align="center">--- Fin del reporte ---</td></tr>
</table>