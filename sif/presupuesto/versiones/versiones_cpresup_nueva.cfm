<cfquery name="rsCVMayor" datasource="#session.dsn#">
	select CVMtipoControl ,CVMcalculoControl
	  from CVMayor
	where Ecodigo = #session.ecodigo#
		and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
		and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
</cfquery>
<cfquery name="qry_cv" datasource="#Session.dsn#">
	select v.Ecodigo, v.CVid, v.CVtipo, v.CVdescripcion, v.CPPid, v.CVaprobada, m.PCEMformatoP, v.ts_rversion
	from CVersion v
		inner join CPresupuestoPeriodo p
			 on p.Ecodigo 	= v.Ecodigo
			and p.CPPid		= v.CPPid
		inner join CPVigencia vg
			 on vg.Ecodigo 	= v.Ecodigo
			and vg.Cmayor	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
			and p.CPPanoMesDesde between vg.CPVdesdeAnoMes and vg.CPVhastaAnoMes
		inner join PCEMascaras m
			 on m.PCEMid 	= vg.PCEMid
	where v.Ecodigo = #session.ecodigo#
	  and v.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
</cfquery>
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr><td >&nbsp;</td></tr>
	<tr><td class="subTitulo" align="center"><cfoutput>Agregar una Nueva Cuenta de Presupuesto</cfoutput></td></tr>
  <tr><td >&nbsp;</td></tr>
	<tr>
		<td>
			<form name="form1" action="versiones_sql.cfm" method="post">
			<cfoutput>
				<input type="hidden" name="CPPid" 	value="#qry_cv.CPPid#">
				<input type="hidden" name="Cmayor" 	value="#form.Cmayor#">
			</cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfinclude template="versiones_header.cfm">
				<tr>
					<td>
						<strong>Cuenta de Mayor:</strong>
					</td>
					<td>
						<cfoutput>#form.Cmayor#</cfoutput>
					</td>
				</tr>
				<tr>
					<td>&nbsp;
						
					</td>
				</tr>
				<tr>
					<td nowrap>
						<strong>Formato de Presupuesto:</strong>&nbsp;&nbsp;&nbsp;
					</td>
					<td>
						<strong><cfoutput>#qry_cv.PCEMformatoP#</cfoutput></strong>
					</td>
				</tr>
				<tr>
					<td>
						<strong>Detalle de la Cuenta:</strong>
					</td>
					<td>
						<cf_CuentaPresupuesto name="CPdetalle" Cmayor="#form.Cmayor#">
					</td>
				</tr>
				<tr>
					<td>
						<strong>Descripcion de la Cuenta:</strong>
					</td>
					<td>
						<input type="text" name="CPdescripcion" size="40" maxlength="40">
					</td>
				</tr>
				<tr>
					<td>
						<strong>Tipo de Control:</strong>
					</td>
					<td>
						<select name="CVPtipoControl">
							<option value="0" <cfif rsCVMayor.CVMtipoControl EQ 0>selected</cfif>>Abierto</option>
							<option value="1" <cfif rsCVMayor.CVMtipoControl EQ 1>selected</cfif>>Restringido</option>
							<option value="2" <cfif rsCVMayor.CVMtipoControl EQ 2>selected</cfif>>Restrictivo</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<strong>Método Cálculo de Control:</strong>
					</td>
					<td>
						<select name="CVPcalculoControl">
							<option value="1" <cfif rsCVMayor.CVMcalculoControl EQ 1>selected</cfif>>Mensual</option>
							<option value="2" <cfif rsCVMayor.CVMcalculoControl EQ 2>selected</cfif>>Acumulado</option>
							<option value="3" <cfif rsCVMayor.CVMcalculoControl EQ 3>selected</cfif>>Total</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left">
						<input type="submit" name="btnAgregarCta" value="Agregar">
					</td>
				</tr>
			</table>
			</form>
		</td>
	</tr>
</table>