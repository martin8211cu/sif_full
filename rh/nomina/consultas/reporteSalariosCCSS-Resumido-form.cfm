<cfsetting requesttimeout="36000">

<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("url.GrupoPlanilla") and not isdefined("form.GrupoPlanilla")>
	<cfset form.GrupoPlanilla = url.GrupoPlanilla >
</cfif>
<cfif isdefined("url.masivo") and not isdefined("form.masivo")>
	<cfset form.masivo = url.masivo >
</cfif>

<cfset meses = ''>

<cfif form.mes EQ 1>
	<cfset meses = 'Enero'>
<cfelseif form.mes EQ 2>
	<cfset meses = 'Febrero'>
<cfelseif form.mes EQ 3>
	<cfset meses = 'Marzo'>
<cfelseif form.mes EQ 4>
	<cfset meses = 'Abril'>
<cfelseif form.mes EQ 5>
	<cfset meses = 'Mayo'>
<cfelseif form.mes EQ 6>
	<cfset meses = 'Junio'>
<cfelseif form.mes EQ 7>
	<cfset meses = 'Julio'>
<cfelseif form.mes EQ 8>
	<cfset meses = 'Agosto'>
<cfelseif form.mes EQ 9>
	<cfset meses = 'Septiembre'>
<cfelseif form.mes EQ 10>
	<cfset meses = 'Octubre'>
<cfelseif form.mes EQ 11>
	<cfset meses = 'Noviembre'>
<cfelseif form.mes EQ 12>
	<cfset meses = 'Diciembre'>
</cfif>

<!--- Se incluye el archivo reporteSalariosCCSS-Query.cfm para el pintado --->
<cfinclude template="reporteSalariosCCSS-Query.cfm">

<cfif rsResultado.recordCount GT 0 >
	<!--- <cf_sifHTML2Word> --->
	<cfoutput>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="3" align="center" ><strong><font size="3">#Session.Enombre#</font></strong></td></tr>
		<tr><td nowrap colspan="3">&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><strong><font size="3">Reporte del Detalle de Salarios</font></strong></td></tr>
		<tr><td colspan="3" align="center"><font size="2"><strong>Fecha:&nbsp;</strong>#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;<strong>Hora:&nbsp;</strong>#TimeFormat(now(),'medium')#</font></td></tr>
		<tr><td colspan="3" align="center"><font size="2"><strong>Periodo:&nbsp;</strong>#form.periodo#&nbsp;<strong> - Mes:&nbsp;</strong>#meses#</font></td></tr>
		<tr><td colspan="3" nowrap>&nbsp;</td></tr>
		<tr><td colspan="3" nowrap><hr></td></tr>
	</table>
	</cfoutput>
	
	<table width="99%" cellpadding="2" cellspacing="0" align="center">
		<tr>
			<td class="tituloListas" nowrap>No. Patronal</td>
			<td class="tituloListas" align="right" nowrap >Total Orden Patronal Actual</td>
			<td class="tituloListas" align="right" nowrap >Total Orden Patronal Anterior</td>
			<td class="tituloListas" align="right" nowrap >Total General Actual</td>
			<td class="tituloListas" align="right" nowrap >Total General Anterior</td>
			<td class="tituloListas" align="right" nowrap >Total con Cambio</td>
			<td class="tituloListas" align="right" nowrap >Total sin Cambio</td>
			<td class="tituloListas" align="right" nowrap >No. Empleados</td>
		</tr>
	
		<cfset totalPatronalActual = 0 >
		<cfset totalPatronalAnterior = 0 >
		<cfset totalGeneralActual = 0 >
		<cfset totalGeneralAnterior = 0 >
		<cfset totalConCambio = 0 >
		<cfset totalSinCambio = 0 >
		<cfset totalEmpleados = 0 >
	
		<cfoutput query="rsResultado">
			<cfset totalPatronalActual 	 = totalPatronalActual + rsResultado.PatAct>
			<cfset totalPatronalAnterior = totalPatronalAnterior + rsResultado.PatAnt>
			<cfset totalGeneralActual 	 = totalGeneralActual + rsResultado.GenAct>
			<cfset totalGeneralAnterior  = totalGeneralAnterior + rsResultado.GenAnt>
			<cfset totalConCambio 		 = totalConCambio + rsResultado.TotCamb>
			<cfset totalSinCambio 		 = totalSinCambio + rsResultado.TotSCamb>
			<cfset totalEmpleados 		 = totalEmpleados + rsResultado.TotEmp>
	
			<tr>
				<td nowrap >#rsResultado.Patron#</td>
				<td align="right" nowrap >#LSNumberFormat(rsResultado.PatAct,',9.00')#</td>
				<td align="right" nowrap >#LSNumberFormat(rsResultado.PatAnt,',9.00')#</td>
				<td align="right" nowrap >#LSNumberFormat(rsResultado.GenAct,',9.00')#</td>
				<td align="right" nowrap >#LSNumberFormat(rsResultado.GenAnt,',9.00')#</td>
				<td align="right" nowrap >#LSNumberFormat(rsResultado.TotCamb,',9.00')#</td>
				<td align="right" nowrap >#LSNumberFormat(rsResultado.TotSCamb,',9.00')#</td>
				<td align="right" nowrap >#rsResultado.TotEmp#</td>
			</tr>
		</cfoutput>
		<cfoutput>
		<tr>
			<td class="tituloListas" nowrap>Totales</td>
			<td class="tituloListas" align="right" nowrap >#LSNumberFormat(totalPatronalActual,',9.00')#</td>
			<td class="tituloListas" align="right" nowrap >#LSNumberFormat(totalPatronalAnterior,',9.00')#</td>
			<td class="tituloListas" align="right" nowrap >#LSNumberFormat(totalGeneralActual,',9.00')#</td>
			<td class="tituloListas" align="right" nowrap >#LSNumberFormat(totalGeneralAnterior,',9.00')#</td>
			<td class="tituloListas" align="right" nowrap >#LSNumberFormat(totalConCambio,',9.00')#</td>
			<td class="tituloListas" align="right" nowrap >#LSNumberFormat(totalSinCambio,',9.00')#</td>
			<td class="tituloListas" align="right" nowrap >#totalEmpleados#</td>
		</tr>
		</cfoutput>
		<tr><td colspan="8" nowrap><hr></td></tr>
	</table>
	<!--- </cf_sifHTML2Word> --->
<cfelse>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="3" align="center" >
				<strong><font size="3">La consulta no gener&oacute; ning&uacute;n registro.</font></strong>
			</td>
		</tr>
		<tr><td colspan="3" align="center" >&nbsp;</td></tr>
	</table>
</cfif>
