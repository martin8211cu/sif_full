<cfinclude template="../common/NRP-form.cfm">
<cfif isdefined("LvarExit")><cfexit></cfif>
  <tr>
    <td align="center">
		<form method="post" action="autorizacionNRP-sql.cfm">
		<input type="hidden" name="CPNRPnum" value="<cfoutput>#Form.CPNRPnum#</cfoutput>">
		<input type="hidden" name="TIPO" value="CANCELA">
		<cfif isdefined("url.lin")>
			<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: history.back();">
		<cfelse>
			<cfif rsEncabezado.CPNAPnum EQ "">
			<input type="submit" name="btnCancelar" value="Cancelar">
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
