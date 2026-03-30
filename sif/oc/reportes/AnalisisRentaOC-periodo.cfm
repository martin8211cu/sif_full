<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfquery name="rsPeriodos" datasource="#session.dsn#">
	select distinct Speriodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Speriodo
</cfquery>
<cfquery name="rsMeses" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="vi.VSvalor"> as Valor, vi.VSdesc as Meses
	from Idiomas i
		inner join VSidioma vi
		on vi.Iid = i.Iid
		and vi.VSgrupo = 1
	where i.Icodigo = '#session.Idioma#'
	order by 1
</cfquery>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">

			<form name="form1" action="AnalisisRentaOC-sql.cfm" method="post">
				<input type="hidden" name="Reporte" value="Periodo">
				<table border="0" align="center" cellpadding="0" cellspacing="3" style="width:100%">
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td align="right" style="width:48%"><strong>Periodo:</strong></td>
						<td align="left">
							<select name="Periodo" id="Perido">
								<cfoutput query="rsPeriodos">
									<option value="#Speriodo#">#Speriodo#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Mes:</strong></td>
						<td nowrap align="left">
							<select name="Mes" id="Mes">
								<cfoutput query="rsMeses">
									<option value="#Valor#">#Meses#</option>
								</cfoutput>
							</select>
						</td>
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
						<td colspan="2" align="Center">(*) El periodo y mes corresponden con el mes de contabilización del documento</td>
					</tr>
				</table>
			</form>
		<cf_web_portlet_end>
<cf_templatefooter>

