<cfquery name="qryCicloLectivo" datasource="#Session.DSN#">
	select convert(varchar,CILcodigo) as CILcodigo
		, CILnombre
		, CILtipoCicloDuracion
	from CicloLectivo
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">		
	order by CILnombre
</cfquery>
<table width="8%" border="0" cellspacing="0" cellpadding="0">
	<tr class="areaMenu"> 
	  <td width="2%">&nbsp;</td>
	  <td width="98%"><strong>Tipo Ciclo Lectivo</strong></td>
	  <td width="2%"><strong>Tipo Duraci&oacute;n Curso</strong></td>
	</tr>
	<cfoutput>
		<cfloop query="qryCicloLectivo">
			<tr> 
				<td> 
					<input type="checkbox" name="CILcodigo" id="CILcodigo" value="#CILcodigo#">
				</td>
				<td nowrap>#CILnombre#&nbsp;</td>
				<td> 
	 				<select name="MCLtipoCicloDuracion_#CILcodigo#">
						<option value="L"<cfif CILtipoCicloDuracion EQ "L">SELECTED</cfif>>Todo el Ciclo Lectivo</option>
						<option value="E"<cfif CILtipoCicloDuracion EQ "E">SELECTED</cfif>>Solo un Periodo Evaluacion</option>
					</select>
				</td>
			</tr>
		</cfloop>
	</cfoutput>
</table>