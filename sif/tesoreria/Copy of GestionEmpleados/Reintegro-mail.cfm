<cfquery name="rsMail" datasource="#session.dsn#">
		select d.DEnombre,d.DEapellido1,d.DEapellido2,c.CCHcodigo,c.CCHdescripcion
		from GEliquidacion l
			inner join CCHica c
				inner join DatosEmpleado d
				on d.DEid=c.CCHresponsable
			on c.CCHid= l.CCHid
		where GELid=#form.GELid#
</cfquery>

<table>
<cfoutput>
	<tr bgcolor="CCCCCC">
		<td bgcolor="CCCCCC" align="center"><strong>Recordatorio de Reintegro</strong></td>
	</tr>
	<tr>
		<td><strong>Sr/Sra:</strong>#rsMail.DEnombre# #rsMail.DEapellido1# #rsMail.DEapellido2#</td>
	</tr>
	<tr>
	
			<cfquery name="rsReintegro" datasource="#session.dsn#">
					select CCHCreintegro from CCHconfig where Ecodigo=#session.Ecodigo#
			</cfquery>
			
			<cfif rsReintegro.CCHCreintegro eq 0>
				<td>Se le recuerda que debe realizar el reintegro de la caja #rsMail.CCHcodigo#-#rsMail.CCHdescripcion# porque llego a su porcentaje mínimo</td>
			<cfelse>
				<td>Se le informa que se realizo el reintegro automático de la caja #rsMail.CCHcodigo#-#rsMail.CCHdescripcion# porque llego a su porcentaje mínimo</td>
			</cfif>
	</tr>
</cfoutput>
</table>
