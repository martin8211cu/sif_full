<cfinclude template="../common/NRP-form.cfm">
<cfif isdefined("LvarExit")><cfexit></cfif>
  <tr>
    <td align="center">
		<form method="post" action="autorizacionNRP-sql.cfm">
		<input type="hidden" name="CPNRPnum" value="<cfoutput>#Form.CPNRPnum#</cfoutput>">
		<cfif isdefined("LvarTrasladosNRP") and LvarTrasladosNRP>
			<input type="hidden" name="TIPO" value="TRASLADO">
		<cfelse>
			<input type="hidden" name="TIPO" value="APRUEBA">
		</cfif>
		<cfif isdefined("url.lin")>
			<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: history.back();">
		<cfelse>
			<cfif rsEncabezado.CPNAPnum EQ "">
				<cfif isdefined("LvarHayRestrictivos") and LvarHayRestrictivos AND NOT isdefined("LvarTrasladosNRP")>
					<span style="color:#FF0000; font-size:12px; font-weight:bold">
						Existen Cuentas Restrictivas que generan Disponible Neto negativo: se deniega aprobar el NRP
					</span>
					<br><BR>
	</td>
  </tr>
  <tr>
    <td align="center">
				<cfelseif isdefined("rsFinanciamiento") and rsFinanciamiento.recordCount GT 0>
					<span style="color:#FF0000; font-size:12px; font-weight:bold">
						Existen Proyectos que no tienen Financiamiento Presupuestal: se deniega aprobar el NRP
					</span>
					<br><BR>
	</td>
  </tr>
  <tr>
    <td align="center">
				<cfelseif rsNRPmeses.recordcount GT 1>
						<span style="color:#FF0000; font-size:12px; font-weight:bold">
							Existen Rechazos de diferentes meses: se deniega aprobar el NRP
						</span>
						<br><BR>
	</td>
  </tr>
  <tr>
    <td align="center">
				<cfelseif isdefined("LvarTrasladosNRP")>
					<cfif rsExceso.total LTE 0>
						<span style="color:#FF0000; font-size:12px; font-weight:bold">
							<cfoutput>
							No se generaron Excesos (#rsExceso.total#), por tanto, no se requiere Traslado
							</cfoutput>
						</span>
						<br><BR>
					<cfelseif rsTrasladoOri.total-rsExceso.total NEQ 0>
						<span style="color:#FF0000; font-size:12px; font-weight:bold">
							Se encontraron diferencias entre Origenes y Destinos del Traslado. Favor completar Origenes
						</span>
						<br><BR>
					<cfelse>
						<input type="submit" name="btnTraslado" value="Aprobar Traslado">
					</cfif>
				<cfelse>
					<input type="submit" name="btnAprobar" value="Aprobar">
				</cfif>
			</cfif>
			<input type="submit" name="btnRegresar" value="Regresar">
		</cfif>
		</form>
	</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
</table>
