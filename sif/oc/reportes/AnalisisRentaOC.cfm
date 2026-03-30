<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">

			<form name="form1" action="AnalisisRentaOC-sql.cfm" method="post">
				<table border="0" align="center" cellpadding="0" cellspacing="3" style="width:100%">
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Inicial:</strong></td>
						<td align="left"><cf_sifcalendario name="FechaIni" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Final:</strong></td>
						<td nowrap align="left"><cf_sifcalendario name="FechaFin" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="center"><input name="BtnGenerar" value="Generar Reporte" type="submit"></td>
					</tr>
					<tr>
						<td colspan="2" align="center">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="center">(*) El rango de fechas se compara con la fecha de Cambio de Propiedad del documento</td>
					</tr>


				</table>
			</form>
		<cf_web_portlet_end>
<cf_templatefooter>

